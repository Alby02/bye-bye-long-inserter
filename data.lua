-- data.lua

if not bye_bye_long_inserter then bye_bye_long_inserter = {} end

-- A table to hold all registered inserter removals
bye_bye_long_inserter.removals = {}

--[[
    Registers an inserter to be removed from technologies and replaced in recipes.
    
    @param inserter_name: The internal prototype name of the inserter to remove
    @param main_recipes: The name (or list of names) of the primary recipes used to craft the inserter.
    @param new_ingredients: (Optional) Ingredients list to swap when replacing this inserter in other recipes. 
                            If nil, will default to the craft ingredients of the removed inserter.
    @param use_amount_multiplier: (Optional) If true, multiplies the replacement ingredients by the amount 
                                  of the removed inserter used in a recipe. Defaults to true.
]]
function bye_bye_long_inserter.remove_inserter(inserter_name, main_recipes, new_ingredients, use_amount_multiplier)
    if type(main_recipes) == "string" then main_recipes = {main_recipes} end
    if not main_recipes then main_recipes = {inserter_name} end
    
    bye_bye_long_inserter.removals[inserter_name] = {
        main_recipes = main_recipes,
        new_ingredients = new_ingredients,
        use_amount_multiplier = (use_amount_multiplier == nil) and true or use_amount_multiplier
    }
end

-- Load compatibility files
require("compatibility.vanilla")
require("compatibility.krastorio2")
require("compatibility.factorioplus")


