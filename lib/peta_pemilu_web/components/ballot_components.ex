defmodule PetaPemiluWeb.BallotComponents do
  use Phoenix.Component
  use PetaPemiluWeb, :verified_routes

  attr :jenis_dapil, :atom, required: true
  attr :background_image, :string, required: true

  def page_header(assigns = %{jenis_dapil: :dpd}) do
    ~H"""
    <div
      style={"background-image: #{assigns.background_image}"}
      class="bg-left-bottom bg-[length:auto_2rem] bg-repeat-x pb-8 mb-12 text-center"
    >
      <h1
        class="bg-[#b52b21] text-white pt-6 px-8 uppercase font-bold text-xl"
        style="text-wrap: balance;"
      >
        <span class="block">Surat Suara Pemilihan Umum</span>
        <span class="block">Anggota Dewan Perwakilan Daerah</span>
        <span class="block">Republik Indonesia</span>
        <span class="block">Tahun 2024</span>
      </h1>
    </div>
    """
  end

  def page_header(assigns = %{jenis_dapil: :dpr}) do
    ~H"""
    <div
      style={"background-image: #{assigns.background_image}"}
      class="bg-left-bottom bg-[length:auto_2rem] bg-repeat-x pb-8 mb-12 text-center"
    >
      <h1 class="bg-[#e6d256] pt-6 px-8 uppercase font-bold text-xl" style="text-wrap: balance;">
        <span class="block">Surat Suara Pemilihan Umum</span>
        <span class="block">Anggota Dewan Perwakilan Rakyat</span>
        <span class="block">Republik Indonesia</span>
        <span class="block">Tahun 2024</span>
      </h1>
    </div>
    """
  end

  def page_header(assigns = %{jenis_dapil: :dprd_prov}) do
    ~H"""
    <div
      style={"background-image: #{assigns.background_image}"}
      class="bg-left-bottom bg-[length:auto_2rem] bg-repeat-x pb-8 mb-12 text-center"
    >
      <h1
        class="bg-[#1c5192] text-white pt-6 px-8 uppercase font-bold text-xl"
        style="text-wrap: balance;"
      >
        <span class="block">Surat Suara Pemilihan Umum</span>
        <span class="block">Anggota Dewan Perwakilan Rakyat</span>
        <span class="block">Daerah Provinsi</span>
        <span class="block">Tahun 2024</span>
      </h1>
    </div>
    """
  end

  def page_header(assigns = %{jenis_dapil: :dprd_kabko}) do
    ~H"""
    <div
      style={"background-image: #{assigns.background_image}"}
      class="bg-left-bottom bg-[length:auto_2rem] bg-repeat-x pb-8 mb-12 text-center"
    >
      <h1
        class="bg-[#286036] text-white pt-6 px-8 uppercase font-bold text-xl"
        style="text-wrap: balance;"
      >
        <span class="block">Surat Suara Pemilihan Umum</span>
        <span class="block">Anggota Dewan Perwakilan Rakyat</span>
        <span class="block">Daerah Kabupaten/Kota</span>
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
        <div style={"height: #{82 + (@rows * 37)}px"} class="h-[452px] w-80 border border-gray-500">
          <h3 class="font-bold uppercase px-6 h-20 flex items-center gap-4 leading-5">
            <span class="block text-4xl w-10 text-center"><%= party.nomor_urut_partai %></span>
            <span class="block flex-1"><%= party.partai %></span>
            <img class="block w-10 h-10 object-contain" src={party.foto_partai} />
          </h3>
          <ol class="[counter-reset:listCounter]">
            <%= for c <- party.caleg do %>
              <li class="[&:first-child]:border-t border-b border-gray-500 border-spacing-0 text-sm [counter-increment:listCounter] relative">
                <%= if c["id"] do %>
                  <a
                    href={
                      ~p"/caleg/#{case assigns.jenis_dapil do
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
      <% end %>
    </div>
    """
  end
end
