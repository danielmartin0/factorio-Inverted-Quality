local common = require("common")

local MELTDOWN_FACTOR = 1 / 16

local function get_avg_amount(product)
	local base_amount = 0
	if product.amount then
		base_amount = math.floor(product.amount) + (product.extra_count_fraction or 0)
	elseif product.amount_min and product.amount_max then
		base_amount = (product.amount_min + product.amount_max) / 2 + (product.extra_count_fraction or 0)
	end
	return base_amount * (product.probability or 1)
end

local function convert_product_to_result(name, value)
	local floor_amount = math.floor(value)
	local fraction = value - floor_amount

	return {
		type = "item",
		name = name,
		amount = floor_amount,
		extra_count_fraction = fraction > 0 and fraction or nil,
	}
end

local function get_nontrivial_recycling_products(item_name)
	local recycle_name = item_name .. "-recycling"
	local recipe = data.raw.recipe[recycle_name]
	if not recipe then
		return nil
	end

	local values = {}
	local has_nontrivial = false

	for _, product in pairs(recipe.results) do
		if product.type == "item" then
			local value = get_avg_amount(product)

			local is_ingredient = false
			for _, ingredient in pairs(recipe.ingredients) do
				if ingredient.type == "item" and ingredient.name == product.name then
					is_ingredient = true
					break
				end
			end

			if not is_ingredient then
				has_nontrivial = true
			end
			values[product.name] = (values[product.name] or 0) + value
		end
	end

	return has_nontrivial and values or nil
end

local function compute_meltdown_values(item_name)
	if not get_nontrivial_recycling_products(item_name) then
		return { [item_name] = MELTDOWN_FACTOR }
	end

	local final_values = {}

	local to_process = { { item_name, 1 } }

	while #to_process > 0 do
		local new_working = {}

		for _, current in ipairs(to_process) do
			local current_name, current_value = table.unpack(current)

			local recycling = get_nontrivial_recycling_products(current_name)
			if recycling then
				for name, value in pairs(recycling) do
					table.insert(new_working, { name, value * current_value * 4 })
				end
			else
				final_values[current_name] = (final_values[current_name] or 0) + current_value
			end
		end

		to_process = new_working
	end

	return final_values
end

for name, item in pairs(data.raw.item) do
	local product_values = compute_meltdown_values(name)

	local products = {}
	for name, value in pairs(product_values) do
		table.insert(products, convert_product_to_result(name, value))
	end

	data:extend({
		{
			type = "recipe",
			name = name .. "-meltdown",
			localised_name = { "recipe-name.Inverted-Quality-meltdown", common.get_item_localised_name(item.name) },
			hidden = item.hidden and true or false,
			hidden_in_factoriopedia = true,
			hide_from_player_crafting = true,
			hide_from_signal_gui = true,
			category = "Inverted-Quality-meltdown",
			subgroup = "Inverted-Quality-meltdown",
			energy_required = 0.2,
			ingredients = { { type = "item", name = name, amount = 1 } },
			results = products,
			icons = common.generate_meltdown_recipe_icons_from_item(item),
			order = "m[meltdown]-" .. name,
			enabled = true,
			auto_recycle = false,
			show_amount_in_title = false,
			unlock_results = false,
		},
	})
end
