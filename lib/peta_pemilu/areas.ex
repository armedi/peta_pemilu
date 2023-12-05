defmodule PetaPemilu.Area.Province do
  use Ecto.Schema

  schema "provinsi" do
    field :kode_prov, :string
    field :provinsi, :string
    field :geom, :map
  end
end

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
