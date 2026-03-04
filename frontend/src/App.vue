<script setup>
import { ref } from "vue";

import Map from "@/components/Map.vue";
import Legend from "@/components/Legend.vue";
import Info from "@/components/Info.vue";

import infrastructureTypes from "@/config/infrastructureTypes.json";

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
</script>

<template>
  <div>
    <Map
      :infrastructureTypes="infrastructureTypes"
      @showInfo="e => showInfo(e)"
      @hideInfo="() => hideInfo()"
    />
    <Legend :infrastructureTypes="infrastructureTypes" />
    <Info v-if="isInfoShown" :info="info" />
  </div>
</template>

<style>
* {
  padding: 0;
  margin: 0;
}
</style>
