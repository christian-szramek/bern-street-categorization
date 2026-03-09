<script setup>
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

const isActive = infrastructureType => {
  return props.modelValue.includes(infrastructureType);
};

const toggle = infrastructureType => {
  const updated = [...props.modelValue];

  const index = updated.indexOf(infrastructureType);

  if (index > -1) {
    // Remove infrastructure type from array if it was active before
    updated.splice(index, 1);
  } else {
    // Add infrastructure type to array if it was inactive before
    updated.push(infrastructureType);
  }

  emit("update:modelValue", updated);
};
</script>

<template>
  <div class="legend-wrapper">
    <v-card title="Legend" elevation="6" rounded="lg" class="legend-card">
      <v-card-text class="pa-3">
        <div
          v-for="it in infrastructureTypes"
          :key="it.name"
          class="legend-item"
        >
          <span
            class="legend-dot"
            :class="{ inactive: !isActive(it.name) }"
            :style="{
              backgroundColor: isActive(it.name) ? it.color : 'transparent',
            }"
            @click="toggle(it.name)"
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
