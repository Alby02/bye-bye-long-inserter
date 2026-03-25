-- compatibility/krastorio2.lua

if mods["Krastorio2"] and settings.startup["bbl-remove-krastorio2-inserters"].value then
    -- Example names based on Krastorio 2 items, assuming kr-advanced-inserter and kr-superior-long-inserter
    -- We replace them with just the non-long variants, but for the sake of the API we just add to the removal list.
    
    bye_bye_long_inserter.remove_inserter("kr-superior-long-inserter", {
        {type = "item", name = "kr-superior-inserter", amount = 1},
        {type = "item", name = "iron-stick", amount = 2},
        {type = "item", name = "iron-gear-wheel", amount = 1}
    })
    
    bye_bye_long_inserter.remove_inserter("kr-advanced-long-inserter", {
        {type = "item", name = "kr-advanced-inserter", amount = 1},
        {type = "item", name = "iron-stick", amount = 2},
        {type = "item", name = "iron-gear-wheel", amount = 1}
    })
end
