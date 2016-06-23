defmodule Tasky.Runner do
  use GenServer
  use Export.Python

  require Logger

  def start_link(path, filename) do
    {:ok, py} = Python.start(python_path: Path.expand(path))

    state = %{
      py_pid: py,
      filename: filename,
      method: "start",
      params: [],
    }

    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    Process.send_after(self(), :work, 1000)
    {:ok, state}
  end

  def handle_info(:work, state) do
    task = Task.async(fn -> call_python_script(state) end)

    case Task.yield(task, 5000) do
      {:ok, {:ok, _result}} ->
        Process.send_after(self(), :work, 8000)
        {:noreply, %{ state | method: "start" }}
      {:ok, {:error, error}} ->
        error
        |> stringify_python_error
        |> Logger.error

        Process.send_after(self(), :work, 2000)
        {:noreply, %{ state | method: "resume" }}
      nil ->
        Task.shutdown(task)
        Logger.error("Python script timed out")
        Process.send_after(self(), :work, 2000)
        {:noreply, %{ state | method: "resume" }}
    end
  end

  defp call_python_script(state) do
    %{
      py_pid: py,
      filename: filename,
      method: method,
      params: params
    } = state

    try do
      result = Python.call(py, filename, method, params)
      {:ok, result}
    rescue
      e ->
        {:error, e}
    end
  end

  defp stringify_python_error(%ErlangError{original: {:python, _, _, lines}}) do
    lines
    |> Enum.map(&handle_python_error_line/1)
    |> Enum.join("\n")
  end

  defp stringify_python_error(_) do
    "Unknown error"
  end

  defp handle_python_error_line({filename, linenumber, methodname, message}) do
    "#{message}\n\t#{filename}:#{linenumber}"
  end
end
