-- Helper test function
function test(fn)
  local status, err = pcall(fn)
  if not status then
    print(err)
  end
end

local infrastructure_logic = dofile('./infrastructure_logic.lua')

-- bic_road

bicycle_road = {}
bicycle_road["bicycle_road"] = "yes" 

test(function ()
  assert(
    infrastructure_logic.get_infrastructure_type(bicycle_road, 'CH') == 'bic_road',
    "Infrastructure type should be bic_road")
end)

test(function ()
  assert(
    infrastructure_logic.get_infrastructure_type(bicycle_road, 'DE') == 'bic_road',
    "Infrastructure type should be bic_road")
end)

test(function ()
  assert(
    infrastructure_logic.get_infrastructure_type(bicycle_road, 'US') == 'bic_road',
    "Infrastructure type should be bic_road")
end)