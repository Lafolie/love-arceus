-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Style Flourish",
	"Style Entrainment",
	"Beautiful Ballet",
	"Fabulous Max",
	"Enticing Beauty",
	"Style Expert", --appears at the bottom of the page for some reason
	"Cool Conduct",
	"Rule of Cool",
	"Action Hero Stunt",
	"Cute Cuddle",
	"Gleeful Steps",
	"Let's Be Friends!",
	"Smart Scheme",
	"Calculated Assault",
	"Learn From Your Mistakes",
	"Tough Tumble",
	"Macho Charge",
	"Endurance"
}

local m = string.match
local gsub = string.gsub
-- local secParser = require "otherData.util_sectionParser"

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	str = gsub(str, "Cast:", "Note:")
	str = gsub(str, "Prerequisites: Coordinator,", ", Coordinator,")
	str = gsub(str, "\r\nBeauty Expert Features\r\n", "\r\n")
	str = gsub(str, "\r\nCool Expert Features\r\n", "\r\n")
	str = gsub(str, "\r\nCute Expert Features\r\n", "\r\n")
	str = gsub(str, "\r\nSmart Expert Features\r\n", "\r\n")
	str = gsub(str, "\r\nTough Expert Features\r\n", "\r\n")

	return str
end

local categoryLUT = {}
categoryLUT["Beautiful Ballet"] = "Beauty Expert Features"
categoryLUT["Fabulous Max"] = "Beauty Expert Features"
categoryLUT["Enticing Beauty"] = "Beauty Expert Features"
categoryLUT["Cool Conduct"] = "Cool Expert Features"
categoryLUT["Rule of Cool"] = "Cool Expert Features"
categoryLUT["Action Hero Stunt"] = "Cool Expert Features"
categoryLUT["Cute Cuddle"] = "Cute Expert Features"
categoryLUT["Gleeful Steps"] = "Cute Expert Features"
categoryLUT["Let's Be Friends!"] = "Cute Expert Features"
categoryLUT["Smart Scheme"] = "Smart Expert Features"
categoryLUT["Calculated Assault"] = "Smart Expert Features"
categoryLUT["Learn From Your Mistakes"] = "Smart Expert Features"
categoryLUT["Tough Tumble"] = "Tough Expert Features"
categoryLUT["Macho Charge"] = "Tough Expert Features"
categoryLUT["Endurance"] = "Tough Expert Features"

local function fixFeats(feats)
	for k, feat in ipairs(feats) do
		-- assign category
		feat.category = categoryLUT[feat.name]

		-- format lists
		local fx, listStr, items
		if feat.name == "Style Entrainment" then
			fx, listStr = m(feat.fx, "(.-)(Beauty.+)")
			items = {"Beauty", "Cool", "Cute", "Smart", "Tough"}

		elseif feat.fx and m(feat.fx, "Rank 1:") then
			fx, listStr = m(feat.fx, "(.-)(Rank 1:.+)")
			items = {"Rank 1:", "Rank 2:"}

		elseif feat.name == "Action Hero Stunt" then
			fx, listStr = m(feat.fx, "(.-)(Example Trigger:.+)")
			items = {"Example Trigger:"}
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

return parser("styleExpert.txt", "Style Expert Class", names, strip, post)