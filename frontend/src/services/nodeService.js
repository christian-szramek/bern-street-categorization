import axios from "axios";

const baseURL = "http://localhost:9000";

const getNodes = async (infrastructureType, mapBounds) => {
  const url = `${baseURL}/collections/public.${infrastructureType}_nodes/items.json?bbox=${mapBounds.getWest()},${mapBounds.getSouth()},${mapBounds.getEast()},${mapBounds.getNorth()}`;

  try {
    const response = await axios.get(url);
    return response.data;
  } catch (error) {
    alert(`Failed to load nodes as GeoJSON from ${url}`);
  }
};

export { getNodes };
