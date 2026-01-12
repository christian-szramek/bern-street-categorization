print('osm2pgsql version: ' .. osm2pgsql.version)

local highway_areas = osm2pgsql.define_area_table('highway_areas', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'geometry', not_null = true }
})

function osm2pgsql.process_way(object)
    if object.tags['area:highway'] then
        highway_areas:insert({
            tags = object.tags,
            geom = object:as_polygon()
        })
    end
end