// import "preact/debug";

import { useSignal, useSignalEffect, type Signal } from "@preact/signals";
import { type LatLngLiteral, type Map as LeafletMap } from "leaflet";
import type { ViewHook } from "phoenix_live_view";
import register from "preact-custom-element";
import { useEffect, useRef } from "preact/hooks";
import { GeoJSON, MapContainer, TileLayer, useMapEvents } from "react-leaflet";

const tagName = "x-maps";

const liveViewHooks = new WeakMap<Element, ViewHook>();

function getLiveViewHook(from: HTMLElement) {
  const xMaps = from.closest(tagName)!;
  return liveViewHooks.get(xMaps)!;
}

export const phxHooks = {
  [tagName]: {
    mounted(this: ViewHook) {
      liveViewHooks.set(this.el, this);
      this.el.dispatchEvent(new Event("mounted"));
    },
    destroyed(this: ViewHook) {
      liveViewHooks.delete(this.el);
    },
  },
};

function MapEvents(props: { center: Signal<LatLngLiteral>; areas: Signal }) {
  useMapEvents({
    click(e) {
      getLiveViewHook(e.originalEvent.target as HTMLElement).pushEvent(
        "map:click",
        e.latlng,
        ({ data }) => {
          props.areas.value = data;
        }
      );
    },
    zoom(e) {
      const map = e.target as LeafletMap;
      getLiveViewHook(map.getContainer()).pushEvent("map:zoom", {
        zoom: map.getZoom(),
      });
    },
  });

  return null;
}

function Maps(props: Record<string, string>) {
  const mapRef = useRef<LeafletMap>(null);

  const center = useSignal<LatLngLiteral>({ lat: Number(props.lat), lng: Number(props.lng) });
  const zoom = useSignal<number>(Number(props.zoom));
  const areas = useSignal<any[]>([]);

  useSignalEffect(() => {
    mapRef.current?.setView(center.value, zoom.value);
  });

  useEffect(() => {
    const element = mapRef.current?.getContainer().closest(tagName);

    const handler = async () => {
      if (window.location.pathname === "/" && "geolocation" in navigator) {
        await new Promise((resolve) => {
          navigator.geolocation.getCurrentPosition((position) => {
            center.value = {
              lat: position.coords.latitude,
              lng: position.coords.longitude,
            };
            zoom.value = 10;
            resolve(void 0);
          });
        });
      }

      getLiveViewHook(element as HTMLElement).pushEvent(
        "map:mounted",
        {
          lat: center.value.lat,
          lng: center.value.lng,
        },
        (reply) => {
          areas.value = reply.data;
        }
      );
    };

    element?.addEventListener("mounted", handler);

    return () => element?.removeEventListener("mounted", handler);
  }, []);

  return (
    <MapContainer ref={mapRef} className="h-full">
      <MapEvents center={center} areas={areas} />
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      {areas.value.map((area, idx) => {
        const [color, fillOpacity] = (() => {
          switch (area.jenis_dapil) {
            case "DPR RI":
              return ["hsl(50, 100%, 50%)", 0.4];
            case "DPRD PROVINSI":
              return ["hsl(212, 82%, 50%)", 0.6];
            case "DPRD KABUPATEN/KOTA":
              return ["hsl(120, 100%, 50%)", 0.25];
            default:
              return ["transparent", 0];
          }
        })()

        // #515151 pres wapres
        // #b52b21 dpd
        // #e6d256 dpr
        // #1c5192 dprd prov
        // #286036 dprd kabko

        return (
          <GeoJSON
            style={{ weight: 0, color, fillOpacity }}
            key={area.kode_dapil}
            data={area.geojson}
          />
        );
      })}
    </MapContainer>
  );
}

register(Maps, tagName);
