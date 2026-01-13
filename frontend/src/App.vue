<script setup>
import Map from "@/components/Map.vue";
import Legend from "./components/Legend.vue";

const infrastructureTypes = [
  {
    name: "pedestrian",
    color: "blue",
  },
  {
    name: "non_pedestrian",
    color: "green",
  },
];
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
