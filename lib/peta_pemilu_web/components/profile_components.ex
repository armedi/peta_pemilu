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
                    src="https://infopemilu.kpu.go.id/berkas-sipol/parpol/profil/gambar_parpol/1656538128_Logo PKB.png"
                    alt="Your Image"
                    width="40px"
                  />
                </td>
                <td>
                  <h5>Partai Kebangkitan Bangsa</h5>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div>
          <i>Nomor urut</i>
          <h3>2</h3>

          <img
            src="https://infopemilu.kpu.go.id/dct/berkas-silon/calon_unggah/20510/pas_foto/3674072811840001.png"
            alt="Your Image"
            width="200px"
          />

          <i>Nama dapil</i>
          <h5>BANTEN III</h5>
        </div>
        <div>
          <table>
            <tbody>
              <tr>
                <td><strong>Nama Lengkap:</strong></td>
                <td>MOH. RANO ALFATH, S.H., M.H.</td>
              </tr>
              <tr>
                <td><strong>Tempat Lahir:</strong></td>
                <td>Tanjung Karang</td>
              </tr>
              <tr>
                <td><strong>Tanggal Lahir:</strong></td>
                <td>28-11-1984</td>
              </tr>
              <tr>
                <td><strong>Usia:</strong></td>
                <td>38 tahun</td>
              </tr>
              <tr>
                <td><strong>Jenis Kelamin:</strong></td>
                <td>LAKI-LAKI</td>
              </tr>
              <tr>
                <td><strong>Agama:</strong></td>
                <td>Islam</td>
              </tr>
              <tr>
                <td><strong>Status Perkawinan:</strong></td>
                <td>Sudah</td>
              </tr>
              <tr>
                <td><strong>Status Disabilitas:</strong></td>
                <td>Bukan Penyandang Disabilitas</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    <div>
      <h3>ALAMAT</h3>
      <li>
        <strong>Alamat lengkap:</strong> Komplek Islamic Village, Jl. Zaitun Raya
        Blok C2 No.14 (sebelah butik syaira)
      </li>
      <li><strong>RT :</strong> 005</li>
      <li><strong>RW:</strong> 004</li>
      <li><strong>Provinsi:</strong> BANTEN</li>
      <li><strong>Kabupaten/Kota:</strong> KOTA TANGERANG SELATAN</li>
      <li><strong>Kecamatan:</strong></li>
      <li><strong>Kelurahan:</strong></li>
    </div>
    <div>
      <h3>PEKERJAAN</h3>
      <p>ANGGOTA DPR</p>
    </div>
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
          <tr>
            <td>PT Lubana Sukses Abadi</td>
            <td>Direktur</td>
            <td>2015</td>
            <td>2023</td>
          </tr>
          <tr>
            <td>PT Natural Green Land</td>
            <td>Direktur</td>
            <td>2015</td>
            <td>2023</td>
          </tr>
          <tr>
            <td>PT Bersatu Jaya</td>
            <td>Direktur</td>
            <td>2015</td>
            <td>2023</td>
          </tr>
          <tr>
            <td>Dewan Perwakilan Rakyat Daerah Provinsi Banten</td>
            <td>Anggota</td>
            <td>2014</td>
            <td>2018</td>
          </tr>
          <tr>
            <td>Dewan Perwakilan Rakyat Republik Indonesia</td>
            <td>Anggota</td>
            <td>2019</td>
            <td>2024</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div>
      <h3>STATUS HUKUM</h3>
      <p>Tidak Memiliki Status Hukum</p>
    </div>
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
          <tr>
            <td>SMA</td>
            <td>SMA Negeri 7 Tangerang</td>
            <td>2000</td>
            <td>2003</td>
          </tr>
          <tr>
            <td>S1</td>
            <td>Universitas Tarumanegara</td>
            <td>2003</td>
            <td>2007</td>
          </tr>
          <tr>
            <td>S2</td>
            <td>Universitas Tarumanegara</td>
            <td>2009</td>
            <td>2010</td>
          </tr>
        </tbody>
      </table>
    </div>
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
          <tr>
            <td>-</td>
            <td>-</td>
            <td>-</td>
            <td>-</td>
          </tr>
        </tbody>
      </table>
    </div>
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
          <tr>
            <td>Kongres Advokat Indonesia</td>
            <td>Anggota</td>
            <td>2014</td>
            <td>2014</td>
          </tr>
          <tr>
            <td>Perhimpunan Advokat Indonesia</td>
            <td>Anggota</td>
            <td>2014</td>
            <td>2014</td>
          </tr>
          <tr>
            <td>Himpunan Pengusaha Muda Indonesia</td>
            <td>Wakil Ketua Bidang Properti dan Usaha</td>
            <td>2014</td>
            <td>2014</td>
          </tr>
          <tr>
            <td>DPD Komite Nasional Pemuda Indonesia (KNPI) Banten</td>
            <td>Ketua</td>
            <td>2017</td>
            <td>2017</td>
          </tr>
          <tr>
            <td>PWNU Provinsi Banten</td>
            <td>Bendahara</td>
            <td>2018</td>
            <td>2018</td>
          </tr>
          <tr>
            <td>Garda Bangsa</td>
            <td>Bendahara Umum</td>
            <td>2020</td>
            <td>2020</td>
          </tr>
        </tbody>
      </table>
    </div>
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
          <tr>
            <td>-</td>
            <td>-</td>
            <td>-</td>
          </tr>
        </tbody>
      </table>
    </div>
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
          <tr>
            <td>-</td>
            <td>-</td>
            <td>-</td>
            <td>-</td>
          </tr>
        </tbody>
      </table>
    </div>
    <div>
      <h3>PROGRAM USULAN</h3>
      <li>
        <strong>
          1. Program Pelatihan dan Bursa Kerja Indonesia saat ini memasuki era bonus
          demografi, di mana penduduk usia produktif lebih banyak dibandingkan
          dengan usia tidak produktif. Saya ingin potensi anak muda dimaksimalkan
          seoptimal mungkin dengan mengadakan program pelatihan dan bursa kerja yang
          akan berguna bagi produktivitas mereka. Program ini menyasar mereka yang
          baru lulus kuliah / fresh graduate maupun masyarakat yang sudah merupakan
          angkatan kerja. 2. Meningkatkan partisipasi politik anak muda Saya ingin
          memperjuangkan kebijakan yang mendukung partisipasi politik anak muda,
          termasuk penyediaan akses informasi dan pelatihan tentang demokrasi dan
          hak-hak politik, peningkatan partisipasi pemilih muda dalam pemilihan umum
          dan pemilihan kepala daerah, serta pemberian dukungan kepada organisasi
          dan inisiatif yang mempromosikan partisipasi politik anak muda. 3. Bantuan
          Hukum Kepada Masyarakat Program ini sebenarnya sudah berjalan ketika saya
          masih menduduki kursi anggota DPR RI, saya akan terus membuka program ini
          bagi masyarakat yang membutuhkan bantuan hukum dalam memenuhi hak-haknya.
          4. Program Pendidikan Kreatif Program pendidikan kreatif dapat membantu
          anak muda memperoleh keterampilan dan pengetahuan tentang seni, desain,
          teknologi, dan kreativitas. Saya ingin memperjuangkan kebijakan dan
          program yang mendukung pendidikan kreatif, termasuk penyediaan akses ke
          fasilitas dan sumber daya, khususnya di pesantren-pesantren dimana hal
          tersebut masih kurang dilakukan. Dan masih banyak lagi.:
        </strong>
      </li>
    </div>
    <div>
      <h3>RIWAYAT PASANGAN</h3>
      <table>
        <thead>
          <tr>
            <th>Nama Pasangan</th>
            <th>Status Pasangan</th>
            <th>Jumlah Anak</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>Ferryka Budiastreani</td>
            <td>Menikah</td>
            <td>3</td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
