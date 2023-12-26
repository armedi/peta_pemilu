defmodule PetaPemiluWeb.CandidateController do
  use PetaPemiluWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: ~p"/")
  end

  def show(conn, _params) do
    text(conn, "Profil Calon")
  end
end
