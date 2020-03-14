local logs = {}

function logger(name)
	local newlog =
	{
		name = 'log-'..name,
		log = {},

		print = function(self, ...)
			local str = {...}
			table.insert(self.log, table.concat(str, "\t"))
		end,

		printf = function(self, txt, ...)
			table.insert(self.log, string.format(txt, ...))
		end,

		flush = function(self)
			love.filesystem.write(self.name, table.concat(self.log, '\n'))
		end
	}
	table.insert(logs, newlog)
	return newlog
end

function flushLoggers()
	for k, v in ipairs(logs) do
		v:flush()
	end
end