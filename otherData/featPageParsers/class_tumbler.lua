-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Tumbler",
	"Aerialist",
	"Quick Gymnastics",
	"Flip Out",
	"Death From Above",
	"Quick Reflexes",
	"Burst of Speed"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

local function fixFeats(feats)
	-- apply some errata as notes, May 2015 Packet
	for k, feat in ipairs(feats) do
		if feat.name == "Flip Out" then
			local fx, listStr = m(feat.fx, "(.-)(Aerial Ace:.+)")
			local items = {"Aerial Ace:", "Splash:", "Acrobatics:", "Bounce:"}

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

return parser("tumbler.txt", "Tumbler Class", names, strip, post)