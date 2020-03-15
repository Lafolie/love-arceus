-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Rider",
	"Ramming Speed",
	"Conqueror's March",
	"Ride as One",
	"Lean In",
	"Cavalier's Reprisal",
	"Overrun"
}

-- local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

return parser("rider.txt", "Rider Class", names, strip)