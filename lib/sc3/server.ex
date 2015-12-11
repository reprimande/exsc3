defmodule SC3.Server do
  use GenServer

  def send_msg(msg, args) do
    GenServer.cast(:sc3_server, {:send_msg, msg, args})
  end

  def get_node_id do
    GenServer.call(:sc3_server, :get_node_id)
  end

  def s_new(name, node_id) do
    send_msg("s_new", [name, node_id, 1, 1])
  end

  def n_set(node_id, args) do
    send_msg("n_set", [node_id, args |> List.flatten])
  end

  def n_free(node_id) do
    send_msg("n_free", [node_id])
  end

  def stop do
    GenServer.cast(:sc3_server, {:stop})
  end

  def start_link(host \\ '0.0.0.0', port \\ 57110, start_node_id \\ 5000) do
    GenServer.start_link(__MODULE__, [host, port, start_node_id], name: :sc3_server)
  end

  def init([host, port, start_node_id]) do
    OSC.Client.start_link
    {:ok, {host, port, start_node_id}}
  end

  def handle_cast({:send_msg, msg, args}, {host, port, next_node_id}) do
    OSC.Client.send(host, port, msg, args)
    {:noreply, {host, port, next_node_id}}
  end

  def handle_cast({:stop}, {host, port, _}) do
    OSC.Client.send(host, port, "/g_freeAll", [0])
    OSC.Client.send(host, port, "/clearSched", [])
    OSC.Client.send(host, port, "/g_new", [1, 0, 0])
    {:noreply, {host, port, 1000}}
  end

  def handle_call(:get_node_id, _from, {host, port, next_node_id}) do
    {:reply, next_node_id, {host, port, next_node_id + 1}}
  end
end
