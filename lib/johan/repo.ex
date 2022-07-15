defmodule Johan.Repo do
  use Ecto.Repo,
    otp_app: :johan,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
