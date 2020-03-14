local m = string.match
local gsub = string.gsub
local f = string.find

--[[
	MOVE LISTS ORDER
		1. Level Up
		2. TM/HM
		3. Egg
		4. Tutor
		5.Mega/Forme/Nonsense (NOT MOVE LIVES BUT NEED FILTERING)
]]

local movesLog = logger('movesLog.txt')
local total, numTutor = 0, 0
local noTutor = {}

-- 3-byte sequence used to denote favourite moves, should be § but pdf2txt kludged it, or some UTF-8 stuff is going on
local shittyBytes = "efbfbd" --string.format("%s%s%s", string.char(0xEF), string.char(0xBF), string.char(0xBD))
function parseLvlMoveList(s)
	local list = {}
	-- movesLog:print("LVL LIST STRING:", s)
	-- for line in s:gmatch("(%d.-)%s+%-*%s") do
	for line in s:gmatch("(.-)%s+%-*%s.-\r\n") do
		
		-- detect and strip favourite move signifiers
		local isFavourite = ""--m(line, "^shittyBytes")
		-- string.match seems to not work for this, so do it manually
		for n=1, 3 do
			isFavourite = isFavourite .. string.format("%x", string.byte(line, n, n))
		end
		isFavourite = isFavourite == shittyBytes or nil

		if isFavourite then
			movesLog:print "FAVE"
			line = line:sub(4)
			line = m(line, "%s*(.+)")
		end

		-- alola/galar dex use the actual § character, so check for that too
		if not isFavourite and m(line, "^" .. string.char(0xa7)) then
			isFavourite = true
			line = string.sub(line, 3)
		end

		-- get level
		local lvl = m(line, "(%d*)%s*")
		if lvl == "" then
			movesLog:print("NO LVL FOUND")
		end

		-- get name, check for 'Evo' as the lvl
		local name = m(line, "%d*%s*(.+)")
		if m(name, "^Evo%s*.+") then
			name = gsub(name, "^Evo%s*(.+)", "%1")
			lvl = 0
		end

		-- insert and finish
		table.insert(list, {lvl = tonumber(lvl), name = name, favourite = isFavourite})
		movesLog:print(lvl, name)
	end

	return list
end

function flattenMoveStr(s)
	s = gsub(s, "-[%c]+", "")
	s = gsub(s, "[%c]+", " ")
	return s
end

function parseMoveList(s)
	local list = {}
	
	s = s .. ","
	movesLog:print "NEW MOVE LIST-------------------"
	for line in s:gmatch("%s*(.-)%s*,") do
		
		line = flattenMoveStr(line)

		-- ignore empty lists
		if line == "None" or not m(line, "%w") then
			return
		end

		local naturalFlag
		-- get natural flag
		if m(line, "%(N%)%s*$") then
			naturalFlag = true
			line = m(line, "(.-)%s*%(N%)")
		end

		movesLog:print(line)
		table.insert(list, {name = line, natural = naturalFlag})
	end

	return list
end

function parseTMMoveList(s)
	local list = {}
	s = s .. ","

	for line in s:gmatch("%s*(.-)%s*,") do
		line = flattenMoveStr(line)

		-- ignore empty lists
		if line == "None" or not m(line, "%w") then
			return
		end

		-- typo hax
		if line == "Thief" then
			line = "46 Thief"
		end

		-- movesLog:print(line)
		local tm = m(line, "(A?%d+)%s*.+")
		local multiplier = 1
		-- p2(tm)
		if m(tm, "A") then
			tm = m(tm, "A(.+)")
			multiplier = -1
		end

		local tmNum = tonumber(tm) * multiplier

		local name = m(line, "A?%d*%s*(.+)")
		-- movesLog:print(line)
		movesLog:print(tmNum, name)
		table.insert(list, {name = name, tm = tmNum})
	end

	return list
end

local moveListIndicators = 
{
	lvl = "Level%s*Up%s*Move%s*List[%s%c]*",
	tm = "TM[/HM]*%s*Move%s*List[%s%c]*",
	tutor = "Tutor%s*Move%s*List[%s%c]*",
	egg = "Egg%s*Move%s*List[%s%c]*"
}
function getMovesStr(p, name)
	total = total + 1
	local s = m(p, "Level%s*Up%s*Move%s*List[%s%c]*.*")
	movesLog:print "========================================"
	movesLog:print(name)

	-- Detect pages that break the algo
	if not s then 
		s = p
		movesLog:print "NO LEVEL MOVE LIST FOUND"
		-- return
	end
	-- movesLog:print(s)

	local hasLvl = m(s, moveListIndicators.lvl)
	local hasTM = m(s, moveListIndicators.tm)
	local hasEgg = m(s, moveListIndicators.egg)
	local hasTutor = m(s, moveListIndicators.tutor)
	
	local endingPhrase = findSpecialPhrase(p)

	-- Ordering of the indicators table has to match pokedex PDF layout!
	local indicators = {}
	if hasLvl then
		table.insert(indicators, {str = moveListIndicators.lvl, name = "lvl"})
	end
	if hasTM then
		table.insert(indicators, {str = moveListIndicators.tm, name = "tm"})
	end
	if hasEgg then
		table.insert(indicators, {str = moveListIndicators.egg, name = "egg"})
	end
	if hasTutor then
		table.insert(indicators, {str = moveListIndicators.tutor, name = "tutor"})
	end

	table.insert(indicators, {str = findSpecialPhrase(s) or "$"})

	local moveLists = {}
	if #indicators < 2 then
		return {}
	end

	for n = 1, #indicators - 1 do
		local start, fin = indicators[n], indicators[n+1]
		moveLists[start.name] = getMoveSection(s, start.str, fin.str)
	end

	

	movesLog:print(#indicators)

	-- for k, v in pairs(moveLists) do
	-- 	movesLog:print(k, v)
	-- end
	-- if hasLvl then movesLog:print("Has lvl") end
	-- if hasTM then movesLog:print("Has TM") end
	-- if hasTutor then 
	-- 	movesLog:print("Has Tutor")
	-- 	numTutor = numTutor + 1
	-- else
	-- 	table.insert(noTutor, name)
	-- end
	-- if hasEgg then movesLog:print("Has Egg") end
	-- if endingPhrase ~= "" then
	-- 	movesLog:print("Has special phrase", endingPhrase)
	-- end

	return moveLists
end

function getMoveSection(str, start, endStr)
	return m(str, start .. "(.-)" .. endStr)
end

local specialPhrases = 
	{
		"Mega%s*Evolution",
		"DARMANITAN%s*Zen%s*Mode",
		"%*Therian%s*Forme:",
		"%*Sky%s*Forme:",
		"Multiform%c*Deoxys",
		"Dragon%s*Fusion:",
		"%*Origin%s*Forme",
		"Forme%s*Change:",
		"Ultra%s*Burst",
		"Zygarde%s*Cube%s*Move%s*List",
		"Confined:"
	}

function findSpecialPhrase(p)
	for _, phrase in ipairs(specialPhrases) do
		if m(p, phrase) then
			return phrase
		end
	end

	-- return ""
end


function printTotalTutor()
	movesLog:printf("%d/%d", numTutor, total)
	movesLog:print "PKMN WITH NO TUTOR LIST"
	for k, v in ipairs(noTutor) do
		movesLog:print("", v)
	end
end

