-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Type Ace",
	"Type Refresh",
	"Move Sync",
	-- bug
	"Insectoid Utility",
	"Iterative Evolution",
	"Chitin Shield",
	"Disruption Order",
	-- dark
	"Clever Ruse",
	"Sneak Attack",
	"Devious",
	"Black%-Out Strike",
	-- Dragon
	"Tyrant's Roar",
	"Highlander",
	"Unconquerable",
	"This Will Not Stand",
	-- electric
	"Lockdown",
	"Overload",
	"Shocking Speed",
	"Chain Lightning",
	-- fairy
	"Fairy Lights",
	"Arcane Favor",
	"Fey Trance",
	"Fairy Rite",
	-- fighting
	"Close Quarters Mastery",
	"Brawler",
	"Face Me Whelp",
	"Smashing Punishment",
	-- fire
	"Brightest Flame",
	"Trail Blazer",
	"Incandescence",
	"Fan The Flames",
	-- flying
	"Celerity",
	"Gale Strike",
	"Zephyr Shield",
	"Tornado Charge",
	-- ghost
	"Ghost Step",
	"Haunting Curse",
	"Vampirism",
	"Boo!",
	-- grass
	"Foiling Foliage",
	"Sunlight Within",
	"Enduring Bloom",
	"Cross%-Pollinate",
	-- ground
	"Mold the Earth",
	"Desert Heart",
	"Earthroil",
	"Upheaval",
	-- ice
	"Glacial Ice",
	"Polar Vortex",
	"Arctic Zeal",
	"Deep Cold",
	-- normal
	"Extra Ordinary",
	"Plainly Perfect",
	"New Normal",
	"Simple Improvements",
	-- poison
	"Potent Venom",
	"Debilitate",
	"Miasma",
	"Corrosive Blight",
	-- psychic
	"Psionic Sponge",
	"Mindbreak",
	"Psychic Resonance",
	"Force of Will",
	-- rock
	"Gravel Before Me",
	"Bigger and Boulder",
	"Tough as Schist",
	"Gneiss Aim",
	-- steel
	"Polished Shine",
	"Iron Grit",
	"Assault Armor",
	"True Steel",
	-- water
	"Flood!",
	"Fishbowl Technique",
	"Fountain of Life",
	"Aqua Vortex"
}

local m = string.match
local gsub = string.gsub
-- local secParser = require "otherData.util_sectionParser"

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	str = gsub(str, "Cast:", "Note:")
	str = gsub(str, "Prerequisites: Elemental Connection", "Elemental Connection")
	local types = {"Bug", "Dark", "Dragon", "Electric", "Fairy", "Fighting", "Fire", "Flying", "Ghost", "Grass", "Ground", "Ice", "Normal", "Poison", "Psychic", "Rock", "Steel", "Water"}
	for k, v in ipairs(types) do
		str = gsub(str, string.format("\r\n%s Ace Features\r\n", v), "\r\n")
	end

	return string.format("%s\r\n%s", m(str, "(.-)%*Type%-Linked Skills:.-(Insectoid Utility.+)"))
end

local categoryLUT = {}
categoryLUT["Insectoid Utility"] = "Bug Ace Features"
categoryLUT["Iterative Evolution"] = "Bug Ace Features"
categoryLUT["Chitin Shield"] = "Bug Ace Features"
categoryLUT["Disruption Order"] = "Bug Ace Features"
categoryLUT["Clever Ruse"] = "Dark Ace Features"
categoryLUT["Sneak Attack"] = "Dark Ace Features"
categoryLUT["Devious"] = "Dark Ace Features"
categoryLUT["Black-Out Strike"] = "Dark Ace Features"
categoryLUT["Tyrant's Roar"] = "Dragon Ace Features"
categoryLUT["Highlander"] = "Dragon Ace Features"
categoryLUT["Unconquerable"] = "Dragon Ace Features"
categoryLUT["This Will Not Stand"] = "Dragon Ace Features"
categoryLUT["Lockdown"] = "Electric Ace Features"
categoryLUT["Overload"] = "Electric Ace Features"
categoryLUT["Shocking Speed"] = "Electric Ace Features"
categoryLUT["Chain Lightning"] = "Electric Ace Features"
categoryLUT["Fairy Lights"] = "Fairy Ace Features"
categoryLUT["Arcane Favor"] = "Fairy Ace Features"
categoryLUT["Fey Trance"] = "Fairy Ace Features"
categoryLUT["Fairy Rite"] = "Fairy Ace Features"
categoryLUT["Close Quarters Mastery"] = "Fighting Ace Features"
categoryLUT["Brawler"] = "Fighting Ace Features"
categoryLUT["Face Me Whelp"] = "Fighting Ace Features"
categoryLUT["Smashing Punishment"] = "Fighting Ace Features"
categoryLUT["Brightest Flame"] = "Fire Ace Features"
categoryLUT["Trail Blazer"] = "Fire Ace Features"
categoryLUT["Incandescence"] = "Fire Ace Features"
categoryLUT["Fan The Flames"] = "Fire Ace Features"
categoryLUT["Celerity"] = "Flying Ace Features"
categoryLUT["Gale Strike"] = "Flying Ace Features"
categoryLUT["Zephyr Shield"] = "Flying Ace Features"
categoryLUT["Tornado Charge"] = "Flying Ace Features"
categoryLUT["Ghost Step"] = "Ghost Ace Features"
categoryLUT["Haunting Curse"] = "Ghost Ace Features"
categoryLUT["Vampirism"] = "Ghost Ace Features"
categoryLUT["Boo!"] = "Ghost Ace Features"
categoryLUT["Foiling Foliage"] = "Grass Ace Features"
categoryLUT["Sunlight Within"] = "Grass Ace Features"
categoryLUT["Enduring Bloom"] = "Grass Ace Features"
categoryLUT["Cross%-Pollinate"] = "Grass Ace Features"
categoryLUT["Mold the Earth"] = "Ground Ace Features"
categoryLUT["Desert Heart"] = "Ground Ace Features"
categoryLUT["Earthroil"] = "Ground Ace Features"
categoryLUT["Upheaval"] = "Ground Ace Features"
categoryLUT["Glacial Ice"] = "Ice Ace Features"
categoryLUT["Polar Vortex"] = "Ice Ace Features"
categoryLUT["Arctic Zeal"] = "Ice Ace Features"
categoryLUT["Deep Cold"] = "Ice Ace Features"
categoryLUT["Extra Ordinary"] = "Normal Ace Features"
categoryLUT["Plainly Perfect"] = "Normal Ace Features"
categoryLUT["New Normal"] = "Normal Ace Features"
categoryLUT["Simple Improvements"] = "Normal Ace Features"
categoryLUT["Potent Venom"] = "Poison Ace Features"
categoryLUT["Debilitate"] = "Poison Ace Features"
categoryLUT["Miasma"] = "Poison Ace Features"
categoryLUT["Corrosive Blight"] = "Poison Ace Features"
categoryLUT["Psionic Sponge"] = "Psychic Ace Features"
categoryLUT["Mindbreak"] = "Psychic Ace Features"
categoryLUT["Psychic Resonance"] = "Psychic Ace Features"
categoryLUT["Force of Will"] = "Psychic Ace Features"
categoryLUT["Gravel Before Me"] = "Rock Ace Features"
categoryLUT["Bigger and Boulder"] = "Rock Ace Features"
categoryLUT["Tough as Schist"] = "Rock Ace Features"
categoryLUT["Gneiss Aim"] = "Rock Ace Features"
categoryLUT["Polished Shine"] = "Steel Ace Features"
categoryLUT["Iron Grit"] = "Steel Ace Features"
categoryLUT["Assault Armor"] = "Steel Ace Features"
categoryLUT["True Steel"] = "Steel Ace Features"
categoryLUT["Flood!"] = "Water Ace Features"
categoryLUT["Fishbowl Technique"] = "Water Ace Features"
categoryLUT["Fountain of Life"] = "Water Ace Features"
categoryLUT["Aqua Vortex"] = "Water Ace Features"

local function fixFeats(feats)
	for k, feat in ipairs(feats) do
		-- assign category
		feat.category = categoryLUT[feat.name]

		-- format lists
		local fx, listStr, items
		if feat.name == "Insectoid Utility" then
			fx, listStr = m(feat.fx, "(.-)(Threaded:.+)")
			items = {"Threaded:", "Wallclimber:", "Naturewalk:", "Sky:"}

		elseif feat.name == "Clever Ruse" then
			fx, listStr = m(feat.fx, "(.-)(They gain.+)")
			items = {"They gain", "Their attacks", "They may"}
			
		elseif feat.name == "Haunting Curse" then
			fx, listStr = m(feat.fx, "(.-)(1 Curse Token:.+)")
			items = {"1 Curse Token:", "2 Curse Tokens:", "3 Curse Tokens:", "4 Curse Tokens:"}
			
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

return parser("typeAce.txt", "Type Ace Class", names, strip, post)