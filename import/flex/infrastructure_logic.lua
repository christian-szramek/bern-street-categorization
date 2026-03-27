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

function M.is_car(tags, restriction)
    if (restriction == 'CH') then
        return tags.highway == 'motorway' or tags.highway == 'motorway_link' or tags.highway == 'trunk' or tags.highway == 'trunk_link' or tags.highway == 'bus_guideway' or tags.highway == 'busway'
    else
        return tags.highway == 'motorway' or tags.highway == 'motorway_link' or tags.highway == 'bus_guideway' or tags.highway == 'busway'
    end
end

function M.is_street(tags, restriction)
    if (restriction == 'CH') then
        return tags.highway == 'primary' or tags.highway == 'primary_link' or tags.highway == 'secondary' or tags.highway == 'secondary_link' or tags.highway == 'tertiary' or tags.highway == 'tertiary_link' or tags.highway == 'unclassified' or tags.highway == 'residential' or tags.highway == 'living_street' or tags.highway == 'service' or tags.highway == 'track'
    else 
        return tags.highway == 'trunk' or tags.highway == 'trunk_link' or tags.highway == 'primary' or tags.highway == 'primary_link' or tags.highway == 'secondary' or tags.highway == 'secondary_link' or tags.highway == 'tertiary' or tags.highway == 'tertiary_link' or tags.highway == 'unclassified' or tags.highway == 'residential' or tags.highway == 'living_street' or tags.highway == 'service' or tags.highway == 'track'

    end
end

function M.is_pedestrian(tags)
    return tags.highway == 'pedestrian' or tags.highway == 'footway' or tags.highway == 'steps' or tags.footway == 'sidewalk' or tags.footway == 'crossing' or tags.footway == 'traffic_island'
end

function M.is_cycleway(tags) 
    return tags.highway == 'cycleway' and tags.cycleway ~= 'sidepath'
end

function M.is_bicycle_road(tags)
    return tags.bicycle_road == 'yes'
end

function M.is_ignored(tags)
    return tags.highway == 'traffic_sign' or tags.highway == 'via_ferrata' or tags.highway == 'proposed' or tags.highway == 'construction' or tags.highway == 'mini_roundabout' or tags.highway == 'escape' or tags.highway == 'raceway' or tags.highway == 'elevator' or tags.highway == 'ladder' or tags.highway == 'corridor' or tags.highway == 'motorway_junction' or tags.highway == 'bus_stop' or tags.highway == 'emergency_bay' or tags.highway == 'emergency_access_point' or tags.highway == 'give_way' or tags.emergency_phone ~= nil or tags.highway == 'hitchhiking' or tags.highway == 'milestone' or tags.highway == 'passing_place' or tags.highway == 'platform' or tags.highway == 'rest_area' or tags.highway == 'services'  or tags.highway == 'speed_camera' or tags.highway == 'speed_display' or tags.highway == 'stop' or tags.highway == 'street_lamp' or tags.highway == 'toll_gantry' or tags.highway == 'traffic_mirror' or tags.highway == 'traffic_signals' or tags.highway == 'trailhead' or tags.highway == 'turning_circle'
end

function M.is_foot_allowed(tags)
    return tags.foot == 'yes' or tags.foot == 'designated' or tags.foot == 'permissive'
end

function M.is_moped_allowed(tags)
    return tags.moped == 'yes' or tags.moped == 'designated'
end

function M.is_mofa_allowed(tags)
    return tags.mofa == 'yes' or tags.mofa == 'designated'
end

function M.is_bicycle_allowed(tags)
    return tags.bicycle == 'yes' or tags.bicycle == 'designated' or tags.bicycle == 'permissive'
end

function M.is_motor_vehicle_allowed(tags)
    return tags.motor_vehicle == 'yes' or tags.motor_vehicle == 'permissive'
end

function M.is_foot_forbidden(tags)
    return tags.foot == 'no'
end

function M.is_bicycle_forbidden(tags)
    return tags.bicycle == 'no'
end

function M.is_horse_forbidden(tags)
    return tags.horse == 'no'
end

function M.is_motor_vehicle_forbidden(tags)
    return tags.motor_vehicle == 'no'
end

function M.is_oneway(tags)
    return tags.oneway == 'yes' or tags.oneway == 'true' or tags.oneway == '1' or tags.oneway == '-1' or tags.oneway == 'reverse' or tags.oneway == 'reversible' or tags.oneway == 'alternating'
end

function M.is_street_with_bus_bicycle_lane(tags)
    return tags.cycleway == 'lane' or tags['cycleway:both'] == 'lane' or tags['cycleway:left'] == 'lane' or tags['cycleway:right'] == 'lane' or tags.cycleway == 'share_busway' or tags['cycleway:both'] == 'share_busway' or tags['cycleway:left'] == 'share_busway' or tags['cycleway:right'] == 'share_busway'
end

function M.is_street_with_separate_bicycle_lane_on_sidepath(tags)
    return tags.cycleway == 'track' or tags['cycleway:both'] == 'track' or tags['cycleway:left'] == 'track' or tags['cycleway:right'] == 'track' or tags.cycleway == 'separate' or tags['cycleway:both'] == 'separate' or tags['cycleway:left'] == 'separate' or tags['cycleway:right'] == 'separate'
end

function M.is_street_with_shared_bicycle_lane_on_carriageway(tags)
    return tags.cycleway == 'shared_lane' or tags['cycleway:both'] == 'shared_lane' or tags['cycleway:left'] == 'shared_lane' or tags['cycleway:right'] == 'shared_lane'
end

function M.is_extra_marked_separate_bicycle_lane_on_sidepath(tags)
    return ( tags.highway == 'cycleway' and tags.cycleway == 'sidepath' ) or ( tags.highway == 'path' and ( tags.path == 'sidepath' or tags.is_sidepath == 'yes' ) and tags.bicycle == 'designated' )
end

function M.is_path(tags)
    return tags.highway == 'path'
end

function M.is_pedestrian_only_path(tags)
    return M.is_foot_allowed(tags) and ( tags.bicycle == nil or M.is_bicycle_forbidden(tags)) and ( tags.horse == nil or M.is_horse_forbidden(tags) ) and ( tags.motor_vehicle == nil or M.is_motor_vehicle_forbidden(tags) )
end

function M.is_pedestrian_path_with_bicycle_allowed(tags)
    return M.is_foot_allowed(tags) and M.is_bicycle_allowed(tags) and tags.bicycle ~= 'designated' and ( tags.horse == nil or M.is_horse_forbidden(tags) ) and ( tags.motor_vehicle == nil or M.is_motor_vehicle_forbidden(tags) )
end

function M.is_bicycle_only_path(tags)
    return M.is_bicycle_allowed(tags) and ( tags.foot == nil or M.is_foot_forbidden(tags) ) and ( tags.horse == nil or M.is_horse_forbidden(tags) ) and ( tags.motor_vehicle == nil or M.is_motor_vehicle_forbidden(tags) )
end

function M.is_bicycle_path_with_pedestrian_or_mofa_or_moped_allowed(tags) 
    return M.is_bicycle_allowed(tags) and M.is_foot_allowed(tags) and ( tags.horse == nil or M.is_horse_forbidden(tags) ) and ( tags.motor_vehicle == nil or M.is_motor_vehicle_allowed(tags) )
end

function M.is_cycleway_both_sides(tags)
    if tags.oneway == 'yes' then
        return ( tags['cycleway:both'] ~= nil and tags['cycleway:both'] ~= "no" ) or ( tags['cycleway:left'] ~= nil and tags['cycleway:right'] ~= nil and tags['cycleway:left'] ~= 'no' and tags['cycleway:right'] ~= 'no' )
    else 
        return (tags.cycleway ~= nil) or  ( tags['cycleway:both'] ~= nil and tags['cycleway:both'] ~= "no" ) or ( tags['cycleway:left'] ~= nil and tags['cycleway:right'] ~= nil and tags['cycleway:left'] ~= 'no' and tags['cycleway:right'] ~= 'no' )
    end
    
end

function M.is_cyclist_waiting_aid(tags)
    return tags.highway == 'cyclist_waiting_aid'
end

function M.is_bus_bicycle_lane_on_one_side_and_separate_bicycle_lane_on_sidepath(tags)
    return M.is_street_with_bus_bicycle_lane(tags) and M.is_street_with_separate_bicycle_lane_on_sidepath(tags)
end

function M.is_crossing(tags)
    return tags.highway == 'crossing'
end

function M.get_lanes(tags)
    if (tags.lanes == '1') then 
        return '1'
    elseif (tags.lanes == '2') then 
        return '2'
    elseif (tags.lanes == '3') then 
        return '3'
    elseif (tags.lanes == '4') then 
        return '4'
    elseif (tags.lanes == '5') then 
        return '5'
    elseif (tags.lanes == '6') then 
        return '6'
    elseif (tags.lanes == '7') then 
        return '7'
    elseif (tags.lanes == '8') then 
        return '8'
    elseif (tags.lanes == '9') then 
        return '9'
    elseif (tags.lanes == '10') then 
        return '10'
    else 
        if (tags['lanes:forward'] ~= nil and tags['lanes:backward'] ~= nil) then
            lanes = tonumber(tags['lanes:forward']) + tonumber(tags['lanes:backward'])
            return tostring(lanes)
        else
            return '1'
        end
    end
end

function M.get_infrastructure_type(tags, restriction)
    if M.is_bicycle_road(tags) then
        return 'bic_road'
    elseif M.is_car(tags, restriction) then 
        return M.get_lanes(tags) .. '_l_s_with_bic_forbidden'
    elseif M.is_street(tags, restriction) then
        if M.is_oneway(tags) then 
            if M.is_street_with_bus_bicycle_lane(tags) then
                if M.is_cycleway_both_sides(tags) then
                    if M.is_bus_bicycle_lane_on_one_side_and_separate_bicycle_lane_on_sidepath(tags) then
                        return M.get_lanes(tags) .. '_l_ows_with_bus_bic_and_sep_bic_on_sp'
                    else
                        return M.get_lanes(tags) .. '_l_ows_with_bus_bic_lane_on_both_sides'
                    end
                else
                    return M.get_lanes(tags) .. '_l_ows_with_bus_bic_lane_on_one_side'
                end
            elseif M.is_street_with_separate_bicycle_lane_on_sidepath(tags) then
                return M.get_lanes(tags) .. '_l_ows_with_sep_bic_lane_on_sp'
            else
                return M.get_lanes(tags) .. '_l_ows_with_no_bic_paths'
            end
        else
            if M.is_street_with_bus_bicycle_lane(tags) then
                if M.is_cycleway_both_sides(tags) then
                    if M.is_bus_bicycle_lane_on_one_side_and_separate_bicycle_lane_on_sidepath(tags) then
                        return M.get_lanes(tags) .. '_l_s_with_bus_bic_and_sep_bic_on_sp'
                    else
                        return M.get_lanes(tags) .. '_l_s_with_bus_bic_lane_on_both_sides'
                    end
                else
                    return M.get_lanes(tags) .. '_l_s_with_bus_bic_lane_on_one_side'
                end
            elseif M.is_street_with_separate_bicycle_lane_on_sidepath(tags) then
                return M.get_lanes(tags) .. '_l_s_with_sep_bic_lane_on_sp'
            elseif M.is_street_with_shared_bicycle_lane_on_carriageway(tags) then 
                return M.get_lanes(tags) ..  '_l_s_with_shared_bic_lane_on_carriageway'
            else            
                return M.get_lanes(tags) .. '_l_s_with_no_bic_paths'
            end
        end
    elseif M.is_extra_marked_separate_bicycle_lane_on_sidepath(tags) then
        return 'sep_bic_lane_on_sp'
    elseif M.is_pedestrian(tags) then
        if M.is_bicycle_allowed(tags) or restriction == 'US' then
            return 'pedestrian_with_bic_allowed'
        else
            return 'pedestrian'
        end
    elseif M.is_cycleway(tags) then
        if tags.cycleway == 'sidepath' or tags.is_sidepath == 'yes' then
            return 'sep_bic_lane_on_sp'
        else
            if M.is_foot_allowed(tags) or M.is_moped_allowed(tags) or M.is_mofa_allowed(tags) then
                return 'cycleway_multiuse'
            else
                return 'cycleway'
            end
        end
    elseif M.is_path(tags) then
        if M.is_pedestrian_only_path(tags) then
            return 'pedestrian'
        elseif M.is_pedestrian_path_with_bicycle_allowed(tags) then
            return 'pedestrian_with_bic_allowed'
        elseif M.is_bicycle_only_path(tags) then 
            return 'cycleway'
        elseif M.is_bicycle_path_with_pedestrian_or_mofa_or_moped_allowed(tags) then
            return 'cycleway_multiuse'
        elseif M.is_bicycle_forbidden(tags) then
            return 'path_with_bic_forbidden'
        else
            return 'uncategorized'
        end
    elseif M.is_cyclist_waiting_aid(tags) then
        return 'cyclist_waiting_aid'
    elseif M.is_crossing(tags) then
        return 'crossing'
    else
        return 'uncategorized'
    end
end

return M