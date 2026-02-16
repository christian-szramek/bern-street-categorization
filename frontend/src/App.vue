<script setup>
import { ref } from "vue";

import Map from "@/components/Map.vue";
import Legend from "@/components/Legend.vue";
import Info from "@/components/Info.vue";

import infrastructureTypes from "@/config/infrastructureTypes.json";

const showInfo = ref(false);
const info = ref({});

function handleInfo(e) {
  info.value = e;
  showInfo.value = true;
}
</script>

<template>
  <div>
    <Map
      :infrastructureTypes="infrastructureTypes"
      @info="e => handleInfo(e)"
    />
    <Legend :infrastructureTypes="infrastructureTypes" />
    <Info v-if="showInfo" :info="info" />
  </div>
</template>

<style>
* {
  padding: 0;
  margin: 0;
}
</style>
