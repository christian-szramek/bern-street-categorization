print('osm2pgsql version: ' .. osm2pgsql.version)

local infrastructure_logic = dofile('./import/flex/infrastructure_logic.lua')
local infrastructure_types = dofile('./import/flex/infrastructure_types.lua')
local restriction = os.getenv("RESTRICTION")

if restriction then
    if not (restriction == 'CH' or restriction == 'DE' or restriction == 'US') then
        error("Unknown restriction: " .. restriction .. ". Set it to CH, DE or US.")
    end

    print("Use restriction according to:", restriction)
else
    error("Environment variable RESTRICTION is not set!")
end

local tables = {
    nodes = {},
    ways = {},
    areas = {}
}

local function create_tables_for_infrastructure_type(name, area, node, displayName)

    if (node) then
        tables.nodes[name] = osm2pgsql.define_node_table(name .. '_nodes', {
            { column = 'tags', type = 'jsonb' },
            { column = 'geom', type = 'point', not_null = true },
            { column = 'displayName', type = 'text' }
        })
    end

    tables.ways[name] = osm2pgsql.define_way_table(name .. '_ways', {
        { column = 'tags', type = 'jsonb' },
        { column = 'geom', type = 'linestring', not_null = true },
        { column = 'displayName', type = 'text' }
    })

    if (area) then
        tables.areas[name] = osm2pgsql.define_area_table(name .. '_areas', {
            { column = 'tags', type = 'jsonb' },
            { column = 'geom', type = 'geometry', not_null = true },
            { column = 'displayName', type = 'text' }
        })
    end
end

local function get_display_name(name)
    for _, entry in ipairs(infrastructure_types) do
        if entry.name == name then
            return entry.displayName
        end
    end
    return nil
end

local function print_feature_tags(tags) 
    print("Feature tags:")

    for k, v in pairs(tags) do
        print("  " .. k .. " = " .. v)
    end
end

for _, entry in ipairs(infrastructure_types) do
    create_tables_for_infrastructure_type(entry.name, entry.area, entry.node, entry.displayName)
end

function osm2pgsql.process_node(object)
    if infrastructure_logic.is_highway(object.tags) and not infrastructure_logic.is_ignored(object.tags) then

        local infrastructure_type = infrastructure_logic.get_infrastructure_type(object.tags, restriction)
        local display_name = get_display_name(infrastructure_type)
        local target_table = tables.nodes[infrastructure_type]

        if target_table then
            target_table:insert({
                tags = object.tags,
                geom = object:as_point(),
                displayName = display_name 
            })
        else
            print("Node table does not exist for infrastructure type: " .. tostring(infrastructure_type))
            print_feature_tags(object.tags)
        end
    end
end

function osm2pgsql.process_way(object)
    if infrastructure_logic.is_highway(object.tags) and not infrastructure_logic.is_ignored(object.tags) then

        local infrastructure_type = infrastructure_logic.get_infrastructure_type(object.tags, restriction)
        local display_name = get_display_name(infrastructure_type)

        if infrastructure_logic.is_area(object.tags) then
            local target_table = tables.areas[infrastructure_type]

            if target_table then 
                tables.areas[infrastructure_type]:insert({
                    tags = object.tags,
                    geom = object:as_polygon(),
                    displayName = display_name 
                })
            else 
                print("Area table does not exist for infrastructure type: " .. tostring(infrastructure_type))
                print_feature_tags(object.tags)
            end
        else 
            local target_table = tables.ways[infrastructure_type]

            if target_table then
                tables.ways[infrastructure_type]:insert({
                    tags = object.tags,
                    geom = object:as_linestring(),
                    displayName = display_name 
                })
            else
                print("Way table does not exist for infrastructure type: " .. tostring(infrastructure_type))
                print_feature_tags(object.tags)
            end
        end
    end
end

function osm2pgsql.process_relation(object)
    if infrastructure_logic.is_highway(object.tags) and not infrastructure_logic.is_ignored(object.tags) then

        local infrastructure_type = infrastructure_logic.get_infrastructure_type(object.tags, restriction)
        local display_name = get_display_name(infrastructure_type)
        local target_table = tables.ways[infrastructure_type]

        if target_table then 
            tables.areas[infrastructure_type]:insert({
                tags = object.tags,
                geom = object:as_multipolygon(),
                displayName = display_name 
            })
        else 
            print("Area table does not exist for infrastructure type: " .. tostring(infrastructure_type))
            print_feature_tags(object.tags)
        end
    end
end
