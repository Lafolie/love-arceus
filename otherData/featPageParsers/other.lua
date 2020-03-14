-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"First Aid Expertise",
	"Let Me Help You With That",
	"Poké Ball Crafter",
	"PokéManiac",
	"Psionic Sight",
	"Skill Monkey"
}

-- local function strip(parser, str)
-- 	local firstFeat = parser.names[1]
-- 	return string.match(str, ".*\r\n(" .. firstFeat .. ".+)Pokémon Raising and Battling Features")
-- end

return parser("other.txt", "Other", names)