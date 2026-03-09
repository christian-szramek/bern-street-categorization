<script setup>
import { onBeforeMount, ref } from "vue";

import Map from "@/components/Map.vue";
import Legend from "@/components/Legend.vue";
import Info from "@/components/Info.vue";

import {
  getNameWithoutLanes,
  getCapitalizedDisplayNameWithoutLanes,
} from "../utils/nameUtils";

import infrastructureTypes from "@/config/infrastructureTypes.json";

const legendInfrastructureTypes = ref([]);
const activeInfrastructureTypes = ref([]);
const isInfoShown = ref(false);
const info = ref({});

const handleInfo = (isShow, e) => {
  isInfoShown.value = isShow;
  info.value = e;
}

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
    if (it.name != "uncategorized" && it.name != "pedestrian") {
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
      @showInfo="e => handleInfo(true, e)"
      @hideInfo="() => handleInfo(false, null)"
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
