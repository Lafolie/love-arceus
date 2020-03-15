-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Martial Artist",
	"Martial Training",
	"My Kung%-Fu is Stronger",
	"Martial Achievement",
	"Second Strike"
}

local m = string.match
local secParser = require "otherData.util_sectionParser"

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	local a, b = m(str, "(.-)Rank 1 Moves.-(My Kung%-Fu.-)Wrestlemania")
	return string.format("%s\r\n%s", a, b)
end

local function fixFeats(feats)
	-- apply some errata as notes, May 2015 Packet
	for k, feat in ipairs(feats) do
		if feat.name == "Martial Artist" then
			feat.fx = m(feat.fx, "(.-)Guts")
			feat.tbl = 
			{
				{"Guts",		"[+HP]"		},
				{"Inner Focus", "[+Speed]"	},
				{"Iron Fist",	"[+Defense]"},
				{"Limber",		"[+Speed]"	},
				{"Reckless",	"[+Attack]"	},
				{"Technician",	"[+Speed]"	},
			}
		end
	end
end

local function post(feats, str)
	local ex = {}
	local exStr = m(str, "(Wrestlemania\r\n.+)\r\nMartial Achievements")
	
	-- metadata for the secParser
	local effect = {name = "fx", str = "Effect:", trim = true}
	local ap = {name = "freq", str = "%d AP"}
	local trigger = {name = "trigger", str = "Trigger:", trim = true}
	local prerequisites = {name = "preqs", str = "Prerequisites:", trim = true}

	local function makeMeta(name, ...)
		local nameTbl = {name = "name", str = name}
		return {nameTbl, ...}
	end

	local meta = 
	{
		makeMeta("Wrestlemania", prerequisites, ap, trigger, effect),
		makeMeta("Heightened Intensity", prerequisites, ap, effect),
		makeMeta("Pummeling Momentum", prerequisites, ap, trigger, effect),
		makeMeta("Bend Like the Willow", prerequisites, ap, trigger, effect),
		makeMeta("Soft Landing", prerequisites, ap, trigger, effect),
		makeMeta("Whirlwind Strikes", prerequisites, ap, effect)
	}

	-- split into chunks
	local chunkMeta = {}
	for k, v in ipairs(meta) do
		table.insert(chunkMeta, {name = k, str = v[1].str})
	end
	local chunks = secParser(exStr, chunkMeta)

	-- parse chunks
	local achievements = {}
	for k, chunk in ipairs(chunks) do
		local achievement = secParser(chunk, meta[k])
		table.insert(achievements, achievement)
	end

	-- set!
	ex.martialAchivements = achievements

	-- build move tables
	ex.rank1Moves = 
	{
		{"Move",			"Prerequisites"	},
		{"Acupressure",		"Limber"		},
		{"Arm Thrust",		"Technician"	},
		{"Double Kick",		"None"			},
		{"Focus Energy",	"None"			},
		{"Karate Chop",		"Inner Focus"	},
		{"Low Sweep",		"None"			},
		{"Mach Punch",		"Iron Fist"		},
		{"Rolling Kick",	"Reckless"		},
		{"Vital Throw",		"Guts"			}
	}

	ex.rank2Moves = 
	{
		{"Move",			"Prerequisites"	},
		{"Brick Break",		"None"			},
		{"Circle Throw",	"Guts"			},
		{"Comet Punch",		"Iron Fist"		},
		{"Counter",			"Limber"		},
		{"Low Kick",		"Inner Focus"	},
		{"Jump Kick",		"Reckless"		},
		{"Power Trick",		"Limber"		},
		{"Quick Guard",		"Technician"	}
	}

	ex.rank3Moves = 
	{
		{"Move",			"Prerequisites"	},
		{"Cross Chop",		"Inner Focus"	},
		{"Close Combat",	"None"			},
		{"Triple Kick",		"Technician"	},
		{"High Jump Kick",	"Reckless"		},
		{"Sky Uppercut",	"Iron Fist"		},
		{"Storm Throw",		"Guts"			}
	}

	fixFeats(feats)
	
	return ex
end

return parser("martialArtist.txt", "Martial Artist Class", names, strip, post)