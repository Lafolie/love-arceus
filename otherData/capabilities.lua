local m = string.match
local gsub = string.gsub
local log = logger "CapesParseLog.txt"

--[[
	Capabilities are parsed in chunks (per document) as there are fewer than moves and abilities.
	They are spread over pages in places too.
]]
function parseCapabilitiesData(tbl)
	addBasicCapes(tbl)
	parseCoreCapes(tbl)
	addExtraCapes(tbl)

	for k, cape in ipairs(tbl) do
		log:print "==============="
		log:print(cape.name)
		log:print(cape.fx)
	end
end

local extraCapes = require "otherData/extraCapes"

function addExtraCapes(tbl)
	for k, cape in ipairs(extraCapes) do
		table.insert(tbl, cape)
	end
end

function parseCoreCapes(tbl)
	local pages = getPages({"otherData/core/capabilities/core.txt"})

	-- living weapon / sprouter
	local name
	local fxLines = {}

	function createAbility()
		if name then
			local cape = {name = name, fx = table.concat(fxLines, " ")}
			table.insert(tbl, cape)
			fxLines = {}
		end
	end

	for k, v in ipairs(pages) do
		-- remove page nums & chapter text, convert bad chars
		v = replaceBadChars(m(v, "^Indices and Reference%c*%d*%c*(.+)"))

		if k == 1 then
			-- trim chapter intro
			v = gsub(v, "^.-size%.\r\n", "")
		end

		-- iterate over lines as some definitions cross page boundaries
		for line in string.gmatch(v, "(.-)\r\n") do
			if m(line, ":") then
				createAbility() --flush current ability to result table
				name, str = m(line, "(.-):%s*(.+)")
				table.insert(fxLines, str)
			else
				table.insert(fxLines, line)
			end
		end
		-- v = gsub("\r\n" .. v, "(%c*[%s%a]-:).-", "\r\n=====%1")
		-- -- log:print(v)
		-- for cape in string.gmatch(v, "(.-)\r\n=====\r\n") do
		-- 	log:print "==============="
		-- 	log:print(cape)
		-- end
	end

	-- flush final ability
	createAbility()
	
end

function addBasicCapes(tbl)
	local power = 
	{
		name = "Power",
		fx = "Power represents a Pokémon or Trainer's physical strength. "
	}

	local jHi = 
	{
		name = "High Jump",
		fx = "High Jump measures how far a Pokémon or Trainer can Jump."
	}

	local jLo = 
	{
		name = "Long Jump",
		fx = "Long Jump measures how far a Pokémon or Trainer can Jump."
	}

	local burrow = 
	{
		name = "Burrow",
		fx = "The Burrow Capability determines how much a Pokémon can shift each turn while underground. The holes dug are only as large as the Pokémon who burrows. If a Pokémon learns the Move Dig and does not have the Burrow Capability, they gain Burrow 3. If they already have the Burrow Capability, the Burrow value is raised 3. A Pokémon or Trainer ending its turn underground must spend a Standard Action to remain underground. If a Pokémon or Trainer has already spent its Standard Action on a round it ends underground, it instead forfeits its next Standard Action."
	}

	local overland = 
	{
		name = "Overland",
		fx = "Overland is a Movement Capability that defines how many meters the Pokémon may shift while on dry land. Most Pokémon and Trainers will use Overland as their primary movement capability."
	}

	local sky = 
	{
		name = "Sky",
		fx = "The Sky Speed determines how many meters a Pokémon may shift in the air. If a Pokémon learns the Move Fly and does not have the Sky Capability, they gain Sky 4. If they already have the Sky Capability, the Sky value is raised by 4."
	}

	local swim = 
	{
		name = "Swim",
		fx = "Swim is a Movement Capability that defines how quickly the Pokémon can move underwater. If a Pokémon learns the Move Dive and does not have the Swim Capability, they gain Swim 3. If they already have the Underwater Capability, the Swim value is raised 3."
	}

	local levitate = 
	{
		name = "Levitate",
		fx = "Levitate is a Movement Capability that defines how quickly the Pokémon moves while floating or levitating. When using the Levitate Capability, the maximum height off the ground the Pokémon can achieve is equal to half of their Levitate Capability. If a Pokémon gains the Levitate ability and does not have the Levitate Capability, they gain Levitate 4. If they already have the Levitate Capability, the Levitate value is raised 2."
	}

	local teleport = 
	{
		name = "Teleporter",
		fx = "Teleporter is a Movement Capability that defines how far the Pokémon can travel by teleportation. Only one teleport action can be taken during a round of combat. The Pokémon must have line of sight to the location they wish to teleport to, and they must end each teleport action touching a surface (ie it is not possible to 'chain' teleports in order to fly). If a Pokémon also has the Sky or Levitate Capability, they may Teleport into Sky spaces (only to spaces within their maximum height for Levitate). Teleporter cannot be increased by taking a Sprint Action. If a Pokémon learns the move Teleport and does not have the Teleporter Capability they gain Teleporter 4. If they already have the Teleporter Capability, the Teleporter value is raised 4."
	}

	table.insert(tbl, power)
	table.insert(tbl, jHi)
	table.insert(tbl, jLo)
	table.insert(tbl, burrow)
	table.insert(tbl, overland)
	table.insert(tbl, sky)
	table.insert(tbl, swim)
	table.insert(tbl, levitate)
	table.insert(tbl, teleport)
end