<script setup>
import Map from "@/components/Map.vue";
import Legend from "@/components/Legend.vue";

import infrastructureTypes from "@/data/infrastructureTypes.json";
</script>

<template>
  <div>
    <Map />
    <Legend :infrastructureTypes="infrastructureTypes" />
  </div>
</template>

<style>
* {
  padding: 0;
  margin: 0;
}
</style>
