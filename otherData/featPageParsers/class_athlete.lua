-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Athlete",
	"Training Regime",
	"Coaching",
	"Adrenaline Rush",
	"Athletic Moves"
}

local m = string.match
-- local secParser = require "otherData.util_sectionParser"

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return m(str, "(.+)Athlete Moves\r\n")
end

local function fixFeats(feats)
	for k, feat in ipairs(feats) do
		local fx, listStr, items
		if feat.name == "Training Regime" then
			fx, listStr = m(feat.fx, "(.-)(Attack:.+)")
			items = {"Attack:", "Defense:", "Special Attack:", "Special Defense:", "Speed:"}

		elseif feat.name == "Coaching" then
			fx, listStr = m(feat.fx, "(.-)(Your Pokémon gains %+1d6.+)")
			items = {"Your Pokémon gains %+1d6", "If your Pokémon was Sprinting", "If your Pokémon was making", "You may also"}
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
	local moves = 
	{
		{"Rank 1",	"Rank 2",		"Rank 3"	},
		{"Bind",	"Body Slam",	"Mega Kick"	},
		{"Block",	"Take Down",	"Facade"	},
		{"Slam",	"Extreme Speed","Retaliate"	},
		{"Strength","",				""			}
	}

	fixFeats(feats)
	ex.athleteMoves = moves
	return ex
end

return parser("athlete.txt", "Athlete Class", names, strip, post)