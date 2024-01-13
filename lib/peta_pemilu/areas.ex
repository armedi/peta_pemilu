defmodule PetaPemilu.Area do
  import Ecto.Query

  def by_coordinate(lat, lng) do
    query =
      from d in "dapil",
        where:
          fragment(
            "ST_Intersects(?, ST_SetSRID(ST_MakePoint(?, ?), 104199))",
            d.geom,
            ^lng,
            ^lat
          ),
        select: %{
          kode_dapil: d.kode_dapil,
          jenis_dapil: d.jenis_dapil,
          nama_dapil: d.nama_dapil,
          nama_dapil_slug: d.nama_dapil_slug,
          wilayah: d.wilayah,
          geojson: d.geojson
        },
        order_by: fragment("
          CASE
            WHEN jenis_dapil = 'DPR RI' THEN 1
            WHEN jenis_dapil = 'DPRD PROVINSI' THEN 2
            WHEN jenis_dapil = 'DPRD KABUPATEN/KOTA' THEN 3
          END")

    areas = PetaPemilu.Repo.all(query)

    case length(areas) do
      0 ->
        areas

      _ ->
        nama_dapil =
          areas
          |> hd
          |> Map.get(:nama_dapil)
          |> String.split()
          |> Enum.drop(-1)
          |> Enum.join(" ")

        areas = [
          %{
            kode_dapil: areas |> hd |> Map.get(:kode_dapil) |> String.slice(0..1),
            jenis_dapil: "DPD RI",
            nama_dapil: nama_dapil,
            nama_dapil_slug: nama_dapil |> String.downcase() |> String.replace(" ", "-"),
            wilayah: []
          }
          | areas
        ]

        areas
    end
  end
end
