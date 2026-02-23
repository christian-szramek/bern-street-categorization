local M = {}

function M.is_highway(tags)
    return tags.highway ~= nil
end

function M.is_area_highway(tags)
    return tags['area:highway'] ~= nil
end

function M.is_area(tags)
    return tags.area == 'yes'
end

function M.is_car(tags)
    return tags.highway == 'motorway' or tags.highway == 'motorway_link' or tags.highway == 'trunk' or tags.highway == 'trunk_link' or tags.highway == 'bus_guideway' or tags.highway == 'escape' or tags.highway == 'raceway' or tags.highway == 'busway' or tags.highway == 'motorway_junction'
end

function M.is_street(tags)
    return tags.highway == 'primary' or tags.highway == 'primary_link' or tags.highway == 'secondary' or tags.highway == 'secondary_link' or tags.highway == 'tertiary' or tags.highway == 'tertiary_link' or tags.highway == 'unclassified' or tags.highway == 'residential' or tags.highway == 'living_street' or tags.highway == 'service' or tags.highway == 'track' or tags.highway == 'mini_roundabout'
end

function M.is_pedestrian(tags)
    return tags.highway == 'pedestrian' or tags.highway == 'footway' or tags.highway == 'steps' or tags.highway == 'corridor' or tags.highway == 'via_ferrata' or tags.footway == 'sidewalk' or tags.footway == 'sidewalk' or tags.footway == 'crossing' or tags.footway == 'trafic_island' or tags.highway == 'elevator' or tags.highway == 'ladder'
end

function M.is_bridleway(tags)
    return tags.highway == 'bridleway'
end

function M.is_cycleway(tags) 
    return tags.highway == 'cycleway'
end

function M.is_ignored(tags)
    return tags.highway == 'bus_stop' or tags.highway == 'cyclist_waiting_aid' or tags.highway == 'emergency_bay' or tags.highway == 'emergency_access_point' or tags.highway == 'give_way' or tags.emergency_phone ~= nil or tags.highway == 'hitchhiking' or tags.highway == 'milestone' or tags.highway == 'passing_place' or tags.highway == 'platform' or tags.highway == 'rest_area' or tags.highway == 'services'  or tags.highway == 'speed_camera' or tags.highway == 'speed_display' or tags.highway == 'stop' or tags.highway == 'street_lamp' or tags.highway == 'toll_gantry' or tags.highway == 'traffic_mirror' or tags.highway == 'traffic_signals' or tags.highway == 'trailhead' or tags.highway == 'turning_circle'
end

function M.is_foot_allowed(tags)
    return tags.foot == 'yes' or tags.foot == 'designated'
end

function M.is_moped_allowed(tags)
    return tags.moped == 'yes' or tags.moped == 'designated'
end

function M.is_mofa_allowed(tags)
    return tags.mofa == 'yes' or tags.mofa == 'designated'
end

function M.is_bicycle_allowed(tags)
    return tags.bicycle == 'yes'
end

function M.is_oneway(tags)
    return tags.oneway ~= nil and tags.oneway ~= 'no' 
end

function M.get_infrastructure_type(tags) 
    if M.is_car(tags) then 
        return 'car'
    elseif M.is_street(tags) then
        if M.is_oneway(tags) then
            return 'one-way_street'
        else 
            return 'two-way_street'
        end
    elseif M.is_pedestrian(tags) then
        if M.is_bicycle_allowed(tags) then
            return 'pedestrian_with_cycling_allowed'
        else
            return 'pedestrian'
        end
    elseif M.is_bridleway(tags) then
        return 'bridleway'
    elseif M.is_cycleway(tags) then
        if M.is_foot_allowed(tags) or M.is_moped_allowed(tags) or M.is_mofa_allowed(tags) then
            return 'cycleway_multiuse'
        else
            return 'cycleway'
        end
    else
        return 'uncategorized'
    end
end

return M