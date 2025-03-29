local hit_effects = require("__base__/prototypes/entity/hit-effects")
local sounds = require("__base__/prototypes/entity/sounds")

data:extend({
	{
		type = "furnace",
		name = "Inverted-Quality-meltdown-facility",
		icon = "__Inverted-Quality__/graphics/Hurricane-arc-furnace/arc-furnace-icon.png",
		icon_size = 64,
		flags = { "placeable-neutral", "placeable-player", "player-creation" },
		minable = { mining_time = 0.2, result = "Inverted-Quality-meltdown-facility" },
		fast_replaceable_group = "Inverted-Quality-meltdown-facility",
		circuit_wire_max_distance = furnace_circuit_wire_max_distance,
		circuit_connector = circuit_connector_definitions["steel-furnace"],
		max_health = 1000,
		corpse = "big-remnants",
		dying_explosion = "medium-explosion",
		impact_category = "metal",
		open_sound = sounds.metal_large_open,
		close_sound = sounds.metal_large_close,
		allowed_effects = { "speed", "consumption", "pollution" },
		effect_receiver = { uses_module_effects = false, uses_beacon_effects = false, uses_surface_effects = true },

		working_sound = {
			sound = {
				filename = "__base__/sound/steel-furnace.ogg",
				volume = 0.7,
				advanced_volume_control = { attenuation = "exponential" },
				audible_distance_modifier = 0.9,
				speed = 0.5,
			},
			max_sounds_per_prototype = 2,
			fade_in_ticks = 8,
			fade_out_ticks = 40,
		},

		resistances = {
			{
				type = "fire",
				percent = 100,
			},
		},

		collision_box = { { -2.1, -2.1 }, { 2.1, 2.1 } },
		selection_box = { { -2.5, -2.5 }, { 2.5, 2.5 } },
		damaged_trigger_effect = hit_effects.entity(),
		crafting_categories = { "Inverted-Quality-meltdown" },
		energy_usage = "3MW",
		heating_energy = "300kW",
		crafting_speed = 1,
		source_inventory_size = 1,
		result_inventory_size = 12,

		energy_source = {
			type = "electric",
			usage_priority = "secondary-input",
			emissions_per_minute = { pollution = 30 },
		},

		graphics_set = {
			always_draw_idle_animation = true,
			idle_animation = {
				layers = {
					{
						filename = "__Inverted-Quality__/graphics/Hurricane-arc-furnace/arc-furnace-hr-shadow.png",
						size = { 600, 400 },
						shift = { 0, 0 },
						scale = 0.5,
						line_length = 1,
						frame_count = 1,
						repeat_count = 50,
						draw_as_shadow = true,
						animation_speed = 0.25,
					},
					{
						filename = "__Inverted-Quality__/graphics/Hurricane-arc-furnace/arc-furnace-hr-animation-1.png",
						size = { 320, 320 },
						shift = { 0, 0 },
						scale = 0.5,
						line_length = 8,
						lines_per_file = 8,
						frame_count = 50,
						animation_speed = 0.25,
					},
				},
			},
			working_visualisations = {
				{
					fadeout = true,
					secondary_draw_order = 1,
					animation = {
						layers = {
							{
								filename = "__Inverted-Quality__/graphics/Hurricane-arc-furnace/arc-furnace-hr-emission-1.png",
								size = { 320, 320 },
								shift = { 0, 0 },
								scale = 0.5,
								line_length = 8,
								lines_per_file = 8,
								frame_count = 40,
								draw_as_glow = true,
								blend_mode = "additive",
								animation_speed = 0.25,
							},
						},
					},
				},
			},
		},
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				source_effects = {
					{
						type = "script",
						effect_id = "Inverted-Quality-meltdown-facility-created",
					},
				},
			},
		},
	},
})
