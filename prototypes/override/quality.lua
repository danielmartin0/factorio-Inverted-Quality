data.raw.quality.normal.color = { 238, 238, 238 }
data.raw.quality.normal.beacon_power_usage_multiplier = 1
data.raw.quality.normal.mining_drill_resource_drain_multiplier = 1
data.raw.quality.normal.science_pack_drain_multiplier = 1
data.raw.quality.normal.next = "shoddy"
data.raw.quality.normal.order = "e"

for name, quality in pairs(data.raw.quality) do
	if quality.level and quality.level > 0 then
		quality.hidden = true
	end
end
