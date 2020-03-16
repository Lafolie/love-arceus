-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Ninja",
	"Ninja's Arsenal",
	"Poison Weapons",
	"Genjutsu",
	"Utility Drop",
	"Weightless Step"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

return parser("ninja.txt", "Ninja Class", names, strip)