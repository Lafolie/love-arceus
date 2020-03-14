-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Ace Trainer",
	"Perseverance",
	"Elite Trainer",
	"Critical Moment",
	"Top Percentage",
	"Signature Technique",
	"Champ in the Making"
}

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return string.match(str, "(.-)Cone, Line, Burst, and Blast Moves\r\n")
end

local function post(feats, str)
	local ex = {}
	local techniqueModifications = 1
end

return parser("aceTrainer.txt", "Ace Trainer Class", names, strip)