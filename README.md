# Automatic Street Categorization of the City Bern

## Description

The goal of this tool is to automatically categorize OpenStreetMap street segments into predefined buckets and visualize them in a web application. It is part of a bachelor thesis and can process the cities Bern, Berlin, Weimar and Wichita Falls.

## Usage

### Prerequisites

- Ubuntu 24.04.04 LTS
- Docker 29.3.1 with Docker Compose
- curl 8.5.0

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

TODO

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

[Follow the frontend setup instructions.](frontend/README.md)

### Test Setup

[Follow the test setup instructions.](import/flex/test/README.md)

### Python Jupyter Notebook Setup

[Follow the Jupyter Notebook Setup Instructions.](jupyter_notebook/README.md)
