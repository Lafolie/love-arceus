-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Cheerleader",
	"Moment of Action",
	"Cheers",
	"Inspirational Support",
	"Bring It On!",
	"Go, Fight, Win!",
	"Keep Fighting!"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

return parser("cheerleaderErrata.txt", "Cheerleader Class", names, strip)