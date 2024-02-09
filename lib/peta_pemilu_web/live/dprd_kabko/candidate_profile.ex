defmodule PetaPemiluWeb.Live.DprdKabko.CandidateProfile do
  use PetaPemiluWeb, :live_view
  import PetaPemiluWeb.ProfileComponents

  def render(assigns) do
    ~H"""
    <.candidate_profile {assigns} />
    """
  end

  def mount(
        %{"dapil" => dapil_slug, "party" => party, "candidate_number" => candidate_number},
        _session,
        socket
      ) do
    {:ok, candidate} =
      PetaPemilu.Candidate.profile(:dprd_kabko, %{
        dapil: dapil_slug,
        party: party,
        candidate_number: String.to_integer(candidate_number)
      })

    {:ok,
     assign(socket,
       page_title:
         "Caleg DPRD Kabupaten/Kota Dapil #{candidate["namaDapil"]} • #{candidate["namaPartai"]}, Nomor Urut #{candidate_number}",
       candidate: candidate
     )}
  end
end
