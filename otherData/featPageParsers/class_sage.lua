-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Sage",
	"Sacred Shield",
	"Mystic Defense",
	"Sage's Benediction",
	"Lay on Hands",
	"Highly Responsive to Prayers",
	"Divine Wind"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

local function fixFeats(feats)
	-- apply some errata as notes, May 2015 Packet
	for k, feat in ipairs(feats) do
		if feat.name == "Sage's Benediction" then
			local fx, listStr = m(feat.fx, "(.-)(Reflect:.+)")
			local items = {"Reflect:", "Light Screen:", "Safeguard:", "Lucky Chant:"}

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

return parser("sage.txt", "Sage Class", names, strip, post)