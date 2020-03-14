-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Commander",
	"Mobilize",
	"Leadership",
	"Battle Conductor",
	"Complex Orders",
	"Tip the Scales",
	"Scheme Twist"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	-- return m(str, "(.+)Cone, Line, Burst, and Blast Moves\r\n")
	return str
end

return parser("commander.txt", "Commander Class", names, strip)