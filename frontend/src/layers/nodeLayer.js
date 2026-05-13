const baseURL = import.meta.env.VITE_TILE_SERVER_URL;

const getNodeLayer = (city, infrastructureType, color, handleMouseOver, handleMouseOut) => {
  const styles = {};
  styles[`public.${city}_${infrastructureType}_nodes`] = _ => [
    {
      radius: 11,
      fillColor: color,
      color: color,
      weight: 2,
      opacity: 1,
      fillOpacity: 1,
      fill: false
    },
    {
      radius: 11,
      fillColor: color,
      color: color,
      weight: 2,
      opacity: 1,
      fillOpacity: 0,
      fill: true
    }
  ];

  return L.vectorGrid
    .protobuf(`${baseURL}/public.${city}_${infrastructureType}_nodes/{z}/{x}/{y}.pbf`, {
      vectorTileLayerStyles: styles,
      minZoom: 1,
      maxZoom: 19,
      interactive: true,
      getFeatureId: f => f.properties.id
    })
    .on('mouseover', e => {
      handleMouseOver(e.layer.properties);
    })
    .on('mouseout', () => {
      handleMouseOut();
    });
};

export { getNodeLayer };
