-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Coordinator",
	"Decisive Director",
	"Adaptable Performance",
	"Flexible Preparations",
	"Innovation",
	"Nuanced Performance",
	"Reliable Performance"
}

local m = string.match

local function strip(parser, str)
	return m(str, "^(.-)\r\nInnovation Moves\r\n")
end

-- local secParser = require "otherData.util_sectionParser"

local function post(feats, str)
	local ex = {}
	local exStr = m(str, "\r\nInnovation Moves\r\n(.+)")
	
	local instructions = {title = "Innovation Moves"}
	instructions.body, exstr = m(exStr, "^(.-)(Template #1.+)")

	local templateStrs = {}
	for n = 1, 4 do
		local start = string.format("Template #%d", n) 
		local finish = n < 4 and string.format("Template #%d", n + 1) or "$"
		local ptn = string.format("(%s.-)%s", start, finish)
		table.insert(templateStrs, m(exStr, ptn))
	end

	local templates = {}
	for k, s in ipairs(templateStrs) do
		local template = {}
		template.title = string.format("Template #%d", k) 
		template.type = m(s, "Type: (.-)\r\n")
		template.freq = m(s, "Frequency: (.-)\r\n")
		template.ac = m(s, "AC: (.-)\r\n")
		template.class = m(s, "Class: (.-)\r\n")
		template.range = m(s, "Range: (.-)\r\n")
		local fx = m(s, "Effect: (.+)")

		if k == 1 then
			local strs = {m(fx, "^(.-)(Beauty.-)(Cool.-)(Cute.-)(Smart.-)(Tough.+)")}
			for k, v in ipairs(strs) do
				v = string.gsub(v, "\r\n", " ")
				v = m(v, "%s*(.+%S)")
				strs[k] = v
			end
			
			fx = table.concat(strs, "\n")
		else
			fx = string.gsub(fx, "\r\n", " ")
			fx = m(fx, "%s*(.+%S)")
		end

		template.fx = fx
		table.insert(templates, template)
	end

	ex.instructions = instructions
	ex.templates = templates
	return ex
end

return parser("coordinator.txt", "Coordinator Class", names, strip, post)