-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Chronicler",
	"Archival Training",
	"Archive Tutor",
	"Targeted Profiling",
	"Observation Party",
	"Cinematic Analysis"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

local function post(feats, str)
	local ex = {}

	return ex
end

return parser("chronicler.txt", "Chronicler Class", names, strip)