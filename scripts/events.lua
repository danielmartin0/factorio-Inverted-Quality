local common = require("common")

local Public = {}

function Public.re_init()
	storage.meltdown_facilities = storage.meltdown_facilities or {}
	storage.compatibility_ports = storage.compatibility_ports or {}

	for _, force in pairs(game.forces) do
		for name, tech in pairs(force.technologies) do
			local prototype = tech.prototype
			if not prototype.hidden and prototype.effects then
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

script.on_event(defines.events.on_player_crafted_item, function(event)
	local stack = event.item_stack
	if not (stack and stack.valid) then
		return
	end

	local quality_name = stack.quality.name

	local step = 0
	while quality_name and prototypes.quality[quality_name].next do
		if math.random() > common.BASE_DEGRADATION_CHANCE * 0.1 ^ step then
			break
		end
		quality_name = prototypes.quality[quality_name].next.name
		step = step + 1
	end

	if quality_name ~= stack.quality.name then
		stack.set_stack({ name = stack.name, count = stack.count, quality = quality_name })
	end
end)

return Public
