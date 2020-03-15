-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Juggler",
	"Bounce Shot",
	"Juggling Show",
	"Round Trip",
	"Tag In",
	"Emergency Release",
	"First Blood"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

return parser("juggler.txt", "Juggler Class", names, strip)