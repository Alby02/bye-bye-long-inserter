-- data-updates.lua

local long_inserter_setting = settings.startup["long-inserter-setting"].value

local function remove_recipe_from_tech(recipe_name)
    for _, tech in pairs(data.raw.technology) do
        if tech.effects then
            for i = #tech.effects, 1, -1 do
                local effect = tech.effects[i]
                if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
                    table.remove(tech.effects, i)
                end
            end
        end
    end
end

local function modify_recipe_ingredients(old_ingredient, new_ingredients)
    for _, recipe in pairs(data.raw.recipe) do
        if recipe.ingredients then
            for i = #recipe.ingredients, 1, -1 do
                local ingredient = recipe.ingredients[i]
                if ingredient.name == old_ingredient then
                    -- Replace the old ingredient with the new ones
                    table.remove(recipe.ingredients, i)
                    for _, new_ingredient in pairs(new_ingredients) do
                        table.insert(recipe.ingredients, new_ingredient)
                    end
                end
            end
        end
    end
end

local function settings_remove ()
    -- Modify all the recipe requiring a long inserter to require a regular inserter a gear and 2 iron stick instead 

    modify_recipe_ingredients("long-handed-inserter", {
        {type = "item", name = "inserter", amount = 1},
        {type = "item", name = "iron-stick", amount = 2},
        {type = "item", name = "iron-gear-wheel", amount = 1}
    })   
end

local function settings_intermediet()
    -- Modify the long inserter to have the same length as a regular inserter
    local inserter = data.raw["inserter"]["inserter"]
    local fast_inserter = data.raw["inserter"]["fast-inserter"]
    local long_inserter = data.raw["inserter"]["long-handed-inserter"]

    if inserter and fast_inserter and long_inserter then
        long_inserter.rotation_speed = ( fast_inserter.rotation_speed + inserter.rotation_speed ) / 2
        long_inserter.extension_speed = ( fast_inserter.extension_speed + inserter.extension_speed ) / 2
        long_inserter.pickup_position = inserter.pickup_position
        long_inserter.insert_position = inserter.insert_position
        long_inserter.localised_name = {"item-name.quick-inserter"}
    end

    -- Modify all the recipe requiring a long inserter to require also a gear and 2 iron stick extra
    modify_recipe_ingredients("long-handed-inserter", {
        {type = "item", name = "long-handed-inserter", amount = 1},
        {type = "item", name = "iron-stick", amount = 2},
        {type = "item", name = "iron-gear-wheel", amount = 1}
    })

    -- Create a new technology that unlocks the better inserter
    data:extend({
        {
            type = "technology",
            name = "better-inserter",
            icon = "__bye-bye-long-inserter__/graphics/technology/quick-inserter.png",
            icon_size = data.raw.technology["automation"].icon_size,
            effects = {
                {
                    type = "unlock-recipe",
                    recipe = "long-handed-inserter"
                }
            },
            prerequisites = {"automation"},
            unit = {
                count = 20,
                ingredients = {
                    {"automation-science-pack", 1},
                },
                time = 15
            },
            order = "a-b-a"
        }
    })

    -- Modify the fast inserter tecnology to require a better inserter technology
    for _, tech in pairs(data.raw.technology) do
        if tech.effects then
            for i = #tech.effects, 1, -1 do
                if tech.effects[i].type == "unlock-recipe" and tech.effects[i].recipe == "fast-inserter" then
                    if not tech.prerequisites then
                        tech.prerequisites = {}
                    end
                    table.insert(tech.prerequisites, "better-inserter")
                end
            end
        end
    end

    -- Modify the fast inserter to require a long inserter instead of a regular inserter

    for i = #data.raw.recipe["fast-inserter"].ingredients, 1, -1 do
        if data.raw.recipe["fast-inserter"].ingredients[i].name == "inserter" then
            data.raw.recipe["fast-inserter"].ingredients[i].name = "long-handed-inserter"
        end
    end
end

-- Remove the long inserter from the technology that unlocks it
remove_recipe_from_tech("long-handed-inserter")

if long_inserter_setting == "remove" then
    settings_remove() 
elseif long_inserter_setting == "intermediate" then
    settings_intermediet()
end