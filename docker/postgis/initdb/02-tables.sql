-- highway_nodes

CREATE TABLE IF NOT EXISTS public.highway_nodes (
    node_id BIGINT,
    tags JSONB,
    infrastructure_type TEXT,
    geom geometry(Point, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS highway_nodes_geom_idx
    ON public.highway_nodes
    USING GIST (geom);

-- highway_ways

CREATE TABLE IF NOT EXISTS public.highway_ways (
    way_id BIGINT,
    tags JSONB,
    infrastructure_type TEXT,
    geom geometry(LineString, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS highway_ways_geom_idx
    ON public.highway_ways
    USING GIST (geom);

-- highway_areas    

CREATE TABLE IF NOT EXISTS public.highway_areas (
    area_id BIGINT,
    tags JSONB,
    infrastructure_type TEXT,
    geom geometry(Geometry, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS highway_areas_geom_idx
    ON public.highway_areas
    USING GIST (geom);
