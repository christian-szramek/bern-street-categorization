<script setup>
import { onBeforeMount, ref } from "vue";

import Map from "@/components/Map.vue";
import Legend from "@/components/Legend.vue";
import Info from "@/components/Info.vue";

import infrastructureTypes from "@/config/infrastructureTypes.json";
import {
  getNameWithoutLanes,
  getCapitalizedDisplayNameWithoutLanes,
} from "../utils/nameUtils";

const legendInfrastructureTypes = ref([]);
const activeInfrastructureTypes = ref([]);

const isInfoShown = ref(false);
const info = ref({});

const showInfo = e => {
  info.value = e;
  isInfoShown.value = true;
};

const hideInfo = () => {
  isInfoShown.value = false;
  info.value = null;
};

onBeforeMount(() => {
  // Transform displayName of infrastructure types without lanes and capitalized (without duplicates)
  infrastructureTypes.forEach(it => {
    const nameWithoutLanes = getNameWithoutLanes(it.name);

    if (
      !legendInfrastructureTypes.value.some(it => it.name === nameWithoutLanes)
    ) {
      const capitalizedDisplayNameWithoutLanes =
        getCapitalizedDisplayNameWithoutLanes(it.displayName);

      legendInfrastructureTypes.value.push({
        displayName: capitalizedDisplayNameWithoutLanes,
        name: nameWithoutLanes,
        color: it.color,
      });
    }
  });

  // Mark all infrastructure types as active except uncategorized
  legendInfrastructureTypes.value.forEach(it => {
    if (it.name != "uncategorized") {
      activeInfrastructureTypes.value.push(it.name);
    }
  });
});
</script>

<template>
  <div>
    <Map
      :infrastructureTypes="infrastructureTypes"
      :activeInfrastructureTypes="activeInfrastructureTypes"
      @showInfo="e => showInfo(e)"
      @hideInfo="() => hideInfo()"
    />
    <Legend
      v-model="activeInfrastructureTypes"
      :infrastructureTypes="legendInfrastructureTypes"
    />
    <Info v-if="isInfoShown" :info="info" />
  </div>
</template>

<style>
* {
  padding: 0;
  margin: 0;
}
</style>
