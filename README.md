# Automatic Street Categorization of the City Bern

## Description

The goal of this tool is to automatically categorize OpenStreetMap street segments into predefined buckets and visualize them in a web application. It is part of a bachelor thesis and can process the cities Bern, Berlin, Weimar and Wichita Falls.

![Screenshot of the Frontend](utils/assets/Frontend_Screenshot.png)

This monorepo consists of multiple projects and directories:

- **docker**: Configuration and initialization files that are mounted to the Docker containers
- **download**: Script to download and crop the OpenStreetMap street segments
- **frontend**: Code for the street segment visualization
- **import**: Scripts for categorizing the street segments and storing them inside the database
- **jupyter_notebook**: Python Jupyter Notebook to analyse the processed street segments
- **utils**: Helper scripts to prepare the E2E test data, generate the database startup script based on the configured infrastructure types and images

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

#### Adding a new city

1. If you find the OSM file of the city directly at [Geofabrik](https://download.geofabrik.de/) add this to a new _EXAMPLE_REGION_URL_ variable
2. If not, add the next bigger area from [Geofabrik](https://download.geofabrik.de/) to this variable and add the OpenStreetMap city boundary relation in the EXAMPLE_BOUNDARIES_URL like this: https://www.openstreetmap.org/api/0.6/relation/1682378/full
3. Add the restriction variable EXAMPLE_RESTRICTION according to the country the city is part of (currently CH, DE and US are implemented)
4. Add the city name to the CITIES variable

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
