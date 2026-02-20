print('osm2pgsql version: ' .. osm2pgsql.version)

local logic = dofile('./import/flex/logic.lua')

local IMPORT_AREA_HIGHWAY = false

local highway_nodes = osm2pgsql.define_node_table('highway_nodes', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'point', not_null = true }
})

local highway_ways = osm2pgsql.define_way_table('highway_ways', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'linestring', not_null = true }
})

local highway_areas = osm2pgsql.define_area_table('highway_areas', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'geometry', not_null = true }
})

function osm2pgsql.process_node(object)
    if logic.is_highway(object.tags) then
        highway_nodes:insert({
            tags = object.tags,
            geom = object:as_point()
        })
    end
end

function osm2pgsql.process_way(object)
    if logic.is_highway(object.tags) then
        if logic.is_area(object.tags) then
            highway_areas:insert({
                tags = object.tags,
                geom = object:as_polygon()
            })
        else
            highway_ways:insert({
                tags = object.tags,
                geom = object:as_linestring()
            })
        end
    end

    if IMPORT_AREA_HIGHWAY and logic.is_area_highway(object.tags) then
        highway_areas:insert({
            tags = object.tags,
            geom = object:as_polygon()
        })
    end
end

function osm2pgsql.process_relation(object)
    if logic.is_highway(object.tags) then
        highway_areas:insert({
            type = object.type,
            tags = object.tags,
            geom = object:as_multipolygon()
        })
    end
end