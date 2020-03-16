-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Oracle",
	"Divination",
	"Unveiled Sight",
	"Small Prophecies",
	"Mark of Vision",
	"Two%-Second Preview",
	"Prescience"
}

local m = string.match
local secParser = require "otherData.util_sectionParser"

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return m(str, "(.-)GM's")
end


local function post(feats, str)
	for k, feat in ipairs(feats) do
		if feat.name == "Divination" then
			local fx, exStr = m(feat.fx, "(.-) (Augury Target:.+)")
			
			-- metadata for the secParser
			local target = {name = "target", str = "Target:", trim = true}
			local effect = {name = "fx", str = "Effect:", trim = true}

			local function makeMeta(name, ...)
				local nameTbl = {name = "name", str = name}
				return {nameTbl, ...}
			end

			local meta = 
			{
				makeMeta("Augury", target, effect),
				makeMeta("Scrying", target, effect)
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
			
			feat.fx = fx
			feat.tbl = talents
		elseif feat.name == "Unveiled Sight" then
			feat.fx = string.gsub(feat.fx, "Disguises and Illusions", "\n\nDisguises and Illusions")

		end
	end
end

return parser("oracle.txt", "Oracle Class", names, strip, post)