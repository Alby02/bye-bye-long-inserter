-- data-final-fixes.lua

if not bye_bye_long_inserter or not bye_bye_long_inserter.removals then return end

-- Resolve any omitted new_ingredients by grabbing them from the craft ingredients 
-- of the removed inserter itself.
for inserter_name, removal_data in pairs(bye_bye_long_inserter.removals) do
    if not removal_data.new_ingredients then
        local recipe = data.raw.recipe[inserter_name]
        removal_data.new_ingredients = recipe and recipe.ingredients or {}
    end
end

-- Remove unlock-recipe effects from technologies
for _, tech in pairs(data.raw.technology) do
    if tech.effects then
        for i = #tech.effects, 1, -1 do
            local effect = tech.effects[i]
            if effect.type == "unlock-recipe" and bye_bye_long_inserter.removals[effect.recipe] then
                table.remove(tech.effects, i)
            end
        end
    end
end

-- Replace ingredients in all recipes
for _, recipe in pairs(data.raw.recipe) do
    local ingredients = recipe.ingredients
    if ingredients then
        local additions = {}
        
        -- Iterate backwards safely because we might remove elements
        for i = #ingredients, 1, -1 do
            local ingredient = ingredients[i]
            local removal_data = bye_bye_long_inserter.removals[ingredient.name]
            
            if removal_data then
                local multiplier = removal_data.use_amount_multiplier and ingredient.amount or 1
                
                -- Remove the original "long" inserter ingredient
                table.remove(ingredients, i)
                
                -- Queue the new replacement ingredients, scaled by the multiplier
                for _, new_ing in pairs(removal_data.new_ingredients) do
                    table.insert(additions, {
                        type = new_ing.type or "item",
                        name = new_ing.name,
                        amount = new_ing.amount * multiplier
                    })
                end
            end
        end
        
        -- Append our queued replacement ingredients
        for _, add in pairs(additions) do
            table.insert(ingredients, add)
        end
    end
end

-- Hide the removed inserters
for inserter_name, _ in pairs(bye_bye_long_inserter.removals) do
    if data.raw.recipe[inserter_name] then
        data.raw.recipe[inserter_name].hidden = true
        data.raw.recipe[inserter_name].enabled = false
    end
end
