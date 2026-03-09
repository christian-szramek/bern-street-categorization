<script setup>
import { ref, onBeforeMount } from 'vue';

import {
  getNameWithoutLanes,
  getCapitalizedDisplayNameWithoutLanes,
} from "@/utils/nameUtils";

const props = defineProps({
  infrastructureTypes: {
    type: Array,
    required: true,
  },
  modelValue: {
    type: Array,
    required: true,
  },
});

const emit = defineEmits(["update:modelValue"]);

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

  emit("update:modelValue", newActiveInfrastructureTypes);
};

onBeforeMount(() => {
  // Transform displayName of infrastructure types without lanes and capitalized (without duplicates)
  props.infrastructureTypes.forEach(it => {
    const nameWithoutLanes = getNameWithoutLanes(it.name);

    if (
      !legendInfrastructureTypes.value.some(it => it.name === nameWithoutLanes)
    ) {
      const capitalizedDisplayNameWithoutLanes =
        getCapitalizedDisplayNameWithoutLanes(it.displayName);

      legendInfrastructureTypes.value.push({
        displayName: capitalizedDisplayNameWithoutLanes,
        name: nameWithoutLanes,
        color: it.color,
      });
    }
  });
});
</script>

<template>
  <div class="legend-wrapper">
    <v-card title="Legend" elevation="6" rounded="lg" class="legend-card">
      <v-card-text class="pa-3">
        <div
          v-for="it in legendInfrastructureTypes"
          :key="it.name"
          class="legend-item"
        >
          <span
            class="legend-dot"
            :class="{ inactive: !isInfrastructureTypeActive(it.name) }"
            :style="{
              backgroundColor: isInfrastructureTypeActive(it.name) ? it.color : 'transparent',
            }"
            @click="toggleInfrastructureType(it.name)"
          />
          <span class="legend-label" v-text="it.displayName" />
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
  font-size: 15px;
}
</style>
