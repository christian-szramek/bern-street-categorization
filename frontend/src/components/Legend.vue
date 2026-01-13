<script setup>
const props = defineProps({
  infrastructureTypes: {
    type: Array,
    required: true,
  },
});
</script>

<template>
  <div class="legend-wrapper">
    <v-card title="Legend" elevation="6" rounded="lg" class="legend-card">
      <v-card-text class="pa-3">
        <div
          v-for="type in infrastructureTypes"
          :key="type.name"
          class="legend-item"
        >
          <span class="legend-dot" :style="{ backgroundColor: type.color }" />
          <span class="legend-label" v-text="type.name" />
        </div>
      </v-card-text>
    </v-card>
  </div>
</template>

<style scoped>
.legend-wrapper {
  position: absolute;
  top: 16px;
  right: 16px;
  z-index: 1000;
}

.legend-card {
  min-width: 180px;
  backdrop-filter: blur(6px);
}

.legend-item {
  display: flex;
  align-items: center;
  margin-bottom: 8px;
}

.legend-dot {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  margin-right: 10px;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.25);
}

.legend-label {
  font-size: 14px;
}
</style>
