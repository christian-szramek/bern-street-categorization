const isCyclingForbidden = infrastructureType => {
  return infrastructureType === 'pedestrian' || infrastructureType.includes('forbidden');
};

export { isCyclingForbidden };
