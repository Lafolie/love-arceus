local m = string.match
local gsub = string.gsub

local tagList = {}
local classList = {}
local log = logger "featsLog.txt"
local tagLog = logger "featTagsLog.txt"

local pageParsers = {}
local parsersPath = "otherData/featPageParsers"
log:print "Loading parsers:"
for k, file in ipairs(love.filesystem.getDirectoryItems(parsersPath)) do
	local fullPath = string.format("%s/%s", parsersPath, file)
	local trimmedPath = m(fullPath, "(.+)%.lua$")
	local info = love.filesystem.getInfo(fullPath)
	if info.type == "file" and m(file, ".+%.lua$") then
		-- require the stuff
		log:print("\tLoading " .. file)
		table.insert(pageParsers, require(trimmedPath))
	end
end

local function parseFeatTags(str)
	local tags = {}
	for tag in string.gmatch(str, "%[(.-)%]") do
		tagList[tag] = tag
		table.insert(tags, tag)
	end

	return tags
end

local freqTbl =
{
	-- add freq strings here
	"Static",
	"At%-Will %- ",
	"%d AP %- ",
	"X AP %- ",
	"Bind %d AP %- ",
	"Scene %- ",
	"Scene x%d %- ",
	"Daily %- ",
	"Daily x%d %- ",
	"X Daily %-",
	"x%d Uses %- ",
	"Daily/%d* - ",
	"One Time Use %- ",
	"One Time Use x%s*%d %- ",
	"One Time Use/%d",
	"Special %- "
}

local function findFrequency(str)
	-- check for the different frequency strings
	for _, freq in ipairs(freqTbl) do
		local match = m(str, ".-(\r\n" .. freq .. ")")
		if match then
			-- escape dashes for later pattern use
			match = gsub(match, "%-", "%%-")

			return match
		end
	end
end

local function findPreqs(str)
	-- first, look for multi-rank preqs
	local preqs = m(str, "\r\nAll Ranks Prerequisites:")
	if preqs then
		return preqs
	end

	preqs = m(str, "\r\nRank 1 Prerequisites:")
	if preqs then
		return preqs
	end

	-- else, looks for preqs
	return m(str, "\r\nPrerequisite[s]*%s*:")
end

local function getFeatSections(str)
	local sections = {{ptn = "^", name = "name"}}
	
	-- must be inserted in the right order!
	local tags = m(str, "\r\n%[")
	local preqs = findPreqs(str)
	local freq = findFrequency(str)
	local trigger = m(str, "\r\nTrigger%s*:")
	local target = m(str, "\r\nTarget%s*:")
	local confx = m(str, "\r\nContest Effect%s*:")
	local batfx = m(str, "\r\nBattle Effect%s*:")
	local ingredient = m(str, "\r\nIngredient 1%s*:")
	local choosefx = m(str, "\r\nChoose One Effect%s*:")
	local fx = m(str, ".-(\r\nEffect%s*:)")
	local special = m(str, "\r\nSpecial%s*:")
	local note = m(str, "\r\nNote%s*:")

	-- insert if required
	if tags then
		-- escape bracket
		tags = gsub(tags, "%[", "%%[")
		table.insert(sections, {ptn = tags, name = "tags"})
	end
	if preqs then
		table.insert(sections, {ptn = preqs, name = "preqs"})
	end
	if freq then
		table.insert(sections, {ptn = freq, name = "freq"})
	end
	if trigger then
		table.insert(sections, {ptn = trigger, name = "trigger"})
	end
	if target then
		table.insert(sections, {ptn = target, name = "target"})
	end

	-- style expert

	if confx then
		table.insert(sections, {ptn = confx, name = "confx"}) 
	end
	if batfx then
		table.insert(sections, {ptn = batfx, name = "batfx"})
	end

	-- chef
	if ingredient then
		table.insert(sections, {ptn = ingredient, name = "ingredients"})
	end

	if choosefx then
		table.insert(sections, {ptn = choosefx, name = "choosefx"})
	end
	if fx then
		table.insert(sections, {ptn = fx, name = "fx"})
	end
	if special then
		table.insert(sections, {ptn = special, name = "special"})
	end
	if note then
		table.insert(sections, {ptn = note, name = "note"})
	end

	table.insert(sections, {ptn = "$", name = ""})
	return sections
end



function parseFeature(f)
	local feat = {}
	local sections = getFeatSections(f.str)
	log:print(string.format("\nFEAT: %s (%s sections discovered)", f.name, #sections - 1))
	-- log:print(f.str)
	-- break sections into strs
	for n = 1, #sections - 1 do
		local current = sections[n]
		local index = current.name
		local start = current.ptn
		local finish = sections[n + 1].ptn

		local ptn
		-- frequency/cost and tags need a different pattern due to lack of section signifier
		if index ~= "freq" and index ~= "tags" then
			ptn = start .. "(.-)" .. finish
		else
			ptn = "(" .. start .. ".-)" .. finish
		end

		local str = m(f.str, ptn)

		-- CLEANUP
		-- unhyphenate
		str = gsub(str, "(%a)%-\r\n(%a)", "%1%2")
		str = gsub(str, "\r\n", " ")
		-- strip opening/closing spaces
		str = m(str, "%s*(.+%S)")

		-- log:print(current.name, ptn)
		log:print(index, str)
		feat[index] = str
	end

	if feat.tags then
		feat.tags = parseFeatTags(feat.tags)
	end

	return feat
end



function parseFeaturesData(tbl)
	for k, parser in ipairs(pageParsers) do
		log:print "==================="
		log:print("Parsing", parser.file)
		local feats = {}
		-- load pages
		local filepath = string.format("otherData/core/features/%s", parser.file)
		local pages = getPages({filepath})
		local pagesFlat = table.concat(pages, "\r\n")

		-- clean up
		pagesFlat = gsub(pagesFlat, "Skills, Edges, Feats\r\n%d*\r\n", "")
		pagesFlat = gsub(pagesFlat, "Trainer Classes\r\n%d*\r\n", "")
		pagesFlat = gsub(pagesFlat, "Sept 2015 Playtest\r\n%d*\r\n", "")
		pagesFlat = replaceBadChars(pagesFlat)
		-- log:print(pagesFlat)
		-- log:print(parser.stripFunc(parser, pagesFlat))

		-- strip data
		local stripped = "\r\n" .. parser.stripFunc(parser, pagesFlat)

		-- find feats
		local featStrs = {}
		for n = 1, #parser.names - 1 do
			local start = parser.names[n]
			local finish = parser.names[n+1]

			-- append newline to non-ending name
			if finish ~= "$" then
				finish = finish .. "\r\n"
			end

			local ptn = string.format("(\r\n%s\r\n.-)%s", start, finish) --
			local str = m(stripped, ptn)
			table.insert(featStrs, {name = start, str = str})
			-- log:print("|||||||||||||||||||||||||||")
			-- log:print(str)
		end

		-- parse feats
		for k, f in ipairs(featStrs) do
			local feat = parseFeature(f)

			-- parse tags for a looksie
			-- parseFeatTags(feat.tags)

			table.insert(feats, feat)
		end

		-- run post func
		local extra = parser.postFunc(feats, pagesFlat)

		-- store results
		local result = 
		{
			category = parser.tag,
			feats = feats,
			extra = extra
		}

		table.insert(tbl, result)
		-- for k, feat in ipairs(feats) do
		-- 	table.insert(tbl, feat)
		-- 	-- NEXT TASK:
		-- 	-- DECIDE HOW TO STORE CLASS/FEATS AND EXTRA DATA
		-- 	-- FROM CLASS FEAT PAGES.
		-- 	-- FLAT LIST OF FEATS DOES NOT SUFFICE!
		-- end
	end

	-- print out feat tags for analysis
	for k, tag in pairs(tagList) do
		tagLog:print(tag)
	end
end