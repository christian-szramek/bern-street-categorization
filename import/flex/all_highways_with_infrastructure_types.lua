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

local function create_tables_for_infrastructure_type(name)

    tables.nodes[name] = osm2pgsql.define_node_table(name .. '_nodes', {
        { column = 'tags', type = 'jsonb' },
        { column = 'geom', type = 'point', not_null = true }
    })

    tables.ways[name] = osm2pgsql.define_way_table(name .. '_ways', {
        { column = 'tags', type = 'jsonb' },
        { column = 'geom', type = 'linestring', not_null = true }
    })

    tables.areas[name] = osm2pgsql.define_area_table(name .. '_areas', {
        { column = 'tags', type = 'jsonb' },
        { column = 'geom', type = 'geometry', not_null = true }
    })
end

for _, entry in ipairs(infrastructure_types) do
    create_tables_for_infrastructure_type(entry.name)
end

function osm2pgsql.process_node(object)
    if infrastructure_logic.is_highway(object.tags) and not infrastructure_logic.is_ignored(object.tags) then

        local infrastructure_type = infrastructure_logic.get_infrastructure_type(object.tags)

        tables.nodes[infrastructure_type]:insert({
            tags = object.tags,
            geom = object:as_point()
        })
    end
end

function osm2pgsql.process_way(object)
    if infrastructure_logic.is_highway(object.tags) and not infrastructure_logic.is_ignored(object.tags) then

        local infrastructure_type = infrastructure_logic.get_infrastructure_type(object.tags)

        if infrastructure_logic.is_area(object.tags) then 
            tables.areas[infrastructure_type]:insert({
                tags = object.tags,
                geom = object:as_polygon()
            })
        else 
            tables.ways[infrastructure_type]:insert({
                tags = object.tags,
                geom = object:as_linestring()
            })
        end
    end
end

function osm2pgsql.process_relation(object)
    if infrastructure_logic.is_highway(object.tags) and not infrastructure_logic.is_ignored(object.tags) then

        local infrastructure_type = infrastructure_logic.get_infrastructure_type(object.tags)

        tables.areas[infrastructure_type]:insert({
            tags = object.tags,
            geom = object:as_multipolygon()
        })
    end
end
