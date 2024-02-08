defmodule PetaPemiluWeb.Live.Dpd.CandidateProfile do
  use PetaPemiluWeb, :live_view
  import PetaPemiluWeb.ProfileComponents

  def render(assigns) do
    ~H"""
    <.candidate_profile {assigns} />
    """
  end

  def mount(
        %{"dapil" => dapil_slug, "candidate_number" => candidate_number},
        _session,
        socket
      ) do
    {:ok, candidate} =
      PetaPemilu.Candidate.profile(:dpd, %{
        dapil: dapil_slug,
        candidate_number: String.to_integer(candidate_number)
      })

    {:ok, assign(socket, candidate: candidate)}
  end
end
