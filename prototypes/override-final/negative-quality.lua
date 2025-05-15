local lib = require("lib")
local find = lib.find

-- Don't forget to update the locale entries if customizing this behavior.

for _, quality in pairs(data.raw.quality) do
	quality.level = quality.level + 3
end

local QUALITY_LEVELS_TO_UNDO = 3

-- Following https://wiki.factorio.com/Quality:
local QUALITY_EFFECTS = {
	max_health = { relative = 0.3 },

	-- Crafting machines
	crafting_speed = { relative = 0.3, bonus = 0.1 },

	-- Roboports
	robot_slots_count = { relative = 0.3, floor = true },
	robot_limit = { absolute = 1 },
	charging_energy = { relative = 0.3, unit = "W" },

	-- Module effects
	effect = {
		recursive = true,
		consumption = { relative = 0.3 },
		speed = { relative = 0.3 },
		productivity = { relative = 0.3 },
		pollution = { relative = 0.3 },
		quality = { relative = 0.3 },
	},

	-- Weapons and turrets
	attack_parameters = {
		recursive = true,
		range = { relative = 0.1 },
		type = { "ammo-turret", "gun", "electric-turret", "artillery-turret", "turret", "fluid-turret" },
	},

	-- Undocumented
	revenge_attack_parameters = {
		recursive = true,
		range = { relative = 0.1 },
	},

	-- Electric poles
	supply_area_distance = { absolute = 1, type = "electric-pole", bonus = 1 },
	maximum_wire_distance = { absolute = 2, bonus = 2 },

	-- Equipment
	width = { absolute = 1, type = "equipment-grid" },
	height = { absolute = 1, type = "equipment-grid" },

	-- Chests
	inventory_size = { relative = 0.3, type = { "container", "logistic-container" }, floor = true },

	-- Ammo
	ammo_type = { recursive = true, damage = { relative = 0.3 } },

	--Inserter
	rotation_speed = { relative = 0.3, type = "inserter" },

	-- mining_drill_resource_drain_multiplier is on quality prototype
	-- science_pack_drain_multiplier is on quality prototype

	-- Solar panel
	production = { relative = 0.3, type = "solar-panel", unit = "W" },

	-- Energy entities
	energy_source = {
		{ input_flow_limit = { relative = 0.3, unit = "W" }, type = "accumulator" },
		{ buffer_capacity = { relative = 1, unit = "J" }, type = { "accumulator", "battery-equipment" } },
		{ output_flow_limit = { relative = 0.3, unit = "W" }, type = "accumulator" },
	},
	energy_consumption = { relative = 0.3, type = "boiler", unit = "W", lower_bound = 0.001 },
	fluid_usage_per_tick = { relative = 0.3, type = "generator" },
	consumption = { relative = 0.3, type = "reactor", unit = "W", lower_bound = 0.001 },

	-- Lightning rods
	efficiency = { relative = 0.3, type = "lightning-attractor" },
	range_elongation = { relative = 0.3, type = "lightning-attractor" },

	-- Beacons
	-- beacon_power_usage_multiplier is on quality prototype

	-- Radar
	max_distance_of_sector_revealed = { absolute = 1, type = "radar" },
	max_distance_of_nearby_sector_revealed = { absolute = 1, type = "radar", lower_bound = 0 },

	-- Science/repair packs
	durability = { relative = 1, type = { "repair-tool", "tool" } },

	-- Tesla fork chance handled as a special case below

	-- Asteroid collectors handled as a special case below

	-- Not documented on wiki, but included in Quezler's doc:
	inventory_size_bonus = { relative = 0.3, floor = true }, -- Equipment and cargo bays
	duration_in_ticks = { relative = 0.3, floor = true, type = "sticker" },

	-- Other undocumented quality effects - these are guesses
	target_movement_modifier_from = { absolute = -0.05, type = "sticker" },
	vehicle_speed_modifier_from = { absolute = -0.05, type = "sticker" },
	vehicle_friction_modifier_from = { absolute = 0.05, type = "sticker" },
}

local function undo_quality_effects_on_physical_value(physical_value, modifier)
	local number = tonumber(string.match(physical_value, "^%d+%.?%d*"))
	local unit = string.match(physical_value, "[^%d%s%.]+$")

	if modifier.bonus then
		number = number + modifier.bonus
	end

	if modifier.relative then
		number = number / (1 + modifier.relative * QUALITY_LEVELS_TO_UNDO)
		if modifier.floor then
			-- Inverted floor is ceil
			number = math.ceil(number)
		end
	elseif modifier.absolute then
		number = number - (modifier.absolute * QUALITY_LEVELS_TO_UNDO)
	end
	if modifier.lower_bound then
		number = math.max(number, modifier.lower_bound)
	end
	return string.format("%.6f", number) .. unit
end

local function apply_modifier(value, modifier)
	if modifier.unit then
		return undo_quality_effects_on_physical_value(value, modifier)
	else
		local new_value = value

		if modifier.bonus then
			new_value = new_value + modifier.bonus
		end

		if modifier.relative then
			new_value = new_value / (1 + modifier.relative * QUALITY_LEVELS_TO_UNDO)
			if modifier.floor then
				-- Inverted floor is ceil
				new_value = math.ceil(new_value)
			end
		elseif modifier.absolute then
			new_value = new_value - (modifier.absolute * QUALITY_LEVELS_TO_UNDO)
		end

		if modifier.lower_bound then
			return math.max(new_value, modifier.lower_bound)
		end
		return new_value
	end
end

local function process_recursive_modifier(value, modifier)
	if type(value) ~= "table" then
		if type(value) == "number" then
			for mod_key, mod_value in pairs(modifier) do
				if mod_key ~= "recursive" and mod_key ~= "type" then
					return apply_modifier(value, mod_value)
				end
			end
		end
		return value
	end

	local result = {}
	for k, v in pairs(value) do
		result[k] = process_recursive_modifier(v, modifier)
	end
	return result
end

local function process_nested_effects(prototype, effect_table)
	for key, modifier in pairs(effect_table) do
		if prototype[key] then
			local old = util.table.deepcopy(prototype[key])
			local modified = false

			-- Handle array of modifiers case (like energy_source)
			if type(modifier) == "table" and #modifier > 0 then
				for _, mod in ipairs(modifier) do
					if
						not mod.type
						or (type(mod.type) == "string" and prototype.type == mod.type)
						or (type(mod.type) == "table" and find(mod.type, prototype.type))
					then
						for subkey, _ in pairs(mod) do
							if subkey ~= "type" and prototype[key][subkey] then
								prototype[key][subkey] = apply_modifier(prototype[key][subkey], mod[subkey])
								modified = true
							end
						end
					end
				end
			else
				if
					not modifier.type
					or (type(modifier.type) == "string" and prototype.type == modifier.type)
					or (type(modifier.type) == "table" and find(modifier.type, prototype.type))
				then
					if modifier.recursive then
						prototype[key] = process_recursive_modifier(prototype[key], modifier)
						modified = true
					else
						prototype[key] = apply_modifier(prototype[key], modifier)
						modified = true
					end
				end
			end

			-- if modified then
			-- 	log(
			-- 		"INVERTED-QUALITY: "
			-- 			.. prototype.name
			-- 			.. " "
			-- 			.. key
			-- 			.. ". Before: "
			-- 			.. serpent.block(old)
			-- 			.. ". After: "
			-- 			.. serpent.block(prototype[key])
			-- 	)
			-- end
		end
	end
end

log("DEBUG:")
log(
	'data.raw.sticker["acid-sticker-small"].target_movement_modifier_from = '
		.. data.raw.sticker["acid-sticker-small"].target_movement_modifier_from
)
log(
	'data.raw.sticker["acid-sticker-small"].vehicle_speed_modifier_from = '
		.. data.raw.sticker["acid-sticker-small"].vehicle_speed_modifier_from
)
log(
	'data.raw.sticker["acid-sticker-small"].vehicle_friction_modifier_from = '
		.. data.raw.sticker["acid-sticker-small"].vehicle_friction_modifier_from
)

for _, prototype in pairs(data.raw) do
	for name, entity in pairs(prototype) do
		process_nested_effects(entity, QUALITY_EFFECTS)
	end
end

log(
	'data.raw.sticker["acid-sticker-small"].target_movement_modifier_from = '
		.. data.raw.sticker["acid-sticker-small"].target_movement_modifier_from
)
log(
	'data.raw.sticker["acid-sticker-small"].vehicle_speed_modifier_from = '
		.. data.raw.sticker["acid-sticker-small"].vehicle_speed_modifier_from
)
log(
	'data.raw.sticker["acid-sticker-small"].vehicle_friction_modifier_from = '
		.. data.raw.sticker["acid-sticker-small"].vehicle_friction_modifier_from
)

for _, chain in pairs(data.raw["chain-active-trigger"] or {}) do
	chain.fork_chance_increase_per_quality_level = chain.fork_chance_increase_per_quality_level / 5
	chain.fork_chance = chain.fork_chance - QUALITY_LEVELS_TO_UNDO * chain.fork_chance_increase_per_quality_level
end

for _, collector in pairs(data.raw["asteroid-collector"] or {}) do
	collector.arm_count_base = 1
	-- collector.arm_count_base = 2 -- maybe this buff is helpful?
	collector.arm_count_quality_scaling = 0

	collector.arm_speed_quality_scaling = collector.arm_speed_quality_scaling / 2 -- buff
	collector.arm_speed_base = collector.arm_speed_base - collector.arm_speed_quality_scaling * QUALITY_LEVELS_TO_UNDO

	collector.passive_energy_usage = undo_quality_effects_on_physical_value(
		collector.passive_energy_usage,
		{ relative = collector.energy_usage_quality_scaling }
	)
	collector.arm_energy_usage = undo_quality_effects_on_physical_value(
		collector.arm_energy_usage,
		{ relative = collector.energy_usage_quality_scaling }
	)
	collector.arm_slow_energy_usage = undo_quality_effects_on_physical_value(
		collector.arm_slow_energy_usage,
		{ relative = collector.energy_usage_quality_scaling }
	)

	-- collector.collection_radius = collector.collection_radius - QUALITY_LEVELS_TO_UNDO -- nominal effect
	collector.collection_radius = collector.collection_radius - QUALITY_LEVELS_TO_UNDO + 2 -- buff

	collector.inventory_size = collector.inventory_size
		- collector.inventory_size_quality_increase * QUALITY_LEVELS_TO_UNDO
	collector.arm_inventory_size = collector.arm_inventory_size
		- collector.arm_inventory_size_quality_increase * QUALITY_LEVELS_TO_UNDO
end
