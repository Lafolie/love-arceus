--[[breaks a string into chunks based on supplied section headers
	 the section table should contain nested tables with the following layout:

	 {
		 {name = "resultTableIndex", str = "sectionHeaderString"}
	 }
]]

local function parser(str, sections)
	table.insert(sections, {str = "$"}) --append end of string
	local result = {}
	for n = 1, #sections - 1 do
		local current = sections[n]
		local start = current.str
		local finish = sections[n + 1].str

		local sectionStr = string.match(str, "(" .. current .. ".-)" .. finish)
		result[current.name] = sectionStr
	end

	return result
end

return parser