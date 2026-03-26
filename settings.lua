-- settings.lua

data:extend({
    {
        type = "bool-setting",
        name = "bbl-remove-vanilla-inserters",
        setting_type = "startup",
        default_value = true,
        order = "a"
    }
})

if mods["Krastorio2"] then
    data:extend({
        {
            type = "bool-setting",
            name = "bbl-remove-krastorio2-inserters",
            setting_type = "startup",
            default_value = true,
            order = "b"
        }
    })
end

if mods["factorioplus"] then
    data:extend({
        {
            type = "bool-setting",
            name = "bbl-remove-factorioplus-inserters",
            setting_type = "startup",
            default_value = true,
            order = "c"
        }
    })
end