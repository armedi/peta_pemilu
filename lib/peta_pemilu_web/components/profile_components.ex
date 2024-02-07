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
    <div>
      <div>
        <div>
          <h4>PROFIL CALON</h4>
        </div>
        <div>
          <table>
            <tbody>
              <tr>
                <td width="50">
                  <img
                    src={"https://infopemilu.kpu.go.id/#{@candidate["logoPartai"]}"}
                    alt={@candidate["namaPartai"]}
                    width="40px"
                  />
                </td>
                <td>
                  <h5><%= @candidate["namaPartai"] %></h5>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div>
          <i>Nomor urut</i>
          <h3><%= @candidate["nomorUrut"] %></h3>

          <img src={@candidate["pasFoto"]} alt={@candidate["nama"]} width="200px" />

          <i>Nama dapil</i>
          <h5><%= @candidate["namaDapil"] %></h5>
        </div>
        <div>
          <table>
            <tbody>
              <tr>
                <td><strong>Nama Lengkap:</strong></td>
                <td><%= @candidate["nama"] %></td>
              </tr>
              <tr>
                <td><strong>Tempat Lahir:</strong></td>
                <td><%= @candidate["tempatLahir"] %></td>
              </tr>
              <tr>
                <td><strong>Usia:</strong></td>
                <td><%= @candidate["usia"] %>></td>
              </tr>
              <tr>
                <td><strong>Jenis Kelamin:</strong></td>
                <td><%= @candidate["jenisKelamin"] %></td>
              </tr>
              <tr>
                <td><strong>Agama:</strong></td>
                <td><%= @candidate["agama"] %></td>
              </tr>
              <tr>
                <td><strong>Status Disabilitas:</strong></td>
                <td><%= @candidate["statusDisabilitas"] %></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div>
      <h3>PEKERJAAN</h3>
      <p><%= @candidate["pekerjaan"] %></p>
    </div>
    <%= unless is_nil(@candidate["riwayatPekerjaan"]) do %>
      <div>
        <h3>RIWAYAT PEKERJAAN</h3>
        <table>
          <thead>
            <tr>
              <th>Nama Perusahaan / Lembaga</th>
              <th>Jabatan</th>
              <th>Tahun Masuk</th>
              <th>Tahun Keluar</th>
            </tr>
          </thead>
          <tbody>
            <%= for job <- @candidate["riwayatPekerjaan"] do %>
              <tr>
                <td><%= job["namaPerusahaanLembaga"] %></td>
                <td><%= job["jabatan"] %></td>
                <td><%= job["tahunMasuk"] %></td>
                <td><%= job["tahunKeluar"] %></td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    <% end %>

    <div>
      <h3>STATUS HUKUM</h3>
      <p><%= @candidate["statusHukum"] %></p>
    </div>
    <%= unless is_nil(@candidate["riwayatPendidikan"]) do %>
      <div>
        <h3>RIWAYAT PENDIDIKAN</h3>
        <table>
          <thead>
            <tr>
              <th>Jenjang Pendidikan</th>
              <th>Nama Institusi</th>
              <th>Tahun Masuk</th>
              <th>Tahun Keluar</th>
            </tr>
          </thead>
          <tbody>
            <%= for education <- @candidate["riwayatPendidikan"] do %>
              <tr>
                <td><%= education["jenjangPendidikan"] %></td>
                <td><%= education["namaInstitusi"] %></td>
                <td><%= education["tahunMasuk"] %></td>
                <td><%= education["tahunKeluar"] %></td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    <% end %>
    <%= unless is_nil(@candidate["riwayatKursusDiklat"]) do %>
      <div>
        <h3>RIWAYAT KURSUS DAN DIKLAT</h3>
        <table>
          <thead>
            <tr>
              <th>Nama Kursus</th>
              <th>lembaga penyelenggara</th>
              <th>nomor sertifikat</th>
              <th>Tahun Masuk</th>
              <th>Tahun Keluar</th>
            </tr>
          </thead>
          <tbody>
            <%= for course <- @candidate["riwayatKursusDiklat"] do %>
              <tr>
                <td><%= course["namaKursus"] %></td>
                <td><%= course["lembagaPenyelenggara"] %></td>
                <td><%= course["nomorSertifikat"] %></td>
                <td><%= course["tahunMasuk"] %></td>
                <td><%= course["tahunKeluar"] %></td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    <% end %>
    <%= unless is_nil(@candidate["riwayatOrganisasi"]) do %>
      <div>
        <h3>RIWAYAT ORGANISASI</h3>
        <table>
          <thead>
            <tr>
              <th>Nama Organisasi</th>
              <th>Jabatan</th>
              <th>Tahun Masuk</th>
              <th>Tahun Keluar</th>
            </tr>
          </thead>
          <tbody>
            <%= for org <- @candidate["riwayatOrganisasi"] do %>
              <tr>
                <td><%= org["namaOrganisasi"] %></td>
                <td><%= org["jabatan"] %></td>
                <td><%= org["tahunMasuk"] %></td>
                <td><%= org["tahunKeluar"] %></td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    <% end %>
    <%= unless is_nil(@candidate["riwayatPenghargaan"]) do %>
      <div>
        <h3>RIWAYAT PENGHARGAAN</h3>
        <table>
          <thead>
            <tr>
              <th>Nama Penghargaan</th>
              <th>Lembaga</th>
              <th>Tahun</th>
            </tr>
          </thead>
          <tbody>
            <%= for prize <- @candidate["riwayatPenghargaan"] do %>
              <tr>
                <td><%= prize["namaPenghargaan"] %></td>
                <td><%= prize["lembaga"] %></td>
                <td><%= prize["tahun"] %></td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </div>
    <% end %>
    <%= unless is_nil(@candidate["programUsulan"]) do %>
      <div>
        <h3>PROGRAM USULAN</h3>
        <ul>
          <%= for program <- @candidate["programUsulan"] do %>
            <li>
              <%= program %>
            </li>
          <% end %>
        </ul>
      </div>
    <% end %>
    """
  end
end
