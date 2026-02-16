print('osm2pgsql version: ' .. osm2pgsql.version)

local infrastructure_types = dofile('./import/flex/infrastructure_types.lua')

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





local car_nodes = osm2pgsql.define_node_table('car_nodes', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'point', not_null = true }
})

local car_ways = osm2pgsql.define_way_table('car_ways', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'linestring', not_null = true }
})

local car_areas = osm2pgsql.define_area_table('car_areas', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'geometry', not_null = true }
})

local street_nodes = osm2pgsql.define_node_table('street_nodes', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'point', not_null = true }
})

local street_ways = osm2pgsql.define_way_table('street_ways', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'linestring', not_null = true }
})

local street_areas = osm2pgsql.define_area_table('street_areas', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'geometry', not_null = true }
})

local pedestrian_nodes = osm2pgsql.define_node_table('pedestrian_nodes', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'point', not_null = true }
})

local pedestrian_ways = osm2pgsql.define_way_table('pedestrian_ways', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'linestring', not_null = true }
})

local pedestrian_areas = osm2pgsql.define_area_table('pedestrian_areas', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'geometry', not_null = true }
})

local horse_nodes = osm2pgsql.define_node_table('horse_nodes', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'point', not_null = true }
})

local horse_ways = osm2pgsql.define_way_table('horse_ways', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'linestring', not_null = true }
})

local horse_areas = osm2pgsql.define_area_table('horse_areas', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'geometry', not_null = true }
})

local cycleway_nodes = osm2pgsql.define_node_table('cycleway_nodes', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'point', not_null = true }
})

local cycleway_ways = osm2pgsql.define_way_table('cycleway_ways', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'linestring', not_null = true }
})

local cycleway_areas = osm2pgsql.define_area_table('cycleway_areas', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'geometry', not_null = true }
})

local uncategorized_nodes = osm2pgsql.define_node_table('uncategorized_nodes', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'point', not_null = true }
})

local uncategorized_ways = osm2pgsql.define_way_table('uncategorized_ways', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'linestring', not_null = true }
})

local uncategorized_areas = osm2pgsql.define_area_table('uncategorized_areas', {
    { column = 'tags', type = 'jsonb' },
    { column = 'geom', type = 'geometry', not_null = true }
})




function osm2pgsql.process_node(object)
    if infrastructure_types.is_highway(object.tags) and not infrastructure_types.is_ignored(object.tags) then

        local tmp_infrastructure_type = infrastructure_types.get_infrastructure_type(object.tags)

        if tmp_infrastructure_type == "car" then
            car_nodes:insert({
                tags = object.tags,
                geom = object:as_point()
            })
        elseif tmp_infrastructure_type == "street" then 
            street_nodes:insert({
                tags = object.tags,
                geom = object:as_point()
            })
        elseif tmp_infrastructure_type == "pedestrian" then 
            pedestrian_nodes:insert({
                tags = object.tags,
                geom = object:as_point()
            })
        elseif tmp_infrastructure_type == "horse" then 
            horse_nodes:insert({
                tags = object.tags,
                geom = object:as_point()
            })
        elseif tmp_infrastructure_type == "cycleway" then 
            cycleway_nodes:insert({
                tags = object.tags,
                geom = object:as_point()
            })
        else  
            uncategorized_nodes:insert({
                tags = object.tags,
                geom = object:as_point()
            })
        end
    end
end

function osm2pgsql.process_way(object)
    if infrastructure_types.is_highway(object.tags) and not infrastructure_types.is_ignored(object.tags) then
        if infrastructure_types.is_area(object.tags) then
            local tmp_infrastructure_type = infrastructure_types.get_infrastructure_type(object.tags)

            if tmp_infrastructure_type == "car" then
                car_areas:insert({
                    tags = object.tags,
                    geom = object:as_polygon()
                })
            elseif tmp_infrastructure_type == "street" then 
                street_areas:insert({
                    tags = object.tags,
                    geom = object:as_polygon()
                })
            elseif tmp_infrastructure_type == "pedestrian" then 
                pedestrian_areas:insert({
                    tags = object.tags,
                    geom = object:as_polygon()
                })
            elseif tmp_infrastructure_type == "horse" then 
                horse_areas:insert({
                    tags = object.tags,
                    geom = object:as_polygon()
                })
            elseif tmp_infrastructure_type == "cycleway" then 
                cycleway_areas:insert({
                    tags = object.tags,
                    geom = object:as_polygon()
                })
            else  
                uncategorized_areas:insert({
                    tags = object.tags,
                    geom = object:as_polygon()
                })
            end
        else
            if infrastructure_types.is_highway(object.tags) and not infrastructure_types.is_ignored(object.tags) then

                local tmp_infrastructure_type = infrastructure_types.get_infrastructure_type(object.tags)

                if tmp_infrastructure_type == "car" then
                    car_ways:insert({
                        tags = object.tags,
                        geom = object:as_linestring()
                    })
                elseif tmp_infrastructure_type == "street" then 
                    street_ways:insert({
                        tags = object.tags,
                        geom = object:as_linestring()
                    })
                elseif tmp_infrastructure_type == "pedestrian" then 
                    pedestrian_ways:insert({
                        tags = object.tags,
                        geom = object:as_linestring()
                    })
                elseif tmp_infrastructure_type == "horse" then 
                    horse_ways:insert({
                        tags = object.tags,
                        geom = object:as_linestring()
                    })
                elseif tmp_infrastructure_type == "cycleway" then 
                    cycleway_ways:insert({
                        tags = object.tags,
                        geom = object:as_linestring()
                    })
                else  
                    uncategorized_ways:insert({
                        tags = object.tags,
                        geom = object:as_linestring()
                    })
                end
            end            
        end
    end
end

function osm2pgsql.process_relation(object)
    if infrastructure_types.is_highway(object.tags) and not infrastructure_types.is_ignored(object.tags) then
        local tmp_infrastructure_type = infrastructure_types.get_infrastructure_type(object.tags)

        if tmp_infrastructure_type == "car" then
            car_areas:insert({
                tags = object.tags,
                geom = object:as_multipolygon()
            })
        elseif tmp_infrastructure_type == "street" then 
            street_areas:insert({
                tags = object.tags,
                geom = object:as_multipolygon()
            })
        elseif tmp_infrastructure_type == "pedestrian" then 
            pedestrian_areas:insert({
                tags = object.tags,
                geom = object:as_multipolygon()
            })
        elseif tmp_infrastructure_type == "horse" then 
            horse_areas:insert({
                tags = object.tags,
                geom = object:as_multipolygon()
            })
        elseif tmp_infrastructure_type == "cycleway" then 
            cycleway_areas:insert({
                tags = object.tags,
                geom = object:as_multipolygon()
            })
        else  
            uncategorized_areas:insert({
                tags = object.tags,
                geom = object:as_multipolygon()
            })
        end
    end
end
