defmodule Johan.Repo do
  use Ecto.Repo,
    otp_app: :johan,
    adapter: Ecto.Adapters.Postgres
end
