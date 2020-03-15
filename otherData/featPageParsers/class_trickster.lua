-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Trickster",
	"Bag of Tricks",
	"Stacked Deck",
	"Flourish",
	"Encore Performance",
	"Sleight"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return m(str, "(.-)Mind Games\r\n")
end

local function fixStackedDeck(feats)
	-- fix up the stupid Stacked Deck table
	local stackedDeck
	-- still haven't mastered next...
	for k, v in ipairs(feats) do
		if v.name == "Stacked Deck" then
			stackedDeck = v
		end
	end

	-- strip table from effect description
	local fx, tblStr = m(stackedDeck.fx, "(.-) Condition Effect (.+)")
	local status = {{"Condition", "Effect"}}

	local strs = 
	{
		"Bad Dreams",
		"Whenever",
		"Paralysis",
		"The",
		"Confuse",
		"The",
		"$"
	}

	-- build the stable
	for n = 1, #strs - 2, 2 do
		local start1 = strs[n]
		local start2 = strs[n+1]
		local finish = strs[n+2]

		local ptn = string.format("(%s.-)(%s.-)%s", start1, start2, finish)
		local a, b = m(tblStr, ptn)

		table.insert(status, {a, b})
	end

	stackedDeck.fx = fx
	stackedDeck.tbl = status
end

local function post(feats, str)
	local ex = {}
	local exStr = m(str, "(Mind Games.+)Trickster Techniques\r\n")

	local techStrs = {}
	table.insert(techStrs, m(exStr, "^(.-)Escape Artist"))
	table.insert(techStrs, m(exStr, "(Escape Artist.-)Shell Game"))
	table.insert(techStrs, m(exStr, "(Shell Game.-)Impromptu Trick"))
	table.insert(techStrs, m(exStr, "(Impromptu Trick.+)"))

	local techs = {}
	for k, s in ipairs(techStrs) do
		local tech = {}
		tech.name = m(s, "^(.-)\r\n")
		tech.freq = m(s, tech.name .. "\r\n(.-)\r\n")
		local fx = m(s, "Effect: (.+)")

		-- shell game has target instead of trigger
		if tech.name == "Shell Game" then
			tech.target = m(s, "Target: (.-)Effect:")

		else
			tech.trigger = m(s, "Trigger: (.-)Effect:")
		end

		tech.fx = fx
		
		-- cleanup
		for i, j in pairs(tech) do
			j = string.gsub(j, "\r\n", " ")
			j = m(j, "%s*(.+%S)")
			tech[i] = j
		end

		table.insert(techs, tech)
	end

	fixStackedDeck(feats)
	ex.techs = techs
	return ex
end

return parser("trickster.txt", "Trickster Class", names, strip, post)