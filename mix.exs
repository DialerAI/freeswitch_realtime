defmodule FreeswitchRealtime.Mixfile do
  use Mix.Project

  def project do
    [app: :freeswitch_realtime,
     version: "0.2.2",
     elixir: "~> 1.4.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     package: package(),
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [mod: {FreeswitchRealtime, []},
     extra_applications: [:logger]]
  end

  # Dependencies
  defp deps do
    [
     {:ex_doc, "~> 0.13.0", only: :dev},
     {:distillery, "~> 1.0"},
     # {:sqlitex, path: "../sqlitex"},
     {:sqlitex, "~> 1.1.1"},
     {:ecto, "~> 2.0.0"},
     {:postgrex, ">= 0.0.0"},
     {:logger_file_backend, "0.0.9"},
     {:instream, "~> 0.14"},
     {:swab, github: "crownedgrouse/swab", branch: "master"},
     {:timex, "~> 3.1.9"},
     {:timex_ecto, "~> 3.0.5"}
    ]
  end

  defp description, do: "Collect and push channels information from FreeSWITCH Sqlite to InfluxDB"

  defp package do
    [
      name: :freeswitch_realtime,
      license_file: "LICENSE",
      external_dependencies: [],
      maintainers: ["Areski Belaid"],
      vendor: "Areski Belaid",
      licenses: ["MIT"],
      links: %{
        "Github" => "https://github.com/areski/freeswitch_realtime",
        "Homepage" => "https://github.com/areski/freeswitch_realtime"
      }
    ]
  end
end
