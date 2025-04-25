local lib = require("lib")
local merge = lib.merge

local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

data:extend({
	merge(data.raw["assembling-machine"]["assembling-machine-1"], {
		name = "Inverted-Quality-burner-assembling-machine",
		icon = "__Inverted-Quality__/graphics/icons/burner-assembling-machine.png",
		minable = { mining_time = 0.2, result = "Inverted-Quality-burner-assembling-machine" },
		graphics_set = {
			animation = {
				layers = {
					{
						filename = "__Inverted-Quality__/graphics/entity/burner-assembling-machine/burner-assembling-machine.png",
						priority = "high",
						width = 214,
						height = 226,
						frame_count = 32,
						line_length = 8,
						shift = util.by_pixel(0, 2),
						scale = 0.5,
					},
					{
						filename = "__base__/graphics/entity/assembling-machine-1/assembling-machine-1-shadow.png",
						priority = "high",
						width = 190,
						height = 165,
						line_length = 1,
						repeat_count = 32,
						draw_as_shadow = true,
						shift = util.by_pixel(8.5, 5),
						scale = 0.5,
					},
				},
			},
		},
		energy_source = {
			type = "burner",
			fuel_categories = { "chemical" },
			effectivity = 0.9,
			fuel_inventory_size = 1,
			emissions_per_minute = { pollution = 5 },
			light_flicker = {
				minimum_light_size = 1,
				light_intensity_to_size_coefficient = 0.2,
				color = { 1, 0.65, 0 },
				minimum_intensity = 0.05,
				maximum_intensity = 0.2,
			},
			smoke = {
				{
					name = "smoke",
					deviation = { 0.1, 0.1 },
					position = { 0.5, -1.5 },
					frequency = 3,
				},
			},
		},
		crafting_speed = 0.5,
		next_upgrade = "assembling-machine-1",
		max_health = 250,
	}),
})
