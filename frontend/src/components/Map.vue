<script setup>
import L from "leaflet";
import "leaflet.vectorgrid";
import { onMounted } from "vue";

let map;

onMounted(() => {
  map = L.map("map").setView([46.9481, 7.4474], 13);

  L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
    maxZoom: 19,
    attribution:
      '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
  }).addTo(map);

  // ways
  L.vectorGrid
    .protobuf(
      "http://localhost:7800/public.street_segments_ways/{z}/{x}/{y}.pbf",
      {
        vectorTileLayerStyles: {
          "public.street_segments_ways": {
            stroke: true,
            color: "green",
            weight: 2,
            opacity: 1,
            interactive: true,
            getFeatureId: f => f.properties.id,
          },
        },
        maxZoom: 19,
      }
    )
    .addTo(map);

  // closed ways
  L.vectorGrid
    .protobuf(
      "http://localhost:7800/public.street_segments_closed_ways/{z}/{x}/{y}.pbf",
      {
        vectorTileLayerStyles: {
          "public.street_segments_closed_ways": {
            stroke: true,
            color: "blue",
            weight: 2,
            opacity: 1,
            interactive: true,
            getFeatureId: f => f.properties.id,
          },
        },
        maxZoom: 19,
      }
    )
    .addTo(map);

  // multiploygon
  L.vectorGrid
    .protobuf(
      "http://localhost:7800/public.street_segments_multipolygon/{z}/{x}/{y}.pbf",
      {
        vectorTileLayerStyles: {
          "public.street_segments_multipolygon": {
            area: true,
            color: "red",
            weight: 2,
            opacity: 1,
            interactive: true,
            getFeatureId: f => f.properties.id,
          },
        },
        maxZoom: 19,
      }
    )
    .addTo(map);
});
</script>

<template>
  <div id="map"></div>
</template>

<style scoped>
#map {
  height: 100vh;
  width: 100vw;
}
</style>
