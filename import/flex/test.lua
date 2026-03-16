local lxp = require("lxp")
local infrastructure_logic = dofile('./infrastructure_logic.lua')

-- Helper test function

function load_osm_tags(xml_path)
    local tags = {}

    local callbacks = {}

    function callbacks.StartElement(parser, name, attr)
        if name == "tag" and attr.k and attr.v then
            tags[attr.k] = attr.v
        end
    end

    local p = lxp.new(callbacks)

    for line in io.lines(xml_path) do
        p:parse(line)
    end

    p:parse()  -- finalize parsing
    p:close()

    return tags
end

function test(fn)
    local status, err = pcall(fn)
        if not status then
            print(err)
    end
end

function print_feature(feature)
    for k,v in pairs(feature) do 
        print(k, v) 
    end
end

function execute_test(feature_path, restriction, expected_infrastructure_type)
    local feature_tags = load_osm_tags(feature_path)

    local actual_infrastructure_type = infrastructure_logic.get_infrastructure_type(feature_tags, restriction)

    if actual_infrastructure_type ~= expected_infrastructure_type then
        print('Test failed for feature: ')
        print('-------------------------------------------------')
        print_feature(feature_tags)
        print('-------------------------------------------------')
    end
    
    test(function ()
        assert(
            expected_infrastructure_type == actual_infrastructure_type,
            'Infrastructure type should be: ' .. expected_infrastructure_type .. ' for restriction: ' .. restriction .. ', but was: ' .. actual_infrastructure_type)
    end)
end

function execute_all_tests_for_city(city, restriction)
    local directory = "./test_data/" .. city 

    for file in io.popen('ls "' .. directory .. '"'):lines() do
        if file:match("%.xml$") then
            local name = file:gsub("%.xml$", "")
            name = name:gsub("_%d+$", "")

            local path = directory .. "/" .. file

            execute_test(path, restriction, name)
        end
    end
end

-- Tests for Bern

-- Tests for Berlin
execute_all_tests_for_city('berlin', 'DE')

