defmodule PetaPemiluWeb.Live.DprdProv do
  use PetaPemiluWeb, :live_view
  require Jason

  def render(assigns) do
    ~H"""
    <div>
      Caleg DPRD Provinsi
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
