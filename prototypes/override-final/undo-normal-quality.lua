local lib = require("lib")
local find = lib.find

local QUALITY_LEVELS_TO_UNDO = data.raw.quality.normal.level

local effects = {
	max_health = { relative = 0.3 },

	-- Crafting machines
	crafting_speed = { relative = 0.3 },

	-- Roboports
	robot_slots_count = { relative = 0.3, floor = true },
	robot_limit = { absolute = 1 },
	charging_energy = { relative = 0.3, unit = "W" },

	-- Module effects
	effect = {
		consumption = { relative = 0.3 },
		speed = { relative = 0.3 },
		productivity = { relative = 0.3 },
		pollution = { relative = 0.3 },
		quality = { relative = 0.3 },
	},

	-- Weapons and turrets
	attack_parameters = {
		range = { relative = 0.1, type = { "turret", "gun" } },
	},

	-- Electric poles
	supply_area_distance = { absolute = 1, type = "electric-pole" },
	maximum_wire_distance = { absolute = 2 },

	-- Equipment
	width = { absolute = 1, type = "equipment-grid" },
	height = { absolute = 1, type = "equipment-grid" },

	-- Chests
	inventory_size = { relative = 0.3, type = { "container", "logistic-container" }, floor = true },

	-- Ammo
	ammo_type = { recursive = true, damage = { relative = 0.3 } },

	--Inserter
	rotation_speed = { relative = 0.3, type = "inserter" },

	-- Mining drills ignored due to being in quality prototype
	-- Beacons power ignored due to being in quality prototype
	-- ...
}

local function split_number_and_unit(value_str)
	local number = tonumber(string.match(value_str, "^%d+%.?%d*"))
	local unit = string.match(value_str, "[^%d%s%.]+$") -- matches any non-digit characters at the end
	return number, unit
end

local function process_nested_effects(prototype, effect_table)
	for key, value in pairs(effect_table) do
		if prototype[key] then
			local old = util.table.deepcopy(prototype[key])
			local modified = false
			if value.recursive then
				-- TODO: Fix this, this is broken
				-- process_nested_effects(prototype[key], value)
			else
				if
					not value.type
					or (type(value.type) == "string" and prototype.type == value.type)
					or (type(value.type) == "table" and find(value.type, prototype.type))
				then
					if value.unit then
						local number, unit = split_number_and_unit(prototype[key])
						if value.relative then
							number = number / (1 + value.relative * QUALITY_LEVELS_TO_UNDO)
						elseif value.absolute then
							number = number - (value.absolute * QUALITY_LEVELS_TO_UNDO)
						end
						prototype[key] = string.format("%.6f", number) .. unit
					else
						if value.relative then
							prototype[key] = prototype[key] / (1 + value.relative * QUALITY_LEVELS_TO_UNDO)
							if value.floor then
								prototype[key] = math.floor(prototype[key])
							end
						elseif value.absolute then
							prototype[key] = prototype[key] - (value.absolute * QUALITY_LEVELS_TO_UNDO)
						end
					end

					modified = true
				end
			end
			if modified then
				log(
					"INVERTED-QUALITY: "
						.. prototype.name
						.. " "
						.. key
						.. ". Before: "
						.. serpent.block(old)
						.. ". After: "
						.. serpent.block(prototype[key])
				)
			end
		end
	end
end

local function undo_quality_effects()
	for _, prototype in pairs(data.raw) do
		for name, entity in pairs(prototype) do
			process_nested_effects(entity, effects)
		end
	end
end

undo_quality_effects()
