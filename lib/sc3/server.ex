defmodule SC3.Server do
  use GenServer

  def send_msg(msg, args) do
    GenServer.cast(:sc3_server, {:send_msg, msg, args})
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

  def start_link(host \\ '0.0.0.0', port \\ 57110) do
    GenServer.start_link(__MODULE__, [host, port], name: :sc3_server)
  end

  def init([host, port]) do
    OSC.Client.start_link
    {:ok, {host, port}}
  end

  def handle_cast({:send_msg, msg, args}, {host, port}) do
    OSC.Client.send(host, port, msg, args)
    {:noreply, {host, port}}
  end
end
