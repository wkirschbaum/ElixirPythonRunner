defmodule Tasky.RandomLogger do
  use GenServer

  require Logger

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, 1000)

    {:ok, "start"}
  end

  def handle_info(:work, state) do
    {:ok, pp} = :python.start()
    :python.call(pp, :__builtin__, :print, ["hey there"])
    task = Task.async(fn -> do_some_work(state) end)
    case Task.yield(task, 5000) do
      {:ok, 0} ->
        state = "start"
        Process.send_after(self(), :work, 8000)
      {:ok, _} ->
        state = "restart"
        Process.send(self(), :work, [])
      _ ->
        Task.shutdown(task)
        state = "restart"
        Process.send(self(), :work, [])
    end

    {:noreply, state}
  end

  defp do_some_work(state) do
    if state == "restart" do
      Logger.debug("resuming")
      {output, exit_code} = System.cmd("python", ["something.py", "resume"])
      Logger.debug(output)
      {output, exit_code}
    else
      Logger.debug("running")
      {output, exit_code} = System.cmd("python", ["something.py", "start"])
      Logger.debug(output)
      {output, exit_code}
    end
    exit_code
  end
end
