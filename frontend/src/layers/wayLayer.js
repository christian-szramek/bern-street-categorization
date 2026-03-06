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

const getWayLayer = (
  infrastructureType,
  color,
  minZoom,
  handleMouseOver,
  handleMouseOut,
) => {
  const weight = computeWeight(infrastructureType);

  const styles = {};
  styles[`public.${infrastructureType}_ways`] = () => [
    // visible stroke
    {
      stroke: true,
      color: color,
      weight: weight,
      opacity: 1,
    },
    // hitbox stroke
    {
      stroke: true,
      color: "white",
      weight: Math.max(weight, 5),
      opacity: 0,
    },
  ];

  const layer = L.vectorGrid
    .protobuf(`${baseURL}/public.${infrastructureType}_ways/{z}/{x}/{y}.pbf`, {
      vectorTileLayerStyles: styles,
      minZoom: minZoom,
      maxZoom: 19,
      interactive: true,
      getFeatureId: f => f.properties.id,
    })
    .on("mouseover", e => {
      handleMouseOver(e.layer.properties);
    })
    .on("mouseout", () => {
      handleMouseOut();
    });

  return layer;
};

export { getWayLayer };
