const baseURL = "http://localhost:7800";

const getWayLayer = (infrastructureType, color, handleMouseOver, minZoom) => {
  const styles = {};
  styles[`public.${infrastructureType}_ways`] = _ => ({
    stroke: true,
    color: color,
    weight: 2,
    opacity: 1,
  });

  return L.vectorGrid
    .protobuf(`${baseURL}/public.${infrastructureType}_ways/{z}/{x}/{y}.pbf`, {
      vectorTileLayerStyles: styles,
      minZoom: minZoom,
      maxZoom: 20,
      interactive: true,
      getFeatureId: f => f.properties.id,
    })
    .on("mouseover", e => {
      handleMouseOver(e.layer.properties);
    });
};

export { getWayLayer };
