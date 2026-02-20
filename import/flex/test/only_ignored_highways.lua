print('osm2pgsql version: ' .. osm2pgsql.version)

local infrastructure_types = dofile('./import/flex/infrastructure_types.lua')

local ignored_highways_nodes = osm2pgsql.define_node_table('ignored_highways_nodes', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'point', not_null = true }
})

local ignored_highways_ways = osm2pgsql.define_way_table('ignored_highways_ways', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'linestring', not_null = true }
})

local ignored_highways_areas = osm2pgsql.define_area_table('ignored_highways_areas', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'geometry', not_null = true }
})


function osm2pgsql.process_node(object)
    if infrastructure_types.is_highway(object.tags) and infrastructure_types.is_ignored(object.tags) then
        ignored_highways_nodes:insert({
            tags = object.tags,
            geom = object:as_point()
        })
    end
end

function osm2pgsql.process_way(object)
    if infrastructure_types.is_highway(object.tags) and infrastructure_types.is_ignored(object.tags) then
        if infrastructure_types.is_area(object.tags) then
            ignored_highways_areas:insert({
                tags = object.tags,
                geom = object:as_polygon()
            })
        else
            ignored_highways_ways:insert({
                tags = object.tags,
                geom = object:as_linestring()
            })
        end
    end
end

function osm2pgsql.process_areas(object)
    if infrastructure_types.is_highway(object.tags) and infrastructure_types.is_ignored(object.tags) then
        ignored_highways_areas:insert({
            tags = object.tags,
            geom = object:as_multipolygon()
        })
    end
end