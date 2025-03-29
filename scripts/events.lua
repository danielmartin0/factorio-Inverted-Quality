-- Inverted-Quality-meltdown-facility-created
local Public = {}

script.on_configuration_changed(function()
	storage.meltdown_facilities = storage.meltdown_facilities or {}
	storage.compatibility_ports = storage.compatibility_ports or {}
end)

script.on_init(function()
	storage.meltdown_facilities = storage.meltdown_facilities or {}
	storage.compatibility_ports = storage.compatibility_ports or {}
end)

script.on_event(defines.events.on_script_trigger_effect, function(event)
	local entity = event.cause_entity
	if entity and entity.valid then
		if event.effect_id == "Inverted-Quality-meltdown-facility-created" then
			storage.meltdown_facilities[#storage.meltdown_facilities + 1] = {
				entity = entity,
				last_seen_products_finished = 0,
			}
		elseif event.effect_id == "Inverted-Quality-compatibility-port-created" then
			storage.compatibility_ports[#storage.compatibility_ports + 1] = {
				entity = entity,
				last_seen_products_finished = 0,
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
			game.print(
				"Compatibility port tick: " .. (e.result_quality or "nil") .. " " .. (e.products_finished or "nil")
			)
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

return Public
