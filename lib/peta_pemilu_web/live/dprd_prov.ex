defmodule PetaPemiluWeb.Live.DprdProv do
  use PetaPemiluWeb, :live_view
  import PetaPemiluWeb.BallotComponents

  def render(assigns) do
    ~H"""
    <div class="pb-8">
      <.page_header
        jenis_dapil={:dprd_prov}
        background_image={"url(#{static_path(@socket, "/images/wave-dprd-prov.svg")})"}
      />
      <.page_subheader dapil={@dapil} />
      <.profile_tips />
      <.parties_candidates jenis_dapil={:dprd_prov} dapil_slug={@dapil_slug} parties={@parties} />>
    </div>
    """
  end

  def mount(%{"dapil" => dapil_slug}, _session, socket) do
    dapil = String.split(dapil_slug, "-") |> Enum.join(" ")
    parties = PetaPemilu.Candidate.by_dapil(:dprd_prov, dapil_slug)

    {:ok, assign(socket, dapil_slug: dapil_slug, dapil: dapil, parties: parties)}
  end
end
