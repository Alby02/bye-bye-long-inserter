-- settings.lua

data:extend({
    {
        type = "bool-setting",
        name = "bbl-remove-krastorio2-inserters",
        setting_type = "startup",
        default_value = true,
        order = "a"
    },
    {
        type = "bool-setting",
        name = "bbl-remove-factorio-plus-inserters",
        setting_type = "startup",
        default_value = true,
        order = "b"
    }
})