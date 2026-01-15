<script setup>
import { computed } from "vue";

const props = defineProps(["info"]);

const filteredInfoKeys = computed(() => {
  return Object.keys(props.info).filter(key => key != "infrastructure_type");
});
</script>

<template>
  <div class="info-wrapper">
    <v-card title="Info" elevation="6" rounded="lg" class="info-card">
      <v-card-text class="pa-3">
        <div v-for="key in filteredInfoKeys" :key="key" class="info-item">
          <span class="info-key">{{ key }} </span>
          <span class="info-value">{{ props.info[key] }}</span>
        </div>
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
  font-size: 15px;
}

.info-item {
  display: flex;
  align-items: flex-start;
}

.info-key {
  font-size: 15px;
  font-weight: bold;
  margin-right: 12px;
  white-space: nowrap;
}

.info-value {
  max-width: 200px;
  font-size: 15px;
  flex: 1;
  white-space: normal;
  word-break: break-word;
  overflow-wrap: anywhere;
}
</style>
