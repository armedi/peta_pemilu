// import "preact/debug";

import { useSignal, useSignalEffect, type Signal } from "@preact/signals";
import { type LatLngLiteral, type Map as LeafletMap } from "leaflet";
import type { ViewHook } from "phoenix_live_view";
import register from "preact-custom-element";
import { useEffect, useRef } from "preact/hooks";
import { GeoJSON, MapContainer, TileLayer, useMapEvents, ZoomControl } from "react-leaflet";

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
      requestIdleCallback(() => {
        this.el.dispatchEvent(new Event("mounted"));
      })
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

  const goToMyLocation = () => {
    if ("geolocation" in navigator) {
      return new Promise((resolve) => {
        navigator.geolocation.getCurrentPosition((position) => {
          center.value = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          };
          zoom.value = 10;
          resolve(void 0)
        });
      })
    }

    return Promise.resolve(void 0)
  }

  const pushMountedEvent = () => {
    const element = mapRef.current?.getContainer().closest(tagName);

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
  }

  useEffect(() => {
    const element = mapRef.current?.getContainer().closest(tagName);

    const handler = async () => {
      if (window.location.pathname === "/") {
        await goToMyLocation();
      }
      pushMountedEvent()
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
      <div class="absolute z-[1000] left-0 top-[74px]">
        <div class="ml-[10px] mt-[10px] border-2 border-[rgba(0,0,0,0.2)] rounded-[4px]">
          <div class="h-[30px] w-[30px] bg-white hover:bg-[#f4f4f4] rounded-sm flex justify-center items-center cursor-pointer" onClick={async (e) => {
            e.stopPropagation();
            await goToMyLocation();
            pushMountedEvent()
          }}>
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" className="w-5 h-5">
              <path fillRule="evenodd" d="m9.69 18.933.003.001C9.89 19.02 10 19 10 19s.11.02.308-.066l.002-.001.006-.003.018-.008a5.741 5.741 0 0 0 .281-.14c.186-.096.446-.24.757-.433.62-.384 1.445-.966 2.274-1.765C15.302 14.988 17 12.493 17 9A7 7 0 1 0 3 9c0 3.492 1.698 5.988 3.355 7.584a13.731 13.731 0 0 0 2.273 1.765 11.842 11.842 0 0 0 .976.544l.062.029.018.008.006.003ZM10 11.25a2.25 2.25 0 1 0 0-4.5 2.25 2.25 0 0 0 0 4.5Z" clipRule="evenodd" />
            </svg>
          </div>
        </div>
      </div>
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
