<script setup>
import { ref, onMounted, onUpdated, watch } from "vue";

import L from "leaflet";
import "leaflet.vectorgrid";

import { getNodeLayer } from "@/layers/nodeLayer";
import { getWayLayer } from "@/layers/wayLayer";
import { getAreaLayer } from "@/layers/areaLayer";

import { getNodes } from "@/services/nodeService";
import { getNameWithoutLanes } from "../../utils/nameUtils";

const props = defineProps({
  infrastructureTypes: {
    type: Array,
    required: true,
  },
  activeInfrastructureTypes: {
    type: Array,
    required: true,
  },
});

const emit = defineEmits(["showInfo", "hideInfo"]);

let map;

const tilesURL = "https://tile.openstreetmap.org/{z}/{x}/{y}.png";

const cities = new Map()
  .set("bern", [46.9481, 7.4474])
  .set("weimar", [50.9803, 11.32903])
  .set("wichitaFalls", [33.9137, -98.4934])
  .set("berlin", [52.5244, 13.4105]);

const centeredCity = ref(cities.get("berlin"));

const extendedInfrastructureTypes = ref([]);
const previousActiveInfrastructureTypes = ref([]);

const handleMouseOver = e => {
  emit("showInfo", e);
};

const handleMouseOut = () => {
  emit("hideInfo");
};

const removeAllNodeLayers = () => {
  extendedInfrastructureTypes.value
    .filter(it => it.type === "node" && it.layer)
    .forEach(it => {
      map.removeLayer(it.layer);
      it.layer = null;
    });
};

const loadNode = async (name, mapBounds, color) => {
    const layerData = await getNodes(name, mapBounds);
    const layer = getNodeLayer(
      layerData,
      color,
      handleMouseOver,
      handleMouseOut,
    );
  return layer;
}

const loadNodes = async () => {
  // Remove previous node layer to avoid duplicates
  removeAllNodeLayers();

  const mapZoom = map.getZoom();
  const mapBounds = map.getBounds();

  extendedInfrastructureTypes.value
    .filter(it => it.type === "node" && isInfrastructureTypeActive(it.name))
    .filter(it => mapZoom >= it.minZoom)
    .forEach(async it => {
      it.layer = await loadNode(it.name, mapBounds, it.color)
      it.layer.addTo(map);
    });
};

const loadWays = () => {
  extendedInfrastructureTypes.value
    .filter(it => it.type === "way" && isInfrastructureTypeActive(it.name))
    .forEach(it => {
      it.layer = getWayLayer(
        it.name,
        it.color,
        it.minZoom,
        handleMouseOver,
        handleMouseOut,
      );

      it.layer.addTo(map);
    });
};

const loadAreas = () => {
  extendedInfrastructureTypes.value
    .filter(it => it.type === "area" && isInfrastructureTypeActive(it.name))
    .forEach(it => {
      it.layer = getAreaLayer(
        it.name,
        it.color,
        it.minZoom,
        handleMouseOver,
        handleMouseOut,
      );

      it.layer.addTo(map)      
    });
};

const loadTiles = () => {
  L.tileLayer(tilesURL, {
    attribution:
      '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    maxZoom: 19,
  }).addTo(map);
};

const extendInfrastructureTypes = () => {
  props.infrastructureTypes.forEach(it => {
    if (it.node) {
      extendedInfrastructureTypes.value.push({
        ...it,
        type: "node",
      });
    }

    extendedInfrastructureTypes.value.push({
      ...it,
      type: "way",
    });

    if (it.area) {
      extendedInfrastructureTypes.value.push({
        ...it,
        type: "area",
      });
    }
  });
};

const isInfrastructureTypeActive = infrastructureType => {
  return props.activeInfrastructureTypes.some(it =>
    infrastructureType.includes(it),
  );
};

const getUpdatedActiveInfrastructureType = (now, previous) => {
  // if type was added
  const added = now.find(x => !previous.includes(x));

  // if type was removed
  if (added == null) {
    return previous.find(x => !now.includes(x));
  }

  return added;
};

const updatePreviousActiveInfrastructureTypes = () => {
  previousActiveInfrastructureTypes.value = [
    ...props.activeInfrastructureTypes,
  ];
};

const updateLayers = updatedInfrastructureType => {
  const infrastructureTypesToUpdate = extendedInfrastructureTypes.value.filter(
    it => getNameWithoutLanes(it.name) === updatedInfrastructureType,
  );

  infrastructureTypesToUpdate.forEach(async it => {
    if (it.layer) {
      map.removeLayer(it.layer);
      it.layer = null;
    } else {
      if (it.type === 'node') {
        it.layer = await loadNode(it.name, map.getBounds(), it.color)
      }
      if (it.type === 'way') {
        it.layer = getWayLayer(it.name, it.color, it.minZoom, handleMouseOver, handleMouseOut);
      }
      if (it.type === 'area') {
        it.layer = getAreaLayer(it.name, it.color, it.minZoom, handleMouseOver, handleMouseOut);
      }

      it.layer.addTo(map);
    }
  });
};

onMounted(() => {
  map = L.map("map").setView(centeredCity.value, 17);

  extendInfrastructureTypes();
  loadTiles();
  loadNodes();
  loadWays();
  loadAreas();

  updatePreviousActiveInfrastructureTypes();

  map.on("moveend", () => {
    loadNodes();
  });
});

onUpdated(() => {
  const updatedInfrastructureType = getUpdatedActiveInfrastructureType(
    props.activeInfrastructureTypes,
    previousActiveInfrastructureTypes.value,
  );

  updateLayers(updatedInfrastructureType);

  updatePreviousActiveInfrastructureTypes();
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
