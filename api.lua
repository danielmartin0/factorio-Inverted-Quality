if InvertedQuality == nil then
	InvertedQuality = {
		entity = {}
	}

	function InvertedQuality.ignore_machine(entity_name)
		if InvertedQuality.entity[entity_name] then
			InvertedQuality.entity[entity_name].ignore = true
		else
			InvertedQuality.entity[entity_name] = {ignore=true}
		end
	end
end
