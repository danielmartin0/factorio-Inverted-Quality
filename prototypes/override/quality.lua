data.raw.quality.normal.color = { 238, 238, 238 }
data.raw.quality.normal.next = "shoddy"

for name, quality in pairs(data.raw.quality) do
	if quality.level and quality.level > 0 then
		quality.hidden = true
	end
end
