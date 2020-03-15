-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Enduring Soul",
	"Staying Power",
	"Shrug Off",
	"Awareness",
	"Resilience",
	"Not Yet!",
	"Vim and Vigor"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

return parser("enduringSoul.txt", "Enduring Soul Class", names, strip)