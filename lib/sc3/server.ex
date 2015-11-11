defmodule SC3.Server do
  use GenServer

  def s_new(name, node_id) do
    GenServer.cast(:sc3_server, {:s_new, name, node_id})
  end

  def n_set(node_id, args) do
    GenServer.cast(:sc3_server, {:n_set, node_id, args})
  end

  def n_free(node_id) do
    GenServer.cast(:sc3_server, {:n_free, node_id})
  end

  def start_link(host \\ '0.0.0.0', port \\ 57110) do
    GenServer.start_link(__MODULE__, [host, port], name: :sc3_server)
  end

  def init([host, port]) do
    OSC.Client.start_link
    {:ok, {host, port}}
  end

  def handle_cast({:s_new, name, node_id}, {host, port}) do
    OSC.Client.send(host, port, "s_new", [name, node_id])
    {:noreply, {host, port}}
  end

  def handle_cast({:n_set, node_id, args}, {host, port}) do
    OSC.Client.send(host, port, "n_set", [node_id, args] |> List.flatten)
    {:noreply, {host, port}}
  end

  def handle_cast({:n_free, node_id}, {host, port}) do
    OSC.Client.send(host, port, "n_free", [node_id])
    {:noreply, {host, port}}
  end
end
