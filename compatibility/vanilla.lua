-- compatibility/vanilla.lua

if settings.startup["bbl-remove-vanilla-inserters"].value then
    bye_bye_long_inserter.remove_inserter("long-handed-inserter")
end
