local uuid = require "uuid"

return function(filename)
	local outstructs = {}

	local f = assert(io.open(filename, "rb"))
	local filestr = f:read("a")
	f:close()

	for label, body in filestr:gmatch("(%S+)%s*(%b{})") do
		local l = {
			label,
			"set %x {runArg1}",
			"set %y {runArg2}",
			"set %z {runArg3}",
		}
		local ox, oy, oz = 0, 0, 0
		for x, y, z in body:gmatch("origin%s*:%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)") do
			---@diagnostic disable-next-line: cast-local-type
			ox, oy, oz = tonumber(x), tonumber(y), tonumber(z)
		end
		local legend = {
			[32] = { skip = true },
		}
		for name, value in body:gmatch("(%w+)%s*:%s*(%d+)") do
			if #name == 1 then
				legend[name:byte()] = { id = tonumber(value) }
			end
		end
		for name, actions in body:gmatch("(%w+)%s*:%s*(%b{})") do
			if #name == 1 then
				local actiontbl = {}
				for line in actions:sub(2, -2):gmatch("([^\n]+)") do
					actiontbl[#actiontbl+1] = line
				end
				legend[name:byte()] = {
					id = "{%b}",
					actions = actiontbl,
				}
			end
		end
		for name, value, cond in body:gmatch("(%w+)%s*:%s*(%d+)%s*%?%s*(%w+)") do
			if #name == 1 then
				legend[name:byte()].condition = cond
			end
		end
		for name, actions, cond in body:gmatch("(%w+)%s*:%s*(%b{})%s*%?%s*(%w+)") do
			if #name == 1 then
				legend[name:byte()].condition = cond
			end
		end
		local layers = {}
		for layerstr in body:gmatch("(%b[])") do
			local layer = {}
			for rowstr in layerstr:sub(2, -2):gmatch("(%b[])") do
				local row = {}
				for i = 2, #rowstr - 1 do
					row[#row+1] = assert(legend[rowstr:byte(i)], "undefined block '"..rowstr:sub(i, i).."' in "..label)
				end
				layer[#layer+1] = row
			end
			table.insert(layers, 1, layer)
		end
		local lx, ly, lz = ox, oy, oz
		local blockc = 0
		local y = 0
		for _, layer in ipairs(layers) do
			local z = 0
			for _, row in ipairs(layer) do
				local x = 0
				for _, block in ipairs(row) do
					local line
					if block.skip then
						goto continue
					end
					if lx ~= x then
						l[#l+1] = "setadd %x "..(x - lx)
						lx = x
					end
					if ly ~= y then
						l[#l+1] = "setadd %y "..(y - ly)
						ly = y
					end
					if lz ~= z then
						l[#l+1] = "setadd %z "..(z - lz)
						lz = z
					end
					if block.actions then
						for index, value in ipairs(block.actions) do
							l[#l+1] = value
						end
					end
					if block.condition then
						line = "call {#setblockif}|"..block.id.."|{%x}|{%y}|{%z}|"..block.condition
					else
						line = "call {#setblock}|"..block.id.."|{%x}|{%y}|{%z}"
					end
					if block.actions then
						line = "ifnot %b|=|0 "..line
					end
					l[#l+1] = line
					blockc = blockc + 1
				    ::continue::
					x = x + 1
				end
				z = z + 1
			end
			y = y + 1
		end
		l[#l+1] = "quit"
		local uuids = {
			x = "l_"..uuid("x"),
			y = "l_"..uuid("y"),
			z = "l_"..uuid("z"),
			b = "l_"..uuid("b"),
		}
		outstructs[#outstructs+1] = table.concat(l, "\n"):gsub("%%([xyzb])", function (m)
			return uuids[m]
		end)
		print("created structure label "..label.." containing "..blockc.." blocks and "..#l.." actions")
	end

	return table.concat(outstructs, "\n\n")
end