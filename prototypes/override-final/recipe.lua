-- Intermediates skip the handcrafting quality degradation:
for _, recipe in pairs(data.raw.recipe) do
	recipe.allow_intermediates = false
	recipe.allow_as_intermediate = false
end
