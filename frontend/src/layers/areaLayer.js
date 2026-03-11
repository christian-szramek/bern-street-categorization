const baseURL = 'http://localhost:7800';

const getAreaLayer = (infrastructureType, color, handleMouseOver, handleMouseOut) => {
  const styles = {};
  styles[`public.${infrastructureType}_areas`] = _ => ({
    fill: true,
    fillColor: color,
    color: color,
    weight: 1,
    fillOpacity: 0.6,
    opacity: 1
  });

  return L.vectorGrid
    .protobuf(`${baseURL}/public.${infrastructureType}_areas/{z}/{x}/{y}.pbf`, {
      vectorTileLayerStyles: styles,
      minZoom: 1,
      maxZoom: 19,
      interactive: true,
      getFeatureId: f => f.properties.id
    })
    .on('mouseover', e => {
      handleMouseOver(e.layer.properties);
    })
    .on('mouseout', e => {
      handleMouseOut();
    });
};

export { getAreaLayer };
