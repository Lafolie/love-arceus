local m = string.match
local gsub = string.gsub
local log = logger "abilityParseLog.txt"
-- LUT is used to quickly find abilties that have been updated in errata packets
local abilityLUT = {}

-- the order of how these are parsed matters!
-- newer errata overrides older rules
local txtFiles = {"core", "sep", "altered", "new", "alola", "galar"}

local splitPtn = "(Ability%s*:.-)%c*%-%-%-%-%-%-%-%-\r\n"
function parseAbilityPage(page, tbl)
	-- log:print(page)
	page = page .. "\r\n--------\r\n"
	for str in string.gmatch(page, splitPtn) do
		local ability = parseAbility(str)
		local name = ability.name

		-- replace cached ability or insert new one
		if abilityLUT[name] then
			-- replace without reassignment
			-- ensures the array part of the result table is also updated
			local cached = abilityLUT[name]
			-- clone existing ability
			local temp = {}
			for k, v in pairs(cached) do
				temp[k] = v
			end

			-- replace
			for k, v in pairs(ability) do
				cached[k] = v
			end

			-- remove dead keys
			for k, v in pairs(temp) do
				if not ability[k] then
					cached[k] = nil
				end
			end
		else
			-- insert
			abilityLUT[name] = ability
			table.insert(tbl, ability)
		end
	end
end

function parseAbility(str)
	log:print "==================="
	-- log:print(str)
	local ability = {}

	ability.name, ability.pp = m(str, "Ability%s*:%s*(.-)%c%c(.-)%c%c")
	ability.trigger = m(str, "Trigger%s*:%s*(.-)%c%c")
	ability.target = m(str, "Target%s*:%s*(.-)%c%c")
	-- ability.bonus = m(str, "Bonus%s*:%s*(.-)%c%c")
	-- ability.special = m(str, "Special%s*:%s*(.-)%c%c")
	ability.fx = m(str, "Effect%s*:%s*(.+)")

	tidyFx(ability)

	log:print(ability.name)
	log:print(ability.fx)

	return ability
end

function tidyFx(ability)
	local fx = ability.fx
	local name = ability.name

	-- TO-DO IMPLEMENT LIST/TABLE STRUCTURE
	if name == "Color Theory" then
		local a, b, c = m(fx, "(.-)(1 =.-Violet)%.(.+)")
		a = gsub(a, "\r\n", " ")
		b = gsub(b, "\r\n", " ")
		b = gsub(b, ";", "\n")
		c = gsub(c, "\r\n", " ")
		fx = string.format("%s\n%s\n%s", a, b, c)

	elseif name == "Cruelty" then
		local a, b, c, d = m(fx, "(.-below%.)(.-times%.)(.-Slowed%.)(.+)")
		a = gsub(a, "\r\n", " ")
		b = gsub(b, "%-\r\n", "")
		c = gsub(c, "\r\n", " ")
		d = gsub(d, "\r\n", " ")
		fx = string.format("%s\n%s\n%s\n%s", a, b, c, d)

	elseif name == "Fabulous Trim" then
		local a, b = m(fx, "(.-parlor%.)(.+)")
		a = gsub(a, "\r\n", " ")
		b = gsub(b, "\r\n", "\n")
		fx = string.format("%s\n%s", a, b)

	elseif name == "Fashion Designer" then
		local a, b = m(fx, "(.-ability%.)(.+)")
		a = gsub(a, "\r\n", " ")
		b = gsub(b, "a\r\n", "a ")
		fx = string.format("%s\n%s", a, b)

	elseif name == "Poltergeist" and m(fx, "Storm%c*$") then
		-- ADD A TABLE ELEMENT LATER
		local a, b = m(fx, "(.-List%.)(.+)")
		a = gsub(a, "\r\n", " ")
		fx = string.format("%s\n%s", a, b)

	elseif name == "Serpent's Mark" and m(fx, "Ambush%c*$") then
		local a, b = m(fx, "(.-inherited%.)(.+)")
		a = gsub(a, "\r\n", " ")
		fx = string.format("%s\n%s", a, b)
	
	elseif name == "Magnet Pull" and m(fx, "^Pick") then
		local a, b, c, d = m(fx, "(.-;)(.-Class%.)(.-user%s*%.)(.+)")
		a = gsub(a, "\r\n", " ")
		b = gsub(b, "\r\n", " ")
		c = gsub(c, "\r\n", " ")
		d = gsub(d, "\r\n", " ")

		-- fix typo
		d = gsub(d, " ot ", " to ")
		fx = string.format("%s\n%s\n%s\n%s", a, b, c, d)
	
	elseif name == "Reckless" and m(fx, "create%.%c*$") then
		log:print(fx)
		local a, b = m(fx, "(.-3%.).-Reckless Moves:%s*(.+)")
		a = gsub(a, "\r\n", " ")
		fx = string.format("%s\n%s", a, b)

	elseif name == "Receiver" then
		local a, b, c = m(fx, "(.-:).-(When.-encounter%.).-(When.+)")
		a = gsub(a, "\r\n", " ")
		b = gsub(b, "\r\n", " ")
		c = gsub(c, "\r\n", " ")
		fx = string.format("%s\n%s\n%s", a, b, c)
		
	elseif name == "Accelerate" then
		local a, b = m(fx, "(.-Accuracy%.).-(Replaces.+)")
		a = gsub(a, "\r\n", " ")
		fx = string.format("%s\n%s", a, b)

	elseif name == "Mimicry" then
		-- wtf

	elseif name == "Transporter" and m(fx, ";") then
		local a, b, c, d = m(fx, "(.-%.)(.-);(.-%.)(.+)")
		a = gsub(a, "\r\n", " ")
		b = gsub(b, "\r\n", " ")
		c = gsub(c, "\r\n", " ")
		d = gsub(d, "\r\n", " ")

		fx = string.format("%s\nChoose One:\n%s\n%s\n%s", a, b, c, d)
	
	elseif name == "Bone Lord" and m(fx, "%)%.%c*$") then
		local a, b, c, d, e = m(fx, "(.-%.)(.-:)(.-%.)(.-keyword)(.+)")
		a = gsub(a, "\r\n", " ")
		b = gsub(b, "\r\n", " ")
		c = gsub(c, "\r\n", " ")
		d = gsub(d, "\r\n", " ")
		e = gsub(e, "\r\n", " ")
		fx = string.format("%s\n%s\n%s\n%s\n%s", a, b, c, d, e)
	
	elseif name == "Ripen" then
		fx = gsub(fx, string.char(0xbc), "25%%")
		fx = gsub(fx, "\r\n", " ")
	
	elseif name == "Power Construct" then
		local a, b = m(fx, "(.-)(Special:.+)")
		a = gsub(a, "\r\n", " ")
		b = gsub(b, "\r\n", " ")

		fx = string.format("Special: The user can only use Power Construct while below 50%% HP.\n%s\n%s", a, b)
	else
		-- strip newlines
		fx = gsub(fx, "\r\n", " ")
		fx = gsub(fx, "(Connection %-.-%.)%s*", "%1\n") --make connection a key/value pair?
	end

	-- separate bonus from fx
	if m(fx, "Bonus:") then
		fx, ability.bonus = m(fx, "(.-)(Bonus:.+)")
	end


	ability.fx = fx
end

function loadAbilityPages()
	for k, v in ipairs(txtFiles) do
		txtFiles[k] = string.format("otherData/core/abilities/%s.txt", v)
	end

	local pages = getPages(txtFiles)

	-- filter out bullshit
	for k, v in ipairs(pages) do
		if m(v, "Tutor and Inheritance Move Changes%c%c") then
			v = gsub(v, "Tutor and Inheritance Move Changes.+", "")
		end

		-- omg there's a typo!
		if m(v, "Fletching Line Ability Updates") then
			v = gsub(v, "Fletching Line Ability Updates.*Rocket", "")
		end

		if m(v, "Koffing Line Ability Updates") then
			log:print "KORRING"
			log:print(v)
			v = gsub(v, "Koffing Line Ability Updates.*Gas", "")
		end

		-- strip section headings in core rules
		if m(v, "Ability List:") then
			v = gsub(v, "Ability List:.-\r\n", "")
		end

		-- add seperators
		pages[k] = gsub(v, "\r\nAbility%s*:", "\r\n--------\r\nAbility:")
	end

	return pages
end

--[[
	Huge Power & Pure Power
	These abilities are defined together in the errata, and must be split here.
	Why are they even separate? They do the same thing but have different names.
]]
function hugePurePowerHax(tbl)
	local ability = abilityLUT["Huge Power / Pure Power"]
	local index
	for k, v in ipairs(tbl) do
		-- meh
		if v.name == "Huge Power / Pure Power" then
			index = k
		end
	end
	table.remove(tbl, index)
	abilityLUT["Huge Power"].fx = ability.fx
	abilityLUT["Pure Power"].fx = ability.fx
end