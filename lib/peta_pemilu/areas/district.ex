defmodule PetaPemilu.Area.District do
  use Ecto.Schema

  schema "kecamatan" do
    field :kode_kec, :string
    field :kode_kk, :string
    field :kode_prov, :string
    field :kecamatan, :string
    field :kab_kota, :string
    field :provinsi, :string
    field :geom, :map
  end
end
