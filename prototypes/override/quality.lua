data.raw.quality.normal.icon = "__Inverted-Quality__/graphics/icons/degradation-1.png"
data.raw.quality.normal.color = { 238, 238, 238 }
data.raw.quality.normal.beacon_power_usage_multiplier = 1
data.raw.quality.normal.mining_drill_resource_drain_multiplier = 1
data.raw.quality.normal.science_pack_drain_multiplier = 1

data.raw.quality.uncommon.icon = "__Inverted-Quality__/graphics/icons/degradation-2.png"
data.raw.quality.uncommon.color = { 55, 55, 21 }
data.raw.quality.uncommon.beacon_power_usage_multiplier = 1
data.raw.quality.uncommon.mining_drill_resource_drain_multiplier = 1
data.raw.quality.uncommon.science_pack_drain_multiplier = 1

data.raw.quality.rare.icon = "__Inverted-Quality__/graphics/icons/degradation-3.png"
data.raw.quality.rare.color = { 82, 43, 15 }
data.raw.quality.rare.beacon_power_usage_multiplier = 1
data.raw.quality.rare.mining_drill_resource_drain_multiplier = 1
data.raw.quality.rare.science_pack_drain_multiplier = 1

data.raw.quality.epic.icon = "__Inverted-Quality__/graphics/icons/degradation-4.png"
data.raw.quality.epic.color = { 96, 11, 16 }
data.raw.quality.epic.beacon_power_usage_multiplier = 1
data.raw.quality.epic.mining_drill_resource_drain_multiplier = 1
data.raw.quality.epic.science_pack_drain_multiplier = 1

data.raw.quality.legendary.icon = "__Inverted-Quality__/graphics/icons/degradation-5.png"
data.raw.quality.legendary.color = { 53, 31, 25 }
data.raw.quality.legendary.beacon_power_usage_multiplier = 1
data.raw.quality.legendary.mining_drill_resource_drain_multiplier = 1
data.raw.quality.legendary.science_pack_drain_multiplier = 1
data.raw.quality.legendary.hidden = true

for _, quality in pairs(data.raw.quality) do
	quality.level = 5 - quality.level
end

-- data.raw.quality.normal.level = 10
-- data.raw.quality.normal.icon = "__Inverted-Quality__/graphics/icons/degradation-1.png"
-- data.raw.quality.normal.color = { 238, 238, 238 }
-- data.raw.quality.normal.next = "worn"

-- data.raw.quality.uncommon.hidden = true
-- data.raw.quality.rare.hidden = true
-- data.raw.quality.epic.hidden = true
-- data.raw.quality.legendary.hidden = true
