-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Telepath",
	"Honed Mind",
	"Telepathic Awareness",
	"Thought Detection",
	"Telepathic Warning",
	"Mental Assault",
	"Suggestion"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

return parser("telepath.txt", "Telepath Class", names, strip)