local common = require("common")

for _, type in pairs({ "item", "tool" }) do
	if data.raw[type] then
		for name, item in pairs(data.raw[type]) do
			data:extend({
				{
					type = "recipe",
					name = name .. "-porting",
					localised_name = {
						"recipe-name.Inverted-Quality-compatibility-porting",
						common.get_item_localised_name(item.name),
					},
					hidden = item.hidden and true or false,
					category = "Inverted-Quality-porting",
					energy_required = 1 / 15,
					enabled = true,
					ingredients = { { type = "item", name = name, amount = 1 } },
					results = { { type = "item", name = name, amount = 1 } },
					hidden_in_factoriopedia = true,
					hide_from_player_crafting = true,
					hide_from_signal_gui = true,
					auto_recycle = false,
					show_amount_in_title = false,
					unlock_results = false,
					allow_speed = false,
					allow_productivity = false,
					allow_quality = false,
					allow_pollution = false,
					allow_consumption = false,
				},
			})
		end
	end
end
