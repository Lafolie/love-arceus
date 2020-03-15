-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Dancer",
	"Dance Form",
	"Beguiling Dance",
	"Dance Practice",
	"Choreographer",
	"Power Pirouette",
	"Passing Waltz"
}

local m = string.match
-- local secParser = require "otherData.util_sectionParser"

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return m(str, "(.-)Mechanic %- Dance Moves:")
end

local function addMechanic(feat, str)
	local body, example = m(str, "Mechanic %- Dance Moves:(.-)(Name\r\n.+)")
	body = string.gsub(body, "\r\n", " ")
	body = m(body, "%s*(.+%S)")

	example = string.gsub(example, "\r\n", "\n")
	feat.mechanicDanceMoves = string.format("%s\n%s", body, example)
end

local function fixFeats(feats, str)
	-- apply some errata as notes, May 2015 Packet
	for k, feat in ipairs(feats) do
		if feat.name == "Dancer" then
			addMechanic(feat, str)
		elseif feat.name == "Power Pirouette" then
			local fx, listStr = m(feat.fx, "(Choose one effect:)(.+)")
			local items = {"All adjacent", "You gain", "Destroy all Hazards"}

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
	fixFeats(feats, str)
end

return parser("dancer.txt", "Dancer Class", names, strip, post)