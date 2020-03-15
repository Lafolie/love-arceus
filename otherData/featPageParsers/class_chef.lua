-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Chef",
	"Hits the Spot",
	"Culinary Appreciation",
	"Accentuated Taste",
	"Complex Aftertaste",
	"Dietician",
	"Dumplings"
}

local m = string.match
local secParser = require "otherData.util_sectionParser"

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	str = string.gsub(str, "Digestion Buff", "Food Buff") --errata, May 2015 Packet
	return m(str, "(.-)Tasty Snacks\r\n")
end

local function fixFeats(feats)
	-- apply some errata as notes, May 2015 Packet
	for k, feat in ipairs(feats) do
		if feat.name == "Chef" then
			feat.note = "Chefs need access to a kitchen or to a Cooking Kit to create food. When Chefs create a food item, let them fluff it however they like! Perhaps one Chef likes to make puff pastries, perhaps another makes healthy treats; perhaps another is a Soup specialist. Let your players get creative in the description of their foods!"
		
		elseif feat.name == "Dumplings" then
			feat.note = "Dumplings cannot be used to make other Dumpling items. No infinite recursion, please."
		
		elseif feat.name == "Accentuated Taste" then
			feat.note = "The bonus from Accentuated Taste can only be gained once per item, even if Complex Aftertaste is used to give an additional Food Buff for the item."

			--also, listify this one
			local fx, listStr = m(feat.fx, "(.-)(Salty:.+)")
			local flavours = {"Salty:", "Spicy:", "Sour:", "Dry:", "Bitter:", "Sweet:", "$"}
			local list = {}
			for n = 1, #flavours - 1 do
				local ptn = string.format("(%s.-)%s", flavours[n], flavours[n+1])
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
	local exStr = m(str, "(Tasty Snacks\r\n.+)\r\nChef Recipes")
	
	-- metadata for the secParser
	local ingredients = {name = "ingredients", str = "Ingredients:", trim = true}
	local cost = {name = "cost", str = "Cost:", trim = true}
	local effect = {name = "fx", str = "Effect:", trim = true}
	local prerequisites = {name = "preqs", str = "Prerequisites:", trim = true}

	local function makeMeta(name, ...)
		local nameTbl = {name = "name", str = name}
		return {nameTbl, ...}
	end

	local meta = 
	{
		makeMeta("Tasty Snacks", prerequisites, cost, effect),
		makeMeta("Salty Surprise[\r\n%s]", effect),
		makeMeta("Spicy Wrap[\r\n%s]", effect),
		makeMeta("Sour Candy[\r\n%s]", effect),
		makeMeta("Dry Wafer[\r\n%s]", effect),
		makeMeta("Bitter Treat[\r\n%s]", effect),
		makeMeta("Sweet Confection[\r\n%s]", effect),
		makeMeta("Meal Planner", prerequisites, effect),
		makeMeta("Hearty Meal", prerequisites, ingredients, effect),
		makeMeta("Bait Mixer", prerequisites, cost, effect),
		makeMeta("Preserves", prerequisites, ingredients, effect),
		makeMeta("Leftovers", prerequisites, cost, effect),
		makeMeta("Vitamins", prerequisites, effect)
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

	fixFeats(feats)
	ex.recipes = recipes
	return ex
end

return parser("chef.txt", "Chef Class", names, strip, post)