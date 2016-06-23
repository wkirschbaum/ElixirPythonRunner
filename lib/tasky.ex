defmodule Tasky do
  use Application

  require Logger

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Tasky.Runner, ["lib/python", "task1"], id: "task1"),
      worker(Tasky.Runner, ["lib/python", "task10"], id: "task10"),
      worker(Tasky.Runner, ["lib/python", "task11"], id: "task11"),
      worker(Tasky.Runner, ["lib/python", "task12"], id: "task12"),
      worker(Tasky.Runner, ["lib/python", "task13"], id: "task13"),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Tasky.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def handle_info(_, state) do
    Logger.debug("asdadassdasdads\n\n\n\nadsasdasd")
  end
end
