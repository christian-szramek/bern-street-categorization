print('osm2pgsql version: ' .. osm2pgsql.version)

local IMPORT_AREA_HIGHWAY = true

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
    if object.tags.highway then
        highway_nodes:insert({
            tags = object.tags,
            infrastructure_type = get_infrastructure_type(object.tags),
            geom = object:as_point()
        })
    end
end

function osm2pgsql.process_way(object)
    if object.tags.highway then
        if object.tags.area == 'yes' then
            highway_areas:insert({
                tags = object.tags,
                infrastructure_type = get_infrastructure_type(object.tags),
                geom = object:as_polygon()
            })
        else
            highway_ways:insert({
                tags = object.tags,
                infrastructure_type = get_infrastructure_type(object.tags),
                geom = object:as_linestring()
            })
        end
    end

    if IMPORT_AREA_HIGHWAY and object.tags['area:highway'] then
        highway_areas:insert({
            tags = object.tags,
            infrastructure_type = get_infrastructure_type(object.tags),
            geom = object:as_polygon()
        })
    end
end

function osm2pgsql.process_relation(object)
    if object.tags.highway then
        highway_areas:insert({
            type = object.type,
            tags = object.tags,
            infrastructure_type = get_infrastructure_type(object.tags),
            geom = object:as_multipolygon()
        })
    end
end

function get_infrastructure_type(tags) 
    if tags.highway == 'pedestrian' or tags.highway == 'footway' or tags.highway == 'steps' or tags.highway == 'crossing' or (tags.highway == 'path' and (tags.sidewalk or tags.footway)) then
        return 'pedestrian'
    else
        return 'non_pedestrian'
    end
end