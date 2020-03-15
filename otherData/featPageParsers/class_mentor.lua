-- local function data(file, tag, names, stripFunc, postFunc)
local parser = require "otherData.featParser"
local names = 
{
	"Mentor",
	"Lessons",
	"Expand Horizons",
	"Guidance",
	"Move Tutor",
	"Egg Tutor",
	"Lifelong Learning"
}

local m = string.match

local function strip(parser, str)
	-- local firstFeat = parser.names[1]
	return m(str, "(.-)Changing Viewpoints\r\n")
end

local function post(feats, str)
	local ex = {}
	local exStr = m(str, "(Changing Viewpoints.+)Mentor Lessons\r\n")

	local lessonStrs = {}
	table.insert(lessonStrs, m(exStr, "^(.-)Empowered Development"))
	table.insert(lessonStrs, m(exStr, "(Empowered Development.-)Corrective Learning"))
	table.insert(lessonStrs, m(exStr, "(Corrective Learning.-)Versatile Teachings"))
	table.insert(lessonStrs, m(exStr, "(Versatile Teachings.+)"))

	local lessons = {}
	for k, s in ipairs(lessonStrs) do
		local lesson = {}
		lesson.name = m(s, "^(.-)\r\n")
		lesson.preqs = m(s, "Prerequisites: (.-)Target:")
		lesson.target = m(s, "Target: (.-)Effect:")
		local fx = m(s, "Effect: (.+)")

		-- versatile teachings has a note
		if lesson.name == "Versatile Teachings" then
			fx, lesson.note = m(fx, "(.-)Note: (.+)")
		end
		lesson.fx = fx
		
		-- cleanup
		for i, j in pairs(lesson) do
			j = string.gsub(j, "\r\n", " ")
			j = m(j, "%s*(.+%S)")
			lesson[i] = j
		end

		table.insert(lessons, lesson)
	end

	ex.lessons = lessons
	return ex
end

return parser("mentor.txt", "Mentor Class", names, strip, post)