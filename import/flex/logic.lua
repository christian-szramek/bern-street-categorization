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

function M.get_infrastructure_type(tags) 
    if tags.highway == 'pedestrian' or tags.highway == 'footway' or tags.highway == 'steps' or tags.highway == 'crossing' or (tags.highway == 'path' and (tags.sidewalk or tags.footway)) then
        return 'pedestrian'
    else
        return 'non_pedestrian'
    end
end

return M