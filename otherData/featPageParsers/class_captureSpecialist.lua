-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Capture Specialist",
	"Advanced Capture Techniques",
	"Captured Momentum",
	"Gotta Catch 'Em All"
}

local m = string.match

local function strip(parser, str)
	local firstFeat = parser.names[1]
	str = string.gsub(str, "`", "'")
	return m(str, "^(.-)\r\nCapture Skills\r\n")
end

local secParser = require "otherData.util_sectionParser"

local function post(feats, str)
	local ex = {}
	local exStr = m(str, "\r\n(Capture Skills\r\n.+)Capture Techniques")
	local captureTechniques = {}
	-- let's do it the hard way
	local techStr = m(str, "^(Capture Skills.-)\r\nCurve Ball\r\n")

	-- metadata for the secParser
	local static = {name = "freq", str = "Static"}
	local effect = {name = "fx", str = "Effect:", trim = true}
	local daily = {name = "freq", str = "Daily"}
	local scene = {name = "freq", str = "Scene"}
	local ap = {name = "freq", str = "%d AP"}
	local trigger = {name = "trigger", str = "Trigger:", trim = true}
	local chooseOne = {name = "choosefx", str = "Choose One Effect:", trim = true}
	local prerequisites = {name = "preqs", str = "Prerequisites:", trim = true}

	local meta = 
	{
		{{name = "name", str = "Capture Skills"}, static, effect},
		{{name = "name", str = "Curve Ball"}, static, effect},
		{{name = "name", str = "Devitalizing Throw"}, ap, trigger, chooseOne},
		{{name = "name", str = "Fast Pitch"}, ap, effect},
		{{name = "name", str = "Snare"}, static, effect},
		{{name = "name", str = "Tools of the Trade"}, static, effect},
		{{name = "name", str = "Catch Combo"}, prerequisites, daily, trigger, effect},
		{{name = "name", str = "False Strike"}, prerequisites, scene, trigger, effect},
		{{name = "name", str = "Relentless Pursuit"}, prerequisites, ap, trigger, effect}
	}

	-- split the string into chunks
	local chunkMeta = {}
	for k, v in ipairs(meta) do
		table.insert(chunkMeta, {name = k, str = v[1].str})
	end
	local chunks = secParser(exStr, chunkMeta)

	-- parse chunks into techs
	for k, chunk in ipairs(chunks) do
		local tech = secParser(chunk, meta[k])
		table.insert(captureTechniques, tech)
	end

	ex.captureTechniques = captureTechniques
	return ex
end

return parser("captureSpecialist.txt", "Capture Specialist Class", names, strip, post)