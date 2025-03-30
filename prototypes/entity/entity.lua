local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

data:extend({
	{
		type = "assembling-machine",
		name = "Inverted-Quality-burner-assembling-machine",
		icon = "__Inverted-Quality__/graphics/icons/burner-assembling-machine.png",
		flags = { "placeable-neutral", "placeable-player", "player-creation" },
		minable = { mining_time = 0.2, result = "Inverted-Quality-burner-assembling-machine" },
		max_health = 200,
		corpse = "assembling-machine-1-remnants",
		dying_explosion = "assembling-machine-1-explosion",
		icon_draw_specification = { shift = { 0, -0.3 } },
		resistances = {
			{
				type = "fire",
				percent = 70,
			},
		},
		collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
		selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
		damaged_trigger_effect = hit_effects.entity(),
		fast_replaceable_group = "assembling-machine",
		next_upgrade = "assembling-machine-1",
		circuit_wire_max_distance = assembling_machine_circuit_wire_max_distance,
		circuit_connector = circuit_connector_definitions["assembling-machine"],
		alert_icon_shift = util.by_pixel(0, -12),
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
		crafting_categories = { "crafting", "basic-crafting", "advanced-crafting" },
		crafting_speed = 0.4,
		energy_source = {
			type = "burner",
			fuel_categories = { "chemical" },
			effectivity = 0.9,
			fuel_inventory_size = 1,
			emissions_per_minute = { pollution = 2 },
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
		energy_usage = "50kW",
		open_sound = sounds.machine_open,
		close_sound = sounds.machine_close,
		allowed_effects = { "speed", "consumption", "pollution" },
		effect_receiver = { uses_module_effects = false, uses_beacon_effects = false, uses_surface_effects = true },
		impact_category = "metal",
		working_sound = {
			sound = {
				filename = "__base__/sound/assembling-machine-t1-1.ogg",
				volume = 0.5,
				audible_distance_modifier = 0.5,
			},
			fade_in_ticks = 4,
			fade_out_ticks = 20,
		},
	},
})
