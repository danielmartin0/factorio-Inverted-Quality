local Public = {}

Public.BASE_DEGRADATION_CHANCE = 0.6

-- From quality mod:
local function get_prototype(base_type, name)
	for type_name in pairs(defines.prototypes[base_type]) do
		local prototypes = data.raw[type_name]
		if prototypes and prototypes[name] then
			return prototypes[name]
		end
	end
end

-- From quality mod:
function Public.get_item_localised_name(name)
	local item = get_prototype("item", name)
	if not item then
		return
	end
	if item.localised_name then
		return item.localised_name
	end
	local prototype
	local type_name = "item"
	if item.place_result then
		prototype = get_prototype("entity", item.place_result)
		type_name = "entity"
	elseif item.place_as_equipment_result then
		prototype = get_prototype("equipment", item.place_as_equipment_result)
		type_name = "equipment"
	elseif item.place_as_tile then
		-- Tiles with variations don't have a localised name
		local tile_prototype = data.raw.tile[item.place_as_tile.result]
		if tile_prototype and tile_prototype.localised_name then
			prototype = tile_prototype
			type_name = "tile"
		end
	end
	return prototype and prototype.localised_name or { type_name .. "-name." .. name }
end

function Public.generate_meltdown_recipe_icons_from_item(item)
	local icons = {}
	if item.icons == nil then
		icons = {
			{
				icon = "__quality__/graphics/icons/recycling.png",
				tint = { 1, 0.3, 0.3 },
			},
			{
				icon = item.icon,
				icon_size = item.icon_size,
				scale = (0.5 * defines.default_icon_size / (item.icon_size or defines.default_icon_size)) * 0.8,
			},
			{
				icon = "__quality__/graphics/icons/recycling-top.png",
				tint = { 1, 0.3, 0.3 },
			},
		}
	else
		icons = {
			{
				icon = "__quality__/graphics/icons/recycling.png",
				tint = { 1, 0.3, 0.3 },
			},
		}
		for i = 1, #item.icons do
			local icon = table.deepcopy(item.icons[i]) -- we are gonna change the scale, so must copy the table
			icon.scale = (
				(icon.scale == nil)
					and (0.5 * defines.default_icon_size / (icon.icon_size or defines.default_icon_size))
				or icon.scale
			) * 0.8
			icon.shift = util.mul_shift(icon.shift, 0.8)
			icons[#icons + 1] = icon
		end
		icons[#icons + 1] = {
			icon = "__quality__/graphics/icons/recycling-top.png",
			tint = { 1, 0.3, 0.3 },
		}
	end
	return icons
end

return Public
