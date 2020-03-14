-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Blur",
	"Defender",
	"Dive",
	"Fighter's Versatility",
	"Multi%-Tasking",
	"Signature Move",
	"Type Expertise",
	"Walk It Off"
}

-- local function strip(parser, str)
-- 	local firstFeat = parser.names[1]
-- 	return string.match(str, ".*\r\n(" .. firstFeat .. ".+)Pokémon Raising and Battling Features")
-- end

return parser("combat.txt", "Combat", names)