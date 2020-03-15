-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Hunter",
	"Pack Tactics",
	"Surprise!",
	"Hunter's Reflexes",
	"Finisher",
	"Don't Look Away",
	"Pack Master"
}

-- local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

return parser("hunter.txt", "Hunter Class", names, strip)