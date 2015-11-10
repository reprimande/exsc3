defmodule SC3.Server do
  use GenServer

  def s_new(name, node_id) do
    GenServer.cast(:sc3_server, {:s_new, name, node_id})
  end

  def start_link(host, port) do
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
end
