defmodule Pelemay.MixProject do
  use Mix.Project

  def project do
    [
      app: :pelemay,
      version: "0.0.1",
      elixir: "~> 1.9",
      compilers: [:elixir_make | Mix.compilers()],
      make_targets: ["all"],
      make_clean: ["clean"],
      make_env: make_env(),
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchfella, "~> 0.3.5"},
      {:flow, "~> 0.14.3"},
      {:elixir_make, "~> 0.6.0", runtime: false},

      # Docs dependencies
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description() do
    "Pelemay = The Penta (Five) “Elemental Way”: Freedom, Insight, Beauty, Efficiency and Robustness"
  end

  defp package() do
    [
      name: "pelemay",
      maintainers: [
        "Susumu Yamazaki",
        "Masakazu Mori",
        "Yoshihiro Ueno",
        "Hideki Takase",
        "Yuki Hisae"
      ],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/zeam-vm/pelemay"}
    ]
  end

  defp make_env() do
    case System.get_env("ERL_EI_INCLUDE_DIR") do
      nil ->
        %{
          "ERL_EI_INCLUDE_DIR" => "#{:code.root_dir()}/usr/include",
          "ERL_EI_LIBDIR" => "#{:code.root_dir()}/usr/lib"
        }

      _ ->
        %{}
    end
  end
end
