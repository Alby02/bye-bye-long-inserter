-- compatibility/factorio-plus-plus.lua

if mods["factorio-plus-plus"] and settings.startup["bbl-remove-factorio-plus-inserters"].value then
    -- Assume the mod adds advanced long inserters
    bye_bye_long_inserter.remove_inserter("express-long-inserter", {
        {type = "item", name = "express-inserter", amount = 1},
        {type = "item", name = "iron-stick", amount = 2},
        {type = "item", name = "iron-gear-wheel", amount = 1}
    })
end
