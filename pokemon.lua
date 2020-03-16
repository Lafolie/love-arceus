local m = string.match
local gsub = string.gsub

require 'formes'
require 'capabilities'
require 'moves'
require 'pokeExtras'

local formCache = {}
local regionCache = {}
local evoCache = {}
local nameLUT = {}
local formeNames = loadFormesList('formesList.txt')

function cacheRegionVariant(poke)
	local num = poke.dexNum
	local c = regionCache[num]
	if not c then
		regionCache[num] = {}
		c = regionCache[num]
	end

	local region = poke.region or 'original'
	c[region] = poke
end

function cacheForme(shortName, fullName)
	local c = formCache[shortName]
	if not c then
		c = {}
		formCache[shortName] = c
	end
	table.insert(c, fullName)
	return c
end

function getPokemonNameOnly(page)
	page = flabebeCheck(page)
	local pkmn = 
	{
		name = getName(page)
	}

	return pkmn
end

function addNewFormeName(name, formeName)
	local fullName = string.format("%s %s", name, formeName)
	formeNames[fullName] = {name = name, forme = formeName}
end

-- EDGE CASES!
-- 	PUMPKABOO/GOURGEIST  - multiple stats for sizes (make into forms)
-- 	ROTOM - bullshit forms
--  NIDORAN - M/F
function getPokemon(page, natDex)
	-- Typo/Misc pre-processing
	page = flabebeCheck(page)
	page = lycanrocCheck(page)
	page = sliggooCheck(page)
	page = advAbility1Check(page)

	-- get simple stuff
	local pkmn =
	{
		name = getName(page),
		hp = getHP(page),
		atk = getAtk(page),
		def = getDef(page),
		spAtk = getSpAtk(page),
		spDef = getSpDef(page),
		spd = getSpd(page),
		
		ability_basic1 = getBA1(page),
		ability_basic2 = getBA2(page),
		ability_advanced1 = getAA1(page),
		ability_advanced2 = getAA2(page),
		ability_advanced3 = getAA3(page),
		ability_high = getHA(page),
		
		height = getHeight(page),
		weight = getWeight(page),
		size = getSize(page),
		gender = getGenderRatio(page),
		hatchRate = getHatchRate(page),
		diet = getDiet(page),
		habitat = getHabitat(page),

		evoStr = getEvolutionStr(page),
		skillStr = getSkillStr(page),
		capabilityStr = getCapabilityStr(page),
	}

	-- pkmn.dexNum

	-- get move lists
	local moveLists = getMovesStr(page, pkmn.name)
	if moveLists.lvl then
		pkmn.movesLvl = parseLvlMoveList(moveLists.lvl)
	end

	-- temporary bypass for MEW
	if pkmn.name ~= "MEW" then
		if moveLists.tm then
			pkmn.movesTM = parseTMMoveList(moveLists.tm)
		end

		if moveLists.egg then
			pkmn.movesEgg = parseMoveList(moveLists.egg)
		end

		if moveLists.tutor then
			pkmn.movesTutor = parseMoveList(moveLists.tutor)
		end
	end

	-- get more complex info
	handleAbilityCorners(pkmn)
	pkmn.typeMain, pkmn.typeSub = getTypes(page)
	pkmn.eggGroup1, pkmn.eggGroup2 = getEggGroups(page)
	processRegion(pkmn, natDex)
	cacheRegionVariant(pkmn)
	parseSkills(pkmn)
	parseCapabilities(pkmn)
	assignExtraInfo(pkmn, page)

	-- add to LUT
	local lowerName = string.lower(pkmn.name)
	nameLUT[lowerName] = pkmn

	-- print "----------------------------------------------------------------"
	-- print(pkmn.name)
	-- print "----------------------------------------------------------------"
	-- for k, v in pairs(pkmn) do
	-- 	print(k, v)
	-- end
	pokemonPrettyPrint(pkmn)
	-- remove bullshit

	pkmn.skillStr = nil
	pkmn.capabilityStr = nil

	return pkmn
end

function pokemonPrettyPrint(p)
	-- local function fmt(txt, ...)
	-- 	local args = {...}
	-- 	for k, v in ipairs(args) do
	-- 		args[k] = tostring(v)
	-- 	end
	-- 	print(string.format(txt, unpack(args)))
	-- end

	print "----------------------------------------------------------------"
	print(string.format("#%d - %s, introduced in Gen %d", p.dexNum, p.name, p.generation))
	print "----------------------------------------------------------------"
	print("TYPES", p.typeMain, p.typeSub)
	print "STATS"
	print("  HP ", p.hp)
	print("  Atk", p.atk)
	print("  Def", p.def)
	print("  SpAtk", p.spAtk)
	print("  SpDef", p.spDef)
	print("  Spd", p.spd)
	print "\nABILITIES"
	print("  Basic1   ", p.ability_basic1)
	print("  Basic2   ", p.ability_basic2)
	print("  Advanced1", p.ability_advanced1)
	print("  Advanced2", p.ability_advanced2)
	print("  Advanced3", p.ability_advanced3)
	print("  High     ", p.ability_high)
	if p.typeAura then
		print("  TYPE AURA", p.typeAura)
	end
	print("\nREGION & FORMES")
	print("  REGION", p.region)
	print("  FORME ", p.formeName)
	print "\nBREEDING"
	print("  GENDER RATIO", p.gender)
	print("  HATCH RATE", p.hatchRate)
	print("  HEIGHT", p.height)
	print("  WEIGHT", p.weight)
	print("  SIZE   ", p.size)
	print("  DIET   ", p.diet)
	print("  HABITAT", p.habitat)
	print "SKILLS"
	print(string.format("  ATHLETICS  %dd6%s%d", p.athletics.dice, p.athletics.mod >= 0 and "+" or "", p.athletics.mod))
	print(string.format("  ACROBATICS %dd6%s%d", p.acrobatics.dice, p.acrobatics.mod >= 0 and "+" or "", p.acrobatics.mod))
	print(string.format("  COMBAT     %dd6%s%d", p.combat.dice, p.combat.mod >= 0 and "+" or "", p.combat.mod))
	print(string.format("  STEALTH    %dd6%s%d", p.stealth.dice, p.stealth.mod >= 0 and "+" or "", p.stealth.mod))
	print(string.format("  PERCEPTION %dd6%s%d", p.perception.dice, p.perception.mod >= 0 and "+" or "", p.perception.mod))
	print(string.format("  FOCUS      %dd6%s%d", p.focus.dice, p.focus.mod >= 0 and "+" or "", p.focus.mod))
	print(string.format("  EDU: TECH  %dd6%s%d", p.eduTech.dice, p.eduTech.mod >= 0 and "+" or "", p.eduTech.mod))
	print "CAPABILITIES"
	print(string.format("  OVERLAND   %d", p.overland))
	print(string.format("  SKY        %d", p.sky))
	print(string.format("  SWIM       %d", p.swim))
	print(string.format("  LEVITATE   %d", p.levitate))
	print(string.format("  BURROW     %d", p.burrow))
	print(string.format("  HIGH JUMP  %d", p.jumpHigh))
	print(string.format("  LONG JUMP  %d", p.jumpLong))
	print(string.format("  POWER      %d", p.power))
	print "  NATUREWALK"
	if p.natureWalk then
		for _, terrain in ipairs(p.natureWalk) do
			print(string.format("    %s", terrain))
		end
	end
	print "  OTHER CAPABILITIES"
	if p.otherCapabilities then
		for _, cape in ipairs(p.otherCapabilities) do
			print(string.format("    %s %s %s", cape.name, cape.rank or "", cape.ex or ""))
		end
	end
	-- print(p.capabilityStr)

end

function processRegion(pkmn, natDex)
	-- print("PROCESS REGION FOR: ", pkmn.name)
	local name = string.lower(pkmn.name)
	local isAlolan = m(name, ".+%s*alola")
	local isGalarian = m(name, ".+%s*galar")



	if isAlolan then
		name = m(name, "(.-)%s*alola")
		pkmn.region = 'alola'
	end
	if isGalarian then
		name = m(name, "(.-)%s*galar")
		pkmn.region = 'galar'
	end

	-- check that name isn't a forme variant
	local forme = formeNames[pkmn.name]
	-- print(pkmn.name)
	if forme then
		-- print("FORME FOUND")
		name = forme.name
		pkmn.formeName = forme.forme
	end


	pkmn.dexNum, pkmn.generation = natDex:find(name)
end

-- Helper function for pokemon names duplicated as a substring of others
function isWholeName(word, str)
    local ptn = word .. "[%a%d%-]"
    local prefix = string.match(str,ptn)
    
    ptn = "%a" .. word
    local suffix = string.match(str,ptn)
    
    ptn = word
    local matches = string.match(str,ptn)
    return matches and not (prefix or suffix)
end

-- Find the name of a Pokemon in the given string from the LUT
function findNameInStr(str, natDex)
	local find = string.find
	
	-- KLINKLANG HAX
	-- local klinklang = m(str, "klinklang")
	-- if klinklang then
	-- 	return find(str, "klinklang")
	-- end

	for name, _ in pairs(nameLUT) do
		-- escape magic chars
		name = gsub(name, '%-', '%%%-')

		local s, f = find(str, name)
		-- local partialName = m(str, "^" .. name .. "%a")
		if isWholeName(name, str) and s and f then
			return s, f
		end
	end
	print('[INFO] Could not find name in LUT. Searching the dex tables for ' .. str)
	for _, name in ipairs(natDex.full) do
		name = gsub(name, '%-', '%%%-')
		local s, f = find(str, name .. "%s-")
		if s and f then 
			return s, f
		end
	end

	print('[WARNING] No name found findNameInStr: ' .. str)
end

-- ONLY CALL THESE AFTER POKEMON HAVE BEEN LOADED -----------------------------------------------------------------------------
local abilityFieldNames = {"ability_basic1", "ability_basic2", "ability_advanced1", "ability_advanced2", "ability_advanced3", "ability_high"}
function handleAbilityCorners(pkmn)
	for k, v in ipairs(abilityFieldNames) do
		local ability = pkmn[v]
		if ability then
			-- resolve type aura
			local name, _type = m(ability, "(Type Aura)%s*%((.-)%)")

			if name and _type then
				pkmn[v] = name
				pkmn.typeAura = _type
			end

			-- resolve dual 'or' abilities
			local a, b = m(ability, "(.-)%sor%s(.+)")

			-- also take castform's bullshit into account
			if not (a and b) then
				a, b = m(ability, "(.-)%s/%s(.+)")
			end
			if a and b then
				pkmn[v] = a
				local altKey = v .. "Alt"
				pkmn[altKey] = b
			end

			-- get rid of the asterix on Arbok's listing
			if ability == "Serpent's Mark*" then
				pkmn[v] = "Serpent's Mark"
			end
		end
	end
end


function getRegionTable(pkmn)
	local num = pkmn.dexNum
	local tbl = regionCache[num]
	if tbl.alola or tbl.galar then
		return tbl
	end
end

function buildFormeTbl(pkmn)
	-- only work on pokemon with alt formes
	if not pkmn.formeName then
		return
	end

	-- find the base name for this pokemon
	local formeName = gsub(pkmn.formeName, "%%", "%%%%") -- escape % in Zygarde's forme names
	local pattern = "%s-" .. formeName
	local shortName = gsub(pkmn.name, pattern, "")
	print("SHORT NAME FOR", pkmn.name, shortName)

	return cacheForme(shortName, pkmn.name)
end

function unhyphenate(str)
	-- do the main job
	str = gsub(str, "(%a)%-%c*(%a)", "%1%2")

	-- restore any pokemon names & other stuff
	local names = 
	{
		PorygonZ = 'Porygon-Z',
		Jangmoo = 'Jangmo-o',
		Hakamoo = 'Hakamo-o',
		Kommoo = 'Kommo-o',
		XRay = 'X-Ray',
		Hooh = 'Ho-oh'
	}

	for k, v in pairs(names) do
		if m(str, k) then
			-- print 'REPLACED'
			str = gsub(str, k, v)
		end
	end

	return str
end

local evoLog = logger('evoLog.txt')
local evoTblLog = logger('evoTbl.txt')
function buildEvoTbl(pkmn, dex, natDex)
	local evoStr = pkmn.evoStr

	-- GURDURR typo hax
	if pkmn.name == "GURDURR" then
		evoStr = gsub(evoStr, "250%s", "20\n")
	end

	-- MILOTIC HAX
	if pkmn.name == "MILOTIC" then
		evoStr = gsub(evoStr, "%c%c20", " 20")
	end

	-- SHELMET HAX
	-- if pkmn.name == "SHELMET" or pkmn.name == "ACCELGOR" then
		-- evoStr = gsub(evoStr, "(Karrablast)[%s%c]*(M)", "%1 %2")
	-- end
	evoTblLog:print("---------------------")
	evoTblLog:print(evoStr .. "|")
	-- un-hyphenate
	evoStr = unhyphenate(evoStr)
	
	if m(evoStr, "%c%c[^%s%d]") then
		evoTblLog:print('NEW LINER')
		evoStr = gsub(evoStr, "%c%c(%D)", " %1")
	end
	-- evoTblLog:print("pre-hyphen", evoStr .. "|")
	
	-- evoTblLog:print("evoStr:", evoStr .. "|")
	-- break list into lines
	local evos = {}
	local numline = 0
	for line in string.gmatch(evoStr, "(.-)%s*%c") do
		evoTblLog:print(line)
		if line ~= "" then
			numline = numline + 1
			-- evoTblLog:print("PARSING LINE", numline, line)
			-- print(string.byte(string.sub(line, #line)))
			local linetbl = parseEvolLine(line, natDex)

			local stage = linetbl.stage
			if not evos[stage] then
				evos[stage] = {}
			end
			local stageTbl = evos[stage]
			local evo = {}
			evo.name = linetbl.name
			evo.lvl = linetbl.lvl
			evo.cause = linetbl.cause
			evo.interactWith = linetbl.interactWith

			-- RAICHU HAX (lvl is not listen on some entries)
			-- evoTblLog:print(evo.name)
			if m(evo.name, "raichu") then
				evo.lvl = 20
			end

			-- magnezone hax
			if m(evo.name, "magnezone") then
				evo.lvl = nil
				evo.cause = "1" .. evo.cause
			end

			if linetbl.stage > 1 and evo.cause then
				evoLog:print(evo.name, "->", evo.cause)
			end

			table.insert(stageTbl, evo)
		end
	end

	evos = cacheEvoTbl(evos, natDex)

	for k, stage in ipairs(evos) do
		for _, v in ipairs(stage) do
			evoTblLog:print("  STAGE:", k)
			evoTblLog:print("  NAME: ", v.name)
			evoTblLog:print("  LVL:  ", v.lvl)
			evoTblLog:print("  CAUSE:", v.cause or "")
			if v.interactWith then
				evoTblLog:print("  INTER:", v.interactWith)
			end
		end
	end

	evoTblLog:print("Lines parsed:", numline)

	

	pkmn.evos = evos
	pkmn.evoStr = nil
end

-- Cache evolutions so that all pokemon in an evolutionary family share the same tbl
-- This allows pkmn with evos in future content packs (such as Eevee) to have correct listings
local evoCacheLog = logger('evoCacheLog.txt')
function cacheEvoTbl(tbl, natDex)
	local rootName = tbl[1][1].name

	-- strip region
	rootName = gsub(rootName, "%salola", "")
	rootName = gsub(rootName, "%sgalar", "")

	-- nidoran hax
	if m(rootName, "nidoran [fm]") then
		rootName = gsub(rootName, "(.+%s)(.)", "%1%(%2%)")
	end

	local dexNum = natDex:find(rootName)
	evoCacheLog:print("===============================")
	evoCacheLog:print("CACHING", rootName, dexNum)
	-- get/create cached tree
	local cacheTree = evoCache[dexNum]
	if not cacheTree then
		cacheTree = {}
		evoCache[dexNum] = cacheTree
		evoCacheLog:print("NEW CACHE ENTRY FOR DEXNUM", dexNum)
	end

	for n, stage in ipairs(tbl) do
		-- get/create stage in cache
		local cacheStage = cacheTree[n]
		if not cacheStage then
			cacheStage = {}
			cacheTree[n] = cacheStage
			evoCacheLog:print("NEW STAGE CACHE ENTRY FOR STAGE", n)
		end

		-- ensure that each evolution is cached once.
		-- log any discrepencies to a file for hax inspection
		for _, evo in ipairs(stage) do
			local cacheEvo = findCachedEvo(evo.name, cacheStage)
			if cacheEvo then
				-- check values and skip
				for k, v in pairs(evo) do
					cacheV = cacheEvo[k]
					if cacheV and cacheV ~= v then
						evoCacheLog:print("DOES NOT MATCH", k, v, cacheV)
						if k == "lvl" then
							local newValue = math.min(v, cacheV)
							cacheEvo[k] = newValue
							evoCacheLog:print(string.format("UPDATED %s to %s", k, newValue))
						end
					elseif not cacheV then
						evoCacheLog:print("MISSING KEY/VALUE PAIR:", k, v)
					end
				end
			else
				-- insert into cache
				evoCacheLog:print("CACHED", evo.name)
				table.insert(cacheStage, evo)
			end
		end
	end

	return cacheTree
end


function findCachedEvo(name, tbl)
	for k, v in ipairs(tbl) do
		if v.name == name then
			return v
		end
	end
end

-- Since the evolution lists are not standardised, grab info
-- and trim until just the reason remains
-- BULLSHIT HAX:
--		MAGNEMITE
--		NOSEPASS?
-- 		LYCANROCK HAS PARENS IN NAME

function parseEvolLine(l, natDex)
	l = string.lower(l)
	evoTblLog:print("LINE", l)

	-- strip stage & level requirement
	local stage = m(l, "^(%d-)%s*%-%s*")
	l = m(l, "^%d-%s*%-%s*(.+)") --trim

	-- substitute 'Min.' for 'Minimum'
	if m(l, "min%.%s*%d") then
		l = gsub(l, "(min%.)(%s*%d)", "minimum%2")
	end

	local lvl = m(l, "minimum%s*(%d*)[%s%c]*")
	l = gsub(l, "%s*minimum[%s%d%c]*", " ")

	-- Substitute regional variant shorthand
	l = gsub(l, "%(g%)", "galar")
	l = gsub(l, "%(a%)", "alola")

	-- lycanroc bollocks
	l = gsub(l, "%(midnight%)", "midnight")
	l = gsub(l, "%(midday%)", "midday")
	l = gsub(l, "%(dusk%)", "dusk")

	-- interact with bollocks
	-- 2 pokemon names in the string messes up the name search
	local interact = m(l, ".-(%s*interact%s*with.+)")
	if interact then
		l = m(l, "(.-)".. interact)
	end

	-- strip region and re-add later
	local region = m(l, "%sgalar")
	region = region or m(l, "%salola")
	if region then
		l = gsub(l, region, "")
	end

	-- extract the name
	local start, fin = findNameInStr(l, natDex)
	local name
	if start and fin then
		name = string.sub(l, start, fin)
		l = string.sub(l, fin+1)
	end

	-- re-append region
	name = name .. (region or "")
	
	if interact then
		l = interact
		local start, fin = findNameInStr(l, natDex)
		interact = string.sub(l, start, fin)	
	end

	-- strip away control chars from cause
	local cause = gsub(l, "%c", "")
	cause = gsub(cause, "^%s*$", "")
	cause = gsub(cause, "^%s?(.*)%s*$", "%1")
	stage = tonumber(stage)
	lvl = tonumber(lvl)
	cause = cause ~= "" and cause or nil

	local r =
	{
		name = name,
		stage = stage,
		lvl = lvl,
		cause = cause,
		interactWith = interact
	}
	-- print(stage, name, lvl or 1, l)
	-- print("  STAGE:", r.stage)
	-- print("  NAME: ", r.name)
	-- print("  LVL:  ", r.lvl)
	-- print("  CAUSE:", r.l)

	return r
	
end

-- BULLSHIT CHECKS ------------------------------------------------------------------------------------------------------------
local flabebe = string.format("FLAB%sB%s", string.char(0xc9), string.char(0xc9))
function flabebeCheck(p)
	if m(p, "242%c*FLAB") then
		p = string.gsub(p, "(242%c*)(.-)\n", "%1FLABEBE\n")
	end

	if m(p, "1%s*%-%s*Flab") then
		p = string.gsub(p, "(1%s*%-%s*)(Flab.-)\n", "%1Flabebe\n")
		-- print(p)
	end
	return p
end

function lycanrocCheck(p)
	if m(p, "Lycanrock") then
		-- p = string.gsub(p, "LYCANROCK", "LYCANROC")
		p = string.gsub(p, "Lycanrock", "Lycanroc")
		print 'HIT LYCANROC'
	end
	return p
end

function sliggooCheck(p)
	if m(p, "Sligoo") then
		p = gsub(p, "Sligoo", "Sliggoo")
	end
	return p
end

function advAbility1Check(p)
	local count = 0
	for str in string.gmatch(p, "Adv%s*Ability%s*1%s*:") do
		count = count + 1
		if count > 1 then
			print "DUPLICATE ABILITY NUMBER FOUND, ALTERING"

			p = gsub(p, "(Adv%s*Ability%s*1%s*:.+Adv%s*Ability%s*)1(%s*:)", "%13%2")
			-- print(p)
			return p
		end

	end

	return p
end

-- REGULAR FUNCS --------------------------------------------------------------------------------------------------------------
function getName(p)
	local name = m(p, "%d*%c*(.-)%c")
	-- NINTALES TYPO HAX WTF
	-- print(name)
	if name == 'NINETAILS Alola' then
		name = 'NINETALES Alola'
	end
	return name
end

function getTypes(p)
	local both = m(p, "Type%s*:%s+(.-)%c")
	local main, sub = m(both, "(%a*)%s*/-%s*(%a-)$")
	sub = #sub > 0 and sub or nil
	return main, sub
end

function getEggGroups(p)
	local both = m(p, "Egg Group%s*:%s+(.-)%c")
	return m(both, "(%a*)%s*/-%s*(%a-)$")
end

function getHP(p)
	local v = m(p, "HP:%s+(.-)%c")
	return tonumber(v)
end
function getAtk(p)
	local v = m(p, "Attack:%s+(.-)%c")
	return tonumber(v)
end
function getDef(p)
	local v = m(p, "Defense:%s+(.-)%c")
	return tonumber(v)
end
function getSpAtk(p)
	local v = m(p, "Special Attack:%s+(.-)%c")
	return tonumber(v)
end
function getSpDef(p)
	local v = m(p, "Special Defense:%s+(.-)%c")
	return tonumber(v)
end
function getSpd(p)
	local v = m(p, "Speed:%s+(.-)%c")
	return tonumber(v)
end

function getBA1(p)
	return m(p, "Basic Ability 1%s*:%s*(.-)%c")
end
function getBA2(p)
	return m(p, "Basic Ability 2%s*:%s*(.-)%c")
end
function getAA1(p)
	return m(p, "Adv Ability 1%s*:%s*(.-)%c")
end
function getAA2(p)
	return m(p, "Adv Ability 2%s*:%s*(.-)%c")
end
function getAA3(p)
	return m(p, "Adv Ability 3%s*:%s*(.-)%c")
end
function getHA(p)
	return m(p, "High Ability%s*:%s*(.-)%c")
end

function getHeight(p)
	local v = m(p, "Height%s*:.-/%s*(.-)%a")
	return tonumber(v)
end

function getWeight(p)
	local v = m(p, "Weight%s*:.-/%s*(.-)%a")
	return tonumber(v)
end

function getSize(p)
	return m(p, "Height%s*:.-%((.-)%)")
end

function getGenderRatio(p)
	local ratio = m(p, "Gender%s*Ratio%s*:%s*(.-)%%")
	return ratio --and ratio or 'none'
end

function getHatchRate(p)
	local v = m(p, "Average%s*Hatch%s*Rate%s*:%s+(.-)%s")
	return tonumber(v)
end

function getEvolutionStr(p)
	return m(p, "Evolution%s*:%s*%c*(.-)Size%s*Information")
end

function getDiet(p)
	return m(p, "Diet%s*:%s*(.-)%c")
end

function getHabitat(p)
	return m(p, "Habitat%s*:%s*(.-)%c")
end

-- local skillLog = logger('skills.txt')
function getSkillStr(p)
	local skills = m(p, "Skill%s*List[%s%c]-(.-)%c*Move%s*List")

	-- hoopa unbound hax
	if not skills then
		skills = m(p, "Skill%s*List[%s%c]-(.-)%c*Confined:")
	end

	skills = gsub(skills, "(%a*)%-%c*(%a)", "%1%2")
	-- skills = gsub(skills, "%s,", ",")
	skills = gsub(skills, "[\n\r]", " ")
	-- skills = m(skills, "^%s*(.+)")
	
	-- skillLog:print(skills)
	return skills
end

function parseSkills(pkmn)
	local str = pkmn.skillStr
	-- print(str)

	local dice, mod = m(str, "Athl%s*(%d-)d6(+*%-*%d*)")
	if (not mod) or mod == "" then mod = 0 end
	pkmn.athletics = {dice = tonumber(dice), mod = tonumber(mod)}

	dice, mod = m(str, "Acro%s*(%d-)d6(+*%-*%d*)")
	if (not mod) or mod == "" then mod = 0 end
	pkmn.acrobatics = {dice = tonumber(dice), mod = tonumber(mod)}

	dice, mod = m(str, "Combat%s*(%d-)d6(+*%-*%d*)")
	if (not mod) or mod == "" then mod = 0 end

	-- drillbur typo
	if pkmn.name == "DRILBUR" then mod = 1 end

	pkmn.combat = {dice = tonumber(dice), mod = tonumber(mod)}

	dice, mod = m(str, "Stealth%s*(%d-)d6(+*%-*%d*)")
	if (not mod) or mod == "" then mod = 0 end
	pkmn.stealth = {dice = tonumber(dice), mod = tonumber(mod)}

	dice, mod = m(str, "Percep%s*(%d-)d6(+*%-*%d*)")
	if (not mod) or mod == "" then mod = 0 end
	pkmn.perception = {dice = tonumber(dice), mod = tonumber(mod)}

	dice, mod = m(str, "Focus%s*(%d-)d6(+*%-*%d*)")
	if (not mod) or mod == "" then mod = 0 end
	pkmn.focus = {dice = tonumber(dice), mod = tonumber(mod)}

	dice, mod = 1, 0
	if m(str, "Edu:%s*Tech") then
		dice, mod = m(str, "Edu:%s*Tech%s*(%d-)d6(+*%-*%d*)")
	end
	if (not mod) or mod == "" then mod = 0 end
	pkmn.eduTech = {dice = tonumber(dice), mod = tonumber(mod)}
end

