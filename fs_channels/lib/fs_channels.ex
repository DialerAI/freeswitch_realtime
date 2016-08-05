defmodule FsChannels do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: FsChannels.Worker.start_link(arg1, arg2, arg3)
      # worker(FsChannels.Worker, [arg1, arg2, arg3]),
      worker(Collector, [[], [name: MyCollector]]),
      worker(Sqlitex.Server, ['/tmp2/golf.sqlite3', [name: Sqlitex.Server]]),
      # worker(Sqlitex.Server, [Application.fetch_env!(:fs_channels, :sqlite_db), [name: Sqlitex.Server]]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FsChannels.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
