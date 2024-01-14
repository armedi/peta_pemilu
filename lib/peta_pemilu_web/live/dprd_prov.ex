defmodule PetaPemiluWeb.Live.DprdProv do
  use PetaPemiluWeb, :live_view
  require Jason

  def render(assigns) do
    ~H"""
    <div class="pb-8">
      <div
        style={"background-image: url(#{static_path(@socket, "/images/wave.svg")})"}
        class="bg-left-bottom bg-[length:auto_2rem] bg-repeat-x pb-8 mb-12 text-center"
      >
        <h1 class="bg-red-500 pt-6 px-8 text-white uppercase font-bold text-xl">
          <span class="block">Surat Suara Pemilihan Umum</span>
          <span class="block">Anggota Dewan Perwakilan Rakyat</span>
          <span class="block">Daerah Provinsi</span>
          <span class="block">Tahun 2024</span>
        </h1>
      </div>
      <h2 class="text-center mb-12 font-bold text-xl uppercase">
        <span class="block">Daerah Pemilihan</span>
        <span class="block"><%= @dapil %></span>
      </h2>
      <div class="flex flex-wrap justify-center gap-8 px-8 mx-auto">
        <%= for party <- @parties do %>
          <div
            style={"background-image: url('#{party.foto_partai}')"}
            class="h-[378px] w-80 bg-center bg-cover bg-no-repeat border border-gray-500"
          >
            <div class="h-full bg-[rgba(255,255,255,0.975)]">
              <h3 class="font-bold text-lg uppercase px-6 h-20 flex items-center gap-4 leading-5">
                <span class="block text-4xl w-10 text-center"><%= party.nomor_urut_partai %></span>
                <span class="block"><%= party.partai %></span>
              </h3>
              <ol class="[counter-reset:listCounter]">
                <%= for c <- party.caleg do %>
                  <li class="text-sm py-2 px-4 [&:first-child]:border-t border-b border-gray-500 border-spacing-0 whitespace-nowrap [counter-increment:listCounter] truncate relative before:content-[counter(listCounter)] before:text-right before:inline-block before:w-4 before:mr-4 after:content-['.'] after:absolute after:left-8">
                    <%= c["nama"] %>
                  </li>
                <% end %>
              </ol>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(%{"slug" => slug}, _session, socket) do
    dapil = String.split(slug, "-") |> Enum.join(" ")
    parties = PetaPemilu.Candidate.caleg_by_dapil(:dprd_prov, slug)

    {:ok, assign(socket, dapil: dapil, parties: parties)}
  end
end
