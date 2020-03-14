-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Ace Trainer",
	"Perseverance",
	"Elite Trainer",
	"Critical Moment",
	"Top Percentage",
	"Signature Technique",
	"Champ in the Making"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return m(str, "(.-)Cone, Line, Burst, and Blast Moves\r\n")
end

local function post(feats, str)
	local ex = {}
	local techMods = {}
	local headers = 
	{
		"Cone, Line, Burst, and Blast Moves",
		"Single Target Moves",
		"Damaging Moves",
		"Status Moves",
		"$"
	}

	local names =
	{
		{"Scattershot", "Shock and Awe", "Vicious Storm", "$"},
		{"Guarding Strike", "Unbalancing Blow", "Reliable Attack", "$"},
		{"Alternative Energy", "Bloodied Speed", "Double Down", "$"},
		{"Burst of Motivation", "Supreme Concentration", "Double Curse", "$"}
	}

	str = m(str, "(Cone, Line, Burst, and Blast Moves.+)Signature Technique Modifications\r\n")

	for n = 1, #headers - 1 do
		local modCat = {}
		local start = headers[n]
		local finish = headers[n + 1]
		local modNames = names[n]
		-- split string into 4 header chunks
		local chunkStr = m(str, start .. "(.-)" .. finish)
		
		modCat.name = start
		modCat.mods = {}

		-- iterate over names
		for i = 1, 3 do
			local mod = {}
			local ptn = string.format("(%s.-)%s", modNames[i], modNames[i + 1])
			local modStr = m(chunkStr, ptn)

			-- break apart
			local name, training, fx = m(modStr, "(.-) %- (.-):%s*(.+)")
			fx = string.gsub(fx, "\r\n", " ")
			fx = m(fx, "%s*(.+%S)")

			mod.name = name
			mod.training = training
			mod.fx = fx

			table.insert(modCat.mods, mod)
		end

		table.insert(techMods, modCat)
	end

	ex.techMods = techMods
	return ex
end

return parser("aceTrainer.txt", "Ace Trainer Class", names, strip, post)