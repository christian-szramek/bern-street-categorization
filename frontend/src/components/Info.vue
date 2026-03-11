<script setup>
import { computed } from 'vue';

const props = defineProps(['info']);

const filteredInfoKeys = computed(() => {
  return Object.keys(props.info).filter(
    (key) => !key.includes('wikipedia') && !key.includes('wikimedia') && !key.includes('wikidata') && !key.includes('image') && !key.includes('name:') && !key.includes('displayName')
  );
});
</script>

<template>
  <div class="info-wrapper">
    <v-card title="Info" elevation="6" rounded="lg" class="info-card">
      <v-card-text class="info-content">
        <div class="section">
          <div class="section-title">Bucket</div>
          <v-chip size="small" color="primary" variant="tonal">
            {{ props.info.displayName }}
          </v-chip>
        </div>
        <div class="section">
          <div class="section-title">Tags</div>
          <div v-for="key in filteredInfoKeys" :key="key" class="info-item">
            <span class="info-key">{{ key }}</span>
            <span class="info-value">{{ props.info[key] }}</span>
          </div>
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
  min-width: 220px;
  backdrop-filter: blur(6px);
}

.info-card :deep(.v-card-title) {
  font-size: 14px;
  font-weight: 600;
  text-transform: uppercase;
  opacity: 0.7;
  padding-bottom: 4px;
}

/* Reduce top padding of content */
.info-content {
  padding-top: 6px;
}

.section {
  margin-bottom: 10px;
}

.section-title {
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  opacity: 0.7;
  margin-bottom: 6px;
}

.info-item {
  display: flex;
  align-items: flex-start;
  margin-bottom: 3px;
}

.info-key {
  font-size: 13px;
  font-weight: 600;
  margin-right: 10px;
  white-space: nowrap;
  opacity: 0.8;
}

.info-value {
  font-size: 13px;
  flex: 1;
  word-break: break-word;
}
</style>
