-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Fashionista",
	"Dashing Makeover",
	"Style is Eternal",
	"Accessorize",
	"Parfumier",
	"Versatile Wardrobe",
	"Dress to Impress"
}

local m = string.match
local secParser = require "otherData.util_sectionParser"

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return m(str, "(.-)Contest Trends\r\n")
end

local function post(feats, str)
	local ex = {}
	local exStr = m(str, ".-(Contest Trends\r\n.+)")

	-- metadata for the secParser
	local fskill = {name = "skill", str = "Fashionista Skill:", trim = true}
	local cost = {name = "cost", str = "Cost:", trim = true}
	local effect = {name = "fx", str = "Effect:", trim = true}
	local prerequisites = {name = "preqs", str = "Prerequisites:", trim = true}

	local function makeMeta(name, ...)
		local nameTbl = {name = "name", str = name}
		return {nameTbl, ...}
	end

	local meta = 
	{
		makeMeta("Contest Trends", prerequisites, effect),
		makeMeta("Basic Fashion", prerequisites, cost, effect),
		makeMeta("Adorable Fashion", fskill, effect),
		makeMeta("Elegant Fashion", fskill, effect),
		makeMeta("Rad Fashion", fskill, effect),
		makeMeta("Rough Fashion", fskill, effect),
		makeMeta("Slick Fashion", fskill, effect),
		makeMeta("Practical Fashion", prerequisites, effect),
		makeMeta("Focused Fashion", prerequisites, effect),
		makeMeta("Incense Maker", prerequisites, effect),

	}

	-- split into chunks
	local chunkMeta = {}
	for k, v in ipairs(meta) do
		table.insert(chunkMeta, {name = k, str = v[1].str})
	end
	local chunks = secParser(exStr, chunkMeta)

	-- parse chunks
	local recipes = {}
	for k, chunk in ipairs(chunks) do
		local recipe = secParser(chunk, meta[k])
		table.insert(recipes, recipe)
	end
	ex.recipes = recipes
	return ex
end

return parser("fashionista.txt", "Fashionista Class", names, strip, post)