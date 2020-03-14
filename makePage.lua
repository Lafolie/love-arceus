local m = string.match
local gsub = string.gsub

require "pokemon"

function makeSpecialPages(pages)
	print "Dynamically creating pages for corner case Pokémon:"
	makeHoopaPage(pages)
	makeOricorioPages(pages)
	makeMeowsticPages(pages)
	makePumpkabooGourgeistPages(pages)
	makeRotomPages(pages)
	makeDarmanitanPages(pages)
	makeUnfezantPages(pages)
	makeBasculinPages(pages)
end

function findPageFor(pages, name)
	for k, page in ipairs(pages) do
		if getName(page) == name then
			return k, page
		end
	end
end

-- ============================================================================================================================
-- BASCULIN
-- ============================================================================================================================

function makeBasculinPages(pages)
	local num, page = findPageFor(pages, "BASCULIN")

	page = gsub(page, "%s*%(.-Basculin Only%)", "")

	local red = gsub(page, "BASCULIN", "BASCULIN Red Stripe")
	local blue = gsub(page, "BASCULIN", "BASCULIN Blue Stripe")

	red = gsub(red, "Adv Ability 2: Reckless.-%c%c", "")
	blue = gsub(blue, "Adv Ability 2: Rock.-%c%c", "")
	
	addNewFormeName("BASCULIN", "Red Stripe")
	addNewFormeName("BASCULIN", "Blue Stripe")

	pages[num] = red
	table.insert(pages, blue)
end

-- ============================================================================================================================
-- UNFEZANT
-- ============================================================================================================================

function makeUnfezantPages(pages)
	local num, page = findPageFor(pages, "UNFEZANT")

	local male = gsub(page, "^([%d%s%c]*)UNFEZANT", "%1UNFEZANT Male")
	local female = gsub(male, "UNFEZANT Male", "UNFEZANT Female")
	
	local ability = m(page, "High Ability: (.-)%c")
	ability = gsub(ability, "%(", "%%%(")
	ability = gsub(ability, "%)", "%%%)")
	male = gsub(male, ability, "Frighten")
	female = gsub(female, ability, "Rocket")
	
	male = gsub(male, "50%% M / 50%% F", "100%% M / 0%% F")
	female = gsub(female, "50%% M / 50%% F", "0%% M / 100%% F")

	addNewFormeName("UNFEZANT", "Male")
	addNewFormeName("UNFEZANT", "Female")

		print(ability)
	pages[num] = male
	table.insert(pages, female)
end

-- ============================================================================================================================
-- DARMANITAN
-- ============================================================================================================================

function makeDarmanitanPages(pages)
	local num, page = findPageFor(pages, "DARMANITAN")

	local standard, zenInfo = m(page, "(.-)DARMANITAN Zen Mode%c*(.+)")

	standard = gsub(standard, "^[%d%s%c]*DARMANITAN", "DARMANITAN Standard Mode")

	local name, basicInfo, skills = m(standard, "(.-Base Stats:%c*).-(Basic Information.-Capability List%c*).-(Skill List.+)")
	local name = gsub(name, "Standard Mode", "Zen Mode")

	local stats, types, capabilities = m(zenInfo, "Base Stats:%c*(.-)(Type : .+)%c%c.*Capability List%c*(.+)")
	print(zenInfo)
	basicInfo = gsub(basicInfo, "Type : Fire", types)
	local zen = string.format("%s%s%s%s%s", name, stats, basicInfo, capabilities, skills)
	
	addNewFormeName("DARMANITAN", "Standard Mode")
	addNewFormeName("DARMANITAN", "Zen Mode")
	print(standard)
	print(zen)

	pages[num] = standard
	table.insert(pages, zen)
end

-- ============================================================================================================================
-- ROTOM
-- ============================================================================================================================

function getRotomAppliances(page, forms)
	local stats, typeInfo, capes, skills = m(page, "Base Stats:%c*(.-)Rotoms.-Type Information%c*(.-)Size Information:.-Capability Information:%c*(.-)Skill Information:%c(.+)")
	local apps = {}
	
	for n = 1, 5 do
		local current = forms[n]
		local nxt = forms[n + 1] or "$"
		local app = {}

		app.stats = stats
		app.types = m(typeInfo, current .. " Rotom:%s*(.-)%c")
		app.capabilities = m(capes, current .. " Rotom%c*(.-)" .. nxt)
		app.skills = m(skills, current .. " Rotom%c*(.-)" .. nxt)
		app.size = "Medium"
		app.height = "1.2m"
		app.weight = "40kg"
		app.name = current .. " Form"
		apps[current] = app
	end

	return apps
end

function makeRotomPage(page, form)
	local name, basicInfo, size, breeding, skillTxt, moves = m(page, "(.-Base Stats:%c*).-(Basic Information.-Size Information%c*)(.-)(Breeding Information.-Capability List%c*).-(Skill List%c*).-(Move List%c*.+)")

	name = gsub(name, "ROTOM Normal Form", "ROTOM " .. form.name)
	basicInfo = gsub(basicInfo, "Electric / Ghost", form.types)
	size = gsub(size, "0.3m", form.height)
	size = gsub(size, "0.3kg", form.weight)
	size = gsub(size, "Small", form.size)

	local result = string.format("%s%s%s%s%s%s%s%s%s", name, form.stats, basicInfo, size, breeding, form.capabilities, skillTxt, form.skills, moves)
	addNewFormeName("ROTOM", form.name)
	-- print(result)
	return result
end

function makeRotomPages(pages)
	local num, page = findPageFor(pages, "ROTOM Normal Form")
	local applianceNum, appliancePage = findPageFor(pages, "ROTOM Appliance Forms")

	local forms = {"Heat", "Wash", "Frost", "Fan", "Mow"}
	local applianceData = getRotomAppliances(appliancePage, forms)

	for k, form in ipairs(forms) do
		local rotom = makeRotomPage(page, applianceData[form])
		table.insert(pages, rotom)
	end
	-- makeRotomPage(page, applianceData.Heat)
	-- print("APPLIANSDFDFD", appliancePage)
	table.remove(pages, applianceNum)
end

-- ============================================================================================================================
-- PUMPKABOO/GOURGEIST
-- ============================================================================================================================

function makePumpkin(page, size, formeName)
	-- split page
	local name, basicInfo, rest = m(page, "(.-Base Stats:%c*).-(Basic Information.-Size Information%c*).-(Breeding Information.-Worry Seed%c*)Small%c")

	local originalName = getName(page)
	local fullName = string.format("%s %s", originalName, formeName)
	name = gsub(name, originalName, fullName)

	local height = string.format("Height: bullshit / %s m %s\r\n", size.height, size.size)
	local weight = string.format("Weight: byllshit / %s kg (0)\r\n", size.weight)

	local page = string.format("%s%s%s%s%s", name, size.stats, basicInfo, height .. weight, rest)
	addNewFormeName(originalName, formeName)
	
	return page
end

function determinePumpkinSize(height)
	if height < 1 then
		return "(Small)"
	elseif height < 1.5 then
		return "(Medium)"
	else
		return "(Large)"
	end
end

-- read Pumpkaboo/Gourgeist page and generate table of stats/size attributes for each size (4 total)
function getPumpkinSizes(page)
	local statsStr = m(page, "Trick,%s*%c*Worry Seed%s*%c*(.+)$")
	local sizeStr = m(page, "Size Information%c*(.-)Breeding Information")
	local sizes = {}

	-- print(sizeStr)
	local heightStr, weightStr = m(sizeStr, "(Height.-%c%c)(.+)")
	local low, high = m(heightStr, "(%d*%.%d*)m.*to%s*(%d*%.%d*)m")

	high = gsub(high, "^%.", "0.")
	high = tonumber(high)
	low = tonumber(low)
	local step = (high-low)/3
	sizes.small = {height = string.format("%0.1f", low), size = determinePumpkinSize(low)}
	sizes.average = {height = string.format("%0.1f", low + step), size = determinePumpkinSize(low + step)}
	sizes.large = {height = string.format("%0.1f", low + step * 2), size = determinePumpkinSize(low + step * 2)}
	sizes.superSize = {height = string.format("%0.1f", high), size = determinePumpkinSize(high)}

	low, high = m(weightStr, "(%d%.%d)%s*kg.-to%s*(%d*)%skg")
	high = tonumber(high)
	low = tonumber(low)
	step = (high-low)/3
	sizes.small.weight = string.format("%0.1f", low)
	sizes.average.weight = string.format("%0.1f", low + step)
	sizes.large.weight = string.format("%0.1f", low + step * 2)
	sizes.superSize.weight = string.format("%0.1f", high)

	sizes.small.stats = m(statsStr, "Small%c*(.-)Average")
	sizes.average.stats = m(statsStr, "Average%c*(.-)Large")
	sizes.large.stats = m(statsStr, "Large%c*(.-)Super Size")
	sizes.superSize.stats = m(statsStr, "Super Size%c*(.+)")

	-- for k, v in pairs(sizes) do
	-- 	print(k, v.height, v.size, v.weight)
	-- end

	return sizes
end

function makePumpkabooGourgeistPages(pages)
	local pumpkabooNum, pumpkabooPage = findPageFor(pages, "PUMPKABOO")
	local gourgeistNum, gourgeistPage = findPageFor(pages, "GOURGEIST")
	local pumpkabooSizes = getPumpkinSizes(pumpkabooPage)
	local gourgeistSizes = getPumpkinSizes(gourgeistPage)

	local sizeTbl = 
	{
		{k = "small", str = "Small"},
		{k = "average", str = "Average"},
		{k = "large", str = "Large"},
		{k = "superSize", str = "Super Size"}
	}

	for n, size in ipairs(sizeTbl) do
		local pumpkaboo = makePumpkin(pumpkabooPage, pumpkabooSizes[size.k], size.str)
		local gourgeist = makePumpkin(gourgeistPage, gourgeistSizes[size.k], size.str)

		if n > 1 then
			table.insert(pages, pumpkaboo)
			table.insert(pages, gourgeist)
		else
			pages[pumpkabooNum] = pumpkaboo
			pages[gourgeistNum] = gourgeist
		end
	end
end

-- ============================================================================================================================
-- MEOWSTIC
-- ============================================================================================================================
function makeMeowstic(page, gender)
	-- used to detect correct gender signifier
	local terms = 
	{
		Male = 
		{
			"(M)",
			"%(M%)",
			"(F)",
			"%(F%)"
		},
		Female = 
		{
			"(F)",
			"%(F%)",
			"(M)",
			"%(M%)"
		}
	}

	local right, rightEscaped, wrong, wrongEscaped = unpack(terms[gender])
	addNewFormeName("MEOWSTIC", gender)

	-- split page into parts
	local name2stats, abilities, evo2skills, lvlup, tmhm, tutor = m(page, "^(.-Type : Psychic%c%c)(.-)(Evolution:.-Move List%c*Level Up Move List%c*)(.-)(TM/HM Move List.-Tutor Move List%c%c)(.+)")

	-- strip ability data
	local result = {}
	for line in string.gmatch(abilities, "(.-%c%c)") do
		if not m(line, wrongEscaped) then
			line = gsub(line, rightEscaped, "")
			table.insert(result, line)
		end
	end

	abilities = table.concat(result, "")

	-- strip level up moves
	result = {}

	for line in string.gmatch(lvlup, "(.-%c%c)") do
		if not m(line, wrongEscaped) then
			line = gsub(line, rightEscaped .. " ", "")
			table.insert(result, line)
		end
	end

	lvlup = table.concat(result, "")

	-- strip tutor moves
	result = {}
	tutor = tutor .. ","

	for line in string.gmatch(tutor, "(.-,)") do
		if not m(line, wrongEscaped) then
			line = gsub(line, rightEscaped .. "%s?", "")
			table.insert(result, line)
		end
	end

	tutor = table.concat(result, "")
	tutor = string.sub(tutor, 1, -2)

	-- add forme to name
	name2stats = gsub(name2stats, "MEOWSTIC", "MEOWSTIC " .. gender)

	-- alter gender ratios
	if gender == "M" then
		evo2skills = gsub(evo2skills, "50%% M / 50%% F", "100%% M / 0%% F")
	else
		evo2skills = gsub(evo2skills, "50%% M / 50%% F", "0%% M / 100%% F")
	end

	return string.format("%s%s%s%s%s%s", name2stats, abilities, evo2skills, lvlup, tmhm, tutor)
end

function makeMeowsticPages(pages)
	local num, page = findPageFor(pages, "MEOWSTIC")

	local male = makeMeowstic(page, "Male")
	local female = makeMeowstic(page, "Female")
	print(male)
	print(female)
	pages[num] = male
	table.insert(pages, female)
end

-- ============================================================================================================================
-- ORICORIO
-- ============================================================================================================================

function makeOricorio(page, type)
	page = gsub(page, "ORICORIO", "ORICORIO ".. type .. " Type")
	page = gsub(page, "Type: Special", "Type: " .. type)
	page = gsub(page, "Flying %(see Forme Change%)", "Flying")
	addNewFormeName("ORICORIO", type .. " Type")
	print(page)
	return page
end

function makeOricorioPages(pages)
	local num, page = findPageFor(pages, "ORICORIO")
	local fire = makeOricorio(page, "Fire")
	local electric = makeOricorio(page, "Electric")
	local psychic = makeOricorio(page, "Psychic")
	local ghost = makeOricorio(page, "Ghost")

	pages[num] = fire
	table.insert(pages, electric)
	table.insert(pages, psychic)
	table.insert(pages, ghost)
end

-- ============================================================================================================================
-- HOOPA
-- ============================================================================================================================

function makeHoopaPage(pages)
	local confinedNum, confinedPage = findPageFor(pages, "HOOPA Confined")
	local unboundNum, unboundPage = findPageFor(pages, "HOOPA Unbound")
	
	-- FIX LVL UP MOVELIST FUCKING BULLSHIT
	confinedPage = gsub(confinedPage, "55 Shadow Ball", "55 Shadow Ball - Bullshit")
	confinedPage = gsub(confinedPage, "68 Nasty Plot", "68 Nasty Plot - Bullshit")
	confinedPage = gsub(confinedPage, "75 Psychic", "75 Psychic - Bullshit")
	confinedPage = gsub(confinedPage, "85 Hyperspace Hole", "85 Hyperspace Hole - Bullshit")

	local firstHalf, secondHalf = m(unboundPage, "^(.-)(Confined: If Hoopa's.+)")
	local moveLists = m(confinedPage, "^.-(Move List.+)") --Headbutt %(N%)
	local newPage = firstHalf .. moveLists .. secondHalf
	print(newPage)

	pages[confinedNum] = confinedPage
	pages[unboundNum] = newPage
end