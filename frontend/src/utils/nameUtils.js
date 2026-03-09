const getNameWithoutLanes = name => {
  return name.replace(/^\d+_l_/, "");
};

const getCapitalizedDisplayNameWithoutLanes = name => {
  const displayNameWithoutLanes = name.replace(/^\d+-lane\s+/i, "");
  return (
    displayNameWithoutLanes.charAt(0).toUpperCase() +
    displayNameWithoutLanes.slice(1)
  );
};

export { getNameWithoutLanes, getCapitalizedDisplayNameWithoutLanes };
