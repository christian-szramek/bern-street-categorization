import { isCyclingForbidden } from '@/utils/infrastructureTypesUtils';

const baseURL = 'http://localhost:7800';

const computeWeight = infrastructureType => {
  switch (infrastructureType.split('_')[0]) {
    case '2':
      return 3;
    case '3':
      return 4;
    case '4':
      return 5;
    case '5':
      return 6;
    case '6':
      return 7;
    case '7':
      return 8;
    case '8':
      return 9;
    default:
      return 2;
  }
};

const getWayLayer = (city, infrastructureType, color, handleMouseOver, handleMouseOut) => {
  const weight = computeWeight(infrastructureType);

  const styles = {};
  styles[`public.${city}_${infrastructureType}_ways`] = () => [
    // visible stroke
    {
      stroke: true,
      color: color,
      weight: weight,
      opacity: 1,
      dashArray: isCyclingForbidden(infrastructureType) ? '6,6' : null
    },
    // hitbox stroke
    {
      stroke: true,
      color: 'white',
      weight: Math.max(weight, 5),
      opacity: 0
    }
  ];

  const layer = L.vectorGrid
    .protobuf(`${baseURL}/public.${city}_${infrastructureType}_ways/{z}/{x}/{y}.pbf`, {
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

  return layer;
};

export { getWayLayer };
