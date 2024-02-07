defmodule PetaPemiluWeb.Live.Dpr.CandidateProfile do
  use PetaPemiluWeb, :live_view
  import PetaPemiluWeb.ProfileComponents

  def render(assigns) do
    ~H"""
    <.candidate_profile jenis_dapil={:dpr} {assigns} />
    """
  end

  def mount(
        %{"dapil" => dapil_slug, "party" => party, "candidate_number" => candidate_number},
        _session,
        socket
      ) do
    {:ok, candidate} =
      PetaPemilu.Candidate.profile(:dpr, %{
        dapil: dapil_slug,
        party: party,
        candidate_number: String.to_integer(candidate_number)
      })

    {:ok, assign(socket, candidate: candidate)}
  end
end
