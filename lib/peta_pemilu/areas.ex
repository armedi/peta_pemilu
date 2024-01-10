defmodule PetaPemilu.Area do
  def by_coordinate(lat, lng) do
    query = "
      SELECT
        kode_dapil,
        jenis_dapil,
        nama_dapil,
        nama_dapil_slug,
        wilayah,
        geojson
      FROM
        (
          SELECT
            *,
            CASE
              WHEN jenis_dapil = 'DPR RI' THEN 1
              WHEN jenis_dapil = 'DPRD PROVINSI' THEN 2
              WHEN jenis_dapil = 'DPRD KABUPATEN/KOTA' THEN 3
            END AS o
          FROM
            dapil
          WHERE
            st_intersects (geom, ST_SetSRID (ST_MakePoint ($1, $2), 104199))
          ORDER BY
            o
        );"

    case PetaPemilu.Repo.query(query, [lng, lat]) do
      {:ok, result} ->
        if length(result.rows) === 0 do
          {:ok, []}
        else
          nama_dapil =
            result.rows
            |> hd
            |> Enum.at(2)
            |> String.split()
            |> Enum.drop(-1)
            |> Enum.join(" ")

          data =
            [
              %{
                "kode_dapil" => result.rows |> hd |> Enum.at(0) |> String.slice(0..1),
                "jenis_dapil" => "DPD RI",
                "nama_dapil" => nama_dapil,
                "nama_dapil_slug" =>
                  nama_dapil
                  |> String.downcase()
                  |> String.replace(" ", "-"),
                "wilayah" => []
              }
              | Enum.map(result.rows, &(Enum.zip(result.columns, &1) |> Enum.into(%{})))
            ]

          {:ok, data}
        end

      res ->
        res
    end
  end
end
