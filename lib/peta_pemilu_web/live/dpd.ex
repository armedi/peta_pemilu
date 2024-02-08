defmodule PetaPemiluWeb.Live.Dpd do
  use PetaPemiluWeb, :live_view
  import PetaPemiluWeb.BallotComponents

  def render(assigns) do
    ~H"""
    <div class="pb-8">
      <.page_header
        jenis_dapil={:dpd}
        background_image={"url(#{static_path(@socket, "/images/wave-dpd.svg")})"}
      />
      <.page_subheader dapil={@dapil} />
      <.profile_tips jenis_dapil={:dpd} />
      <div class="flex flex-wrap justify-center gap-4 mx-auto max-w-6xl">
        <%= for candidate <- @candidates do %>
          <%= if candidate.id_calon do %>
            <a
              href={
                # ~p"/caleg/dpd/#{assigns.dapil_slug}/#{candidate.id_calon}"
                ~p"/caleg/dpd/#{assigns.dapil_slug}/#{candidate.nomor_urut}"
              }
              class="h-64 w-32 overflow-clip border flex flex-col border-gray-500 text-center"
            >
              <.candidate_card_inner candidate={candidate} />
            </a>
          <% else %>
            <div class="h-64 w-32 overflow-clip border flex flex-col border-gray-500 text-center text-gray-400">
              <.candidate_card_inner candidate={candidate} />
            </div>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end

  defp candidate_card_inner(assigns) do
    ~H"""
    <div class="p-1 font-bold text-lg"><%= @candidate.nomor_urut %></div>
    <img
      src={@candidate.foto}
      loading="lazy"
      fetchpriority="low"
      alt={@candidate.nama}
      class="w-32 h-40 object-cover object-top"
    />
    <div style="text-wrap: balance" class="text-xs flex-1 flex justify-center items-center">
      <%= @candidate.nama %>
    </div>
    """
  end

  def mount(%{"dapil" => dapil_slug}, _session, socket) do
    dapil = String.split(dapil_slug, "-") |> Enum.join(" ")
    candidates = PetaPemilu.Candidate.by_dapil(:dpd, dapil_slug)

    {:ok, assign(socket, dapil_slug: dapil_slug, dapil: dapil, candidates: candidates)}
  end
end
