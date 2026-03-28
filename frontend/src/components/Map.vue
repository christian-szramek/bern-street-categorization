<script setup>
import { ref, onMounted, onUpdated, watch } from 'vue';

import L from 'leaflet';
import 'leaflet.vectorgrid';

import { getNodeLayer } from '@/layers/nodeLayer';
import { getWayLayer } from '@/layers/wayLayer';
import { getAreaLayer } from '@/layers/areaLayer';

import { getNodes } from '@/services/nodeService';
import { getNameWithoutLanes } from '@/utils/nameUtils';

const tilesURL = import.meta.env.VITE_BASE_MAP_URL;

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

let loadVersion = 0;

const extendedInfrastructureTypes = ref([]);

const handleMouseOver = e => {
  emit('showInfo', e);
};

const handleMouseOut = () => {
  emit('hideInfo');
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

const loadNodeLayer = async (infrastructureType, mapBounds, color) => {
  const layerData = await getNodes(props.centeredCity.name, infrastructureType, mapBounds);
  return getNodeLayer(layerData, color, handleMouseOver, handleMouseOut);
};

const loadAllNodeLayers = async version => {
  removeAllNodeLayers();

  const mapBounds = map.getBounds();

  for (const it of extendedInfrastructureTypes.value) {
    if (it.type === 'node' && isInfrastructureTypeActive(it.name)) {
      const layer = await loadNodeLayer(it.name, mapBounds, it.color);

      if (version !== loadVersion) return;

      it.layer = layer;
      it.layer.addTo(map);
    }
  }
};

const removeAllNodeLayers = () => {
  extendedInfrastructureTypes.value
    .filter(it => it.type === 'node' && it.layer)
    .forEach(it => {
      map.removeLayer(it.layer);
      it.layer = null;
    });
};

const loadAllWayLayers = () => {
  extendedInfrastructureTypes.value
    .filter(it => it.type === 'way' && isInfrastructureTypeActive(it.name))
    .forEach(it => {
      it.layer = getWayLayer(props.centeredCity.name, it.name, it.color, handleMouseOver, handleMouseOut);
      it.layer.addTo(map);
    });
};

const loadAllAreaLayers = () => {
  extendedInfrastructureTypes.value
    .filter(it => it.type === 'area' && isInfrastructureTypeActive(it.name))
    .forEach(it => {
      it.layer = getAreaLayer(props.centeredCity.name, it.name, it.color, handleMouseOver, handleMouseOut);
      it.layer.addTo(map);
    });
};

const loadAllDataLayers = async () => {
  const version = ++loadVersion;

  await loadAllNodeLayers(version);

  if (version !== loadVersion) return;

  loadAllWayLayers();
  loadAllAreaLayers();
};

const removeAllDataLayers = () => {
  extendedInfrastructureTypes.value
    .filter(it => it.layer)
    .forEach(it => {
      map.removeLayer(it.layer);
      it.layer = null;
    });
};

const loadBaseMapLayer = () => {
  L.tileLayer(tilesURL, {
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    maxZoom: 19
  }).addTo(map);
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

const updateDataLayers = async updatedInfrastructureType => {
  const version = ++loadVersion;

  const infrastructureTypesToUpdate = extendedInfrastructureTypes.value.filter(it => getNameWithoutLanes(it.name) === updatedInfrastructureType);

  for (const it of infrastructureTypesToUpdate) {
    if (it.layer) {
      map.removeLayer(it.layer);
      it.layer = null;
    } else {
      let layer;

      if (it.type === 'node') {
        layer = await loadNodeLayer(it.name, map.getBounds(), it.color);

        if (version !== loadVersion) return;
      }

      if (it.type === 'way') {
        layer = getWayLayer(props.centeredCity.name, it.name, it.color, handleMouseOver, handleMouseOut);
      }

      if (it.type === 'area') {
        layer = getAreaLayer(props.centeredCity.name, it.name, it.color, handleMouseOver, handleMouseOut);
      }

      it.layer = layer;
      it.layer.addTo(map);
    }
  }
};

onMounted(async () => {
  map = L.map('map').setView(props.centeredCity.latlon, 15);

  extendInfrastructureTypes();
  loadBaseMapLayer();
  await loadAllDataLayers();

  map.on('moveend', async () => {
    const version = ++loadVersion;
    await loadAllNodeLayers(version);
  });
});

watch(
  () => props.centeredCity,
  async (newCenteredCity, _) => {
    loadVersion++;
    removeAllDataLayers();
    map.setView(newCenteredCity.latlon);
    await loadAllDataLayers();
  }
);

watch(
  () => props.activeInfrastructureTypes,
  async (newActiveInfrastructureTypes, oldActiveInfrastructureTypes) => {
    const updatedInfrastructureType = getUpdatedActiveInfrastructureType(newActiveInfrastructureTypes, oldActiveInfrastructureTypes);

    if (updatedInfrastructureType) {
      await updateDataLayers(updatedInfrastructureType);
    }
  }
);
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
