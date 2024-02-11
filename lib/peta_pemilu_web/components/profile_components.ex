defmodule PetaPemiluWeb.ProfileComponents do
  use Phoenix.Component

  def candidate_profile(assigns) do
    ~H"""
    <main class="max-w-screen-md mx-auto p-8">
      <div class="flex flex-col-reverse sm:flex-row mb-12 relative drop-shadow">
        <div class="flex-1 flex flex-col justify-end relative">
          <h1 class="inline-flex min-w-0 items-end font-bold">
            <span class="inline-flex justify-center items-center h-24 w-16 text-4xl bg-gray-600 text-white rounded-l">
              <%= @candidate["nomorUrut"] %>
            </span>
            <span class="flex-1 inline-flex items-center -ml-[2px] px-6 py-4 border-2 sm:border-r-0 border-gray-600 text-2xl">
              <%= @candidate["nama"] %>
            </span>
          </h1>
        </div>

        <div class="mx-auto mb-4 sm:mb-0 relative">
          <%= unless is_nil(@candidate["logoPartai"]) do %>
            <img
              src={"https://infopemilu.kpu.go.id/#{@candidate["logoPartai"]}"}
              alt={@candidate["namaPartai"]}
              class="h-8 sm:h-16 w-8 sm:w-16 object-contain absolute top-1 sm:top-0 right-1 sm:right-36"
            />
          <% end %>

          <img
            src={@candidate["pasFoto"]}
            alt={@candidate["nama"]}
            class="w-52 sm:w-32 aspect-[2/3] object-cover rounded-lg sm:rounded-bl-none"
          />
        </div>
      </div>

      <%= unless is_nil(@candidate["motivasi"]) do %>
        <div class="mb-12">
          <h3 class="text-lg font-semibold mb-2">Motivasi</h3>
          <ul>
            <%= for motivation <- @candidate["motivasi"] do %>
              <li class="whitespace-pre-line">
                <%= motivation %>
              </li>
            <% end %>
          </ul>
        </div>
      <% end %>

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
        <h3 class="inline-block text-lg font-semibold mb-2 after:content-[':']">Usia</h3>
        <p class="inline-block">
          <%= if @candidate["usia"] do %>
            <%= @candidate["usia"] %> tahun
          <% else %>
            -
          <% end %>
        </p>
      </div>

      <div class="mb-12">
        <h3 class="inline-block text-lg font-semibold mb-2 after:content-[':']">Agama</h3>
        <p class="inline-block">
          <%= if @candidate["agama"] do %>
            <%= @candidate["agama"] %>
          <% else %>
            -
          <% end %>
        </p>
      </div>

      <div class="mb-12">
        <h3 class="inline-block text-lg font-semibold mb-2 after:content-[':']">Status Hukum</h3>
        <p class="inline-block">
          <%= if @candidate["statusHukum"] do %>
            <%= @candidate["statusHukum"] %>
          <% else %>
            -
          <% end %>
        </p>
      </div>

      <%= unless is_nil(@candidate["pekerjaan"]) do %>
        <div class="mb-12">
          <h3 class="inline-block text-lg font-semibold mb-2 after:content-[':']">Pekerjaan</h3>
          <p class="inline-block">
            <%= @candidate["pekerjaan"] %>
          </p>
        </div>
      <% end %>

      <%= unless is_nil(@candidate["riwayatPekerjaan"]) do %>
        <div class="mb-12">
          <h3 class="text-lg font-semibold mb-2">Riwayat Pekerjaan</h3>
          <%= for job <- @candidate["riwayatPekerjaan"] do %>
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
          <%= for education <- @candidate["riwayatPendidikan"] do %>
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
          <%= for course <- @candidate["riwayatKursusDiklat"] do %>
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
          <%= for org <- @candidate["riwayatOrganisasi"] do %>
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
          <%= for prize <- @candidate["riwayatPenghargaan"] do %>
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
