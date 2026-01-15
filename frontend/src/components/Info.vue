<script setup>
const props = defineProps(["info"]);
</script>

<template>
  <div class="info-wrapper">
    <v-card title="Info" elevation="6" rounded="lg" class="info-card">
      <v-card-text class="pa-3">
        <span class="info-label"> {{ props.info }} </span>
      </v-card-text>
    </v-card>
  </div>
</template>

<style scoped>
.info-wrapper {
  position: absolute;
  bottom: 16px;
  right: 16px;
  z-index: 1000;
}

.info-card {
  min-width: 180px;
  backdrop-filter: blur(6px);
}

.info-label {
  font-size: 14px;
}
</style>
