defmodule PetaPemiluWeb.CandidateController do
  use PetaPemiluWeb, :controller

  def dpd(conn, %{"id" => id}) do
    conn
    |> put_root_layout(html: false)
    |> put_layout(html: false)
    |> render(:show,
      url: "https://infopemilu.kpu.go.id/Pemilu/Dct_dpd/profil",
      data: [{"ID_CANDIDATE", id}, {"pilihan_publikasi", "BERSEDIA"}]
    )
  end

  def dpr(conn, %{"id" => id}) do
    conn
    |> put_root_layout(html: false)
    |> put_layout(html: false)
    |> render(:show,
      url: "https://infopemilu.kpu.go.id/Pemilu/Dct_dpr/profile",
      data: [{"id_calon_dpr", id}, {"status_publikasi", "Bersedia"}]
    )
  end

  def dprd_prov(conn, %{"id" => id}) do
    conn
    |> put_root_layout(html: false)
    |> put_layout(html: false)
    |> render(:show,
      url: "https://infopemilu.kpu.go.id/Pemilu/Dct_dprprov/profile",
      data: [{"id_calon_dpr", id}, {"status_publikasi", "Bersedia"}]
    )
  end

  def dprd_kabko(conn, %{"id" => id}) do
    conn
    |> put_root_layout(html: false)
    |> put_layout(html: false)
    |> render(:show,
      url: "https://infopemilu.kpu.go.id/Pemilu/Dct_dprd/profile",
      data: [{"id_calon_dpr", id}, {"status_publikasi", "Bersedia"}]
    )
  end
end
