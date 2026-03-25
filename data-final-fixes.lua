-- data-final-fixes.lua

if not bye_bye_long_inserter or not bye_bye_long_inserter.removals then return end

-- Track main recipes for quick filtering
local is_main_recipe = {}

for inserter_name, removal_data in pairs(bye_bye_long_inserter.removals) do
    for _, mr in pairs(removal_data.main_recipes) do
        is_main_recipe[mr] = true
    end
    
    -- Grab replacement ingredients from the FIRST main recipe if omitted
    if not removal_data.new_ingredients then
        local first_recipe = data.raw.recipe[removal_data.main_recipes[1]]
        removal_data.new_ingredients = first_recipe and first_recipe.ingredients or {}
    end
    
    -- Hide the item itself to try preventing uncrafting/generation issues
    if data.raw.item[inserter_name] then
        data.raw.item[inserter_name].hidden = true
        data.raw.item[inserter_name].hidden_in_factoriopedia = true
    end
end

-- Completely hide, disable, and disconnect the main recipes
for main_recipe_name, _ in pairs(is_main_recipe) do
    local recipe = data.raw.recipe[main_recipe_name]
    if recipe then
        recipe.enabled = false
        recipe.hidden = true
    end
end

for _, tech in pairs(data.raw.technology) do
    if tech.effects then
        for i = #tech.effects, 1, -1 do
            local effect = tech.effects[i]
            if effect.type == "unlock-recipe" and is_main_recipe[effect.recipe] then
                table.remove(tech.effects, i)
            end
        end
    end
end

-- Helper to safely add an item to an existing component list, merging exact matches
local function insert_or_merge_component(list, comp)
    local found = false
    local c_name = comp.name or comp[1]
    local c_amt = comp.amount or comp[2] or 1
    local c_type = comp.type or "item"
    
    for _, existing in pairs(list) do
        local e_name = existing.name or existing[1]
        local e_type = existing.type or "item"
        if e_name == c_name and e_type == c_type then
            if existing.amount then
                existing.amount = existing.amount + c_amt
            else
                existing[2] = existing[2] + c_amt
            end
            found = true
            break
        end
    end
    
    if not found then
        table.insert(list, {type = c_type, name = c_name, amount = c_amt})
    end
end

-- Process an item list (like ingredients or results) and apply the fallback swaps
local function apply_replacements(item_list)
    if not item_list then return end
    local additions = {}
    
    -- Iterate backwards safely because we might remove elements
    for i = #item_list, 1, -1 do
        local comp = item_list[i]
        local name = comp.name or comp[1]
        local removal_data = bye_bye_long_inserter.removals[name]
        
        if removal_data then
            local multiplier = removal_data.use_amount_multiplier and (comp.amount or comp[2] or 1) or 1
            
            -- Remove the original "long" inserter
            table.remove(item_list, i)
            
            -- Queue the new replacement components, scaled by the multiplier
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
    
    -- Append our queued replacement components merging duplicate definitions safely
    for _, add in pairs(additions) do
        insert_or_merge_component(item_list, add)
    end
end

-- Replace ingredients and results in ALL other recipes (including recycling yields etc)
for recipe_name, recipe in pairs(data.raw.recipe) do
    if not is_main_recipe[recipe_name] then
        -- Process Ingredients
        apply_replacements(recipe.ingredients)
        
        -- Process Results
        if recipe.result then
            -- If string result, convert to table format if it matches a removal
            if bye_bye_long_inserter.removals[recipe.result] then
                local res_amt = recipe.result_count or 1
                recipe.results = {{type = "item", name = recipe.result, amount = res_amt}}
                recipe.result = nil
                recipe.result_count = nil
                apply_replacements(recipe.results)
            end
        elseif recipe.results then
            apply_replacements(recipe.results)
        end
    end
end
