defmodule PetaPemilu.Area.City do
  use Ecto.Schema

  schema "kab_kota" do
    field :kode_kk, :string
    field :kode_prov, :string
    field :kab_kota, :string
    field :provinsi, :string
    field :geom, :map
  end
end
