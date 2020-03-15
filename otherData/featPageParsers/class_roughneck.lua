-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Roughneck",
	"Menace",
	"Mettle",
	"Malice",
	"Fearsome Display",
	"Cruel Gaze",
	"Tough as Nails"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

local function fixFeats(feats)
	-- apply some errata as notes, May 2015 Packet
	for k, feat in ipairs(feats) do
		if feat.name == "Fearsome Display" then
			local fx, listStr = m(feat.fx, "(.-)(Leer:.+)")
			local items = {"Leer:", "Chip Away:", "Headbutt:", "Glare:", "Mean Look:", "Endure:", "Slack Off:"}

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

return parser("roughneck.txt", "Roughneck Class", names, strip, post)