defmodule Tasky.Runner.Supervisor do
  use GenServer

  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(state) do
    Process.flag(:trap_exit, true)

    Tasky.Runner.start_link("lib/python", "task1")
    Tasky.Runner.start_link("lib/python", "task12")

    {:ok, state}
  end

  def handle_info({:EXIT, pid, reason}, state) do
    Logger.debug("something")
    IO.inspect(state)
    {:noreply, state}
  end
end
