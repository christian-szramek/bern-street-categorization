const getNodeLayer = (data, color, handleMouseOver, handleMouseOut) => {
  return L.geoJSON(data, {
    pointToLayer: (_, latlng) =>
      L.circleMarker(latlng, {
        radius: 4,
        fillColor: color,
        color: color,
        weight: 1,
        opacity: 1,
        fillOpacity: 1
      }),
    onEachFeature: (feature, layer) => {
      layer.on('mouseover', () => {
        handleMouseOver({
          ...feature.properties.tags,
          displayName: feature.properties.displayName
        });
      });
      layer.on('mouseout', () => {
        handleMouseOut();
      });
    }
  });
};

export { getNodeLayer };
