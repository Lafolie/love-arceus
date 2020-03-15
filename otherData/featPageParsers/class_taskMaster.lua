-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Taskmaster",
	"Quick Healing",
	"Savage Strike",
	"Strike of the Whip",
	"Pain Resistance",
	"Press On!",
	"Desperate Strike",
	"Deadly Gambit"
}

-- local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

return parser("taskmaster.txt", "Taskmaster Class", names, strip)