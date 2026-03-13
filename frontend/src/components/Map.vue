<script setup>
import { ref, onMounted, onUpdated } from 'vue';

import L from 'leaflet';
import 'leaflet.vectorgrid';

import { getNodeLayer } from '@/layers/nodeLayer';
import { getWayLayer } from '@/layers/wayLayer';
import { getAreaLayer } from '@/layers/areaLayer';

import { getNodes } from '@/services/nodeService';
import { getNameWithoutLanes } from '@/utils/nameUtils';

const props = defineProps({
  infrastructureTypes: {
    type: Array,
    required: true
  },
  activeInfrastructureTypes: {
    type: Array,
    required: true
  },
  centeredCity: {
    type: Object,
    required: true
  }
});

const emit = defineEmits(['showInfo', 'hideInfo']);

let map;

const tilesURL = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

const extendedInfrastructureTypes = ref([]);
const previousActiveInfrastructureTypes = ref([]);
const previousCenteredCity = ref(null);

const handleMouseOver = e => {
  emit('showInfo', e);
};

const handleMouseOut = () => {
  emit('hideInfo');
};

const removeAllNodeLayers = () => {
  extendedInfrastructureTypes.value
    .filter(it => it.type === 'node' && it.layer)
    .forEach(it => {
      map.removeLayer(it.layer);
      it.layer = null;
    });
};

const loadNode = async (infrastructureType, mapBounds, color) => {
  const layerData = await getNodes(props.centeredCity.name, infrastructureType, mapBounds);
  const layer = getNodeLayer(layerData, color, handleMouseOver, handleMouseOut);
  return layer;
};

const loadNodes = async () => {
  // Remove previous node layer to avoid duplicates
  removeAllNodeLayers();

  const mapBounds = map.getBounds();

  extendedInfrastructureTypes.value
    .filter(it => it.type === 'node' && isInfrastructureTypeActive(it.name))
    .forEach(async it => {
      it.layer = await loadNode(it.name, mapBounds, it.color);
      it.layer.addTo(map);
    });
};

const loadWays = () => {
  extendedInfrastructureTypes.value
    .filter(it => it.type === 'way' && isInfrastructureTypeActive(it.name))
    .forEach(it => {
      it.layer = getWayLayer(props.centeredCity.name, it.name, it.color, handleMouseOver, handleMouseOut);
      it.layer.addTo(map);
    });
};

const loadAreas = () => {
  extendedInfrastructureTypes.value
    .filter(it => it.type === 'area' && isInfrastructureTypeActive(it.name))
    .forEach(it => {
      it.layer = getAreaLayer(props.centeredCity.name, it.name, it.color, handleMouseOver, handleMouseOut);
      it.layer.addTo(map);
    });
};

const loadTiles = () => {
  L.tileLayer(tilesURL, {
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    maxZoom: 19
  }).addTo(map);
};

const extendInfrastructureTypes = () => {
  props.infrastructureTypes.forEach(it => {
    if (it.node) {
      extendedInfrastructureTypes.value.push({
        ...it,
        type: 'node'
      });
    }

    extendedInfrastructureTypes.value.push({
      ...it,
      type: 'way'
    });

    if (it.area) {
      extendedInfrastructureTypes.value.push({
        ...it,
        type: 'area'
      });
    }
  });
};

const isInfrastructureTypeActive = infrastructureType => {
  return props.activeInfrastructureTypes.some(it => infrastructureType.includes(it));
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
  previousActiveInfrastructureTypes.value = [...props.activeInfrastructureTypes];
};

const updatePreviousCenteredCity = () => {
  previousCenteredCity.value = props.centeredCity;
};

const updateLayers = updatedInfrastructureType => {
  const infrastructureTypesToUpdate = extendedInfrastructureTypes.value.filter(it => getNameWithoutLanes(it.name) === updatedInfrastructureType);

  infrastructureTypesToUpdate.forEach(async it => {
    if (it.layer) {
      map.removeLayer(it.layer);
      it.layer = null;
    } else {
      if (it.type === 'node') {
        it.layer = await loadNode(it.name, map.getBounds(), it.color);
      }
      if (it.type === 'way') {
        it.layer = getWayLayer(props.centeredCity.name, it.name, it.color, handleMouseOver, handleMouseOut);
      }
      if (it.type === 'area') {
        it.layer = getAreaLayer(props.centeredCity.name, it.name, it.color, handleMouseOver, handleMouseOut);
      }

      it.layer.addTo(map);
    }
  });
};

const loadAllLayers = () => {
  loadNodes();
  loadWays();
  loadAreas();
};

const removeAllLayers = () => {
  extendedInfrastructureTypes.value
    .filter(it => it.layer)
    .forEach(it => {
      map.removeLayer(it.layer);
      it.layer = null;
    });
};

onMounted(() => {
  map = L.map('map').setView(props.centeredCity.latlon, 15);

  extendInfrastructureTypes();
  loadTiles();
  loadAllLayers();

  updatePreviousActiveInfrastructureTypes();
  updatePreviousCenteredCity();

  map.on('moveend', () => {
    loadNodes();
  });
});

onUpdated(() => {
  if (props.centeredCity !== previousCenteredCity.value) {
    // update centered city
    removeAllLayers();
    map.setView(props.centeredCity.latlon);
    loadAllLayers();
  } else {
    // update displayed infrastructure types
    const updatedInfrastructureType = getUpdatedActiveInfrastructureType(props.activeInfrastructureTypes, previousActiveInfrastructureTypes.value);

    if (updatedInfrastructureType) {
      updateLayers(updatedInfrastructureType);
    }
  }

  updatePreviousActiveInfrastructureTypes();
  updatePreviousCenteredCity();
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
