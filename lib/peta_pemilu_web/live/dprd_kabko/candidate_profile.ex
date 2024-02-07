defmodule PetaPemiluWeb.Live.DprdKabko.CandidateProfile do
  use PetaPemiluWeb, :live_view
  import PetaPemiluWeb.ProfileComponents

  def render(assigns) do
    ~H"""
    <.candidate_profile jenis_dapil={:dprd_kabko} {assigns} />
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

    {:ok, assign(socket, candidate: candidate)}
  end
end
