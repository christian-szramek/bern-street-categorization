-- NODES

-- car

CREATE TABLE IF NOT EXISTS public.car_nodes (
    node_id BIGINT,
    tags JSONB,
    geom geometry(Point, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS car_nodes_geom_idx
    ON public.car_nodes
    USING GIST (geom);

-- street

CREATE TABLE IF NOT EXISTS public.street_nodes (
    node_id BIGINT,
    tags JSONB,
    geom geometry(Point, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS street_nodes_geom_idx
    ON public.street_nodes
    USING GIST (geom);

-- pedestrian

CREATE TABLE IF NOT EXISTS public.pedestrian_nodes (
    node_id BIGINT,
    tags JSONB,
    geom geometry(Point, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS pedestrian_nodes_geom_idx
    ON public.pedestrian_nodes
    USING GIST (geom);

-- horse

CREATE TABLE IF NOT EXISTS public.horse_nodes (
    node_id BIGINT,
    tags JSONB,
    geom geometry(Point, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS horse_nodes_geom_idx
    ON public.horse_nodes
    USING GIST (geom);

-- cycleway

CREATE TABLE IF NOT EXISTS public.cycleway_nodes (
    node_id BIGINT,
    tags JSONB,
    geom geometry(Point, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS cycleway_nodes_geom_idx
    ON public.cycleway_nodes
    USING GIST (geom);

-- uncategorized

CREATE TABLE IF NOT EXISTS public.uncategorized_nodes (
    node_id BIGINT,
    tags JSONB,
    geom geometry(Point, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS uncategorized_nodes_geom_idx
    ON public.uncategorized_nodes
    USING GIST (geom);

-- WAYS

-- car

CREATE TABLE IF NOT EXISTS public.car_ways (
    way_id BIGINT,
    tags JSONB,
    geom geometry(LineString, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS car_ways_geom_idx
    ON public.car_ways
    USING GIST (geom);

-- street

CREATE TABLE IF NOT EXISTS public.street_ways (
    way_id BIGINT,
    tags JSONB,
    geom geometry(LineString, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS street_ways_geom_idx
    ON public.street_ways
    USING GIST (geom);

-- pedestrian

CREATE TABLE IF NOT EXISTS public.pedestrian_ways (
    way_id BIGINT,
    tags JSONB,
    geom geometry(LineString, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS pedestrian_ways_geom_idx
    ON public.pedestrian_ways
    USING GIST (geom);

-- horse

CREATE TABLE IF NOT EXISTS public.horse_ways (
    way_id BIGINT,
    tags JSONB,
    geom geometry(LineString, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS horse_ways_geom_idx
    ON public.horse_ways
    USING GIST (geom);

-- cycleway

CREATE TABLE IF NOT EXISTS public.cycleway_ways (
    way_id BIGINT,
    tags JSONB,
    geom geometry(LineString, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS cycleway_ways_geom_idx
    ON public.cycleway_ways
    USING GIST (geom);

-- uncategorized

CREATE TABLE IF NOT EXISTS public.uncategorized_ways (
    way_id BIGINT,
    tags JSONB,
    geom geometry(LineString, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS uncategorized_ways_geom_idx
    ON public.uncategorized_ways
    USING GIST (geom);

-- AREAS

-- car 

CREATE TABLE IF NOT EXISTS public.car_areas (
    area_id BIGINT,
    tags JSONB,
    geom geometry(Geometry, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS car_areas_geom_idx
    ON public.car_areas
    USING GIST (geom);

-- street

CREATE TABLE IF NOT EXISTS public.street_areas (
    area_id BIGINT,
    tags JSONB,
    geom geometry(Geometry, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS street_areas_geom_idx
    ON public.street_areas
    USING GIST (geom);

-- pedestrian

CREATE TABLE IF NOT EXISTS public.pedestrian_areas (
    area_id BIGINT,
    tags JSONB,
    geom geometry(Geometry, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS pedestrian_areas_geom_idx
    ON public.pedestrian_areas
    USING GIST (geom);

-- horse

CREATE TABLE IF NOT EXISTS public.horse_areas (
    area_id BIGINT,
    tags JSONB,
    geom geometry(Geometry, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS horse_areas_geom_idx
    ON public.horse_areas
    USING GIST (geom);

-- cycleway

CREATE TABLE IF NOT EXISTS public.cycleway_areas (
    area_id BIGINT,
    tags JSONB,
    geom geometry(Geometry, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS cycleway_areas_geom_idx
    ON public.cycleway_areas
    USING GIST (geom);

-- uncategorized

CREATE TABLE IF NOT EXISTS public.uncategorized_areas (
    area_id BIGINT,
    tags JSONB,
    geom geometry(Geometry, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS uncategorized_areas_geom_idx
    ON public.uncategorized_areas
    USING GIST (geom);
