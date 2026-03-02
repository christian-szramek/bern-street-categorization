const baseURL = "http://localhost:7800";

const computeWeight = infrastructureType => {
  switch (infrastructureType.split("_")[0]) {
    case "2":
      return 3;
    case "3":
      return 5;
    case "4":
      return 7;
    case "5":
      return 9;
    case "6":
      return 1;
    case "7":
      return 13;
    case "8":
      return 15;
    default:
      return 1;
  }
};

const getWayLayer = (infrastructureType, color, handleMouseOver, minZoom) => {
  const styles = {};
  styles[`public.${infrastructureType}_ways`] = _ => ({
    stroke: true,
    color: color,
    weight: computeWeight(infrastructureType),
    opacity: 1,
  });

  return L.vectorGrid
    .protobuf(`${baseURL}/public.${infrastructureType}_ways/{z}/{x}/{y}.pbf`, {
      vectorTileLayerStyles: styles,
      minZoom: minZoom,
      maxZoom: 19,
      interactive: true,
      getFeatureId: f => f.properties.id,
    })
    .on("mouseover", e => {
      handleMouseOver(e.layer.properties);
    });
};

export { getWayLayer };
