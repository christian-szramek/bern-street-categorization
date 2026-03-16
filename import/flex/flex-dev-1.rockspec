package = "flex"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/christian-szramek/bern-street-categorization.git"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
dependencies = {
   "lua >= 5.1, < 5.5"
}
build = {
   type = "builtin",
   modules = {
      all_highways_with_infrastructure_types = "all_highways_with_infrastructure_types.lua",
      infrastructure_logic = "infrastructure_logic.lua",
      infrastructure_types = "infrastructure_types.lua",
      ["test.all_highways_without_infrastructure_types"] = "test/all_highways_without_infrastructure_types.lua",
      ["test.only_area_highway"] = "test/only_area_highway.lua",
      ["test.only_ignored_highways"] = "test/only_ignored_highways.lua"
   }
}
