-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Provocateur",
	"Push Buttons",
	"Quick Wit",
	"Mixed Messages",
	"Powerful Motivator",
	"Play Them Like a Fiddle",
	"Enchanting Gaze"
}

local m = string.match
local secParser = require "otherData.util_sectionParser"

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

local function fixFeats(feats)
	-- apply some errata as notes, May 2015 Packet
	for k, feat in ipairs(feats) do
		local fx, listStr, items
		local items = {"Baby%-Doll Eyes:", "Confide:", "Leer:", "Sweet Kiss", "Taunt:", "Torment:", "Lovely Kiss:"}
		
		if feat.name == "Powerful Motivator" or feat.name == "Play Them Like a Fiddle" then
			fx, listStr = m(feat.fx, "(.-)(Baby%-Doll Eyes:.+)")
		end

		--listify this one
		if fx then
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

return parser("provocateur.txt", "Provocateur Class", names, strip, post)