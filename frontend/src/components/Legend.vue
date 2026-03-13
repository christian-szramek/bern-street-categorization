<script setup>
import { ref, onBeforeMount } from 'vue';

import { getNameWithoutLanes, getCapitalizedDisplayNameWithoutLanes } from '@/utils/nameUtils';

const props = defineProps({
  infrastructureTypes: {
    type: Array,
    required: true
  },
  modelValue: {
    type: Array,
    required: true
  },
  cities: {
    type: Array,
    required: true
  },
  centeredCity: {
    type: Object,
    required: true
  }
});

const emit = defineEmits(['update:modelValue', 'centeredCityChanged']);

const legendInfrastructureTypes = ref([]);

const isInfrastructureTypeActive = infrastructureType => {
  return props.modelValue.includes(infrastructureType);
};

const toggleInfrastructureType = infrastructureType => {
  const newActiveInfrastructureTypes = [...props.modelValue];

  const index = newActiveInfrastructureTypes.indexOf(infrastructureType);

  if (index > -1) {
    // Remove infrastructure type from array if it was active before
    newActiveInfrastructureTypes.splice(index, 1);
  } else {
    // Add infrastructure type to array if it was inactive before
    newActiveInfrastructureTypes.push(infrastructureType);
  }

  emit('update:modelValue', newActiveInfrastructureTypes);
};

onBeforeMount(() => {
  // Transform displayName of infrastructure types without lanes and capitalized (without duplicates)
  props.infrastructureTypes.forEach(it => {
    const nameWithoutLanes = getNameWithoutLanes(it.name);

    if (!legendInfrastructureTypes.value.some(it => it.name === nameWithoutLanes)) {
      const capitalizedDisplayNameWithoutLanes = getCapitalizedDisplayNameWithoutLanes(it.displayName);

      legendInfrastructureTypes.value.push({
        displayName: capitalizedDisplayNameWithoutLanes,
        name: nameWithoutLanes,
        color: it.color,
        image: `/images/infrastructureTypes/${nameWithoutLanes}.jpg`,
        description: it.description
      });
    }
  });
});
</script>

<template>
  <div class="legend-wrapper">
    <v-card title="Legend" elevation="6" rounded="md" class="legend-card">
      <v-card-subtitle>
        <v-select
          class="city-select"
          :modelValue="props.centeredCity"
          :items="props.cities"
          item-title="displayName"
          return-object
          density="compact"
          variant="underlined"
          @update:modelValue="city => emit('centeredCityChanged', city)"
        />
      </v-card-subtitle>
      <v-card-text class="legend-content">
        <div class="section-title" v-text="'Infrastructure Types'" />
        <v-tooltip v-for="it in legendInfrastructureTypes" :key="it.name" location="left" content-class="tooltip-content" offset="33">
          <template v-slot:activator="{ props }">
            <div v-bind="props" class="legend-item" @click="toggleInfrastructureType(it.name)">
              <span
                class="legend-dot"
                :class="{ inactive: !isInfrastructureTypeActive(it.name) }"
                :style="{
                  backgroundColor: isInfrastructureTypeActive(it.name) ? it.color : 'transparent'
                }"
              />
              <span class="legend-label" v-text="it.displayName" />
            </div>
          </template>

          <v-card elevation="4" rounded="md" class="hover-card">
            <v-img :src="it.image" height="180" cover />
            <v-card-text>
              <div class="hover-title" v-text="it.displayName" />
              <div class="hover-description" v-text="it.description" />
            </v-card-text>
          </v-card>
        </v-tooltip>
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
  min-width: 220px;
  backdrop-filter: blur(6px);
}

.legend-card :deep(.v-card-title) {
  font-size: 14px;
  font-weight: 600;
  text-transform: uppercase;
  opacity: 0.7;
  padding-bottom: 4px;
}

.legend-content {
  padding-top: 6px;
}

.section-title {
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  opacity: 0.7;
  margin-bottom: 8px;
}

.legend-item {
  display: flex;
  align-items: center;
  margin-bottom: 6px;
  cursor: pointer;
}

.legend-dot {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  margin-right: 10px;
  box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.35);
  transition:
    background-color 0.15s ease,
    transform 0.1s ease;
}

.legend-dot:hover {
  transform: scale(1.15);
}

.legend-dot.inactive {
  background-color: transparent !important;
}

.legend-label {
  font-size: 13px;
  font-weight: 600;
  opacity: 0.75;
}

.city-select :deep(.v-list-item-title) {
  font-size: 13px;
  font-weight: 600;
  opacity: 0.75;
}

.city-select :deep(.v-list-item) {
  min-height: 32px;
}

.hover-card {
  width: 240px;
}

.hover-title {
  font-size: 14px;
  font-weight: 600;
  margin-bottom: 4px;
  opacity: 0.75;
}

.hover-description {
  font-size: 12px;
  opacity: 0.75;
}

:deep(.tooltip-content) {
  padding: 0 !important;
  margin: 0 !important;
}
</style>
