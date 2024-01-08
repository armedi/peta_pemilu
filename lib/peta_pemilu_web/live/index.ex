defmodule PetaPemiluWeb.Live.Index do
  use PetaPemiluWeb, :live_view
  alias PetaPemilu.Area
  require Jason

  @default_zoom 5.0
  @default_lat 0.0
  @default_lng 119.3

  defp dapil(assigns) do
    assigns =
      assign(assigns,
        color:
          case assigns.area["jenis_dapil"] do
            "DPD RI" -> "#b52b21"
            "DPR RI" -> "#e6d256"
            "DPRD PROVINSI" -> "#1c5192"
            "DPRD KABUPATEN/KOTA" -> "#286036"
          end
      )

    ~H"""
    <div class="w-60 shrink-0 bg-white rounded-t opacity-90">
      <div
        class="p-4 text-white font-bold rounded-t"
        style={"background-color: #{@color}" <> if @area["jenis_dapil"] == "DPR RI", do: ";color: unset", else: ""}
      >
        <%= @area["jenis_dapil"] %>
      </div>
      <div class="p-4 h-44 overflow-scroll">
        <div class="font-bold mb-2">
          DAPIL <%= @area["nama_dapil"] %>
        </div>
        <ul class="pl-4 list-outside list-disc">
          <%= for w <- @area["wilayah"] do %>
            <li><%= w %></li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div class="relative">
      <x-maps
        id="maps"
        phx-hook="x-maps"
        phx-update="ignore"
        lat={@lat}
        lng={@lng}
        zoom={@zoom}
        class="block grow h-[100vh] isolate"
      />
      <div class="w-full flex [&>:first-child]:ml-auto [&>:last-child]:mr-auto px-4 gap-4 overflow-scroll absolute bottom-0">
        <%= if Map.has_key?(assigns, :areas) && length(assigns.areas) > 0 do %>
          <%= for area <- @areas do %>
            <.dapil area={area} />
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(
        %{"map_view" => map_view_string},
        _session,
        socket
      ) do
    map_view =
      map_view_string
      |> String.trim_leading("@")
      |> String.trim_trailing("z")
      |> String.split(",")
      |> Enum.map(fn x -> Float.parse(x) |> elem(0) end)
      |> (&Enum.zip([:lat, :lng, :zoom], &1)).()

    case map_view do
      [_, _, zoom: _zoom] -> {:ok, assign(socket, map_view)}
      [_, _] -> {:ok, assign(socket, map_view ++ [zoom: @default_zoom])}
      _ -> {:ok, assign(socket, lat: @default_lat, lng: @default_lng, zoom: @default_zoom)}
    end
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, lat: @default_lat, lng: @default_lng, zoom: @default_zoom)}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end

  defp set_map_view(socket, %{"lat" => lat, "lng" => lng, "zoom" => zoom}) do
    rounded_lat = if is_float(lat), do: Float.round(lat, 6), else: lat
    rounded_lng = if is_float(lng), do: Float.round(lng, 6), else: lng
    zoom = zoom * 1.0

    socket
    |> assign(
      lat: lat,
      lng: lng,
      zoom: zoom
    )
    |> push_patch(to: "/@#{rounded_lat},#{rounded_lng},#{zoom}z")
  end

  def handle_event("map:mounted", %{"lat" => lat, "lng" => lng}, socket) do
    {:ok, data} = Area.by_coordinate(lat, lng)

    {:reply, %{"data" => data},
     socket
     |> set_map_view(%{"lat" => lat, "lng" => lng, "zoom" => 10})
     |> assign(areas: Enum.map(data, &Map.drop(&1, ["geojson"])))}
  end

  def handle_event("map:click", %{"lat" => lat, "lng" => lng}, socket) do
    {:ok, data} = Area.by_coordinate(lat, lng)

    {:reply, %{"data" => data},
     socket
     |> set_map_view(%{"lat" => lat, "lng" => lng, "zoom" => socket.assigns.zoom})
     |> assign(areas: Enum.map(data, &Map.drop(&1, ["geojson"])))}
  end

  def handle_event("map:zoom", %{"zoom" => zoom}, socket) do
    {:noreply,
     socket
     |> set_map_view(%{"lat" => socket.assigns.lat, "lng" => socket.assigns.lng, "zoom" => zoom})}
  end
end
