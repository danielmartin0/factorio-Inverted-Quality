data:extend({
	{
		type = "technology",
		name = "Inverted-Quality",
		icon = "__quality__/graphics/technology/quality-module-1.png",
		icon_size = 256,
		effects = {
			{
				type = "unlock-quality",
				quality = "scuffed",
			},
			{
				type = "unlock-quality",
				quality = "funky",
			},
			{
				type = "unlock-quality",
				quality = "defective",
			},
			{
				type = "unlock-quality",
				quality = "broken",
			},
		},
		prerequisites = {},
		unit = {
			count = 1,
			ingredients = {
				{ "automation-science-pack", 1 },
			},
			time = 60,
		},
		hidden = true,
	},
})
