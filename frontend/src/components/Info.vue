<script setup>
import { computed } from "vue";

const props = defineProps(["info"]);

const filteredInfoKeys = computed(() => {
  return Object.keys(props.info).filter(
    key =>
      !key.includes("wikipedia") &&
      !key.includes("wikimedia") &&
      !key.includes("wikidata") &&
      !key.includes("image"),
  );
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
  left: 16px;
  z-index: 1000;
  pointer-events: none;
}

.info-card {
  min-width: 180px;
  backdrop-filter: blur(6px);
}

.info-label {
  font-size: 11px;
}

.info-item {
  display: flex;
  align-items: flex-start;
}

.info-key {
  font-size: 14px;
  font-weight: bold;
  margin-right: 12px;
  white-space: nowrap;
}

.info-value {
  max-width: 200px;
  font-size: 14px;
  flex: 1;
  white-space: normal;
  word-break: break-word;
  overflow-wrap: anywhere;
}
</style>
