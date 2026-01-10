print('osm2pgsql version: ' .. osm2pgsql.version)

local highway_nodes = osm2pgsql.define_node_table('highway_nodes', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'point', not_null = true }
})

local highway_ways = osm2pgsql.define_way_table('highway_ways', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'linestring', not_null = true }
})

local highway_closed_ways = osm2pgsql.define_area_table('highway_closed_ways', {
    { column = 'type', type = 'text' },
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'geometry', not_null = true }
})

local highway_multipolygons = osm2pgsql.define_area_table('highway_multipolygons', {
    { column = 'type', type = 'text' },
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'geometry', not_null = true }
})

function osm2pgsql.process_node(object)
    if object.tags.highway then
        highway_nodes:insert({
            tags = object.tags,
            geom = object:as_point()
        })
    end
end

function osm2pgsql.process_way(object)
    if object.is_closed and (object.tags.highway or object.tags['area:highway']) then
        highway_closed_ways:insert({
            type = object.type,
            tags = object.tags,
            geom = object:as_polygon()
        })
    end

    if not object.is_closed and object.tags.highway then
        highway_ways:insert({
            tags = object.tags,
            geom = object:as_linestring()
        })
    end
end

function osm2pgsql.process_relation(object)
    if object.tags.highway then
        highway_multipolygons:insert({
            type = object.type,
            tags = object.tags,
            geom = object:as_multipolygon()
        })
    end
end