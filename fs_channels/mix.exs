defmodule FsChannels.Mixfile do
  use Mix.Project

  def project do
    [app: :fs_channels,
     version: "0.1.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),

     # hex
     description: description,
     package: package,
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger],
     mod: {FsChannels, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:sqlitex, "~> 1.0.0"}]
  end

  defp description, do: "Collect and push channels information from FreeSWITCH Sqlite to InfluxDB"

  defp package do
    [maintainers: ["Areski Belaid"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/areski/fs_channels_influxdb"}]
  end
end
