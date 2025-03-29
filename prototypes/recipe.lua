data:extend({
	{
		type = "recipe",
		name = "Inverted-Quality-compatibility-port",
		ingredients = {
			{ type = "item", name = "transport-belt", amount = 1 },
			{ type = "item", name = "electronic-circuit", amount = 5 },
			{ type = "item", name = "iron-gear-wheel", amount = 1 },
		},
		results = { { type = "item", name = "Inverted-Quality-compatibility-port", amount = 1 } },
		energy_required = 1,
		enabled = true,
		-- enabled = false,
	},
	{
		type = "recipe",
		name = "Inverted-Quality-meltdown-facility",
		ingredients = {
			{ type = "item", name = "steel-plate", amount = 10 },
			{ type = "item", name = "electronic-circuit", amount = 10 },
			{ type = "item", name = "stone-brick", amount = 20 },
		},
		results = { { type = "item", name = "Inverted-Quality-meltdown-facility", amount = 1 } },
		energy_required = 5,
		enabled = true,
		-- enabled = false,
	},
})
