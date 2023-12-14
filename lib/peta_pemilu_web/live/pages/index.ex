defmodule PetaPemiluWeb.Pages.Index do
  use PetaPemiluWeb, :live_view
  require Jason

  def render(assigns) do
    ~H"""
    <x-maps
      id="maps"
      phx-hook="x-maps"
      phx-update="ignore"
      center={Jason.encode!([@lat, @lng])}
      zoom={@zoom}
      class="h-screen"
    />
    """
  end

  def mount(params, _session, socket) do
    %{"lat" => lat, "lng" => lng, "zoom" => zoom} =
      params["map_view"]
      |> String.trim_leading("@")
      |> String.trim_trailing("z")
      |> String.split(",")
      |> Enum.map(fn x -> Float.parse(x) |> elem(0) end)
      |> (&Enum.zip(["lat", "lng", "zoom"], &1)).()
      |> Enum.into(%{})

    {:ok, assign(socket, lat: lat, lng: lng, zoom: zoom)}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("select_point", %{"lat" => lat, "lng" => lng}, socket) do
    {lat, lng} = {Float.round(lat, 6), Float.round(lng, 6)}
    zoom = socket.assigns.zoom

    {:reply, %{"center" => [lat, lng]}, push_patch(socket, to: "/@#{lat},#{lng},#{zoom}z")}
  end
end
