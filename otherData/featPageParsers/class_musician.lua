-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Musician",
	"Musical Ability",
	"Mt%. Moon Blues",
	"Cacophony",
	"Noise Complaint",
	"Voice Lessons",
	"Power Chord"
}

local m = string.match
local secParser = require "otherData.util_sectionParser"

local function strip(parser, str)
	return m(str, "(.-)Song of Courage\r\n")
end

local function fixFeats(feats)
	-- apply some errata as notes, May 2015 Packet
	for k, feat in ipairs(feats) do
		if feat.name == "Musician" then
			--listify
			local mechanic, listStr = m(feat.mechanicSongs, "(.-)(When using a Move.+)")
			local items = {"When using a Move", "When using a Dance Move", "As a Standard Action", "As a Full Action", "$"}
			local list = {}
			for n = 1, #items - 1 do
				local ptn = string.format("(%s.-)%s", items[n], items[n+1])
				local li = m(listStr, ptn)
				table.insert(list, li)
			end
			feat.mechanicSongs = mechanic
			feat.list = list
		end
	end
end

local function post(feats, str)
	local ex = {}
	local exStr = m(str, "(Song of Courage\r\n.+)")
	
	-- metadata for the secParser
	local effect = {name = "fx", str = "Effect:", trim = true}
	local ap = {name = "freq", str = "%d AP"}
	local trigger = {name = "trigger", str = "Trigger:", trim = true}

	local function makeMeta(name, ...)
		local nameTbl = {name = "name", str = name}
		return {nameTbl, ...}
	end

	local meta = 
	{
		makeMeta("Song of Courage", ap, trigger, effect),
		makeMeta("Song of Might", ap, trigger, effect),
		makeMeta("Song of Life", ap, trigger, effect)
	}

	-- split into chunks
	local chunkMeta = {}
	for k, v in ipairs(meta) do
		table.insert(chunkMeta, {name = k, str = v[1].str})
	end
	local chunks = secParser(exStr, chunkMeta)

	-- parse chunks
	local songs = {}
	for k, chunk in ipairs(chunks) do
		local song = secParser(chunk, meta[k])
		table.insert(songs, song)
	end

	fixFeats(feats)
	ex.songs = songs
	return ex
end

return parser("musician.txt", "Musician Class", names, strip, post)