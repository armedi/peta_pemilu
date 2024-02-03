defmodule PetaPemiluWeb.Live.DprdKabko do
  use PetaPemiluWeb, :live_view
  import PetaPemiluWeb.BallotComponents
  require Jason

  def render(assigns) do
    ~H"""
    <div class="pb-8">
      <.page_header
        jenis_dapil={:dprd_kabko}
        background_image={"url(#{static_path(@socket, "/images/wave-dprd-kabko.svg")})"}
      />
      <.page_subheader dapil={@dapil} />
      <.profile_tips />
      <.parties_candidates jenis_dapil={:dprd_kabko} dapil_slug={@dapil_slug} parties={@parties} />
    </div>
    """
  end

  def mount(%{"slug" => slug}, _session, socket) do
    dapil = String.split(slug, "-") |> Enum.join(" ")
    parties = PetaPemilu.Candidate.caleg_by_dapil(:dprd_kabko, slug)

    {:ok, assign(socket, dapil_slug: slug, dapil: dapil, parties: parties)}
  end
end
