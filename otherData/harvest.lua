local gsub = string.gsub

local accentedE = string.char(0xe9)
local dash = string.char(0xad)
local dgt = string.char(0xbb)
function replaceBadChars(s)
	s = gsub(s, accentedE, "é")
	s = gsub(s, dash, "-")
	s = gsub(s, dgt, "")
	return s
end

require "otherData.moves"
require "otherData.abilities"
require "otherData.capabilities"
require "otherData.edges"
require "otherData.feats"

function harvestOtherData()
	local moves, capabilities, abilities, items, features, edges = {}, {}, {}, {}, {}, {}

	-- handle moves
	if sessionConfig 'moves' then
		for k, v in ipairs(loadMovesPages()) do
			v = replaceBadChars(v)
			parseMovePage(v, moves)
		end

		love.filesystem.write("json/moves.json", json.encode(moves))
	end

	-- handle abilities
	if sessionConfig 'abilities' then
		for k, v in ipairs(loadAbilityPages()) do
			v = replaceBadChars(v)
			parseAbilityPage(v, abilities)
		end
		hugePurePowerHax(abilities)

		love.filesystem.write("json/abilities.json", json.encode(abilities))
	end

	-- handle capabilities
	if sessionConfig 'capabilities' then
		parseCapabilitiesData(capabilities)
		love.filesystem.write("json/capabilities.json", json.encode(capabilities))
	end

	-- handle edges
	if sessionConfig 'edges' then
		parseEdgesData(edges)
		love.filesystem.write("json/edges.json", json.encode(edges))
	end

	-- handle feats
	if sessionConfig 'feats' then
		parseFeaturesData(features)
		love.filesystem.write("json/features.json", json.encode(features))
	end
end





