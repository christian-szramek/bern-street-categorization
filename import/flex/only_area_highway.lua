print('osm2pgsql version: ' .. osm2pgsql.version)

local logic = dofile('./import/flex/logic.lua')

local highway_areas = osm2pgsql.define_area_table('highway_areas', {
    { column = 'tags', type = 'jsonb' },
    { column = 'infrastructure_type', type = 'text' },
    { column = 'geom', type = 'geometry', not_null = true }
})

function osm2pgsql.process_way(object)
    if logic.is_area_highway(object.tags) then
        highway_areas:insert({
            tags = object.tags,
            infrastructure_type = "pedestrian",
            geom = object:as_polygon()
        })
    end
end