defmodule PetaPemiluWeb.ProfileComponents do
  use Phoenix.Component

  def candidate_profile(assigns = %{jenis_dapil: :dpr}) do
    dpr_dprd_profile(assigns)
  end

  def candidate_profile(assigns = %{jenis_dapil: :dprd_prov}) do
    dpr_dprd_profile(assigns)
  end

  def candidate_profile(assigns = %{jenis_dapil: :dprd_kabko}) do
    dpr_dprd_profile(assigns)
  end

  defp dpr_dprd_profile(assigns) do
    ~H"""
    <main class="max-w-screen-md mx-auto my-8">
      <div class="flex mb-12">
        <div class="flex-1 flex flex-col justify-end relative">
          <img
            src={"https://infopemilu.kpu.go.id/#{@candidate["logoPartai"]}"}
            alt={@candidate["namaPartai"]}
            class="h-16 w-16 object-contain absolute top-0 right-3"
          />

          <h1 class="inline-flex min-w-0 items-end font-bold">
            <span class="inline-flex justify-center items-center h-24 w-16 text-4xl bg-gray-600 text-white rounded-l">
              <%= @candidate["nomorUrut"] %>
            </span>
            <span class="flex-1 inline-flex items-center px-6 py-4 border border-r-0 border-gray-400 text-2xl">
              <%= @candidate["nama"] %>
            </span>
          </h1>
        </div>

        <img
          src={@candidate["pasFoto"]}
          alt={@candidate["nama"]}
          class="w-32 aspect-[2/3] object-cover rounded-lg rounded-bl-none"
        />
      </div>

      <%= unless is_nil(@candidate["programUsulan"]) do %>
        <div class="mb-12">
          <h3 class="text-lg font-semibold mb-2">Program Usulan</h3>
          <ul>
            <%= for program <- @candidate["programUsulan"] do %>
              <li class="whitespace-pre-line">
                <%= program %>
              </li>
            <% end %>
          </ul>
        </div>
      <% end %>

      <div class="mb-12">
        <h3 class="text-lg font-semibold mb-2">Pekerjaan</h3>
        <p><%= @candidate["pekerjaan"] %></p>
      </div>

      <%= unless is_nil(@candidate["riwayatPekerjaan"]) do %>
        <div class="mb-12">
          <h3 class="text-lg font-semibold mb-2">Riwayat Pekerjaan</h3>
          <%= for job <- Enum.reverse(@candidate["riwayatPekerjaan"]) do %>
            <div class="mb-2">
              <h4 class="font-semibold"><%= job["namaPerusahaanLembaga"] %></h4>
              <div><%= job["jabatan"] %></div>
              <div class="text-sm text-gray-400">
                <%= job["tahunMasuk"] %> - <%= job["tahunKeluar"] %>
              </div>
            </div>
          <% end %>
        </div>
      <% end %>

      <%= unless is_nil(@candidate["riwayatPendidikan"]) do %>
        <div class="mb-12">
          <h3 class="text-lg font-semibold mb-2">Riwayat Pendidikan</h3>
          <%= for education <- Enum.reverse(@candidate["riwayatPendidikan"]) do %>
            <div class="mb-2">
              <h4 class="font-semibold"><%= education["namaInstitusi"] %></h4>
              <div><%= education["jenjangPendidikan"] %></div>
              <div class="text-sm text-gray-400">
                <%= education["tahunMasuk"] %> - <%= education["tahunKeluar"] %>
              </div>
            </div>
          <% end %>
        </div>
      <% end %>

      <%= unless is_nil(@candidate["riwayatKursusDiklat"]) do %>
        <div class="mb-12">
          <h3 class="text-lg font-semibold mb-2">Riwayat Kursus dan Diklat</h3>
          <%= for course <- Enum.reverse(@candidate["riwayatKursusDiklat"]) do %>
            <div class="mb-2">
              <h4 class="font-semibold"><%= course["namaKursus"] %></h4>
              <div><%= course["lembagaPenyelenggara"] %></div>
              <div>Nomor Sertifikat: <%= course["nomorSertifikat"] %></div>
              <div class="text-sm text-gray-400">
                <%= course["tahunMasuk"] %> - <%= course["tahunKeluar"] %>
              </div>
            </div>
          <% end %>
        </div>
      <% end %>

      <%= unless is_nil(@candidate["riwayatOrganisasi"]) do %>
        <div class="mb-12">
          <h3 class="text-lg font-semibold mb-2">Riwayat Organisasi</h3>
          <%= for org <- Enum.reverse(@candidate["riwayatOrganisasi"]) do %>
            <div class="mb-2">
              <h4 class="font-semibold"><%= org["namaOrganisasi"] %></h4>
              <div><%= org["jabatan"] %></div>
              <div class="text-sm text-gray-400">
                <%= org["tahunMasuk"] %> - <%= org["tahunKeluar"] %>
              </div>
            </div>
          <% end %>
        </div>
      <% end %>

      <%= unless is_nil(@candidate["riwayatPenghargaan"]) do %>
        <div class="mb-12">
          <h3 class="text-lg font-semibold mb-2">Riwayat Penghargaan</h3>
          <%= for prize <- Enum.reverse(@candidate["riwayatPenghargaan"]) do %>
            <div class="mb-2">
              <h4 class="font-semibold"><%= prize["namaPenghargaan"] %></h4>
              <div><%= prize["lembaga"] %></div>
              <div class="text-sm text-gray-400"><%= prize["tahun"] %></div>
            </div>
          <% end %>
        </div>
      <% end %>
    </main>
    """
  end
end
