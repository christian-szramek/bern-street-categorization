<script setup>
import { onBeforeMount, ref } from "vue";

import Map from "@/components/Map.vue";
import Legend from "@/components/Legend.vue";
import Info from "@/components/Info.vue";

import {
  getNameWithoutLanes,
  getCapitalizedDisplayNameWithoutLanes,
} from "../utils/nameUtils";

import config from "@/config/infrastructureTypes.json";

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
  config.infrastructureTypes.forEach(it => {
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

  activeInfrastructureTypes.value = config.defaultActiveInfrastructureTypes;
});
</script>

<template>
  <div>
    <Map
      :infrastructureTypes="config.infrastructureTypes"
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
