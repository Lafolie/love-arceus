local m = string.match
local gsub = string.gsub
local log = logger "edgesParseLog.txt"

function parseEdgesData(tbl)
	parseTrainerEdges(tbl)
	parsePokeEdges(tbl)
end

local edgeCategories = {"Crafting", "Pokémon Training", "Combat", "Other"}

function parseEdge(e, kind)
		local edge = {}
		edge.name = e.name
		-- edge.cat = e.cat

		-- log:print(e.body)
		local body = gsub(e.body, "Static\r\n", "")
		
		-- tag scribe hax
		if e.name == "Tag Scribe" then
			body = gsub(body, "Special - Extended Action\r\n", "")
			edge.special = "Extended Action"
		end

		local preq = m(body, "Prerequisites*:%s*(.-)Effect:")
		local fx = m(body, "Effect:%s*(.+)")
		local cost = m(preq, "Cost:%s*(.-)\r\n")
		if cost then
			preq = gsub(preq, "Cost:.+", "")
		end

		preq = gsub(preq, "\r\n", " ")
		edge.preq = m(preq, "(.+)%s+")
		edge.fx = gsub(fx, "\r\n", " ")
		edge.cost = cost
		edge.kind = kind
		
		log:print "=========="
		log:print(edge.name)
		-- log:print(edge.cat)
		log:print(edge.preq)
		log:print(edge.cost)
		log:print(edge.fx)
		
		return edge
end

function parseTrainerEdges(tbl)
	local pages = getPages({"otherData/core/edges/edges.txt"})

	local edgeStrs = {}
	-- read by line (similar to capabilities)
	local catID, catStr, nextCatStr = 0

	local function setNextCat()
		catID = math.min(catID + 1, #edgeCategories)
		catStr = string.format("%s Edges", edgeCategories[catID])
		nextCatStr = string.format("%s Edges", edgeCategories[catID + 1])
	end

	for k, page in ipairs(pages) do
		-- remove page nums & chapter text, convert bad chars
		page = replaceBadChars(m(page, "^Skills, Edges, Feats%c*%d*%c*(.+)"))

		-- special case for first page
		if k == 1 then
			page  = m(page, "Skill Edges\r\n(.+)")
			page = gsub(page, "(.-)Cast's Note:.-(Categoric Inclination.+)", "%1%2")
		end

		setNextCat()

		local name, prevLine
		local body = {}

		for str in string.gmatch(page, "(.-)\r\n") do
			if str == nextCatStr then
				-- hit category line
				setNextCat()
				
			else
				if m(str, "^Prerequisites*:") then	
					-- flush last ability
					if name then
						-- log:print(name)
						table.remove(body, #body) --remove name that was added last iteration
						local bodyStr = table.concat(body, "\r\n")
						table.insert(edgeStrs, {name = name, body = bodyStr})
					end

					-- setup next
					name = prevLine
					body = {str}
				else
					table.insert(body, str)
					prevLine = str
				end

			end
		end

		-- flush last edge
		-- table.remove(body, #body) --remove name that was added last iteration
		local bodyStr = table.concat(body, "\r\n")
		table.insert(edgeStrs, {name = name, body = bodyStr})
	end

	-- parse read table
	for k, v in ipairs(edgeStrs) do
		local edge = parseEdge(v, "pc")
		table.insert(tbl, edge)
	end
end

-- these pages are not normalized enough, so may as well do this sicne they're also short
function parsePokeEdges(tbl)
	local pages = getPages({"otherData/core/edges/poke.txt"})

	local p1Names = 
	{
		"Skill Improvement",
		"Attack Conflict",
		"Mixed Sweeper",
		"Underdog's Strength",
		"Realized Potential",
		"Ability Mastery",
		"Advanced Connection"
	}
	local p2names = 
	{
		"Accuracy Training",
		"Underdog's Lessons",
		"Capability Training",
		"Advanced Mobility",
		"Basic Ranged Attacks",
		"Aura Pulse",
		"Enticing Bait",
		"Extended Invisibility",
		"Far Reading",
		"Precise Threadings",
		"Seismometer",
		"TK Mastery",
		"Trail Sniffer"
	}

	-- local edges = {}
	local nameKey = 1
	for k, page in ipairs(pages) do
		-- remove page nums & chapter text, convert bad chars
		page = replaceBadChars(m(page, "^Pok.mon%c*%d*%c*(.+)"))

		local names = k == 1 and p1Names or p2names
		table.insert(names, "$")

		
		for n = 1, #names - 1 do
			local start = names[n]
			local fin = names[n + 1]
			local str = m(page, start .. "\r\n(.-)" .. fin)
			
			-- remove guff
			str = gsub(str, "Note:.+", "")
			if start == "Underdog's Lessons" then
				str = m(str, "(.-Evolutions%.).+")
			end

			-- mixed sweeper stuff
			if start == "Mixed Sweeper" then
				-- ???
				local ranks = m(str, "%[.-Cost:")
				
				
				local a, b, c = m(ranks, "Rank 1.-: (.-)Rank 2.-: (.-)Rank 3.-: (.+)")
				a = gsub(a, "\r\n", " ")
				b = gsub(b, "\r\n", " ")
				c = gsub(c, "\r\n", " ")

				ranks = string.format("[Ranked 3]\nRank 1: %s\nRank 2: %s\nRank 3: %s", a, b, c)

				str = gsub(str, "%[.-(Cost:)", "Prerequisites:"..ranks.."%1")
			end

			local e = {}
			e.name = start
			e.body = str

			table.insert(tbl, parseEdge(e, "poke"))
		end
	end
end