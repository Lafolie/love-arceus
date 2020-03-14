-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Commander's Voice",
	"Focused Command",
	
	"Agility Training",
	"Brutal Training",
	"Focused Training",
	"Inspired Training",
	
	"Ravager Orders",
	"Reckless Advance",
	"Strike Again!",
	"Marksman Orders",
	"Trick Shot",
	"Long Shot",
	
	"Trickster Orders",
	"Capricious Whirl",
	"Dazzling Dervish",
	"Guardian Orders",
	"Brace for Impact",
	"Sentinel Stance",

	"Precision Orders",
	"Pinpoint Strike",
	"Perfect Aim",

	
	
}

local function strip(parser, str)
	local firstFeat = parser.names[1]
	str = string.gsub(str, "Training Features: The following.-different Feature%)%.", "")
	str = string.gsub(str, "%[Stratagem%] Features are special Orders.-well%.", "")
	str = string.gsub(str, "Orders, Training Features, and Trainer Classes\r\n.-(Trickster Orders.+)", "%1")
	return string.match(str, ".*\r\n(" .. firstFeat .. ".+)")
end

return parser("training.txt", "Pokémon Training and Order", names, strip)