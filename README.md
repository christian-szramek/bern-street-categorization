# Automatic Street Categorization of the City Bern

## Description

The goal of this tool is to automatically categorize OSM street segments into predefined infrastructure buckets and visualize them in a web application. It is part of a bachelor thesis and can process the cities Bern, Berlin, Weimar and Wichita Falls.

The processing part of the tool mainly consists of two steps. The downloading of the required OSM data and the filtering, categorization and storing of the street segments inside a database. These steps are performed for each city that is configured in the .env file.
![Street Processing Flow](utils/assets/Street_Processing_Flow.png)

First the latest OSM data gets downloaded from [Geofabrik](https://www.geofabrik.de/) for the given city. If the city has no dedicated download endpoint, the next bigger area is downloaded and afterwards only the city data is extracted using the [Osmium Tool](https://osmcode.org/osmium-tool/) and the city boundary (OSM relation).
![OSM Download Flow](utils/assets/OSM_Download_Flow.png)

Afterwards the needed node, way and area tables get dynamically defined for each infrastructure bucket using [OSM2PGSQL](https://osm2pgsql.org/) and a [PostgreSQL](https://www.postgresql.org/) database with the [PostGIS](https://postgis.net/) extension. Each feature of the resulting OSM data will be processed, but only street segments raceways and elevators. The result of this step are populated database tables for each city and infrastructure type e.g. bern_2_l_s_with_bus_bic_lane_on_one_side representing 2-lane two way streets with a bus or bicycle lane on one side in Bern.
![Street Import Flow](utils/assets/Street_Import_Flow.png)

To access the infrastructure buckets from the frontend, [pg_featureserv](https://access.crunchydata.com/documentation/pg_featureserv/latest/) and [pg_tileserv](https://access.crunchydata.com/documentation/pg_tileserv/latest/) were used as Docker containers. Ways and areas are fetched as tiles and nodes were fetched as GeoJSON. The frontend was developed with [Vue.js](https://vuejs.org/) and [leaflet](https://leafletjs.com/). The street segments are vizualized in different colors and can be (de-)selected on the map by clicking the bullet point in the legend. To improve readability the lane information is abstracted in the legend, but visible when hovering the street segment. Also an example street and a description are shown when hovering the infrastructure type in the legend. The centered city can be changed using the select component in the legend.
![Screenshot of the Frontend](utils/assets/Frontend_Screenshot.png)

This monorepo consists of multiple projects and directories:

- **docker**: Configuration and initialization files that are mounted to the Docker containers
- **download**: Script to download and extract the OSM street segments
- **frontend**: Code for the street segment visualization
- **import**: Scripts for filtering, categorizing and storing the street segments inside the database
- **jupyter_notebook**: Python Jupyter Notebook to analyze the processed street segments
- **utils**: Helper scripts to prepare the E2E test data, generate the database startup script and images

## Usage

### Prerequisites

- Ubuntu 24.04.04 LTS
- Docker 29.3.1 with Docker Compose
- curl 8.5.0
- Node.js 25.8.0
- npm 11.11.0

### Installing the Dependencies

1. Install [Osmium Tool](https://osmcode.org/osmium-tool/):

```sh
foo@bar:~$ sudo apt install osmium-tool
```

2. Install [OSM2PGSQL](https://osm2pgsql.org/):

```sh
foo@bar:~$ sudo apt install osm2pgsql
```

### Env File Configuration

1. Create a `.env` file based on the `.env.example` in the root project directory

[To add a new city follow these instructions.](import/README.md)

### Database and Backend Startup

1. Start the Docker services:

```sh
foo@bar:~$ docker compose up -d
```

### Street Processing Execution

1. Execute the street segment processing with the values according to the .env file:

```sh
foo@bar:~$ ./process.sh
```

- If you want to rerun the processing, execute the following script: `./rerun.sh`

### Frontend Setup

1. Navigate to the frontend directory:

```sh
foo@bar:~$ cd frontend
```

2. Install the dependencies:

```sh
foo@bar:~$ npm install
```

3. Start the development server:

```sh
foo@bar:~$ npm run dev
```

4. Open the frontend in the browser e.g.: _http://localhost:5173/_

### Test Setup

[Follow the test setup instructions.](import/flex/test/README.md)

### Python Jupyter Notebook Setup

[Follow the Jupyter Notebook Setup Instructions.](jupyter_notebook/README.md)
