local m = string.match
local gsub = string.gsub

-- order of these matters!
local extraPokePhrases =
	{
		-- will use mega evo parsing
		"Mega%s*Evolution",
		"Ultra%s*Burst",

		-- will use txt parsing
		"DARMANITAN%s*Zen%s*Mode",
		"%*Therian%s*Forme:",
		"%*Sky%s*Forme:",
		"Multiform%c*Deoxys",
		"Dragon%s*Fusion:",
		"%*Origin%s*Forme",
		"Forme%s*Change:",
		"Zygarde%s*Cube%s*Move%s*List",
		"Confined:"
	}

function findExtraBlock(p)
	for n, phrase in ipairs(extraPokePhrases) do
		local result = m(p, phrase .. ".+")
		if result then
			return result, n
		end
	end
end

local extraLog = logger("extraInfo.txt")

function parseExtraInfo(page)
	local extra, phrasen = findExtraBlock(page)

	if not extra then
		return
	end

	-- extraLog:print(extra)
	if phrasen > 2 then
		-- text
		extra = stripNewlines(extra)
		-- extraLog:print(extra)
		return extra
	end
	
	-- mega evo
	local evos = {}
	if m(extra, "Mega Evolution X") then
		local x, y = m(extra, "(Mega Evolution X.-)(Mega Evolution Y.+)")
		-- extraLog:print(x, y)
		table.insert(evos, parseMegaEvo(x, "X"))
		table.insert(evos, parseMegaEvo(y, "Y"))
	elseif phrasen == 2 then
		local ultra = parseMegaEvo(extra)
		local txt
		ultra.ability, txt = m(ultra.ability, "(.-)%s(.+)")
		ultra.ability_advanced1 = m(txt, "becomes%s*(.-);")
		ultra.capability = m(txt, "Gains%s*(.-)%.")

		extraLog:print(ultra.ability, ultra.ability_advanced1, ultra.capability)
	else
		table.insert(evos, parseMegaEvo(extra))
	end

end

function assignExtraInfo(pkmn, page)
	-- special case for Arbok
	if pkmn.name == "ARBOK" then
		local str = m(page, "%((Serpent's.-)%)")
		str = gsub(str, "%c%c", " ")
		pkmn.extra = str
		print(pkmn.extra)
		return
	end

	local info = parseExtraInfo(page)

	

	if type(info) == "string" then
		if m(info, "^Zygarde") then
			local list = m(info, "Zygarde Cube Move List%c*(.+)") .. ","
			local moves = {}
			for line in string.gmatch(list, "%s?(.-),") do
				table.insert(moves, line)
			end
			pkmn.movesZygardeCube = moves
			return
		end

		pkmn.extra = info
	elseif type(info) == "table" then
		pkmn.megaEvos = info
	end
end

function stripNewlines(str)
	str = gsub(str, "(%a)%-%c%c(%a)", "%1%2")

	local txt = str
	local list = ""
	-- split known lists and append later
	if m(str, "Oricorio") then
		txt, list = m(str, "(.-type:)(.+)")
	elseif m(str, "Confined:") then
		txt, list = m(str, "(.-different Dark%c*Type Moves%.)(.+)")
	end

	txt = gsub(txt, "([^%.])%c%c", "%1 ")

	return txt .. list
end

function parseMegaEvo(str, name)
	extraLog:print "============="
	extraLog:print(str)
	local evo = {}
	local types = m(str, "Type:%s*(.-)%c*Ability")
	types = gsub(types, "(%a)%-%c%c(%a)", "%1%2")
	if not m(types, "Unchanged") then
		local a, b = m(types, "(%a*)%s*/-%s*(%a*)$")
		evo.typeMain = a
		evo.typeSub = b
	end

	evo.ability = gsub(m(str, "Ability:%s*(.-)%c*Stats"), "%c%c", " ")
	

	local stats = "," .. m(str, "Stats:(.+)")

	local v = m(stats, "([%+%-]?%d*)%s*Atk")
	if v then evo.atk = tonumber(v) end

	v = m(stats, "([%+%-]?%d*)%s*Sp%.%s*Atk")
	if v then evo.spAtk = tonumber(v) end

	v = m(stats, "([%+%-]?%d*)%s*Def")
	if v then evo.def = tonumber(v) end

	v = m(stats, "([%+%-]?%d*)%s*Sp%.%s*Def")
	if v then evo.spDef = tonumber(v) end

	v = m(stats, "([%+%-]?%d*)%s*Speed")
	if v then evo.spd = tonumber(v) end


	evo.name = name

	extraLog:print("EVOT TBLE:")
	for k, v in pairs(evo) do
		extraLog:print(k, v)
	end

	return evo
end