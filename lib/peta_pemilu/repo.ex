defmodule PetaPemilu.Repo do
  use Ecto.Repo,
    otp_app: :peta_pemilu,
    adapter: Ecto.Adapters.Postgres
end
