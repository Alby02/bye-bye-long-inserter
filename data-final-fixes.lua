-- data-final-fixes.lua

if not bye_bye_long_inserter then return end
if not bye_bye_long_inserter.removals then return end

local function remove_recipe_from_tech(recipe_name)
    for _, tech in pairs(data.raw.technology) do
        if tech.effects then
            for i = #tech.effects, 1, -1 do
                local effect = tech.effects[i]
                if (effect.type == "unlock-recipe" and effect.recipe == recipe_name) then
                    table.remove(tech.effects, i)
                end
            end
        end
    end
end

local function modify_recipe_ingredients(old_ingredient, new_ingredients)
    for _, recipe in pairs(data.raw.recipe) do
        if recipe.ingredients then
            -- Note: this only works for recipes with explicit ingredients arrays.
            -- Normal/expensive split recipes need to be handled if present.
            local changed = false
            for i = #recipe.ingredients, 1, -1 do
                local ingredient = recipe.ingredients[i]
                local name = ingredient.name or ingredient[1]
                if name == old_ingredient then
                    table.remove(recipe.ingredients, i)
                    changed = true
                end
            end
            
            if changed then
                for _, new_ingredient in pairs(new_ingredients) do
                    -- Check if format is {name="iron-plate", amount=1} or {"iron-plate", 1}
                    if new_ingredient.name then
                        table.insert(recipe.ingredients, {type = new_ingredient.type or "item", name = new_ingredient.name, amount = new_ingredient.amount})
                    else
                        table.insert(recipe.ingredients, {new_ingredient[1], new_ingredient[2]})
                    end
                end
            end
        end
        
        -- Handle normal/expensive split
        for _, diff in pairs({"normal", "expensive"}) do
            if recipe[diff] and recipe[diff].ingredients then
                local changed = false
                for i = #recipe[diff].ingredients, 1, -1 do
                    local ingredient = recipe[diff].ingredients[i]
                    local name = ingredient.name or ingredient[1]
                    if name == old_ingredient then
                        table.remove(recipe[diff].ingredients, i)
                        changed = true
                    end
                end
                
                if changed then
                    for _, new_ingredient in pairs(new_ingredients) do
                        if new_ingredient.name then
                            table.insert(recipe[diff].ingredients, {type = new_ingredient.type or "item", name = new_ingredient.name, amount = new_ingredient.amount})
                        else
                            table.insert(recipe[diff].ingredients, {new_ingredient[1], new_ingredient[2]})
                        end
                    end
                end
            end
        end
    end
end

-- Process all registered removals
for inserter_name, new_ingredients in pairs(bye_bye_long_inserter.removals) do
    remove_recipe_from_tech(inserter_name)
    modify_recipe_ingredients(inserter_name, new_ingredients)
    
    -- Also remove the recipe itself if it exists, or just hide it
    if data.raw.recipe[inserter_name] then
        data.raw.recipe[inserter_name].hidden = true
        data.raw.recipe[inserter_name].enabled = false
    end
end
