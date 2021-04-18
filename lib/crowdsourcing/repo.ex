defmodule Crowdsourcing.Repo do
  use Ecto.Repo,
    otp_app: :crowdsourcing,
    adapter: Ecto.Adapters.Postgres
end
