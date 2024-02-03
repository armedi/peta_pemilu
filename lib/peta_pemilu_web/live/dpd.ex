defmodule PetaPemiluWeb.Live.Dpd do
  use PetaPemiluWeb, :live_view
  import PetaPemiluWeb.BallotComponents
  require Jason

  def render(assigns) do
    ~H"""
    <div class="pb-8">
      <.page_header
        jenis_dapil={:dpd}
        background_image={"url(#{static_path(@socket, "/images/wave-dpd.svg")})"}
      />
      <.page_subheader dapil={@dapil} />
      <div class="flex flex-wrap justify-center gap-4 mx-auto max-w-6xl">
        <%= for candidate <- @candidates do %>
          <.dynamic_tag
            name={if candidate.id_calon, do: "a", else: "div"}
            href={
              if candidate.id_calon,
                do: ~p"/caleg/dpd/#{assigns.dapil_slug}/#{candidate.id_calon}",
                else: nil
            }
            target={
              if candidate.id_calon,
                do: "_blank",
                else: nil
            }
            class={"h-64 w-32 overflow-clip border flex flex-col border-gray-500 text-center #{if !candidate.id_calon, do: "text-gray-400", else: ""}"}
          >
            <div class="p-1 font-bold text-lg"><%= candidate.nomor_urut %></div>
            <img
              src={candidate.foto}
              loading="lazy"
              fetchpriority="low"
              alt={candidate.nama}
              class="w-32 h-40 object-cover object-top"
            />
            <div style="text-wrap: balance" class="text-xs flex-1 flex justify-center items-center">
              <%= candidate.nama %>
            </div>
          </.dynamic_tag>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(%{"slug" => slug}, _session, socket) do
    dapil = String.split(slug, "-") |> Enum.join(" ")
    candidates = PetaPemilu.Candidate.caleg_by_dapil(:dpd, slug)

    {:ok, assign(socket, dapil_slug: slug, dapil: dapil, candidates: candidates)}
  end
end
