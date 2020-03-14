local m = string.match
local gsub = string.gsub


local capeLog = logger('capeLog.txt')
function getCapabilityStr(p)
	local str = m(p, 'Capability%s*List[%s%c]*(.-)[%s%c]*Skill%s*List')
	str = unhyphenate(str)
	str = gsub(str, "[%c]+", " ")
	capeLog:print(str)
	capeLog:print("==========")
	return str
end

function parseCapabilities(pkmn)
	-- if pkmn.dexNum > 1 then
	-- 	return
	-- end

	-- remove naturewalk first
	local natureWalk, overland, sky, swim, levitate, burrow, hjump, ljump, power, other

	local str, natureWalk = stripNaturewalk(pkmn.capabilityStr)
	str, overland = stripOverland(str)
	str, sky = stripSky(str)
	str, swim = stripSwim(str)
	str, levitate = stripLevitate(str)
	str, burrow = stripBurrow(str)
	str, power = stripPower(str)
	str, jumpHigh, jumpLong = stripJumps(str)

	-- apply basic capabilities
	pkmn.overland = overland or 0
	pkmn.sky = sky or 0
	pkmn.swim = swim or 0
	pkmn.levitate = levitate or 0
	pkmn.burrow = burrow or 0
	pkmn.jumpHigh = jumpHigh or 0
	pkmn.jumpLong = jumpLong or 0
	pkmn.power = power or 0
	pkmn.natureWalk = #natureWalk > 0 and natureWalk or nil

	local otherCapabilities = {}
	str = str .. ","
	for line in string.gmatch(str, "%s*(.-)%s*,") do
		table.insert(otherCapabilities, parseCape(line))
	end

	pkmn.otherCapabilities = otherCapabilities
end

function parseCape(s)
	-- local rank = m(s, ".-%s*(%d*)[%c%s,]*$")
	local cape, rank = m(s, "(%D*)%s*(%d*)%s*%c*")
	cape = m(cape, "(.-)%s*$")

	local parens = m(cape, "%((.-)%)")
	if parens then
		if parens == "only in strong winds" then
			cape = "Windswept"
		else
			cape = m(cape, "(.-)%s%(")
		end
	end
	-- print("PARSE CAPE:", cape, rank)
	return {name = cape, rank = tonumber(rank), ex = parens}
end

function stripNaturewalk(s)
	local terrain = {}
	local nwalk = m(s, "%s*Naturewalk%s*%(.-%)[%s%c,]*")
	
	-- return if no naturewalk was found
	if not nwalk then
		return s, terrain
	end

	-- strip from string
	local nwalkPtn = gsub(nwalk, "%(", "%%%(")
	nwalkPtn = gsub(nwalkPtn, "%)", "%%%)")
	s = gsub(s, nwalkPtn, "")

	-- get terrain list

	nwalk = m(nwalk, "%((.-)%)") .. ","

	for t in nwalk:gmatch("%s*(.-)%s*,") do
		table.insert(terrain, t)
		-- print("INSRERTED", t)
	end

	return s, terrain
end

function stripOverland(s)
	-- get and strip
	local cape = m(s, "%s*Overland%s*%d*[%s%c,]*")
	
	if not cape then
		return s
	end
	s = gsub(s, cape, "")

	--parse rank
	local rank = m(cape, "%s*(%d-)[%c%s,]*$")
	-- print("RANK", cape, rank)
	return s, tonumber(rank)
end

function stripSky(s)
	-- get and strip
	local cape = m(s, "%s*Sky%s*%d*[%s%c,]*")
	
	if not cape then
		return s
	end
	s = gsub(s, cape, "")

	--parse rank
	local rank = m(cape, ".-%s*(%d*)[%c%s,]*$")

	return s, tonumber(rank)
end

function stripSwim(s)
	-- get and strip
	local cape = m(s, "%s*Swim%s*%d*[%s%c,]*")
	
	if not cape then
		return s
	end
	s = gsub(s, cape, "")

	--parse rank
	local rank = m(cape, ".-%s*(%d*)[%c%s,]*$")

	return s, tonumber(rank)
end

function stripLevitate(s)
	-- get and strip
	local cape = m(s, "%s*Levitate%s*%d*[%s%c,]*")
	
	if not cape then
		return s
	end
	s = gsub(s, cape, "")

	--parse rank
	local rank = m(cape, ".-%s*(%d*)[%c%s,]*$")

	return s, tonumber(rank)
end

function stripBurrow(s)
	-- get and strip
	local cape = m(s, "%s*Burrow%s*%d*[%s%c,]*")
	
	if not cape then
		return s
	end
	s = gsub(s, cape, "")

	--parse rank
	local rank = m(cape, ".-%s*(%d*)[%c%s,]*$")

	return s, tonumber(rank)
end

function stripPower(s)
	-- get and strip
	local cape = m(s, "%s*Power%s*%d*[%s%c,]*")
	
	if not cape then
		return s
	end
	s = gsub(s, cape, "")

	--parse rank
	local rank = m(cape, ".-%s*(%d*)[%c%s,]*$")

	return s, tonumber(rank)
end

function stripJumps(s)
	-- get and strip
	local cape = m(s, "%s*Jump%s*%d*%s*/%s*%d*[%s%c,]*")

	if not cape then
		return s
	end
	s = gsub(s, cape, "")

	--parse rank
	local rankHigh = m(cape, ".-%s*(%d*)%s*/")
	-- print("HIGH RANK", rankHigh)
	local rankLong = m(cape, "/%s*(%d*)[%c%s,]*$")

	return s, tonumber(rankHigh), tonumber(rankLong)
end