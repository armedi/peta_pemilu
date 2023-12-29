defmodule PetaPemiluWeb.Live.Index do
  use PetaPemiluWeb, :live_view
  alias PetaPemilu.Area
  require Jason

  defp dapil(assigns) do
    ~H"""
    <%!-- <div class="mb-6 [&:nth-child(1)]:text-[#f8c7c0] [&:nth-child(2)]:text-[#cfbaa0] [&:nth-child(3)]:text-[#a49bb4]"> --%>
    <div class="mb-6 [&:nth-child(1)]:text-[#ea5d49] [&:nth-child(2)]:text-[#aa8456] [&:nth-child(3)]:text-[#706486]">
      <div>DAPIL <%= @area["jenis_dapil"] %>: <strong><%= @area["nama_dapil"] %></strong></div>
      <ul class="list-inside list-disc">
        <%= for w <- @area["wilayah"] do %>
          <li><%= w %></li>
        <% end %>
      </ul>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="flex isolate">
      <x-maps
        id="maps"
        phx-hook="x-maps"
        phx-update="ignore"
        center={Jason.encode!(%{"lat" => @lat, "lng" => @lng})}
        zoom={@zoom}
        class="block grow h-screen relative after:content-[''] after:absolute after:top-0 after:right-0 after:w-16 after:h-full after:bg-gradient-to-r after:from-transparent after:to-white isolate after:z-[400]"
      />
      <div class="w-72 p-8">
        <%= if Map.has_key?(assigns, :areas) do %>
          <%= for area <- @areas do %>
            <.dapil area={area} />
          <% end %>
        <% end %>
      </div>
    </div>
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

    {:ok, data} = Area.by_coordinate(lat, lng)

    {:reply, %{"data" => data},
     socket
     |> assign(lat: lat, lng: lng, areas: Enum.map(data, &Map.drop(&1, ["geojson"])))
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
