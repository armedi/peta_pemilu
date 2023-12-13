defmodule PetaPemiluWeb.Pages.Index do
  # In Phoenix v1.6+ apps, the line is typically: use PetaPemiluWeb, :live_view
  use Phoenix.LiveView
  import Phoenix.LiveView
  require Jason

  def render(assigns) do
    ~H"""
    <x-maps id="maps" phx-hook="x-maps" phx-update="ignore" class="h-screen" />
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("click", %{"latlng" => %{"lat" => lat, "lng" => lng}}, socket) do
    center = [lat, lng]

    {:reply, %{"center" => center}, socket |> push_patch(to: "/?lat=#{lat}&lng=#{lng}")}
  end
end
