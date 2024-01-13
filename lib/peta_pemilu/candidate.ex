defmodule PetaPemilu.Candidate do
  import Ecto.Query

  def caleg_by_dapil(:dpd, dapil_slug) do
    query =
      from prov in "provinsi",
        join: c in "caleg_dpd",
        on: prov.kode_prov == c.kode_provinsi,
        where: prov.provinsi_slug == ^dapil_slug,
        select: %{
          nomor_urut: c.nomor_urut,
          foto: c.foto,
          nama: c.nama,
          id_calon: c.id_calon_dpd
        },
        order_by: [c.nomor_urut]

    PetaPemilu.Repo.all(query)
  end

  def caleg_by_dapil(:dpr, dapil_slug) do
    query =
      from d in "dapil",
        join: c in "caleg_dpr",
        on: d.kode_dapil == c.kode_dapil,
        join: p in "partai",
        on: c.id_partai == p.id,
        where: d.jenis_dapil == "DPR RI" and d.nama_dapil_slug == ^dapil_slug,
        select: %{
          partai: p.nama,
          nomor_urut: c.nomor_urut,
          foto: c.foto,
          nama: c.nama,
          id_calon: c.id_calon_dpr
        },
        order_by: [p.nomor_urut, c.nomor_urut]

    PetaPemilu.Repo.all(query)
  end

  def caleg_by_dapil(:dprd_prov, dapil_slug) do
    query =
      from d in "dapil",
        join: c in "caleg_dprd_prov",
        on: d.kode_dapil == c.kode_dapil,
        join: p in "partai",
        on: c.id_partai == p.id,
        where: d.jenis_dapil == "DPRD PROVINSI" and d.nama_dapil_slug == ^dapil_slug,
        select: %{
          partai: p.nama,
          nomor_urut: c.nomor_urut,
          foto: c.foto,
          nama: c.nama,
          id_calon: c.id_calon_dpr
        },
        order_by: [p.nomor_urut, c.nomor_urut]

    PetaPemilu.Repo.all(query)
  end

  def caleg_by_dapil(:dprd_kabko, dapil_slug) do
    query =
      from d in "dapil",
        join: c in "caleg_dprd_kabko",
        on: d.kode_dapil == c.kode_dapil,
        join: p in "partai",
        on: c.id_partai == p.id,
        where: d.jenis_dapil == "DPRD KABUPATEN/KOTA" and d.nama_dapil_slug == ^dapil_slug,
        select: %{
          partai: p.nama,
          nomor_urut: c.nomor_urut,
          foto: c.foto,
          nama: c.nama,
          id_calon: c.id_calon_dpr
        },
        order_by: [p.nomor_urut, c.nomor_urut]

    PetaPemilu.Repo.all(query)
  end

  def fetch_candidate_profile(kind, id) do
    multipart =
      case kind do
        "dpd" ->
          Multipart.new()
          |> Multipart.add_part(Multipart.Part.text_field("ID_CANDIDATE", id))
          |> Multipart.add_part(Multipart.Part.text_field("pilihan_publikasi", "BERSEDIA"))

        _ ->
          Multipart.new()
          |> Multipart.add_part(Multipart.Part.text_field("id_calon_dpr", id))
          |> Multipart.add_part(Multipart.Part.text_field("status_publikasi", "Bersedia"))
      end

    url =
      case kind do
        "dpd" -> "https://infopemilu.kpu.go.id/Pemilu/Dct_dpd/profil"
        "dpr" -> "https://infopemilu.kpu.go.id/Pemilu/Dct_dpr/profile"
        "dprd-prov" -> "https://infopemilu.kpu.go.id/Pemilu/Dct_dprprov/profile"
        "dprd-kabko" -> "https://infopemilu.kpu.go.id/Pemilu/Dct_dprd/profile"
      end

    Req.post(url,
      headers: [
        {"Content-Type", Multipart.content_type(multipart, "multipart/form-data")},
        {"Content-Length", Multipart.content_length(multipart)}
      ],
      body: Multipart.body_stream(multipart)
    )
  end
end
