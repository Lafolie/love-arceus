-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Researcher",
	-- general research field
	"Breadth of Knowledge",
	"Bookworm",
	"Well Read",
	"Echoes of the Future",
	-- apothecary
	"Apothecary",
	"Patch Cure",
	"Medical Techniques",
	"Medicinal Blend",
	-- artificer
	"Crystal Artificer",
	"Crystal Resonance",
	"Rainbow Light",
	"Fistful of Force",
	-- botany
	"Seed Bag",
	"Top Tier Berries",
	"Herb Lore",
	-- chemisty
	"Chemist",
	"Chemical Warfare",
	"Caustic Chemistry",
	"Playing God",
	-- climatology
	"Climatology",
	"Climate Control",
	"Weather Systems",
	"Extreme Weather",
	-- occultism
	"Witch Hunter",
	"Psionic Analysis",
	"Mental Resistance",
	"Immutable Mind",
	-- paleontology
	"Fossil Restoration",
	"Ancient Heritage",
	"Genetic Memory",
	"Prehistoric Bond",
	-- pokémon caretaking
	"Pusher",
	"This One's Special, I Know It",
	"Skill Trainer",
	"Re%-Balancing",
	-- gadgeteer
	"Improvised Gadgets",
	"I Meant to Do That",
	"Capsule Science",
	"Enhanced Capsules"
}

local m = string.match
local gsub = string.gsub
local secParser = require "otherData.util_sectionParser"

local headings = 
	{
		"General Research Field",
		"Apothecary Research Field",
		"Artificer Research Field",
		"Botany Research Field",
		"Chemistry Research Field",
		"Climatology Research Field",
		"Occultism Research Field",
		"General Research Field",
		"Paleontology Research Field",
		"Pokémon Caretaking Research Field",
		"Gadgeteer Research Field"
	}

local gadgeteerRecipes

local log = logger 'researcherDebugLog.txt'

local function strip(parser, str)
	-- load the errata pages
	local pages = getPages({"otherData/core/features/gadgeteer.txt"})
	local flat = table.concat(pages, "\r\n")
	flat = replaceBadChars(flat)
	flat = gsub(flat, "May 2015 Playtest\r\n%d*\r\n", "")

	-- apply errata
	local gadgeteer, general = m(flat, "(Improvised Gadgets\r\n.-)Additional Changes\r\n.-(General Research Field.-)Book Item Mechanics\r\n")
	str = gsub(str, "General Research Field.-best result%.", general)
	str = str .. gadgeteer
	log:print(gadgeteer)
	-- save gadeteer stuff for later
	gadgeteerRecipes = m(gadgeteer, "\r\nGadgeteer Recipes\r\n.-5000%.")

	-- remove headings
	str = gsub(str, "\r\nResearcher Fields of Study\r\n", "\r\n")
	for k, heading in ipairs(headings) do
		local heading = string.format("\r\n%s\r\n", heading)
		str = gsub(str, heading, "\r\n")
	end

	-- strip recipie chunks
	str = gsub(str, "\r\nApothecary Recipes\r\n.-cost%.", "\r\n")
	str = gsub(str, "\r\nArtificer Recipes\r\n.-Brace used%.", "\r\n")
	str = gsub(str, "\r\nChemistry Recipes\r\n.-Sleep%.", "\r\n")
	str = gsub(str, "\r\nGadgeteer Recipes\r\n.-5000%.", "\r\n")

	-- fix botany Seed Bag fx (listified later)
	local str = gsub(str, "(Rank 1 Effect:.-Worry Seed%.)", "Effect: %1")

	return str
end

local categoryLUT = {}
categoryLUT["Breadth of Knowledge"] = "General Research Field"
categoryLUT["Bookworm"] = "General Research Field"
categoryLUT["Well Read"] = "General Research Field"
categoryLUT["Echoes of the Future"] = "General Research Field"
categoryLUT["Apothecary"] = "Apothecary Research Field"
categoryLUT["Patch Cure"] = "Apothecary Research Field"
categoryLUT["Medical Techniques"] = "Apothecary Research Field"
categoryLUT["Medicinal Blend"] = "Apothecary Research Field"
categoryLUT["Crystal Artificer"] = "Artificer Research Field"
categoryLUT["Crystal Resonance"] = "Artificer Research Field"
categoryLUT["Rainbow Light"] = "Artificer Research Field"
categoryLUT["Fistful of Force"] = "Artificer Research Field"
categoryLUT["Seed Bag"] = "Botany Research Field"
categoryLUT["Top Tier Berries"] = "Botany Research Field"
categoryLUT["Herb Lore"] = "Botany Research Field"
categoryLUT["Chemist"] = "Chemistry Research Field"
categoryLUT["Chemical Warfare"] = "Chemistry Research Field"
categoryLUT["Caustic Chemistry"] = "Chemistry Research Field"
categoryLUT["Playing God"] = "Chemistry Research Field"
categoryLUT["Climatology"] = "Climatology Research Field"
categoryLUT["Climate Control"] = "Climatology Research Field"
categoryLUT["Weather Systems"] = "Climatology Research Field"
categoryLUT["Extreme Weather"] = "Climatology Research Field"
categoryLUT["Witch Hunter"] = "Occultism Research Field"
categoryLUT["Psionic Analysis"] = "Occultism Research Field"
categoryLUT["Mental Resistance"] = "Occultism Research Field"
categoryLUT["Immutable Mind"] = "Occultism Research Field"
categoryLUT["Fossil Restoration"] = "Paleontology Research Field"
categoryLUT["Ancient Heritage"] = "Paleontology Research Field"
categoryLUT["Genetic Memory"] = "Paleontology Research Field"
categoryLUT["Prehistoric Bond"] = "Paleontology Research Field"
categoryLUT["Pusher"] = "Pokémon Caretaking Research Field"
categoryLUT["This One's Special, I Know It"] = "Pokémon Caretaking Research Field"
categoryLUT["Skill Trainer"] = "Pokémon Caretaking Research Field"
categoryLUT["Re-Balancing"] = "Pokémon Caretaking Research Field"
categoryLUT["Improvised Gadgets"] = "Gadgeteer Research Field"
categoryLUT["I Meant to Do That"] = "Gadgeteer Research Field"
categoryLUT["Capsule Science"] = "Gadgeteer Research Field"
categoryLUT["Enhanced Capsules"] = "Gadgeteer Research Field"

local function fixFeats(feats)
	for k, feat in ipairs(feats) do
		-- assign category
		feat.category = categoryLUT[feat.name]

		-- format lists
		local fx, listStr, items
		if feat.name == "Top Tier Berries" then
			fx, listStr = m(feat.fx, "(.-)(Novice:.+)")
			items = {"Novice:", "Adept:", "Expert:", "Master:"}

		elseif feat.name == "Seed Bag" then
			fx, listStr = m(feat.fx, "(.-)(Rank 1 Effect:.+)")
			items = {"Rank 1 Effect:", "Rank 2 Effect:"}

		elseif feat.name == "Herb Lore" then
			fx, listStr = m(feat.fx, "(.-)(Energy Powder:.+)")
			items = {"Energy Powder:", "Heal Powder:", "Poultice:"}

		elseif feat.name == "Playing God" then
			fx, listStr = m(feat.fx, "(.-)(The Pokémon is.+)")
			items = {"The Pokémon is", "The Pokémon adds", "Increase one of"}

		elseif feat.name == "Extreme Weather" then
			fx, listStr = m(feat.fx, "(.-)(Hail:.+)")
			items = {"Hail:", "Rain:", "Sandstorm:", "Sun:"}

		elseif feat.name == "Psionic Analysis" then
			fx, listStr = m(feat.fx, "(.-)(Whether they.+)")
			items = {"Whether they", "Which Psychic", "If they're"}

		elseif feat.name == "Prehistoric Bond" then
			fx, listStr = m(feat.fx, "(.-)(HP.+)")
			items = {"HP", "Attack", "Defense", "Special Attack", "Special Defense", "Speed"}

		elseif feat.name == "I Meant to Do That" then
			fx, listStr = m(feat.fx, "(.-)(Magnetic:.+)")
			items = {"Magnetic:", "Threaded:", "Zapper:"}

		elseif feat.name == "Capsule Science" then
			fx, listStr = m(feat.fx, "(.-)(Bean Caps:.+)")
			items = {"Bean Caps:", "Glue Caps:", "Nets Caps:", "Wonder Launcher:"}

		elseif feat.name == "Enhanced Capsules" then
			fx, listStr = m(feat.fx, "(.-)(Glow:.+)")
			items = {"Glow:", "Magnetic:", "Threaded:", "Zapper:"}
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

-- metadata for the secParser
local effect = {name = "fx", str = "Effects*:", trim = true}
local atWill = {name = "freq", str = "At%-Will"}
local ingredients = {name = "ingredients", str = "Ingredients:", trim = true}
local cost = {name = "cost", str = "Cost:", trim = true}
local prerequisites = {name = "preqs", str = "Prerequisites:", trim = true}

local function makeMeta(name, ...)
	local nameTbl = {name = "name", str = name}
	return {nameTbl, ...}
end

local function parseRecipes(exStr, meta)
	-- p2(exStr)
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

	return recipes
end

local function post(feats, str)
	local ex = {}
	local exStr, meta

	-- parse recipes
	-- apothecary
	exStr = m(str, "\r\nApothecary Recipes\r\n.-cost%.")
	meta = 
	{
		makeMeta("Restorative Science", prerequisites, cost, effect),
		makeMeta("Super Cures", prerequisites, cost, effect),
		makeMeta("Hyper Cures", prerequisites, effect),
		makeMeta("Performance Enhancers", prerequisites, cost, effect)
	}
	ex.apothecaryRecipes = parseRecipes(exStr, meta)
	
	-- artificer, wtf is is with the random plurals?!
	exStr = m(str, "\r\nArtificer Recipes\r\n.-Brace used%.")
	meta =
	{
		makeMeta("Type Booster", prerequisites, ingredients, effect),
		makeMeta("Type Brace", prerequisites, ingredients, effect),
		makeMeta("Focus Gem", prerequisites, ingredients, effect),
		makeMeta("Chakra Crystal", prerequisites, ingredients, effect),
		makeMeta("Rainbow Gem", prerequisites, ingredients, effect),
		makeMeta("Plate Crafter", prerequisites, ingredients, effect)
	}
	ex.artificerRecipes = parseRecipes(exStr, meta)

	-- chemistry
	exStr = m(str, "\r\nChemistry Recipes\r\n.-Sleep%.")
	meta =
	{
		makeMeta("Enhancers", prerequisites, cost, effect),
		makeMeta("Pester Balls: Disorient", prerequisites, cost, effect),
		makeMeta("Pester Balls: Pain", prerequisites, cost, effect),
		makeMeta("Pester Balls: Shut Down", prerequisites, cost, effect)
	}
	ex.chemistryRecipes = parseRecipes(exStr, meta)

	-- gadgeteer
	log:print("------------------")
	log:print(gadgeteerRecipes)
	meta =
	{
		makeMeta("Cap Cannon", atWill, effect),
		makeMeta("Cap Ammo", atWill, effect),
		makeMeta("Wonder Launcher", atWill, effect)
	}
	ex.gadgeteerRecipes = parseRecipes(gadgeteerRecipes, meta)

	fixFeats(feats)

	return ex
end

return parser("researcher.txt", "Researcher Class", names, strip, post)