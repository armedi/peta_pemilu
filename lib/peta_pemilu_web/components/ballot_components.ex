defmodule PetaPemiluWeb.BallotComponents do
  use Phoenix.Component
  use PetaPemiluWeb, :verified_routes

  attr :jenis_dapil, :atom, required: true
  attr :background_image, :string, required: true

  def page_header(assigns) do
    ~H"""
    <div
      style={"background-image: #{assigns.background_image}"}
      class="bg-left-bottom bg-[length:auto_2rem] bg-repeat-x pb-8 mb-12 text-center"
    >
      <h1
        class={[
          case assigns.jenis_dapil do
            :dpd -> "bg-[#b52b21] text-white"
            :dpr -> "bg-[#e6d256]"
            :dprd_prov -> "bg-[#1c5192] text-white"
            :dprd_kabko -> "bg-[#286036] text-white"
          end,
          "pt-6 px-8 uppercase font-bold text-xl"
        ]}
        style="text-wrap: balance;"
      >
        <span class="block">Surat Suara Pemilihan Umum</span>
        <span class="block">Anggota Dewan Perwakilan Rakyat</span>
        <span class="block">Republik Indonesia</span>
        <span class="block">Tahun 2024</span>
      </h1>
    </div>
    """
  end

  attr :dapil, :string, required: true

  def page_subheader(assigns) do
    ~H"""
    <h2 class="text-center mb-12 font-bold text-xl uppercase">
      <span class="block">Daerah Pemilihan</span>
      <span class="block"><%= @dapil %></span>
    </h2>
    """
  end

  attr :jenis_dapil, :atom, required: true
  attr :dapil_slug, :string, required: true, doc: "the slug of the dapil"
  attr :parties, :list, required: true, doc: "the list of parties with their candidates"

  def parties_candidates(assigns) do
    assigns =
      assign(assigns,
        rows:
          assigns.parties
          |> Enum.max_by(&length(Map.get(&1, :caleg)))
          |> Map.get(:caleg)
          |> length()
          |> (&Enum.max([&1, 10])).()
      )

    ~H"""
    <div class="flex flex-wrap justify-center gap-8 px-8 mx-auto">
      <%= for party <- @parties do %>
        <div
          style={"background-image: url('#{party.foto_partai}'); height: #{82 + (@rows * 37)}px"}
          class="h-[452px] w-80 bg-center bg-cover bg-no-repeat border border-gray-500"
        >
          <div class="h-full bg-[rgba(255,255,255,0.975)]">
            <h3 class="font-bold text-lg uppercase px-6 h-20 flex items-center gap-4 leading-5">
              <span class="block text-4xl w-10 text-center"><%= party.nomor_urut_partai %></span>
              <span class="block"><%= party.partai %></span>
            </h3>
            <ol class="[counter-reset:listCounter]">
              <%= for c <- party.caleg do %>
                <li class="[&:first-child]:border-t border-b border-gray-500 border-spacing-0 text-sm [counter-increment:listCounter] relative">
                  <%= if c["id"] do %>
                    <a
                      href={
                        "/caleg/#{case assigns.jenis_dapil do
                          :dpr -> "dpr"
                          :dprd_prov -> "dprd-prov"
                          :dprd_kabko -> "dprd-kabko"
                        end}/#{assigns.dapil_slug}/#{c["id"]}"
                      }
                      target="_blank"
                      class="block w-full py-2 px-4 whitespace-nowrap truncate before:content-[counter(listCounter)] before:text-right before:inline-block before:w-4 before:mr-4 after:content-['.'] after:absolute after:left-8"
                    >
                      <%= c["nama"] %>
                    </a>
                  <% else %>
                    <span class="block w-full text-gray-400 py-2 px-4 whitespace-nowrap truncate before:content-[counter(listCounter)] before:text-right before:inline-block before:w-4 before:mr-4 after:content-['.'] after:absolute after:left-8">
                      <%= c["nama"] %>
                    </span>
                  <% end %>
                </li>
              <% end %>
            </ol>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
