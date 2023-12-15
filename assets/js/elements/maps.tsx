import "preact/debug";

import { useSignal, useSignalEffect, type Signal } from "@preact/signals";
import { type LatLngExpression, type Map as LeafletMap } from "leaflet";
import type { ViewHook } from "phoenix_live_view";
import register from "preact-custom-element";
import { useRef } from "preact/hooks";
import {
  MapContainer,
  Marker,
  Popup,
  TileLayer,
  useMapEvents,
} from "react-leaflet";

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
    },
    destroyed(this: ViewHook) {
      liveViewHooks.delete(this.el);
    },
  },
};

function MapEvents(props: { center: Signal<LatLngExpression> }) {
  useMapEvents({
    click(e) {
      props.center.value = e.latlng;
      getLiveViewHook(e.originalEvent.target as HTMLElement).pushEvent(
        "select_map_point",
        e.latlng
      );
    },
  });

  return null;
}

function Maps(props: Record<string, string>) {
  const mapRef = useRef<LeafletMap>(null);

  const center = useSignal<LatLngExpression>(JSON.parse(props.center));
  const zoom = useSignal<number>(JSON.parse(props.zoom));

  useSignalEffect(() => {
    mapRef.current?.setView(center.value);
  });

  return (
    <MapContainer
      ref={mapRef}
      center={center.value}
      zoom={zoom.value}
      className="h-full"
    >
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
