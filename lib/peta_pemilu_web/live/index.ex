defmodule PetaPemiluWeb.Live.Index do
  use PetaPemiluWeb, :live_view
  alias PetaPemilu.Area
  require Jason

  def render(assigns) do
    ~H"""
    <x-maps
      id="maps"
      phx-hook="x-maps"
      phx-update="ignore"
      center={Jason.encode!(%{"lat" => @lat, "lng" => @lng})}
      zoom={@zoom}
      class="h-screen"
    />
    """
  end

  def mount(
        %{"map_view" => map_view},
        _session,
        socket
      ) do
    assigns =
      map_view
      |> String.trim_leading("@")
      |> String.trim_trailing("z")
      |> String.split(",")
      |> Enum.map(fn x -> Float.parse(x) |> elem(0) end)
      |> (&Enum.zip([:lat, :lng, :zoom], &1)).()

    case assigns do
      [_, _, zoom: _zoom] -> {:ok, assign(socket, assigns)}
      [_, _] -> {:ok, assign(socket, assigns ++ [zoom: 5.0])}
      _ -> {:ok, assign(socket, lat: 0.0, lng: 119.3, zoom: 5.0)}
    end
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, lat: 0.0, lng: 119.3, zoom: 5.0)}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end

  def handle_event("select_map_point", %{"lat" => lat, "lng" => lng}, socket) do
    rounded_lat = if is_float(lat), do: Float.round(lat, 6), else: lat
    rounded_lng = if is_float(lng), do: Float.round(lng, 6), else: lng
    zoom = socket.assigns.zoom

    {:ok, data} = Area.geo_json(lat, lng)

    {:reply, %{"data" => data},
     socket
     |> assign(lat: lat, lng: lng)
     |> push_patch(to: "/@#{rounded_lat},#{rounded_lng},#{zoom}z")}
  end

  def handle_event("zoom_map", %{"zoom" => zoom}, socket) do
    lat = socket.assigns.lat
    lng = socket.assigns.lng
    zoom = zoom * 1.0

    rounded_lat = if is_float(lat), do: Float.round(lat, 6), else: lat
    rounded_lng = if is_float(lng), do: Float.round(lng, 6), else: lng

    {:noreply,
     socket
     |> assign(zoom: zoom)
     |> push_patch(to: "/@#{rounded_lat},#{rounded_lng},#{zoom}z")}
  end
end
