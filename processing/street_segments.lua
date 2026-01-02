print('osm2pgsql version: ' .. osm2pgsql.version)

local street_segments_ways = osm2pgsql.define_way_table('street_segments_ways', {
    { column = 'infra_type', type = 'text' },
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'linestring', not_null = true }
})

local street_segments_closed_ways = osm2pgsql.define_area_table('street_segments_closed_ways', {
    { column = 'infra_type', type = 'text' },
    { column = 'type', type = 'text' },
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'geometry', not_null = true }
})

local street_segments_multipolygon = osm2pgsql.define_area_table('street_segments_multipolygon', {
    { column = 'infra_type', type = 'text' },
    { column = 'type', type = 'text' },
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'geometry', not_null = true }
})

function osm2pgsql.process_way(object)
    if object.is_closed and object.tags['area:highway'] then
        street_segments_closed_ways:insert({
            infra_type = 'start-infra-type',
            type = object.type,
            tags = object.tags,
            geom = object:as_polygon()
        })
    end

    if not object.is_closed and object.tags.highway then
        street_segments_ways:insert({
            infra_type = 'start-infra-type',
            tags = object.tags,
            geom = object:as_linestring()
        })
    end
end

function osm2pgsql.process_relation(object)
    --[[ if object.tags.type == 'multipolygon' or
       object.tags.type == 'boundary' then
        if object.tags.highway then
            street_segments_multipolygon:insert({
                infra_type = 'start-infra-type',
                type = object.type,
                tags = object.tags,
                geom = object:as_multipolygon()
            })
        end
    end ]]
 
    if object.tags.highway then
        street_segments_multipolygon:insert({
            infra_type = 'start-infra-type',
            type = object.type,
            tags = object.tags,
            geom = object:as_multipolygon()
        })
    end
end