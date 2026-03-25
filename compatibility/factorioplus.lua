-- compatibility/factorioplus.lua

if mods["factorioplus"] and settings.startup["bbl-remove-factorioplus-inserters"] and settings.startup["bbl-remove-factorioplus-inserters"].value then
    bye_bye_long_inserter.remove_inserter("express-long-inserter")
end

