-- compatibility/vanilla.lua

-- Replace long-handed-inserter with a normal inserter, a gear and 2 iron sticks
bye_bye_long_inserter.remove_inserter("long-handed-inserter", {
    {type = "item", name = "inserter", amount = 1},
    {type = "item", name = "iron-stick", amount = 2},
    {type = "item", name = "iron-gear-wheel", amount = 1}
})
