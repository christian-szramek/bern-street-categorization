# Adding a new city

1. If you find the OSM file of the city directly at [Geofabrik](https://download.geofabrik.de/) add this to a new _EXAMPLE_REGION_URL_ variable
2. If not, add the next bigger area from [Geofabrik](https://download.geofabrik.de/) to this variable and add the OpenStreetMap city boundary relation in the EXAMPLE_BOUNDARIES_URL like this: https://www.openstreetmap.org/api/0.6/relation/1682378/full
3. Add the restriction variable EXAMPLE_RESTRICTION according to the country the city is part of (currently CH, DE and US are implemented)
4. Add the city name to the CITIES variable
