defmodule PetaPemilu.Area do
  def by_coordinate(lat, lng) do
    query = "
      SELECT
        kode_dapil,
        jenis_dapil,
        nama_dapil,
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
        data =
          Enum.map(result.rows, &(Enum.zip(result.columns, &1) |> Enum.into(%{})))

        {:ok, data}

      res ->
        res
    end
  end
end
