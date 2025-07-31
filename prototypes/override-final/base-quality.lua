local common = require("common")

local degradation_chance = settings.startup["inverted-quality-degradation-chance"].value

for _, type in pairs({
	"assembling-machine",
	"rocket-silo",
	"lab",
}) do
	for name, e in pairs(data.raw[type]) do
		if not e.effect_receiver then
			e.effect_receiver = {}
		end
		if not e.effect_receiver.base_effect then
			e.effect_receiver.base_effect = {}
		end
		e.effect_receiver.base_effect.quality = degradation_chance * 10 - (e.effect_receiver.base_effect.quality or 0)
		-- if name == "Inverted-Quality-meltdown-facility" or name == "Inverted-Quality-downgrade-port" then
		-- 	e.effect_receiver.base_effect.quality = -100
		-- end
	end
end
