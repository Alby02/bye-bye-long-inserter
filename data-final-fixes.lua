-- data-final-fixes.lua

if not bye_bye_long_inserter or not bye_bye_long_inserter.removals then return end

-- Helper to safely get ingredients from a recipe
local function get_recipe_ingredients(recipe_name)
    local recipe = data.raw.recipe[recipe_name]
    if not recipe then return nil end
    -- First check root ingredients
    if recipe.ingredients then return recipe.ingredients end
    -- Fallback to normal difficulty ingredients
    if recipe.normal and recipe.normal.ingredients then return recipe.normal.ingredients end
    return nil
end

-- Resolve any omitted new_ingredients by grabbing them from the craft ingredients 
-- of the removed inserter itself.
for inserter_name, removal_data in pairs(bye_bye_long_inserter.removals) do
    if not removal_data.new_ingredients then
        removal_data.new_ingredients = get_recipe_ingredients(inserter_name) or {}
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

-- Helper to process an ingredient list and apply replacements
local function apply_replacements(ingredients)
    if not ingredients then return end
    local additions = {}
    
    -- Iterate backwards safely because we might remove elements
    for i = #ingredients, 1, -1 do
        local ingredient = ingredients[i]
        local name = ingredient.name or ingredient[1]
        local removal_data = bye_bye_long_inserter.removals[name]
        
        if removal_data then
            -- Determine amount of the removed inserter originally required
            local required_amount = ingredient.amount or ingredient[2] or 1
            local multiplier = removal_data.use_amount_multiplier and required_amount or 1
            
            -- Remove the original "long" inserter ingredient
            table.remove(ingredients, i)
            
            -- Queue the new replacement ingredients, scaled by the multiplier
            for _, new_ing in pairs(removal_data.new_ingredients) do
                local r_name = new_ing.name or new_ing[1]
                local r_amt = new_ing.amount or new_ing[2] or 1
                local r_type = new_ing.type or "item"
                
                table.insert(additions, {
                    type = r_type,
                    name = r_name,
                    amount = r_amt * multiplier
                })
            end
        end
    end
    
    -- Append our queued replacement ingredients
    for _, add in pairs(additions) do
        table.insert(ingredients, add)
    end
end

-- Replace ingredients in all recipes
for _, recipe in pairs(data.raw.recipe) do
    apply_replacements(recipe.ingredients)
    if recipe.normal then apply_replacements(recipe.normal.ingredients) end
    if recipe.expensive then apply_replacements(recipe.expensive.ingredients) end
end

-- Hide the removed inserters
for inserter_name, _ in pairs(bye_bye_long_inserter.removals) do
    if data.raw.recipe[inserter_name] then
        data.raw.recipe[inserter_name].hidden = true
        data.raw.recipe[inserter_name].enabled = false
    end
end
