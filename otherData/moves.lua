local m = string.match
local gsub = string.gsub
local splitPtn = "(Move:.-Contest Effect:.-\r)"

local pokeTypes = 
{
	"bug",
	"dark",
	"dragon",
	"electric",
	"fairy",
	"fighting",
	"fire",
	"flying",
	"ghost",
	"grass",
	"ground",
	"ice",
	"steel",
	"water",
	"none"
}

local log = logger "moveParseLog.txt"

function parseMovePage(page, tbl)
	for str in string.gmatch(page, splitPtn) do
		local move = parseMove(str)
		table.insert(tbl, move)
	end
end

function parseMove(str)
	log:print "==================="
	log:print(str)
	local move = {}
	move.name = m(str, "Move%s*:%s*(.-)%c")
	move.type = m(str, "Type%s*:%s*(.-)%c")
	move.freq = m(str, "Frequency%s*:%s*(.-)%c")
	move.ac = m(str, "AC%s*:%s*(.-)%c")
	move.class = m(str, "Class%s*:%s*(.-)%c")
	move.range = m(str, "Range%s*:%s*(.-)%c")
	move.cont = m(str, "Contest Type%s*:%s*(.-)%c")
	move.cone = m(str, "Contest Effect%s*:%s*(.-)%c")

	move.dmg = m(str, "Damage Base (.-)%s*:%s*.-%c")
	move.fx = m(str, "Effect%s*:%s*(.-)%c*Contest Type")

	-- convert stuff as appropriate
	move.ac = tonumber(move.ac)

	local dmg = tonumber(move.dmg) or nil
	if (not dmg) and move.dmg == "X" then
		dmg = -1
	end

	move.dmg = dmg
	
	if move.fx then
		move.fx = gsub(move.fx, "\r\n", " ")
	end

	if move.fx == "None" then
		move.fx = nil
	end

	for k, v in pairs(move) do
		log:print("", k, v)
	end

	return move
end

function loadMovesPages()
	-- generate list of filenames from the types table
	local fileNames = {}
	local basePath = "otherData/core/moves/"

	local function exists(name, ex)
		local path = string.format("%s%s%s.txt", basePath, name, ex or "")
		return love.filesystem.getInfo(path) and path or nil
	end

	for k, v in ipairs(pokeTypes) do
		table.insert(fileNames, exists(v))
		table.insert(fileNames, exists(v, "alola"))
		table.insert(fileNames, exists(v, "galar"))
	end

	return getPages(fileNames)
end
