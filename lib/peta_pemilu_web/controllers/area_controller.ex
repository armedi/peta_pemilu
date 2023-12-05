defmodule PetaPemiluWeb.AreaController do
  use PetaPemiluWeb, :controller

  def index(conn, %{"lng" => lng, "lat" => lat} = params) do
    {longitude, _} = Float.parse(lng)
    {latitude, _} = Float.parse(lat)
    {area_level, _} = Integer.parse(params["lvl"] || "4")

    query =
      case area_level do
        1 ->
          "SELECT kode_prov, provinsi, ST_AsGeoJSON(ST_Simplify(geom, 0.01)) AS boundaries FROM provinsi WHERE st_intersects(geom, ST_SetSRID(ST_MakePoint($1, $2), 104199))"

        2 ->
          "SELECT kode_kk, kode_prov, kab_kota, provinsi, ST_AsGeoJSON(ST_Simplify(geom, 0.001)) AS boundaries FROM kab_kota WHERE st_intersects(geom, ST_SetSRID(ST_MakePoint($1, $2), 104199))"

        3 ->
          "SELECT kode_kec, kode_kk, kode_prov, kecamatan, kab_kota, provinsi, ST_AsGeoJSON(ST_Simplify(geom, 0.0001)) AS boundaries FROM kecamatan WHERE st_intersects(geom, ST_SetSRID(ST_MakePoint($1, $2), 104199))"

        _ ->
          "SELECT kode_kd, kode_kec, kode_kk, kode_prov, kel_desa, kecamatan, kab_kota, provinsi, ST_AsGeoJSON(geom) AS boundaries FROM kel_desa WHERE st_intersects(geom, ST_SetSRID(ST_MakePoint($1, $2), 104199))"
      end

    case PetaPemilu.Repo.query(query, [longitude, latitude]) do
      {:ok, result} ->
        data = Enum.map(result.rows, &(Enum.zip(result.columns, &1) |> Enum.into(%{})))
        json(conn, data)

      {:error, _} ->
        conn
        |> put_status(500)
        |> json(%{error: "Something went wrong"})
    end
  end

  def index(conn, _) do
    conn
    |> put_status(400)
    |> json(%{error: "Missing lng or lat params"})
  end
end
