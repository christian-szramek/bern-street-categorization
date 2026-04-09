# Adding a new city

Adding a new city consists of two steps. First you have to configure it in the _.env_ file, so that the database tables get created and populated:
 
1. If you find the OSM file of the city directly at [Geofabrik](https://download.geofabrik.de/) add this to a new _EXAMPLE_REGION_URL_ variable in the _.env_ file (take Berlin as an example)
2. If not, add the next bigger area from [Geofabrik](https://download.geofabrik.de/) to this variable and add the OpenStreetMap city boundary relation in the EXAMPLE_BOUNDARIES_URL  variable like this: https://www.openstreetmap.org/api/0.6/relation/1682378/full (take Bern as an example)
3. Add the restriction variable EXAMPLE_RESTRICTION according to the country the city is part of (currently CH, DE and US are implemented)
4. Add the city name to the CITIES variable

Afterwards you have to configure the new city in the frontend:
1. Add a new city object to the cities array in the [frontend configuration file](../frontend/src/config/infrastructureTypes.json)
