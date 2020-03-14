--[[breaks a string into chunks based on supplied section headers
	 the section table should contain nested tables with the following layout:

	 {
		 {name = "resultTableIndex", str = "sectionHeaderString"}
	 }
]]
local m = string.match

local function parser(str, sections)
	table.insert(sections, {str = "$"}) --append end of string
	local result = {}
	for n = 1, #sections - 1 do
		local current = sections[n]
		local start = current.str
		local finish = sections[n + 1].str

		local sectionStr = m(str, "(" .. current .. ".-)" .. finish)

		-- trim identifier from string if required
		if current.trim then
			sectionStr = m(sectionStr, current .. "(.+)")	
		end

		-- cleanup
		sectionStr = string.gsub(sectionStr, "\r\n", " ")
		sectionStr = m(sectionStr, "%s*(.+%S)")

		result[current.name] = sectionStr
	end

	return result
end

return parser