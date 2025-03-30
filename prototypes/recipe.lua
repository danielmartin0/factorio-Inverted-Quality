data:extend({
	{
		type = "recipe",
		name = "Inverted-Quality-burner-assembling-machine",
		ingredients = {
			{ type = "item", name = "iron-plate", amount = 5 },
			{ type = "item", name = "wood", amount = 8 },
		},
		results = { { type = "item", name = "Inverted-Quality-burner-assembling-machine", amount = 1 } },
		enabled = true,
		-- enabled = false,
	},
	{
		type = "recipe",
		name = "Inverted-Quality-downgrade-port",
		ingredients = {
			{ type = "item", name = "iron-plate", amount = 5 },
		},
		results = { { type = "item", name = "Inverted-Quality-downgrade-port", amount = 1 } },
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
