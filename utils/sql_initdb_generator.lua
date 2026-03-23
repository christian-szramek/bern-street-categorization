local infrastructure_types = dofile('../import/flex/infrastructure_types.lua')

local cities = {
    "bern",
    "berlin",
    "wichita_falls",
    "weimar"
}

local function create_ways(city, name)
    return string.format([[
CREATE TABLE IF NOT EXISTS public.%s_%s_ways (
    way_id BIGINT,
    tags JSONB,
    geom geometry(LineString, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS %s_%s_ways_geom_idx
ON public.%s_%s_ways USING GIST (geom);

]], city, name, city, name, city, name)
end

local function create_nodes(city, name)
    return string.format([[
CREATE TABLE IF NOT EXISTS public.%s_%s_nodes (
    node_id BIGINT,
    tags JSONB,
    geom geometry(Point, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS %s_%s_nodes_geom_idx
ON public.%s_%s_nodes USING GIST (geom);

]], city, name, city, name, city, name)
end

local function create_areas(city, name)
    return string.format([[
CREATE TABLE IF NOT EXISTS public.%s_%s_areas (
    area_id BIGINT,
    tags JSONB,
    geom geometry(Geometry, 3857) NOT NULL
);

CREATE INDEX IF NOT EXISTS %s_%s_areas_geom_idx
ON public.%s_%s_areas USING GIST (geom);

]], city, name, city, name, city, name)
end

-- =========================================
-- Generate SQL
-- =========================================

local output_file = "../docker/postgis/initdb/02-tables.sql"
local f = assert(io.open(output_file, "w"))

f:write("-- =========================================\n")
f:write("-- AUTO-GENERATED FILE - DO NOT EDIT\n")
f:write("-- =========================================\n\n")

for _, entry in ipairs(infrastructure_types) do
    local name = entry.name

    for _, city in ipairs(cities) do
        f:write(string.format("\n-- =========================================\n"))
        f:write(string.format("-- %s | %s\n", city, name))
        f:write(string.format("-- =========================================\n\n"))

        -- ways always
        f:write(create_ways(city, name))

        -- optional nodes
        if entry.node then
            f:write(create_nodes(city, name))
        end

        -- optional areas
        if entry.area then
            f:write(create_areas(city, name))
        end
    end
end

f:close()

print("SQL file generated: " .. output_file)