local common = require("common")

local MELTDOWN_FACTOR = 1 / 8

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

local function get_non_self_recycling_products(item_name)
	local recycle_name = item_name .. "-recycling"
	local recipe = data.raw.recipe[recycle_name]
	if not recipe then
		return nil, false
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

	return (has_nontrivial and values or nil)
end

local function compute_meltdown_values(item_name)
	local final_values = {}
	local to_process = { { name = item_name, value = 1, seen_items = { [item_name] = true }, depth = 0 } }
	local max_depth = 0

	while #to_process > 0 do
		local new_working = {}

		for _, current in ipairs(to_process) do
			local current_name = current.name
			local current_value = current.value
			local seen_items = current.seen_items
			local depth = current.depth

			if depth > max_depth then
				max_depth = depth
			end

			local recycling_products = get_non_self_recycling_products(current_name)
			if recycling_products then
				for name, value in pairs(recycling_products) do
					if not seen_items[name] then
						local new_seen = {}
						for k in pairs(seen_items) do
							new_seen[k] = true
						end
						new_seen[name] = true

						table.insert(new_working, {
							name = name,
							value = value * current_value * 4,
							seen_items = new_seen,
							depth = depth + 1,
						})
					else
						final_values[name] = (final_values[name] or 0) + value * current_value * 4 * MELTDOWN_FACTOR
					end
				end
			else
				final_values[current_name] = (final_values[current_name] or 0) + current_value * MELTDOWN_FACTOR
			end
		end

		to_process = new_working
	end

	return final_values, max_depth
end

for _, type in pairs({ "item", "tool", "ammo", "capsule", "module", "gun", "repair-tool" }) do
	for name, item in pairs(data.raw[type]) do
		local product_values, max_depth = compute_meltdown_values(name)

		local products = {}
		for product_name, value in pairs(product_values) do
			table.insert(products, convert_product_to_result(product_name, value))
		end

		data:extend({
			{
				type = "recipe",
				name = name .. "-meltdown",
				localised_name = { "recipe-name.Inverted-Quality-meltdown", common.get_item_localised_name(item.name) },
				hidden = item.hidden and true or false,
				-- hidden_in_factoriopedia = true,
				hide_from_player_crafting = true,
				hide_from_signal_gui = true,
				category = "Inverted-Quality-meltdown",
				subgroup = "Inverted-Quality-meltdown",
				energy_required = 0.4,
				ingredients = { { type = "item", name = name, amount = 1 } },
				results = products,
				icons = common.generate_meltdown_recipe_icons_from_item(item),
				order = tostring(max_depth),
				enabled = true,
				auto_recycle = false,
				show_amount_in_title = false,
				unlock_results = false,
			},
		})
	end
end
