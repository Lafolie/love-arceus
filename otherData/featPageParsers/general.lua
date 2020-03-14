-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Command Versatility",
	"Press",
	"Quick Switch",
	"Species Savant",
	"Tutoring"
}

local function strip(parser, str)
	local firstFeat = parser.names[1]
	return string.match(str, ".*\r\n(" .. firstFeat .. ".+)Pokémon Raising and Battling Features")
end

return parser("general.txt", "Pokémon Raising and Battling", names, strip)