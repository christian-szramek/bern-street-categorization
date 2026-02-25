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

function M.is_street_or_way_with_cycling_forbidden(tags)
    return tags.highway == 'motorway' or tags.highway == 'motorway_link' or tags.highway == 'trunk' or tags.highway == 'trunk_link' or tags.highway == 'bus_guideway' or tags.highway == 'escape' or tags.highway == 'raceway' or tags.highway == 'busway' or tags.bicycle == 'no'
end

function M.is_street(tags)
    return tags.highway == 'primary' or tags.highway == 'primary_link' or tags.highway == 'secondary' or tags.highway == 'secondary_link' or tags.highway == 'tertiary' or tags.highway == 'tertiary_link' or tags.highway == 'unclassified' or tags.highway == 'residential' or tags.highway == 'living_street' or tags.highway == 'service' or tags.highway == 'track' or tags.highway == 'mini_roundabout'
end

function M.is_pedestrian(tags)
    return tags.highway == 'pedestrian' or tags.highway == 'footway' or tags.highway == 'steps' or tags.highway == 'via_ferrata' or tags.footway == 'sidewalk' or tags.footway == 'crossing' or tags.footway == 'traffic_island'
end

function M.is_bridleway(tags)
    return tags.highway == 'bridleway'
end

function M.is_cycleway(tags) 
    return tags.highway == 'cycleway' and tags.cycleway ~= 'sidepath'
end

function M.is_cycleroad(tags)
    return tags.bicycle_road == 'yes'
end

function M.is_ignored(tags)
    return tags.highway == 'elevator' or tags.highway == 'ladder' or tags.highway == 'corridor' or tags.highway == 'motorway_junction' or tags.highway == 'bus_stop' or tags.highway == 'cyclist_waiting_aid' or tags.highway == 'emergency_bay' or tags.highway == 'emergency_access_point' or tags.highway == 'give_way' or tags.emergency_phone ~= nil or tags.highway == 'hitchhiking' or tags.highway == 'milestone' or tags.highway == 'passing_place' or tags.highway == 'platform' or tags.highway == 'rest_area' or tags.highway == 'services'  or tags.highway == 'speed_camera' or tags.highway == 'speed_display' or tags.highway == 'stop' or tags.highway == 'street_lamp' or tags.highway == 'toll_gantry' or tags.highway == 'traffic_mirror' or tags.highway == 'traffic_signals' or tags.highway == 'trailhead' or tags.highway == 'turning_circle'
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
    return tags.oneway == 'yes' or tags.oneway == 'true' or tags.oneway == '1' or tags.oneway == '-1' or tags.oneway == 'reverse' or tags.oneway == 'reversible' or tags.oneway == 'alternating'
end

function M.is_street_with_separate_cycling_or_bus_lane(tags)
    return tags.cycleway == 'lane' or tags['cycleway:both'] == 'lane' or tags['cycleway:left'] == 'lane' or tags['cycleway:right'] == 'lane' or tags.cycleway == 'share_busway'
end

function M.is_street_with_separate_cycling_lane_on_sidewalk(tags)
    return tags.cycleway == 'track' or tags['cycleway:both'] == 'track' or tags['cycleway:left'] == 'track' or tags['cycleway:right'] == 'track' or tags.cycleway == 'separate' or tags['cycleway:both'] == 'separate' or tags['cycleway:left'] == 'separate' or tags['cycleway:right'] == 'separate'
end

function M.is_street_with_shared_cycling_lane_on_carriageway(tags)
    return tags.cycleway == 'shared_lane'
end

function M.is_extra_marked_separate_cycling_lane_on_sidewalk(tags)
    return ( tags.highway == 'cycleway' and tags.cycleway == 'sidepath' ) or ( tags.highway == 'path' and tags.path == 'sidepath'  and tags.bicycle == 'designated' )
end

function M.get_infrastructure_type(tags) 
    if M.is_street_or_way_with_cycling_forbidden(tags) then 
        return 'street_or_way_with_cycling_forbidden'
    elseif M.is_cycleroad(tags) then
        return 'cycleroad'
    elseif M.is_street(tags) then
        if M.is_oneway(tags) then
            return 'one-way_street'
        else 
            if M.is_street_with_separate_cycling_or_bus_lane(tags) then
                return 'street_with_separate_cycling_or_bus_lane'
            elseif M.is_street_with_separate_cycling_lane_on_sidewalk(tags) then
                return 'street_with_separate_cycling_lane_on_sidewalk'
            elseif M.is_street_with_shared_cycling_lane_on_carriageway(tags) then 
                return 'street_with_shared_cycling_lane_on_carriageway'
            else 
                return 'street_without_cycling_infrastructure'
            end
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
    elseif M.is_extra_marked_separate_cycling_lane_on_sidewalk(tags) then
        return 'separate_cycling_lane_on_sidewalk'
    else
        return 'uncategorized'
    end
end

return M