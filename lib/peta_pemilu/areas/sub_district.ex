defmodule PetaPemilu.Area.SubDistrict do
  use Ecto.Schema

  schema "kel_desa" do
    field :kode_kd, :string
    field :kode_kec, :string
    field :kode_kk, :string
    field :kode_prov, :string
    field :kel_desa, :string
    field :kecamatan, :string
    field :kab_kota, :string
    field :provinsi, :string
    field :geom, :map
  end
end
