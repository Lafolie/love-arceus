-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Telekinetic",
	"PK Alpha",
	"PK Omega",
	"Power of the Mind",
	"PK Combat",
	"Telekinetic Burst",
	"Psionic Overload"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

local function fixFeats(feats)
	-- apply some errata as notes, May 2015 Packet
	for k, feat in ipairs(feats) do
		if feat.name == "Psionic Overload" then
			local fx, listStr = m(feat.fx, "(.-)(Kinesis:.+)")
			local items = {"Kinesis:", "Barrier:", "Psychic:", "Telekinesis:"}

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

return parser("telekinetic.txt", "Telekinetic Class", names, strip, post)