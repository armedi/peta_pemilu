defmodule PetaPemiluWeb.Live.Dpr do
  use PetaPemiluWeb, :live_view
  import PetaPemiluWeb.BallotComponents
  require Jason

  def render(assigns) do
    ~H"""
    <div class="pb-8">
      <.page_header
        jenis_dapil={:dpr}
        background_image={"url(#{static_path(@socket, "/images/wave-dpr.svg")})"}
      />
      <.page_subheader dapil={@dapil} />
      <.parties_candidates jenis_dapil={:dpr} dapil_slug={@dapil_slug} parties={@parties} />
    </div>
    """
  end

  def mount(%{"slug" => slug}, _session, socket) do
    dapil = String.split(slug, "-") |> Enum.join(" ")
    parties = PetaPemilu.Candidate.caleg_by_dapil(:dpr, slug)

    {:ok, assign(socket, dapil_slug: slug, dapil: dapil, parties: parties)}
  end
end
