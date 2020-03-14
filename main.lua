--[[
	LOVE-ARCEUS
	-----------
	Data-parsing tool for Pokémon Tabletop United literature

	This tool takes plaintext output of the official PDF files and converts the
	data into JSON for use in applications.

	This tool is built specifically for the Arceus PTU web application, but the
	resultant JSON should be usable by others.

	SOURCE TEXT FILES
	-----------------

	This tool is domain-specific and tightly coupled to the PDF -> text output.
	The following tool is used by the included Windows PowerShell scripts:

		https://www.xpdfreader.com/download.html

	If you want to run the PowerShell scripts, be sure to alter the filepaths
	first. There are 2 ps1 scripts:

		pdf2txt.ps1					- rips Pokedexes
		otherData/ripOtherData.ps1	- rips everything else
			
	The ripOtherData script requires the full suite of PDFs, including
	expansions (?) and errata.

	RUNNING
	-------

	Love-Arceus has a few cmd args to speed up execution, mainly for
	development. Run the tool with the -help arg for available options.

	To parse everything, run the tool with the -all arg.

	EXPORTED DATA NOTES
	-------------------
	Move Lists:
		-Level up moves with a level of 0 should be printed as 'Evo'
]]

json = require 'json'
require 'logger'

-- implemented logging late into project, so print is overridden
-- console printing is useless anyway since the buffer would need to be ridiculously huge
local main_log = logger('main.txt')
do
	p2=print
	function print(...)
		-- p(...)
		main_log:print(...)
	end
end

-- dexes for determining nation dex numbers (not included in PTU literature)
require 'dex'
nationalDex = readAllDexes()

-- main data harvesting/parsing files
require 'otherData.harvest' -- evertyhing except the Pokédex
require 'pokemon'			--the Pokédex
require 'makePage' 			--dynamically creates Pokédex pages for corner-case Pokémon

-- files for dex ripping
local ripDexFiles = 
{
	'rips/core.txt',
	'rips/alola.txt',
	'rips/galar.txt'
}

local darumakaFiles = 
{
	"rips/darumaka.txt"
}

local bulbaDex = 
{
	"devDex.txt"
}

-- session config stuff
local sessionConfigTbl = {}
function sessionConfig(...)
	local options = {...}
	for k, v in ipairs(options) do
		if not sessionConfigTbl[v] then
			return
		end
	end

	return true
end

-- arg processing / declaration
local configOptions = {}
configOptions["-dex"] = "Parse Pokedex"
configOptions["-abilities"] = "Parse abilities"
configOptions['-edges'] = 'Parse edges'
configOptions['-capabilities'] = 'Parse capabilities'
configOptions['-moves'] = 'Parse moves'
configOptions['-feats'] = 'Parse features'

local function processArgs(args)
	for k, arg in ipairs(args) do
		if arg == "-all" then
			for option, txt in ipairs(configOptions) do
				option = option:m("%-(.+)")
				sessionConfigTbl[option] = true
			end
		elseif arg == "-help" then
			sessionConfigTbl.help = true
			p2 '\nCommandline options for love-arceus:'
			p2 '\t-all'
			p2 '\t\tParse everything'
			for option, txt in pairs(configOptions) do
				p2('', option)
				p2('\t', txt)
			end
		elseif configOptions[arg] then
			local option = arg:match('%-(.+)')
			sessionConfigTbl[option] = true
		end
	end
end

-- work is done in love.load since this is not a game
function love.load(args)
	-- arg test
	if args then
		processArgs(args)

		if sessionConfig 'help' then
			love.event.push 'quit'
			return
		end
	end
	
	-- ensure that json folder exists
	love.filesystem.createDirectory('json')

	-- HAX FOR DEVELOPMENT
	sessionConfigTbl.feats = true
	-- harvest other data
	harvestOtherData()

	-- harvest pokedex
	if sessionConfig 'dex' then
		local pages = getPages(ripDexFiles)

		makeSpecialPages(pages)
		-- doFormeStuff(pages) --this was used to find meta on formes
		harvest(pages)
	end

	flushLoggers()

	-- auto-exit?
	love.event.push 'quit'
end

function doFormeStuff(pages)
	local pokemonData = {}
	for k, page in ipairs(pages) do
		table.insert(pokemonData, getPokemonNameOnly(page))
	end

	findNamesWithSpaces(pokemonData)
end

-- harvest data (Pokédex)
-- this should really live somewhere else but CBA
function harvest(pages)
	-- local pages = getPages('devgalar.txt')
	-- file:write(ff[1])
	-- print('TOTAL PAGES:', #pages)
	-- file:close()
	
	-- GENERATE THE BOIS
	local pokemonData = {}
	for k, page in ipairs(pages) do
		table.insert(pokemonData, getPokemon(page, nationalDex))
	end

	-- BUILD EVO/FORM TABLES
	for k, pkmn in ipairs(pokemonData) do
		buildEvoTbl(pkmn, pokemonData, nationalDex)
		pkmn.formeTbl = buildFormeTbl(pkmn)
	end
	printTotalTutor()

	-- print forme tables (must be done after building to ensure all tables are fully populated)
	for k, pkmn in ipairs(pokemonData) do
		-- buildEvoTbl(pkmn, pokemonData, nationalDex)
		-- pkmn.formeTbl = buildFormeTbl(pkmn)
		if pkmn.formeTbl then
			for k, v in ipairs(pkmn.formeTbl) do
				print("FORME:", v)
			end
		end
	end

	-- test json
	local bulbasaurJson = json.encode(pokemonData[1])
	love.filesystem.write('json/bulbausaurTest.json', bulbasaurJson)

	for k, v in ipairs(pokemonData) do
		if v.name == "EEVEE" then
			local bulbasaurJson = json.encode(v)
			love.filesystem.write('json/eeveeTest.json', bulbasaurJson)
		elseif v.name == "MAGNEMITE" then
			local bulbasaurJson = json.encode(v)
			love.filesystem.write('json/magnemiteTest.json', bulbasaurJson)
		elseif v.name == "KARRABLAST" then
			local bulbasaurJson = json.encode(v)
			love.filesystem.write('json/karrablastTest.json', bulbasaurJson)
		elseif v.name == "ARCEUS" then
			local bulbasaurJson = json.encode(v)
			love.filesystem.write('json/arceusTest.json', bulbasaurJson)
		elseif v.name == "ELDEGOSS" then
			local bulbasaurJson = json.encode(v)
			love.filesystem.write('json/eldegossTest.json', bulbasaurJson)
		elseif v.name == "KLINK" then
			local bulbasaurJson = json.encode(v)
			love.filesystem.write('json/klinkTest.json', bulbasaurJson)
		end
	end

	-- ability checking stuff
	local abilityNameLog = logger("abilityNameCheckLog.txt")
	for k, poke in ipairs(pokemonData) do
		for prop, v in pairs(poke) do
			if string.match(prop, "ability_") then
				-- local m = string.match(v, "%(") or string.match(v, "/")
				local m = string.match(v, "[^%a%s']")
				m = m or string.match(v, " or ")
				if m then
					abilityNameLog:print(poke.name, v)
				end
			end
		end
	end

	-- filterDexNums('dexes/gen1.txt')

	-- for n=1, 8 do
	-- 	-- generateDexFile(n)
	-- 	print(nationalDex[n][1])
	-- end

	--output all pokemon
	local dexJson = json.encode(pokemonData)
	love.filesystem.write('json/pokedex.json', dexJson)
end

-- read txt files and split results tables of pages, ready for parsing
local pageFeed = string.char(0xc)
function getPages(fileNames)
	print 'Reading files:'
	local result = {}
	local count = 0
	for k, fileName in ipairs(fileNames) do
		local f = love.filesystem.read(fileName)
		
		-- str = string.format("Bulbasaur%sIvysaur%sVenusaur%s",pageFeed, pageFeed, pageFeed)
		count = #result
		local pattern = "(.-)" .. pageFeed
		-- local page = string.gsub(f, pattern, "")
		for page in string.gmatch(f, pattern) do
			table.insert(result, page)
		end
		print(string.format('\tRead %d pages from %s', #result - count, fileName))
	end
	print(string.format('Finished reading %d pages total', #result))
	return result
end

-- input events make for quick closure of the program once it has been run
function love.keypressed()
	love.event.push "quit"
end

function love.mousepressed()
	love.event.push "quit"
end


-- ERROR STUFF
-- error handler subtly modified to flush log files in case of an error
local utf8 = require("utf8")
 
local function error_printer(msg, layer)
	p2((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end
 
function love.errorhandler(msg)
	flushLoggers()
	msg = tostring(msg)
 
	error_printer(msg, 2)
 
	if not love.window or not love.graphics or not love.event then
		return
	end
 
	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end
 
	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
		if love.mouse.isCursorSupported() then
			love.mouse.setCursor()
		end
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end
 
	love.graphics.reset()
	local font = love.graphics.setNewFont(14)
 
	love.graphics.setColor(1, 1, 1, 1)
 
	local trace = debug.traceback()
 
	love.graphics.origin()
 
	local sanitizedmsg = {}
	for char in msg:gmatch(utf8.charpattern) do
		table.insert(sanitizedmsg, char)
	end
	sanitizedmsg = table.concat(sanitizedmsg)
 
	local err = {}
 
	table.insert(err, "Error\n")
	table.insert(err, sanitizedmsg)
 
	if #sanitizedmsg ~= #msg then
		table.insert(err, "Invalid UTF-8 string in error message.")
	end
 
	table.insert(err, "\n")
 
	for l in trace:gmatch("(.-)\n") do
		if not l:match("boot.lua") then
			l = l:gsub("stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end
 
	local p = table.concat(err, "\n")
 
	p = p:gsub("\t", "")
	p = p:gsub("%[string \"(.-)\"%]", "%1")
 
	local function draw()
		local pos = 70
		love.graphics.clear(89/255, 157/255, 220/255)
		love.graphics.printf(p, pos, pos, love.graphics.getWidth() - pos)
		love.graphics.present()
	end
 
	local fullErrorText = p
	local function copyToClipboard()
		if not love.system then return end
		love.system.setClipboardText(fullErrorText)
		p = p .. "\nCopied to clipboard!"
		draw()
	end
 
	if love.system then
		p = p .. "\n\nPress Ctrl+C or tap to copy this error"
	end
 
	return function()
		love.event.pump()
 
		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
			elseif e == "keypressed" and a == "escape" then
				return 1
			elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
				copyToClipboard()
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				if love.system then
					buttons[3] = "Copy to clipboard"
				end
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return 1
				elseif pressed == 3 then
					copyToClipboard()
				end
			end
		end
 
		draw()
 
		if love.timer then
			love.timer.sleep(0.1)
		end
	end
 
end