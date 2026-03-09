<script setup>
import { onBeforeMount, ref } from "vue";

import Map from "@/components/Map.vue";
import Legend from "@/components/Legend.vue";
import Info from "@/components/Info.vue";

import config from "@/config/infrastructureTypes.json";

const activeInfrastructureTypes = ref([]);
const isInfoShown = ref(false);
const info = ref({});

const handleInfo = (isShow, e) => {
  isInfoShown.value = isShow;
  info.value = e;
}

onBeforeMount(() => {
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
      :infrastructureTypes="config.infrastructureTypes"
    />
    <Info 
      v-if="isInfoShown" 
      :info="info" 
    />
  </div>
</template>

<style>
* {
  padding: 0;
  margin: 0;
}
</style>
