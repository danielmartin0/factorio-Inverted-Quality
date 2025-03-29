for _, type in pairs({
	"assembling-machine",
	"furnace",
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
		if name == "Inverted-Quality-meltdown-facility" or name == "Inverted-Quality-compatibility-port" then
			e.effect_receiver.base_effect.quality = -100
		else
			e.effect_receiver.base_effect.quality = 2.25 - (e.effect_receiver.base_effect.quality or 0) -- Defaults to 90%
		end
	end
end
