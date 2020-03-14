local m = string.match
local gsub = string.gsub

local function stripDefault(parser, str)
	local firstFeat = parser.names[1]
	return m(str, ".*\r\n(" .. firstFeat .. ".+)")
end

local function postDefault()

end

local function parser(file, tag, names, stripFunc, postFunc)
	stripFunc = stripFunc or stripDefault
	postFunc = postFunc or postDefault
	table.insert(names, "$")
	return
	{
		file = file,
		tag = tag,
		stripFunc = stripFunc,
		postFunc = postFunc,
		names = names
	}
end

return parser

