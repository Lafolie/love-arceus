-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Stat Ace",
	"Stat Link",
	"Stat Training",
	"Stat Maneuver",
	"Stat Mastery",
	"Stat Embodiment",
	"Stat Stratagem"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return str
end

local function post(feats, str)
	-- build lists on relevant feats
	local editFeats = {}
	editFeats["Stat Training"] = ":"
	editFeats["Stat Maneuver"] = "Effect:"
	editFeats["Stat Mastery"] = "Effect:"
	editFeats["Stat Embodiment"] = "Aces"
	editFeats["Stat Stratagem"] = "Effect:"

	local stats = {"Attack", "Defense", "Special Attack", "Special Defense", "Speed", "$"}

	for k, feat in ipairs(feats) do
		local itemHeader = editFeats[feat.name]
		if itemHeader then
			local fx, listStr = m(feat.fx, "(.-)( Attack.+)")

			-- build list
			local list = {}
			for n = 1, 5 do
				local ptn = string.format("(%s%%s*%s.-)%s", stats[n], itemHeader, stats[n+1])
				local li = m(listStr, ptn)
				table.insert(list, li)
			end

			feat.fx = fx
			feat.list = list
		end
	end
end

return parser("statAce.txt", "Stat Ace Class", names, strip, post)