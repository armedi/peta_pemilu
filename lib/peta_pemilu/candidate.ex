defmodule PetaPemilu.Candidate do
  import Ecto.Query

  def by_dapil(:dpd, dapil_slug) do
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
        order_by: [c.kode_provinsi, c.nomor_urut]

    PetaPemilu.Repo.all(query)
  end

  def by_dapil(:dpr, dapil_slug) do
    query =
      from c in subquery(
             from d in "dapil",
               inner_join: cd in "caleg_dpr",
               on: d.kode_dapil == cd.kode_dapil,
               inner_join: p in "partai",
               on: cd.id_partai == p.id,
               where: d.jenis_dapil == "DPR RI" and d.nama_dapil_slug == ^dapil_slug,
               select: %{
                 nomor_urut_partai: p.nomor_urut,
                 foto_partai: p.foto,
                 partai: p.nama,
                 nomor_urut: cd.nomor_urut,
                 foto: cd.foto,
                 nama: cd.nama,
                 id_calon: cd.id_calon_dpr
               },
               order_by: [p.nomor_urut, cd.nomor_urut]
           ),
           select: %{
             nomor_urut_partai: c.nomor_urut_partai,
             foto_partai: c.foto_partai,
             partai: c.partai,
             caleg:
               fragment(
                 "json_agg(json_build_object('nomor_urut', ?, 'foto', ?, 'nama', ?, 'id', ?))",
                 c.nomor_urut,
                 c.foto,
                 c.nama,
                 c.id_calon
               )
           },
           group_by: [c.nomor_urut_partai, c.foto_partai, c.partai],
           order_by: [c.nomor_urut_partai]

    PetaPemilu.Repo.all(query)
  end

  def by_dapil(:dprd_prov, dapil_slug) do
    query =
      from c in subquery(
             from d in "dapil",
               inner_join: cd in "caleg_dprd_prov",
               on: d.kode_dapil == cd.kode_dapil,
               inner_join: p in "partai",
               on: cd.id_partai == p.id,
               where: d.jenis_dapil == "DPRD PROVINSI" and d.nama_dapil_slug == ^dapil_slug,
               select: %{
                 nomor_urut_partai: p.nomor_urut,
                 foto_partai: p.foto,
                 partai: p.nama,
                 nomor_urut: cd.nomor_urut,
                 foto: cd.foto,
                 nama: cd.nama,
                 id_calon: cd.id_calon_dpr
               },
               order_by: [p.nomor_urut, cd.nomor_urut]
           ),
           select: %{
             nomor_urut_partai: c.nomor_urut_partai,
             foto_partai: c.foto_partai,
             partai: c.partai,
             caleg:
               fragment(
                 "json_agg(json_build_object('nomor_urut', ?, 'foto', ?, 'nama', ?, 'id', ?))",
                 c.nomor_urut,
                 c.foto,
                 c.nama,
                 c.id_calon
               )
           },
           group_by: [c.nomor_urut_partai, c.foto_partai, c.partai],
           order_by: [c.nomor_urut_partai]

    PetaPemilu.Repo.all(query)
  end

  def by_dapil(:dprd_kabko, dapil_slug) do
    query =
      from c in subquery(
             from d in "dapil",
               inner_join: cd in "caleg_dprd_kabko",
               on: d.kode_dapil == cd.kode_dapil,
               inner_join: p in "partai",
               on: cd.id_partai == p.id,
               where: d.jenis_dapil == "DPRD KABUPATEN/KOTA" and d.nama_dapil_slug == ^dapil_slug,
               select: %{
                 nomor_urut_partai: p.nomor_urut,
                 foto_partai: p.foto,
                 partai: p.nama,
                 nomor_urut: cd.nomor_urut,
                 foto: cd.foto,
                 nama: cd.nama,
                 id_calon: cd.id_calon_dpr
               },
               order_by: [p.nomor_urut, cd.nomor_urut]
           ),
           select: %{
             nomor_urut_partai: c.nomor_urut_partai,
             foto_partai: c.foto_partai,
             partai: c.partai,
             caleg:
               fragment(
                 "json_agg(json_build_object('nomor_urut', ?, 'foto', ?, 'nama', ?, 'id', ?))",
                 c.nomor_urut,
                 c.foto,
                 c.nama,
                 c.id_calon
               )
           },
           group_by: [c.nomor_urut_partai, c.foto_partai, c.partai],
           order_by: [c.nomor_urut_partai]

    PetaPemilu.Repo.all(query)
  end

  def profile(:dpd, %{dapil: dapil, candidate_number: candidate_number}) do
    caleg =
      PetaPemilu.Repo.one(
        from c in "caleg_dpd",
          left_join: p in "provinsi",
          on: c.kode_provinsi == p.kode_prov,
          where:
            p.provinsi_slug == ^dapil and
              c.nomor_urut == ^candidate_number,
          select: [:id, :profile]
      )

    case caleg do
      nil ->
        {:error, "Not found"}

      _ ->
        case caleg.profile do
          nil ->
            case Req.get(
                   base_url: "https://caleg.zakiego.com/api",
                   url: "/dpd/calon/:dapil/:candidate_number",
                   path_params: [dapil: dapil, candidate_number: candidate_number]
                 ) do
              {:ok, response} ->
                data = response.body["data"]

                PetaPemilu.Repo.update_all(
                  from("caleg_dpd", where: [id: ^caleg.id], update: [set: [profile: ^data]]),
                  []
                )

                {:ok, data}

              result ->
                result
            end

          profile ->
            {:ok, profile}
        end
    end
  end

  def profile(:dpr, %{dapil: dapil, party: party, candidate_number: candidate_number}) do
    caleg =
      PetaPemilu.Repo.one(
        from c in "caleg_dpr",
          left_join: d in "dapil",
          on: c.kode_dapil == d.kode_dapil,
          left_join: p in "partai",
          on: c.id_partai == p.id,
          where:
            d.nama_dapil_slug == ^dapil and p.slug == ^party and
              c.nomor_urut == ^candidate_number,
          select: [:id, :profile]
      )

    case caleg do
      nil ->
        {:error, "Not found"}

      _ ->
        case caleg.profile do
          nil ->
            case Req.get(
                   base_url: "https://caleg.zakiego.com/api",
                   url: "/dpr-ri/calon/:dapil/:party/:candidate_number",
                   path_params: [
                     dapil: dapil,
                     party: party,
                     candidate_number: candidate_number
                   ]
                 ) do
              {:ok, response} ->
                [data | _tail] = response.body["data"]

                PetaPemilu.Repo.update_all(
                  from("caleg_dpr", where: [id: ^caleg.id], update: [set: [profile: ^data]]),
                  []
                )

                {:ok, data}

              result ->
                result
            end

          profile ->
            {:ok, profile}
        end
    end
  end

  def profile(:dprd_prov, %{dapil: dapil, party: party, candidate_number: candidate_number}) do
    caleg =
      PetaPemilu.Repo.one(
        from c in "caleg_dprd_prov",
          left_join: d in "dapil",
          on: c.kode_dapil == d.kode_dapil,
          left_join: p in "partai",
          on: c.id_partai == p.id,
          where:
            d.nama_dapil_slug == ^dapil and p.slug == ^party and
              c.nomor_urut == ^candidate_number,
          select: [:id, :profile]
      )

    case caleg.profile do
      nil ->
        case Req.get(
               base_url: "https://caleg.zakiego.com/api",
               url: "/dprd-provinsi/calon/:dapil/:party/:candidate_number",
               path_params: [
                 dapil: dapil,
                 party: party,
                 candidate_number: candidate_number
               ]
             ) do
          {:ok, response} ->
            data = response.body["data"]

            PetaPemilu.Repo.update_all(
              from("caleg_dprd_prov", where: [id: ^caleg.id], update: [set: [profile: ^data]]),
              []
            )

            {:ok, data}

          result ->
            result
        end

      profile ->
        {:ok, profile}
    end
  end

  def profile(:dprd_kabko, %{dapil: dapil, party: party, candidate_number: candidate_number}) do
    caleg =
      PetaPemilu.Repo.one(
        from c in "caleg_dprd_kabko",
          left_join: d in "dapil",
          on: c.kode_dapil == d.kode_dapil,
          left_join: p in "partai",
          on: c.id_partai == p.id,
          where:
            d.nama_dapil_slug == ^dapil and p.slug == ^party and
              c.nomor_urut == ^candidate_number,
          select: [:id, :profile]
      )

    case caleg.profile do
      nil ->
        case Req.get(
               base_url: "https://caleg.zakiego.com/api",
               url: "/dprd-kabupaten-kota/calon/:dapil/:party/:candidate_number",
               path_params: [
                 dapil: dapil,
                 party: party,
                 candidate_number: candidate_number
               ]
             ) do
          {:ok, response} ->
            data = response.body["data"]

            PetaPemilu.Repo.update_all(
              from("caleg_dprd_kabko", where: [id: ^caleg.id], update: [set: [profile: ^data]]),
              []
            )

            {:ok, data}

          result ->
            result
        end

      profile ->
        {:ok, profile}
    end
  end
end
