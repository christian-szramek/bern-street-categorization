# Automatic Street Categorization of the City Bern

## Description

The goal of this tool is to automatically categorize OpenStreetMap (OSM) street segments into predefined infrastructure buckets and visualize them in a web application. It is part of a bachelor thesis and can process the cities Bern, Berlin, Weimar and Wichita Falls.

The processing part of the tool mainly consists of two steps. The downloading of the required OSM data and the filtering, categorization and storing of the street segments inside a database. These steps are performed for each city that is declared \
in the _.env_ file. \
If the E2E test should be executed the download steps gets skipped and the test data for Bern and Berlin gets processed. For more information check the [test documentation.](import/flex/test/README.md)

![Street Processing Flow](utils/assets/Street_Processing_Flow.png)

First the latest OSM data gets downloaded from [Geofabrik](https://www.geofabrik.de/) for the current city. If the city has no dedicated download endpoint, the next bigger area is downloaded and the city data is extracted using the [Osmium Tool](https://osmcode.org/osmium-tool/) and the cities boundary (OSM relation). You can set that by either setting the Geofabrik city download URL in the `REGION_URL` parameter of the _.env_ file, or the next bigger area as the `REGION_URL` and the boundary as the `BOUNDARIES_URL` parameter.

![OSM Download Flow](utils/assets/OSM_Download_Flow.png)

Afterwards the needed node, way and area tables get dynamically defined based on a [configuration file](import/flex/infrastructure_types.lua) for each infrastructure bucket. Each feature of the OSM dataset from the previous step will be processed, but only non-ignorable features will be stored. These include the street segments and additionally crossings and cyclist waiting aids marked as nodes and pedestrian areas. Ignored features are for example traffic signs, railways and elevators. After a feature is evaluated as non-ignorable, it's infrastructure type gets determined based on it's OSM tags. Then it gets stored in the according database table including the OSM tags, the display name of the bucket and the geometry information. Used technologies in this step are the [PostgreSQL](https://www.postgresql.org/) database with the [PostGIS](https://postgis.net/) extension and the [OSM2PGSQL](https://osm2pgsql.org/) tool. The result of this step are populated database tables e.g. _bern_2_l_s_with_bus_bic_lane_on_one_side_ representing 2-lane two way streets with a bus or bicycle lane on one side in Bern.

![Street Import Flow](utils/assets/Street_Import_Flow.png)

To access the infrastructure buckets from the frontend [pg_tileserv](https://access.crunchydata.com/documentation/pg_tileserv/latest/) is used as a Docker container. Nodes, ways and areas are fetched as vector tiles. The frontend was developed with [Vue.js](https://vuejs.org/) and [leaflet](https://leafletjs.com/). The street segments are visualized in different colors and can be (de-)selected in the map by clicking the bullet point in the legend. To improve readability the lane information is abstracted in the legend, but visible when hovering the street segment. Also, an example street and a description are shown when hovering the infrastructure type in the legend. The centered city can be changed using the select component in the legend.

![Screenshot of the Frontend](utils/assets/Frontend_Screenshot.png)

## Repository Structure

This monorepo consists of multiple projects and directories:

- **docker**: Configuration and initialization files that are mounted to the Docker containers
- **download**: Script to download and extract the OSM street segments
- **frontend**: Code for the street segment visualization
- **import**: Scripts for filtering, categorizing and storing the street segments inside the database
- **jupyter_notebook**: Python Jupyter Notebook to analyze the processed street segments
- **utils**: Helper scripts to prepare the E2E test data, generate the database startup script and images

## Usage

### Prerequisites

- Ubuntu 24.04.04 LTS with the latest updates
- curl 8.5.0
- Docker 29.3.1 with Docker Compose and possibility to execute docker as a non-root user ([Installation guide](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository))

### Installing the Dependencies

1. Install [Osmium Tool](https://osmcode.org/osmium-tool/):

```sh
sudo apt install osmium-tool
```

2. Install [OSM2PGSQL](https://osm2pgsql.org/):

```sh
sudo apt install osm2pgsql
```

### Env File Configuration

1. Create a `.env` file based on the `.env.example` in the root project directory

```sh
cp .env.example .env
```

[To add a new city follow these instructions.](import/README.md)

### Services Startup

1. Start the Docker services:

```sh
docker compose up -d
```

### Street Processing

1. Execute the street segment processing with the values according to the .env file:

```sh
./process.sh
```

- If you want to rerun the processing, execute the following script: `./rerun.sh`

### Open the Frontend

1. Open the frontend in the browser e.g.: _http://localhost:8080/_

### Test Setup

[Follow the test setup instructions.](import/flex/test/README.md)

### Python Jupyter Notebook Setup

[Follow the Jupyter Notebook Setup Instructions.](jupyter_notebook/README.md)

## Frontend Development Setup

### Prerequisites

- Node.js 25.8.0 ([Installation through Node Version Manager is recommended](https://github.com/nvm-sh/nvm))
- npm 11.11.0

1. Navigate to the frontend directory:

```sh
cd frontend
```

2. Install the dependencies:

```sh
npm install
```

3. Start the development server:

```sh
npm run dev
```

4. Open the frontend in the browser e.g.: _http://localhost:5173/_
