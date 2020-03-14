local m = string.match

function generateDexFile(n)
	local source = string.format("dexhtml/gen%d.txt", n)
	local dest = string.format("dexes/gen%d.dex", n)

	local tbl = filterDexNums(source)
	love.filesystem.write(dest, table.concat(tbl, "\n"))
end

function filterDexNums(file)
	local result = {}
	for line in love.filesystem.lines(file) do
		local str = m(line, "<.->(.-)<.->")
		table.insert(result, str)
	end
	return result
end

function readAllDexes()
	local fulldex, gendex = {}, {}
	for n=1, 8 do
		local gen = {}
		local file = string.format("dexes/gen%d.dex", n)
		for line in love.filesystem.lines(file) do
			local name = m(line, "%d*%s*(.+)")
			name = string.lower(name)
			table.insert(gen, name)
			table.insert(fulldex, name)
		end
		table.insert(gendex, gen)
	end
	result = 
	{
		full = fulldex,
		generation = gendex,

		-- get the number from a gen dex (useless?)
		findIn = function(self, gen, name)
			local tbl = self.generation[gen]
			for k, v in ipairs(tbl) do
				if v == name then
					return k
				end
			end
		end,

		-- get the national dex number
		find = function(self, name)
			name = string.lower(name)
			
			-- print(string.byte(string.sub(name, 10, 10)))
			local total, num = 0
			for n=1, 8 do
				num = self:findIn(n, name)
				if num then
					return num + total, n
				end
				total = total + #self.generation[n]
			end
			print(name, '[DEX:FIND]NOT FOUND!!!!!!!!!!!!')
		end
	}
	return result
end