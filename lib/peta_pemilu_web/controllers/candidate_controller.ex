defmodule PetaPemiluWeb.CandidateController do
  use PetaPemiluWeb, :controller
  alias PetaPemilu.Candidate

  def dpd(conn, %{"id" => id}) do
    {:ok, response} = Candidate.fetch_candidate_profile("dpd", id)

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(response.status, response.body)
  end

  def dpr(conn, %{"id" => id}) do
    {:ok, response} = Candidate.fetch_candidate_profile("dpr", id)

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(response.status, response.body)
  end

  def dprd_prov(conn, %{"id" => id}) do
    {:ok, response} = Candidate.fetch_candidate_profile("dprd-prov", id)

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(response.status, response.body)
  end

  def dprd_kabko(conn, %{"id" => id}) do
    {:ok, response} = Candidate.fetch_candidate_profile("dprd-kabko", id)

    conn
    |> put_resp_content_type("text/html")
    |> send_resp(response.status, response.body)
  end
end
