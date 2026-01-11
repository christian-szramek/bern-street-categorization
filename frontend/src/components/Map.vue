<script setup>
import L from "leaflet";
import "leaflet.vectorgrid";
import { onMounted } from "vue";

let map;

const bern = [46.9481, 7.4474];

onMounted(() => {
  map = L.map("map").setView(bern, 13);

  L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
    maxZoom: 19,
    attribution:
      '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
  }).addTo(map);

  // nodes
  L.vectorGrid
    .protobuf("http://localhost:7800/public.highway_nodes/{z}/{x}/{y}.pbf", {
      vectorTileLayerStyles: {
        "public.highway_nodes": (properties, zoom) => {
          return {
            radius: 4, // circle radius in pixels
            fillColor: "blue",
            color: "blue",
            weight: 1,
            opacity: 1,
            fillOpacity: 1,
          };
        },
      },
      interactive: true,
      getFeatureId: f => f.properties.id,
      maxZoom: 19,
    })
    .addTo(map);

  // ways
  L.vectorGrid
    .protobuf("http://localhost:7800/public.highway_ways/{z}/{x}/{y}.pbf", {
      vectorTileLayerStyles: {
        "public.highway_ways": {
          stroke: true,
          color: "green",
          weight: 2,
          opacity: 1,
          interactive: true,
          getFeatureId: f => f.properties.id,
        },
      },
      maxZoom: 19,
    })
    .addTo(map);

  // areas
  L.vectorGrid
    .protobuf("http://localhost:7800/public.highway_areas/{z}/{x}/{y}.pbf", {
      vectorTileLayerStyles: {
        "public.highway_areas": {
          area: true,
          color: "red",
          weight: 2,
          opacity: 1,
          interactive: true,
          getFeatureId: f => f.properties.id,
        },
      },
      maxZoom: 19,
    })
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
