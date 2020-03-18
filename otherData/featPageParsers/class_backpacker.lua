-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Backpacker",
	"Item Mastery",
	"Equipment Savant",
	"Hero's Journey"
}

local m = string.match
local secParser = require "otherData.util_sectionParser"

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return m(str, "(.-)Backpacker Talents\r\n")
end

local function post(feats, str)
	local ex = {}
	local exStr = m(str, "\r\n(Backpacker Talents\r\n.+)")
	
	-- metadata for the secParser
	local static = {name = "freq", str = "Static"}
	local effect = {name = "fx", str = "Effect:", trim = true}

	local function makeMeta(name, ...)
		local nameTbl = {name = "name", str = name}
		return {nameTbl, ...}
	end

	local meta = 
	{
		makeMeta("Call to Adventure", static, effect),
		makeMeta("Frisk", static, effect),
		makeMeta("Handyman", static, effect),
		makeMeta("Hat Trick", static, effect),
		makeMeta("Movement Mastery", static, effect),
		makeMeta("Sole Power", static, effect),
		makeMeta("Wayfarer", static, effect),
		makeMeta("Wear it Better", static, effect)
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

	ex.backpackerTalents = talents
	return ex
end

return parser("backpacker.txt", "Backpacker Class", names, strip, post)