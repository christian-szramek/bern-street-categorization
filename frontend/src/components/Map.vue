<script setup>
import L from "leaflet";
import "leaflet.vectorgrid";
import { ref, computed, onMounted, onUpdated } from "vue";

const props = defineProps(["infrastructureTypes"]);

const emit = defineEmits(["info"]);

let map;

const nodeLayer = ref(null);
const waysLayer = ref(null);
const areasLayer = ref(null);

const cities = new Map()
  .set("bern", [46.9481, 7.4474])
  .set("weimar", [50.9803, 11.32903])
  .set("wichitaFalls", [33.9137, -98.4934])
  .set("berlin", [52.5244, 13.4105]);

const centeredCity = ref(cities.get("bern"));

const defaultColor = "#666";

const nodesURL =
  "http://localhost:9000/collections/public.highway_nodes/items.json?bbox=";
const waysURL = "http://localhost:7800/public.highway_ways/{z}/{x}/{y}.pbf";
const areasURL = "http://localhost:7800/public.highway_areas/{z}/{x}/{y}.pbf";
const tilesURL = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";

/* transform the infrastructureTypes to allow direct access when rendering the map
 *
 * [
 *   { name: "infrastructure_type_a", color: "blue" },
 *   { name: "infrastructure_type_b", color: "green" }
 * ]
 *
 * to
 *
 * {
 *  infrastructure_type_a: "blue",
 *  infrastructure_type_b: "green"
 * }
 */

const infrastructureColorMap = computed(() => {
  return Object.fromEntries(
    props.infrastructureTypes.map(type => [type.name, type.color]),
  );
});

function colorByInfrastructure(vectorProps) {
  return (
    infrastructureColorMap.value[vectorProps.infrastructure_type] ??
    defaultColor
  );
}

function handleMouseover(e) {
  emit("info", e);
}

async function loadNodes() {
  const b = map.getBounds();

  const url = `${nodesURL}${b.getWest()},${b.getSouth()},${b.getEast()},${b.getNorth()}`;

  const res = await fetch(url);
  const data = await res.json();

  // Remove previous node layer to avoid duplicates
  if (nodeLayer.value) {
    map.removeLayer(nodeLayer.value);
  }

  nodeLayer.value = L.geoJSON(data, {
    pointToLayer: (feature, latlng) =>
      L.circleMarker(latlng, {
        radius: 4,
        fillColor: colorByInfrastructure(feature.properties),
        color: colorByInfrastructure(feature.properties),
        weight: 1,
        opacity: 1,
        fillOpacity: 1,
      }),
    onEachFeature: (feature, layer) => {
      layer.on("mouseover", () => {
        handleMouseover(feature.properties.tags);
      });
    },
    maxZoom: 20,
  }).addTo(map);
}

function loadWays() {
  waysLayer.value = L.vectorGrid
    .protobuf(waysURL, {
      vectorTileLayerStyles: {
        "public.highway_ways": props => ({
          stroke: true,
          color: colorByInfrastructure(props),
          weight: 2,
          opacity: 1,
        }),
      },
      minZoom: 12,
      maxZoom: 20,
      interactive: true,
      getFeatureId: f => f.properties.id,
    })
    .on("mouseover", e => {
      handleMouseover(e.layer.properties);
    })
    .addTo(map);
}

function loadAreas() {
  areasLayer.value = L.vectorGrid
    .protobuf(areasURL, {
      vectorTileLayerStyles: {
        "public.highway_areas": props => ({
          fill: true,
          fillColor: colorByInfrastructure(props),
          color: colorByInfrastructure(props),
          weight: 1,
          fillOpacity: 0.6,
          opacity: 1,
        }),
      },
      maxZoom: 20,
      interactive: true,
      getFeatureId: f => f.properties.id,
    })
    .on("mouseover", e => {
      handleMouseover(e.layer.properties);
    })
    .addTo(map);
}

function loadTiles() {
  L.tileLayer(tilesURL, {
    attribution:
      '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
  }).addTo(map);
}

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
