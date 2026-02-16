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

const cities = new Map()
  .set("bern", [46.9481, 7.4474])
  .set("weimar", [50.9803, 11.32903])
  .set("wichitaFalls", [33.9137, -98.4934])
  .set("berlin", [52.5244, 13.4105]);

const centeredCity = ref(cities.get("bern"));

const nodeLayers = new Map()
  .set("carNodeLayer", null)
  .set("streetNodeLayer", null)
  .set("pedestrianNodeLayer", null)
  .set("horseNodeLayer", null)
  .set("cyclewayNodeLayer", null)
  .set("uncategorizedNodeLayer", null);

const wayLayers = new Map()
  .set("carWayLayer", null)
  .set("streetWayLayer", null)
  .set("pedestrianWayLayer", null)
  .set("horseWayLayer", null)
  .set("cyclewayWayLayer", null)
  .set("uncategorizedWayLayer", null);

const areaLayers = new Map()
  .set("carAreaLayer", null)
  .set("streetAreaLayer", null)
  .set("pedestrianAreaLayer", null)
  .set("horseAreaLayer", null)
  .set("cyclewayAreaLayer", null)
  .set("uncategorizedAreaLayer", null);

const tilesURL = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";

const handleMouseOver = e => {
  emit("info", e);
};

const removeAllNodeLayers = () => {
  nodeLayers.forEach(layer => {
    if (layer) {
      map.removeLayer(layer);
    }
  });
};

const addAllNodeLayers = () => {
  nodeLayers.forEach(layer => {
    layer.addTo(map);
  });
};

const addAllWayLayers = () => {
  wayLayers.forEach(layer => {
    layer.addTo(map);
  });
};

const addAllAreaLayers = () => {
  areaLayers.forEach(layer => {
    layer.addTo(map);
  });
};

const loadNodes = async () => {
  // Remove previous node layer to avoid duplicates
  removeAllNodeLayers();

  const carData = await getNodes("car", map.getBounds());
  nodeLayers.set(
    "carNodeLayer",
    getNodeLayer(carData, "red", handleMouseOver, 13),
  );

  const streetData = await getNodes("street", map.getBounds());
  nodeLayers.set(
    "streetNodeLayer",
    getNodeLayer(streetData, "yellow", handleMouseOver, 13),
  );

  const pedestrianData = await getNodes("pedestrian", map.getBounds());
  nodeLayers.set(
    "pedestrianNodeLayer",
    getNodeLayer(pedestrianData, "blue", handleMouseOver, 13),
  );

  const horseData = await getNodes("horse", map.getBounds());
  nodeLayers.set(
    "horseNodeLayer",
    getNodeLayer(horseData, "purple", handleMouseOver, 13),
  );

  const cyclewayData = await getNodes("cycleway", map.getBounds());
  nodeLayers.set(
    "cyclewayNodeLayer",
    getNodeLayer(cyclewayData, "green", handleMouseOver, 13),
  );

  const uncategorizedData = await getNodes("uncategorized", map.getBounds());
  nodeLayers.set(
    "uncategorizedNodeLayer",
    getNodeLayer(uncategorizedData, "grey", handleMouseOver, 13),
  );

  addAllNodeLayers();
};

const loadWays = () => {
  wayLayers.set("carWayLayer", getWayLayer("car", "red", handleMouseOver, 13));

  wayLayers.set(
    "streetWayLayer",
    getWayLayer("street", "yellow", handleMouseOver, 13),
  );

  wayLayers.set(
    "pedestrianWayLayer",
    getWayLayer("pedestrian", "blue", handleMouseOver, 13),
  );

  wayLayers.set(
    "horseWayLayer",
    getWayLayer("horse", "purple", handleMouseOver, 13),
  );

  wayLayers.set(
    "cyclewayWayLayer",
    getWayLayer("cycleway", "green", handleMouseOver, 13),
  );

  wayLayers.set(
    "uncategorizedWayLayer",
    getWayLayer("uncategorized", "grey", handleMouseOver, 13),
  );

  addAllWayLayers();
};

const loadAreas = () => {
  areaLayers.set(
    "carAreaLayer",
    getAreaLayer("car", "red", handleMouseOver, 13),
  );

  areaLayers.set(
    "streetAreaLayer",
    getAreaLayer("street", "yellow", handleMouseOver, 13),
  );

  areaLayers.set(
    "pedestrianAreaLayer",
    getAreaLayer("pedestrian", "blue", handleMouseOver, 13),
  );

  areaLayers.set(
    "horseAreaLayer",
    getAreaLayer("horse", "purple", handleMouseOver, 13),
  );

  areaLayers.set(
    "cyclewayAreaLayer",
    getAreaLayer("cycleway", "green", handleMouseOver, 13),
  );

  areaLayers.set(
    "uncategorizedAreaLayer",
    getAreaLayer("uncategorized", "grey", handleMouseOver, 13),
  );

  addAllAreaLayers();
};

const loadTiles = () => {
  L.tileLayer(tilesURL, {
    attribution:
      '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
  }).addTo(map);
};

onMounted(() => {
  map = L.map("map").setView(centeredCity.value, 15);

  loadTiles();
  loadNodes();
  loadWays();
  loadAreas();

  map.on("moveend", loadNodes);

  // Remove when finished
  map.on("zoomend", () => {
    console.log(map.getZoom());
  });
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
