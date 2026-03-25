-- compatibility/krastorio2.lua

if mods["Krastorio2"] and settings.startup["bbl-remove-krastorio2-inserters"] and settings.startup["bbl-remove-krastorio2-inserters"].value then
    bye_bye_long_inserter.remove_inserter("kr-superior-long-inserter")
    bye_bye_long_inserter.remove_inserter("kr-advanced-long-inserter")
end
