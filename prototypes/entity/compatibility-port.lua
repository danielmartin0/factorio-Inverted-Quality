local hit_effects = require("__base__.prototypes.entity.hit-effects")
local sounds = require("__base__.prototypes.entity.sounds")

local SCALE = 0.23

data:extend({
	{
		type = "furnace",
		name = "Inverted-Quality-compatibility-port",
		vector_to_place_result = { 0, -0.84 },
		icon = "__Inverted-Quality__/graphics/icons/compatibility-port.png",
		flags = { "placeable-neutral", "placeable-player", "player-creation" },
		minable = { mining_time = 0.1, result = "Inverted-Quality-compatibility-port" },
		max_health = 50,
		corpse = "small-remnants",
		dying_explosion = "splitter-explosion",
		-- icon_draw_specification = { shift = { 0, -0.3 } },
		resistances = {
			{
				type = "fire",
				percent = 70,
			},
		},
		collision_box = { { -0.29, -0.3 }, { 0.29, 0.3 } },
		selection_box = { { -0.49, -0.5 }, { 0.49, 0.5 } },
		damaged_trigger_effect = hit_effects.entity(),
		fast_replaceable_group = "Inverted-Quality-compatibility-port",
		-- next_upgrade = "assembling-machine-2",
		circuit_wire_max_distance = assembling_machine_circuit_wire_max_distance,
		circuit_connector = circuit_connector_definitions["assembling-machine"],
		-- alert_icon_shift = util.by_pixel(0, -12),
		graphics_set = {
			animation = {
				north = {
					layers = {
						{
							filename = "__Inverted-Quality__/graphics/entity/compatibility-port/compatibility-port.png",
							priority = "extra-high",
							width = 424,
							height = 340,
							frame_count = 4,
							line_length = 4,
							animation_speed = 1,
							frame_sequence = { 3 },
							scale = SCALE,
							shift = util.by_pixel(5, 0),
						},
					},
				},
				east = {
					layers = {
						{
							filename = "__Inverted-Quality__/graphics/entity/compatibility-port/compatibility-port.png",
							priority = "extra-high",
							width = 424,
							height = 340,
							frame_count = 4,
							line_length = 4,
							animation_speed = 1,
							frame_sequence = { 4 },
							scale = SCALE,
							shift = util.by_pixel(5, 0),
						},
					},
				},
				south = {
					layers = {
						{
							filename = "__Inverted-Quality__/graphics/entity/compatibility-port/compatibility-port.png",
							priority = "extra-high",
							width = 424,
							height = 340,
							frame_count = 4,
							line_length = 4,
							animation_speed = 1,
							frame_sequence = { 1 },
							scale = SCALE,
							shift = util.by_pixel(5, 3),
						},
					},
				},
				west = {
					layers = {
						{
							filename = "__Inverted-Quality__/graphics/entity/compatibility-port/compatibility-port.png",
							priority = "extra-high",
							width = 424,
							height = 340,
							frame_count = 4,
							line_length = 4,
							animation_speed = 1,
							frame_sequence = { 2 },
							scale = SCALE,
							shift = util.by_pixel(5, 0),
						},
					},
				},
			},
		},
		crafting_categories = { "Inverted-Quality-porting" },
		crafting_speed = 1,
		energy_source = {
			type = "void",
		},
		energy_usage = "1kW",
		open_sound = sounds.machine_open,
		close_sound = sounds.machine_close,
		allowed_effects = {},
		effect_receiver = { uses_module_effects = false, uses_beacon_effects = false, uses_surface_effects = false },
		impact_category = "metal",
		working_sound = {
			sound = { filename = "__base__/sound/transport-belt-working.ogg", volume = 0.5 },
			audible_distance_modifier = 0.4,
			fade_in_ticks = 2,
			fade_out_ticks = 5,
		},

		result_inventory_size = 1,
		source_inventory_size = 1,
		custom_input_slot_tooltip_key = "compatibility-port-input-slot-tooltip",
		icon_draw_specification = { scale = 0.75, scale_for_many = 0.5 },
		perceived_performance = { maximum = 4 },
		created_effect = {
			type = "direct",
			action_delivery = {
				type = "instant",
				source_effects = {
					{
						type = "script",
						effect_id = "Inverted-Quality-compatibility-port-created",
					},
				},
			},
		},
	},
})
