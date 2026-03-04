print('osm2pgsql version: ' .. osm2pgsql.version)

local restrictions = os.getenv("RESTRICTIONS")

if restrictions then
    print("Use restrictions according to:", restrictions)
else
    error("Environment variable RESTRICTIONS is not set!")
end

local infrastructure_logic = dofile('./import/flex/infrastructure_logic.lua')
local infrastructure_types = dofile('./import/flex/infrastructure_types.lua')

local tables = {
    nodes = {},
    ways = {},
    areas = {}
}

local function create_tables_for_infrastructure_type(name, area, node)

    if (node) then
        tables.nodes[name] = osm2pgsql.define_node_table(name .. '_nodes', {
            { column = 'tags', type = 'jsonb' },
            { column = 'geom', type = 'point', not_null = true }
        })
    end

    tables.ways[name] = osm2pgsql.define_way_table(name .. '_ways', {
        { column = 'tags', type = 'jsonb' },
        { column = 'geom', type = 'linestring', not_null = true }
    })

    if (area) then
        tables.areas[name] = osm2pgsql.define_area_table(name .. '_areas', {
            { column = 'tags', type = 'jsonb' },
            { column = 'geom', type = 'geometry', not_null = true }
        })
    end
end

for _, entry in ipairs(infrastructure_types) do
    create_tables_for_infrastructure_type(entry.name, entry.area, entry.node)
end

function osm2pgsql.process_node(object)
    if infrastructure_logic.is_highway(object.tags) and not infrastructure_logic.is_ignored(object.tags) then

        local infrastructure_type = infrastructure_logic.get_infrastructure_type(object.tags)
        local target_table = tables.nodes[infrastructure_type]

        if target_table then
            target_table:insert({
                tags = object.tags,
                geom = object:as_point()
            })
        else
            print("Node table does not exist for infrastructure type: " .. tostring(infrastructure_type))
            print("Feature tags:")
            for k, v in pairs(object.tags) do
                print("  " .. k .. " = " .. v)
            end
        end
    end
end

function osm2pgsql.process_way(object)
    if infrastructure_logic.is_highway(object.tags) and not infrastructure_logic.is_ignored(object.tags) then

        local infrastructure_type = infrastructure_logic.get_infrastructure_type(object.tags)


        if infrastructure_logic.is_area(object.tags) then
            local target_table = tables.areas[infrastructure_type]

            if target_table then 
                tables.areas[infrastructure_type]:insert({
                    tags = object.tags,
                    geom = object:as_polygon()
                })
            else 
                print("Area table does not exist for infrastructure type: " .. tostring(infrastructure_type))
                print("Feature tags:")
                for k, v in pairs(object.tags) do
                    print("  " .. k .. " = " .. v)
                end
            end
        else 
            local target_table = tables.ways[infrastructure_type]

            if target_table then
                tables.ways[infrastructure_type]:insert({
                    tags = object.tags,
                    geom = object:as_linestring()
                })
            else
                print("Way table does not exist for infrastructure type: " .. tostring(infrastructure_type))
                print("Feature tags:")
                for k, v in pairs(object.tags) do
                    print("  " .. k .. " = " .. v)
                end
            end
        end
    end
end

function osm2pgsql.process_relation(object)
    if infrastructure_logic.is_highway(object.tags) and not infrastructure_logic.is_ignored(object.tags) then

        local infrastructure_type = infrastructure_logic.get_infrastructure_type(object.tags)
        local target_table = tables.ways[infrastructure_type]

        if target_table then 
            tables.areas[infrastructure_type]:insert({
                tags = object.tags,
                geom = object:as_multipolygon()
            })
        else 
            print("Area table does not exist for infrastructure type: " .. tostring(infrastructure_type))
            print("Feature tags:")
            for k, v in pairs(object.tags) do
                print("  " .. k .. " = " .. v)
            end
        end
    end
end
