-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Medic",
	"Front Line Healer",
	"Medical Techniques",
	"I'm a Doctor",
	"Proper Care",
	"Stay With Us!"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

local function fixFeats(feats)
	-- apply some errata as notes, May 2015 Packet
	for k, feat in ipairs(feats) do
		if feat.name == "Proper Care" then
			local fx, listStr = m(feat.fx, "(.-)(When you trigger.+)")
			local items = {"When you trigger First", "When you trigger Nurse", "All Restoratives"}

			--listify this one
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

return parser("medic.txt", "Medic Class", names, strip, post)