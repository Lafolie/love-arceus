-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Hobbyist",
	"Dilettante",
	"Dabbler",
	"Look and Learn"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return m(str, "(.-)Scene Features List Action Point Features List\r\n")
end

local function post(feats, str)
	local ex = {}
	-- local exStr = m(str, "Trainer Class Feature Prerequisite Trainer Class Feature Prerequisite\r\n(.+)")
	
	local sceneFeats = {}
	local actionFeats = {}

	local function makeFeat(tbl, class, name, preqs)
		table.insert(tbl, {name = name, class = class, preqs = preqs})
	end

	-- fuck this grid shit, do it manually
	makeFeat(sceneFeats, "Ace Trainer", "Critical Moment", "Commander's Voice")
	makeFeat(sceneFeats, "Capture Specialist", "Capture Techniques (False Strike and Catch Combo Only", "Poké Ball Crafter")
	makeFeat(sceneFeats, "Enduring Soul", "Staying Power", "Medic Training")
	makeFeat(sceneFeats, "Trickster", "Sleight", "Command Versatility")
	makeFeat(sceneFeats, "Researcher", "Chemical Warfare", "Repel Crafter")
	makeFeat(sceneFeats, "Roughneck", "Mettle", "Defender")

	makeFeat(actionFeats, "Coordinator", "Nuanced Performance", "Grace")
	makeFeat(actionFeats, "Juggler", "Round Trip", "Quick Switch")
	makeFeat(actionFeats, "Chef", "Hits the Spot", "Basic Cooking")
	makeFeat(actionFeats, "Fashionista", "Style is Eternal", "Groomer")
	makeFeat(actionFeats, "Athlete", "Coaching", "Swimmer")
	makeFeat(actionFeats, "Tumbler", "Quick Gymnastics", "Acrobat")

	ex.sceneFeats = sceneFeats
	ex.actionFeats = actionFeats
	return ex
end

return parser("hobbyist.txt", "Hobbyist Class", names, strip, post)