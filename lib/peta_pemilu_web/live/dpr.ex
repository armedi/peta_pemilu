defmodule PetaPemiluWeb.Live.Dpr do
  use PetaPemiluWeb, :live_view
  require Jason

  def render(assigns) do
    ~H"""
    <div>
      Caleg DPR
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
