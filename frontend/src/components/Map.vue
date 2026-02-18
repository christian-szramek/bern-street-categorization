<script setup>
import { ref, onMounted } from "vue";

import L from "leaflet";
import "leaflet.vectorgrid";

import { getNodeLayer } from "@/layers/nodeLayer";
import { getWayLayer } from "@/layers/wayLayer";
import { getAreaLayer } from "@/layers/areaLayer";

import { getNodes } from "@/services/nodeService";

const props = defineProps(["infrastructureTypes"]);

const emit = defineEmits(["info"]);

let map;

const tilesURL = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";

const cities = new Map()
  .set("bern", [46.9481, 7.4474])
  .set("weimar", [50.9803, 11.32903])
  .set("wichitaFalls", [33.9137, -98.4934])
  .set("berlin", [52.5244, 13.4105]);

const centeredCity = ref(cities.get("berlin"));

const extendedInfrastructureTypes = ref([]);

const handleMouseOver = e => {
  emit("info", e);
};

const removeAllNodeLayers = () => {
  extendedInfrastructureTypes.value
    .filter(it => it.type === "node")
    .forEach(it => {
      if (it.layer) {
        map.removeLayer(it.layer);
        it.layer = null;
      }
    });
};

const loadNodes = async () => {
  // Remove previous node layer to avoid duplicates
  removeAllNodeLayers();

  const mapZoom = map.getZoom();
  const mapBounds = map.getBounds();

  extendedInfrastructureTypes.value
    .filter(it => it.type === "node")
    .filter(it => mapZoom >= it.minZoom)
    .forEach(async it => {
      const layerData = await getNodes(it.name, mapBounds);
      it.layer = getNodeLayer(layerData, it.color, handleMouseOver);
      it.layer.addTo(map);
    });
};

const loadWays = () => {
  extendedInfrastructureTypes.value
    .filter(it => it.type === "way")
    .forEach(it => {
      it.layer = getWayLayer(it.name, it.color, handleMouseOver, it.minZoom);
      it.layer.addTo(map);
    });
};

const loadAreas = () => {
  extendedInfrastructureTypes.value
    .filter(it => it.type === "area")
    .forEach(it => {
      it.layer = getAreaLayer(it.name, it.color, handleMouseOver, it.minZoom);
      it.layer.addTo(map);
    });
};

const loadTiles = () => {
  L.tileLayer(tilesURL, {
    attribution:
      '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    maxZoom: 20,
  }).addTo(map);
};

// Add  three layers (node, way, area) or every infrastructure type
const extendInfrastructureTypes = () => {
  props.infrastructureTypes.forEach(it => {
    extendedInfrastructureTypes.value.push({
      ...it,
      type: "node",
    });

    extendedInfrastructureTypes.value.push({
      ...it,
      type: "way",
    });

    extendedInfrastructureTypes.value.push({
      ...it,
      type: "area",
    });
  });
};

onMounted(() => {
  map = L.map("map").setView(centeredCity.value, 16);

  extendInfrastructureTypes();
  loadTiles();
  loadNodes();
  loadWays();
  loadAreas();

  map.on("moveend", loadNodes);

  // For Testing
  map.on("moveend", () => console.log("Zoom level: ", map.getZoom()));
});
</script>

<template>
  <div id="map"></div>
</template>

<style scoped>
#map {
  height: 100vh;
  width: auto;
}
</style>
