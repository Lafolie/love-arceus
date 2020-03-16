-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Aura Guardian",
	"Aura Reader",
	"The Power of Aura",
	"Sword of Body and Soul",
	"Ambient Aura",
	"Aura Mastery"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

local function fixFeats(feats)
	-- apply some errata as notes, May 2015 Packet
	for k, feat in ipairs(feats) do
		if feat.name == "Ambient Aura" then
			local fx, listStr = m(feat.fx, "(.-)(You create an.+)")
			local items = {"You create an", "You cure yourself", "Gain the Blindsense"}

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

return parser("auraGuardian.txt", "Aura Guardian Class", names, strip, post)