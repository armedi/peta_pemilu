defmodule PetaPemilu.Candidate do
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
