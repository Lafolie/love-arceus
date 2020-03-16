-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Channeler",
	"Shared Senses",
	"Battle Synchronization",
	"Spirit Boost",
	"Power Conduit",
	"Pain Dampening",
	"Soothing Connection"
}

local m = string.match
local secParser = require "otherData.util_sectionParser"

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

local function fixFeats(feats)
	for k, feat in ipairs(feats) do
		local fx, listStr, items
		if feat.name == "Spirit Boost" then
			fx, listStr = m(feat.fx, "(.-)(Attack:.+)")
			items = {"Attack", "Defense", "Special Attack", "Special Defense", "Speed"}

		elseif feat.name == "Power Conduit" then
			listStr = feat.choosefx
			items = {"Trade all", "Transfer a", "Give up"}

		elseif feat.name == "Channeler" then
			-- set mechanic property
			-- has to be done here since it has a generic "Mechanic:" identifier
			local fx, mechanic = m(feat.fx, "(.-) Mechanic: (.+)")
			feat.fx = fx
			feat.mechanicChanneling = mechanic
		end

		--listify this one
		if listStr then
			table.insert(items, "$")
			local list = {}
			for n = 1, #items - 1 do
				local ptn = string.format("(%s.-)%s", items[n], items[n+1])
				local li = m(listStr, ptn)
				table.insert(list, li)
			end
			feat.fx = fx
			feat.list = list
		end
	end
end

local function post(feats, str)
	fixFeats(feats)
end

return parser("channeler.txt", "Channeler Class", names, strip, post)