-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Duelist",
	"Expend Momentum",
	"Effective Methods",
	"Directed Focus",
	"Type Methodology",
	"Duelist's Manual",
	"Seize The Moment"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

return parser("duelist.txt", "Duelist Class", names, strip)