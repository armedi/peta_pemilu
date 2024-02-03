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
          case assigns.area.jenis_dapil do
            "DPD RI" -> "#b52b21"
            "DPR RI" -> "#e6d256"
            "DPRD PROVINSI" -> "#1c5192"
            "DPRD KABUPATEN/KOTA" -> "#286036"
          end
      )

    ~H"""
    <div class="w-60 shrink-0 isolate">
      <.link patch={
        case assigns.area.jenis_dapil do
          "DPD RI" -> ~p"/caleg/dpd/#{assigns.area.nama_dapil_slug}"
          "DPR RI" -> ~p"/caleg/dpr/#{assigns.area.nama_dapil_slug}"
          "DPRD PROVINSI" -> ~p"/caleg/dprd-prov/#{assigns.area.nama_dapil_slug}"
          "DPRD KABUPATEN/KOTA" -> ~p"/caleg/dprd-kabko/#{assigns.area.nama_dapil_slug}"
        end
      }>
        <div
          class="block py-3 px-2 text-white font-bold rounded-full text-center cursor-pointer relative top-1 w-60 mx-auto z-10 hover:brightness-90 border-b-4 border-l-2"
          style={"background-color: #{@color}; border-color: hsl(from #{@color} h s calc(l - 0.1));" <> if @area.jenis_dapil == "DPR RI", do: "color: unset;", else: ""}
        >
          <%= @area.jenis_dapil %>
        </div>
        <div class="pt-5 pb-4 px-6 h-44 overflow-scroll rounded-t-lg bg-white opacity-90">
          <div class="font-bold mb-2">
            DAPIL <%= @area.nama_dapil %>
          </div>
          <ul class="pl-4 list-outside list-disc">
            <%= for w <- @area.wilayah do %>
              <li><%= w %></li>
            <% end %>
          </ul>
        </div>
      </.link>
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
        class="block grow h-[100dvh] isolate"
      />
      <div class="w-full flex [&>:first-child]:ml-auto [&>:last-child]:mr-auto px-4 gap-3 overflow-scroll absolute bottom-0 pointer-events-none [&>*]:pointer-events-auto">
        <%= if Map.has_key?(assigns, :areas) && length(assigns.areas) > 0 do %>
          <%= for area <- @areas do %>
            <.dapil area={area} />
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(
        %{"map_view" => map_view_string},
        _uri,
        socket
      ) do
    map_view =
      map_view_string
      |> String.trim_leading("@")
      |> String.trim_trailing("z")
      |> String.split(",")
      |> Enum.map(fn x -> Float.parse(x) |> elem(0) end)

    [lat, lng, zoom] =
      case map_view do
        [_, _, _] -> map_view
        [lat, lng] -> [lat, lng, @default_zoom]
        _ -> [@default_lat, @default_lng, @default_zoom]
      end

    {:noreply,
     assign(socket,
       lat: lat,
       lng: lng,
       zoom: zoom
     )}
  end

  def handle_params(_unsigned_params, _ui, socket) do
    {:noreply,
     assign(socket,
       lat: @default_lat,
       lng: @default_lng,
       zoom: @default_zoom
     )}
  end

  defp set_map_view(socket, %{"lat" => lat, "lng" => lng, "zoom" => zoom}) do
    rounded_lat = if is_float(lat), do: Float.round(lat, 6), else: lat
    rounded_lng = if is_float(lng), do: Float.round(lng, 6), else: lng
    zoom = zoom * 1.0

    socket
    |> push_patch(to: "/@#{rounded_lat},#{rounded_lng},#{zoom}z")
  end

  def handle_event("map:mounted", %{"lat" => lat, "lng" => lng}, socket) do
    data = Area.by_coordinate(lat, lng)

    {:reply, %{"data" => data},
     socket
     |> set_map_view(%{"lat" => lat, "lng" => lng, "zoom" => 10})
     |> assign(areas: Enum.map(data, &Map.drop(&1, [:geojson])))}
  end

  def handle_event("map:click", %{"lat" => lat, "lng" => lng}, socket) do
    data = Area.by_coordinate(lat, lng)

    {:reply, %{"data" => data},
     socket
     |> set_map_view(%{"lat" => lat, "lng" => lng, "zoom" => socket.assigns.zoom})
     |> assign(areas: Enum.map(data, &Map.drop(&1, [:geojson])))}
  end

  def handle_event("map:zoom", %{"zoom" => zoom}, socket) do
    {:noreply,
     socket
     |> set_map_view(%{"lat" => socket.assigns.lat, "lng" => socket.assigns.lng, "zoom" => zoom})}
  end
end
