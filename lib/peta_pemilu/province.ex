defmodule PetaPemilu.Province do
  use Ecto.Schema
  import Ecto.Changeset

  schema "provinsi" do
    field :kode_prov, :string
    field :provinsi, :string
    field :geom, :map
  end

  def changeset(provinsi, attrs) do
    provinsi
    |> cast(attrs, [:kode_prov, :provinsi, :geom])
    |> validate_required([:kode_prov, :provinsi, :geom])
  end
end
