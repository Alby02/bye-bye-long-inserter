-- settings.lua

data:extend({
    {
        type = "string-setting",
        name = "long-inserter-setting",
        setting_type = "startup",
        default_value = "remove",
        allowed_values = {"remove", "intermediate"},
        localised_name = {"mod-setting.long-inserter-setting-name"},
        localised_description = {"mod-setting.long-inserter-setting-description"},
        order = "a"
    }
})