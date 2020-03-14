local m = string.match

function findNamesWithSpaces(pokeData)
	
	local result = {}
	for k, poke in ipairs(pokeData) do
		if m(poke.name, '%s') then
			print(poke.name)
			table.insert(result, poke.name)
		end
	end
	love.filesystem.write('namesWithSpaces.txt', table.concat(result, '\n'))
end

function loadFormesList(fileName, dex)
	local result = {}
	for line in love.filesystem.lines(fileName) do
		local firstWord, forme = m(line, "^(.-)%s(.*)")
		local name = m(line, "(.*)%c*")
		result[name] = {name = firstWord, forme = forme}
		-- print(name, firstWord, forme)
	end
	return result
end

