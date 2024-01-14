defmodule PetaPemiluWeb.Live.Dpd do
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
          <span class="block">Anggota Dewan Perwakilan Daerah</span>
          <span class="block">Republik Indonesia</span>
          <span class="block">Tahun 2024</span>
        </h1>
      </div>
      <h2 class="text-center mb-12 font-bold text-xl uppercase">
        <span class="block">Daerah Pemilihan</span>
        <span class="block"><%= @dapil %></span>
      </h2>
      <div class="flex flex-wrap justify-center gap-4 mx-auto max-w-6xl">
        <%= for candidate <- @candidates do %>
          <div class="h-64 w-32 overflow-clip border flex flex-col border-gray-500 text-center">
            <div class="p-1 font-bold text-lg"><%= candidate.nomor_urut %></div>
            <img
              src={candidate.foto}
              loading="lazy"
              alt={candidate.nama}
              class="w-32 h-40 object-cover object-top"
            />
            <div style="text-wrap: balance" class="text-xs flex-1 flex justify-center items-center"><%= candidate.nama %></div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(%{"slug" => slug}, _session, socket) do
    dapil = String.split(slug, "-") |> Enum.join(" ")
    candidates = PetaPemilu.Candidate.caleg_by_dapil(:dpd, slug)

    {:ok, assign(socket, candidates: candidates, dapil: dapil)}
  end
end
