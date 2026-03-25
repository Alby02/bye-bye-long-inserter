-- data.lua

if not bye_bye_long_inserter then bye_bye_long_inserter = {} end

-- A table to hold all registered inserter removals
bye_bye_long_inserter.removals = {}

--[[
    Registers an inserter to be removed from technologies and replaced in recipes.
    
    @param inserter_name: The internal prototype name of the inserter to remove
    @param new_ingredients: Ingredients list to swap when replacing this inserter in other recipes
]]
function bye_bye_long_inserter.remove_inserter(inserter_name, new_ingredients)
    bye_bye_long_inserter.removals[inserter_name] = new_ingredients
end

-- Load compatibility files
require("compatibility.vanilla")
require("compatibility.krastorio2")
require("compatibility.factorio-plus-plus")
