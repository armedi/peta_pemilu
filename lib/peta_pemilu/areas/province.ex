defmodule PetaPemilu.Area.Province do
  use Ecto.Schema

  schema "provinsi" do
    field :kode_prov, :string
    field :provinsi, :string
    field :geom, :map
  end
end
