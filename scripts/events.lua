local common = require("common")

local Public = {}

function Public.re_init()
	storage.meltdown_facilities = storage.meltdown_facilities or {}
	storage.compatibility_ports = storage.compatibility_ports or {}
	storage.player_last_seen_max_ingredient_depth = storage.player_last_seen_max_ingredient_depth or {}

	for _, force in pairs(game.forces) do
		for name, tech in pairs(force.technologies) do
			local prototype = tech.prototype
			if prototype.effects then
				for _, effect in pairs(prototype.effects) do
					if effect.type == "unlock-quality" then
						force.technologies[name].researched = true
						break
					end
				end
			end
		end
	end
end

script.on_configuration_changed(function()
	Public.re_init()
end)

script.on_init(function()
	Public.re_init()
end)

script.on_event(defines.events.on_script_trigger_effect, function(event)
	local entity = event.cause_entity
	if entity and entity.valid then
		if event.effect_id == "Inverted-Quality-meltdown-facility-created" then
			storage.meltdown_facilities[#storage.meltdown_facilities + 1] = {
				entity = entity,
				last_seen_products_finished = -1,
			}
		elseif event.effect_id == "Inverted-Quality-downgrade-port-created" then
			storage.compatibility_ports[#storage.compatibility_ports + 1] = {
				entity = entity,
				last_seen_products_finished = -1,
			}
		end
	end
end)

script.on_event(defines.events.on_tick, function()
	for i = #storage.meltdown_facilities, 1, -1 do
		local meltdown_facility = storage.meltdown_facilities[i]
		local e = meltdown_facility.entity

		if e and e.valid then
			e.result_quality = "normal"
		else
			table.remove(storage.meltdown_facilities, i)
		end
	end

	for i = #storage.compatibility_ports, 1, -1 do
		local compatibility_port = storage.compatibility_ports[i]
		local e = compatibility_port.entity

		if e and e.valid then
			if
				e.result_quality
				and e.result_quality.next
				and e.products_finished ~= compatibility_port.last_seen_products_finished
			then
				e.result_quality = e.result_quality.next.name
				compatibility_port.last_seen_products_finished = e.products_finished
			end
		else
			table.remove(storage.compatibility_ports, i)
		end
	end
end)

-- TODO: Finish this code and give players less of a penalty from handcrafting whilst already part of the way up the chain
-- script.on_event(defines.events.on_pre_player_crafted_item, function(event)
-- 	local items = event.items.get_contents()
-- 	local max_ingredient_depth

-- 	for _, item in pairs(items) do
-- 		local meltdown_recipe = prototypes.recipe[item.name .. "-meltdown"]

-- 		if meltdown_recipe and tonumber(meltdown_recipe.order) then
-- 			if tonumber(meltdown_recipe.order) > max_ingredient_depth then
-- 				max_ingredient_depth = tonumber(meltdown_recipe.order)
-- 			end
-- 		end
-- 	end
-- 	max_ingredient_depth = max_ingredient_depth or 0

-- 	game.print(max_ingredient_depth)
-- end)

script.on_event(defines.events.on_player_crafted_item, function(event)
	local stack = event.item_stack
	if not (stack and stack.valid) then
		return
	end

	local recipe = event.recipe.prototype
	local meltdown_recipe = prototypes.recipe[recipe.name .. "-meltdown"]

	local steps
	if meltdown_recipe and tonumber(meltdown_recipe.order) then
		steps = tonumber(meltdown_recipe.order)
	end
	steps = steps or 1

	local quality = prototypes.quality.normal

	for _ = 1, steps do
		if math.random() < common.BASE_DEGRADATION_CHANCE and quality.next then
			quality = quality.next

			while quality.next do
				if math.random() > 0.1 then
					break
				end
				quality = quality.next
			end
		end
	end

	if quality.name ~= "normal" then
		stack.set_stack({ name = stack.name, count = stack.count, quality = quality.name })
	end
end)

script.on_event({
	defines.events.on_built_entity,
	defines.events.on_robot_built_entity,
	defines.events.on_space_platform_built_entity,
}, function(event)
	local entity = event.entity
	if not (entity and entity.valid) then
		return
	end

	if entity.quality.name == "broken" then
		local dead = entity.die()

		if not dead then
			entity.destroy()
		end
	end
end)

script.on_event({
	defines.events.on_robot_built_tile,
	defines.events.on_player_built_tile,
}, function(event)
	local quality = event.quality
	local surface = game.surfaces[event.surface_index]

	if not (surface and surface.valid) then
		return
	end

	if quality.name == "broken" then
		local tiles = event.tiles
		for _, tile in pairs(tiles) do
			local hidden_tile = surface.get_hidden_tile(tile.position)
			surface.set_tiles({ {
				name = hidden_tile,
				position = tile.position,
			} }, true)
		end
	end
end)

script.on_event(defines.events.on_equipment_inserted, function(event)
	local grid = event.grid
	local equipment = event.equipment
	if not (grid and grid.valid and equipment and equipment.valid) then
		return
	end

	if equipment.quality.name == "broken" then
		grid.take({ equipment = equipment })
	end
end)

script.on_event(defines.events.on_player_used_capsule, function(event)
	local player = game.players[event.player_index]
	local quality = event.quality

	if not (player and player.valid and player.character and player.character.valid) then
		return
	end

	if quality.name == "broken" then
		player.character.damage(20, game.player.force, "impact")
	end
end)

script.on_event(defines.events.on_player_gun_inventory_changed, function(event)
	local player = game.players[event.player_index]

	if not (player and player.valid) then
		return
	end

	local character = player.character

	if not (character and character.valid) then
		return
	end

	local gun_inventory = character.get_inventory(defines.inventory.character_guns)
	local ammo_inventory = character.get_inventory(defines.inventory.character_ammo)

	if ammo_inventory then
		for i = #ammo_inventory, 1, -1 do
			local ammo = ammo_inventory[i]
			if ammo.valid_for_read and ammo.quality.name == "broken" then
				ammo.clear()
			end
		end
	end

	if gun_inventory then
		for i = #gun_inventory, 1, -1 do
			local weapon = gun_inventory[i]
			if weapon.valid_for_read and weapon.quality.name == "broken" then
				weapon.clear()
			end
		end
	end
end)

return Public
