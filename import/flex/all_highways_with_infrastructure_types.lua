print('osm2pgsql version: ' .. osm2pgsql.version)

local infrastructure_types = dofile('./import/flex/infrastructure_types.lua')

local IMPORT_AREA_HIGHWAY = false

local restrictions = os.getenv("RESTRICTIONS")

if restrictions then
    print("Use restrictions according to:", restrictions)
else
    error("Environment variable RESTRICTIONS is not set! Add RESTRICTIONS=CH for example to the .env file")
end

local highway_nodes = osm2pgsql.define_node_table('highway_nodes', {
    { column = 'tags', type = 'jsonb' },
    { column = 'infrastructure_type', type = 'text' },
    { column = 'geom', type = 'point', not_null = true }
})

local highway_ways = osm2pgsql.define_way_table('highway_ways', {
    { column = 'tags', type = 'jsonb' },
    { column = 'infrastructure_type', type = 'text' },
    { column = 'geom', type = 'linestring', not_null = true }
})

local highway_areas = osm2pgsql.define_area_table('highway_areas', {
    { column = 'tags', type = 'jsonb' },
    { column = 'infrastructure_type', type = 'text' },
    { column = 'geom', type = 'geometry', not_null = true }
})

function osm2pgsql.process_node(object)
    if infrastructure_types.is_highway(object.tags) and not infrastructure_types.is_ignored(object.tags) then
        highway_nodes:insert({
            tags = object.tags,
            infrastructure_type = infrastructure_types.get_infrastructure_type(object.tags),
            geom = object:as_point()
        })
    end
end

function osm2pgsql.process_way(object)
    if infrastructure_types.is_highway(object.tags) and not infrastructure_types.is_ignored(object.tags) then
        if infrastructure_types.is_area(object.tags) then
            highway_areas:insert({
                tags = object.tags,
                infrastructure_type = infrastructure_types.get_infrastructure_type(object.tags),
                geom = object:as_polygon()
            })
        else
            highway_ways:insert({
                tags = object.tags,
                infrastructure_type = infrastructure_types.get_infrastructure_type(object.tags),
                geom = object:as_linestring()
            })            
        end
    end

    if IMPORT_AREA_HIGHWAY and infrastructure_types.is_area_highway(object.tags) and not infrastructure_types.is_ignored(object.tags) then
        highway_areas:insert({
            tags = object.tags,
            infrastructure_type = infrastructure_types.get_infrastructure_type(object.tags),
            geom = object:as_polygon()
        })
    end
end

function osm2pgsql.process_relation(object)
    if infrastructure_types.is_highway(object.tags) and not infrastructure_types.is_ignored(object.tags) then
        highway_areas:insert({
            type = object.type,
            tags = object.tags,
            infrastructure_type = infrastructure_types.get_infrastructure_type(object.tags),
            geom = object:as_multipolygon()
        })
    end
end
