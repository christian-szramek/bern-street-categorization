<script setup>
import L from "leaflet";
import "leaflet.vectorgrid";
import { ref, computed, onMounted } from "vue";

const props = defineProps(["infrastructureTypes"]);

const emit = defineEmits(["info"]);

let map;
let nodeLayer = ref(null);

const bern = [46.9481, 7.4474];
const defaultColor = "#666";

const nodesURL =
  "http://localhost:9000/collections/public.highway_nodes/items.json?bbox=";
const waysURL = "http://localhost:7800/public.highway_ways/{z}/{x}/{y}.pbf";
const areasURL = "http://localhost:7800/public.highway_areas/{z}/{x}/{y}.pbf";
const tileURL = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";

const showNodes = true;
const showWays = true;
const showAreas = true;

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
    props.infrastructureTypes.map(type => [type.name, type.color])
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
  }).addTo(map);
}

function loadWays() {
  L.vectorGrid
    .protobuf(waysURL, {
      vectorTileLayerStyles: {
        "public.highway_ways": props => ({
          stroke: true,
          color: colorByInfrastructure(props),
          weight: 2,
          opacity: 1,
        }),
      },
      interactive: true,
      getFeatureId: f => f.properties.id,
      maxZoom: 19,
    })
    .on("mouseover", e => {
      handleMouseover(e.layer.properties);
    })
    .addTo(map);
}

function loadAreas() {
  L.vectorGrid
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
      interactive: true,
      getFeatureId: f => f.properties.id,
      maxZoom: 19,
    })
    .on("mouseover", e => {
      handleMouseover(e.layer.properties);
    })
    .addTo(map);
}

onMounted(() => {
  map = L.map("map").setView(bern, 13);

  L.tileLayer(tileURL, {
    maxZoom: 19,
    attribution:
      '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
  }).addTo(map);

  // Initial load
  if (showNodes) {
    loadNodes();
  }
  if (showWays) {
    loadWays();
  }
  if (showAreas) {
    loadAreas();
  }

  if (showNodes) {
    // Reload nodes when map moves
    showNodes ?? map.on("moveend", loadNodes);
  }
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
