-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Warper",
	"Space Distortion",
	"Warping Ground",
	"Strange Energy",
	"Farcast",
	"Warped Transmission",
	"Reality Bender"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	str = string.gsub(str, "Doxy:", "Note:")
	return str
end

return parser("warper.txt", "Warper Class", names, strip)