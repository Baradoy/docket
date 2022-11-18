defmodule Docket.Repo do
  use Ecto.Repo,
    otp_app: :docket,
    adapter: Ecto.Adapters.SQLite3
end
