import axios from 'axios';

const baseURL = import.meta.env.VITE_FEATURE_SERVER_URL;

const getNodes = async (city, infrastructureType, mapBounds) => {
  const url = `${baseURL}/collections/public.${city}_${infrastructureType}_nodes/items.json?bbox=${mapBounds.getWest()},${mapBounds.getSouth()},${mapBounds.getEast()},${mapBounds.getNorth()}`;

  try {
    const response = await axios.get(url);
    return response.data;
  } catch (error) {
    alert(`Failed to load nodes as GeoJSON from ${url}`);
  }
};

export { getNodes };
