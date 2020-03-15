-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Survivalist",
	"Natural Fighter",
	"Trapper",
	"Wilderness Guide",
	"Terrain Talent",
	"Adaptive Geography"
}

local m = string.match
local secParser = require "otherData.util_sectionParser"

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return m(str, "(.-)Terrain Talents\r\n")
end

local function fixFeats(feats)
	-- apply some errata as notes, May 2015 Packet
	for k, feat in ipairs(feats) do
		local fx, listStr, items
		if feat.name == "Trapper" then
			fx, listStr = m(feat.fx, "(.-)(Dust Trap.+)")
			items = {"Dust Trap", "Tangle Trap", "Slick Trap", "Abrasion Trap"}

		elseif feat.name == "Wilderness Guide" then
			fx, listStr = m(feat.fx, "(.-)(Grassland.+)")
			items = {"Grassland or Forest:", "Ocean or Wetlands:", "Desert or Tundra:", "Mountain or Cave:", "Urban:"}
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
	local ex = {}
	local exStr = m(str, "(Terrain Talents\r\n.+)")
	
	-- metadata for the secParser
	local static = {name = "freq", str = "Static"}
	local effect = {name = "fx", str = "Effect:", trim = true}

	local function makeMeta(name, ...)
		local nameTbl = {name = "name", str = name}
		return {nameTbl, ...}
	end

	local meta = 
	{
		makeMeta("Plains Runner", static, effect),
		makeMeta("Forest Ranger", static, effect),
		makeMeta("Marsh Stomper", static, effect),
		makeMeta("Deep Diver", static, effect),
		makeMeta("Arctic Pilgrim", static, effect),
		makeMeta("Surefooted", static, effect),
		makeMeta("Cave Dweller", static, effect),
		makeMeta("Traceur", static, effect),
		makeMeta("Dune Walker", static, effect),
	}

	-- split into chunks
	local chunkMeta = {}
	for k, v in ipairs(meta) do
		table.insert(chunkMeta, {name = k, str = v[1].str})
	end
	local chunks = secParser(exStr, chunkMeta)

	-- parse chunks
	local talents = {}
	for k, chunk in ipairs(chunks) do
		local talent = secParser(chunk, meta[k])
		table.insert(talents, talent)
	end

	fixFeats(feats)
	ex.terrainTalents = talents
	return ex
end

return parser("survivalist.txt", "Survivalist Class", names, strip, post)