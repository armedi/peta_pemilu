import "preact/debug";

import { useSignal, type Signal } from '@preact/signals';
import type { LatLngExpression } from "leaflet";
import type { ViewHook } from "phoenix_live_view";
import register from "preact-custom-element";
import {
  MapContainer,
  Marker,
  Popup,
  TileLayer,
  useMapEvents,
} from "react-leaflet";

const tagName = "x-maps"

const liveViewHooks = new WeakMap<Element, ViewHook>();

function getLiveViewHook(from: HTMLElement) {
  const xMaps = from.closest(tagName)!
  return liveViewHooks.get(xMaps)!;
}

export const phxHooks = {
  [tagName]: {
    mounted(this: ViewHook) {
      liveViewHooks.set(this.el, this);
    },
    destroyed(this: ViewHook) {
      liveViewHooks.delete(this.el);
    }
  },
};

type MapEventsProps = {
  center: Signal<LatLngExpression>
}

function MapEvents(props: MapEventsProps) {
  useMapEvents({
    click(e) {
      const lv = getLiveViewHook(e.originalEvent.target as HTMLElement);
      lv.pushEvent("click", { latlng: e.latlng }, (reply, ref) => {
        props.center.value = reply.center
      });
    },
  });

  return null;
}

function Maps() {
  const center = useSignal<LatLngExpression>([0, 118]);

  return (
    <MapContainer center={center.value} zoom={5} className="h-full">
      <MapEvents center={center} />
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      <Marker position={center.value}>
        <Popup>
          A pretty CSS3 popup. <br /> Easily customizable.
        </Popup>
      </Marker>
    </MapContainer>
  );
}

register(Maps, tagName);
