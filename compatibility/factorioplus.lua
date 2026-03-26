-- compatibility/factorioplus.lua

if mods["factorioplus"] and settings.startup["bbl-remove-factorioplus-inserters"] and settings.startup["bbl-remove-factorioplus-inserters"].value then
    bye_bye_long_inserter.remove_inserter("long-handed-burner-inserter", "long-handed-burner-inserter")
    bye_bye_long_inserter.remove_inserter("very-long-handed-inserter", "very-long-handed-inserter")
end
