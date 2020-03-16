-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Hex Maniac",
	"Hex Maniac Studies",
	"Diffuse Pain",
	"Malediction",
	"Grand Hex"
}

local m = string.match
-- local secParser = require "otherData.util_sectionParser"

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

local function fixFeats(feats)
	-- apply some errata as notes, May 2015 Packet
	for k, feat in ipairs(feats) do
		if feat.name == "Hex Maniac Studies" then
			feat.fx = m(feat.fx, "(.-) Hex Maniac Moves ")
			feat.tbl = 
			{
				{"Hex Maniac Moves", "Rank"},
				{"Confuse Ray", "1"},
				{"Curse", "1"},
				{"Hypnosis", "1"},
				{"Spite", "1"},
				{"Will-O-Wisp", "1"},
				{"Hex", "3"}
			}
		end
	end
end

local function post(feats, str)
	fixFeats(feats)
end

return parser("hexManiac.txt", "Hex Maniac Class", names, strip, post)