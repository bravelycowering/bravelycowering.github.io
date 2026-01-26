local uuid = require "uuid"

return function(filename)
	local outstructs = {}

	local f = assert(io.open(filename, "rb"))
	local filestr = f:read("a")
	f:close()

	for label, body in filestr:gmatch("(%S+)%s*(%b{})") do
		local l_coords = "l_"..uuid"coords"
		local l_coordorder = "l_"..uuid"coordorder"
		local l_xcoord = l_coordorder.."[0]"
		local l_ycoord = l_coordorder.."[1]"
		local l_zcoord = l_coordorder.."[2]"
		local l_positive = "l_"..uuid"positive"
		local l_negative = "l_"..uuid"negative"
		local l = {
			label,
			"set "..l_positive.." {runArg4}",
			"setsplit "..l_positive,
			"set "..l_negative.." {runArg5}",
			"setsplit "..l_negative,
			"set "..l_coordorder.." {runArg6}",
			"setsplit "..l_coordorder,
			"set %x {runArg1}",
			"set %y {runArg2}",
			"set %z {runArg3}",
		}
		local uuids = {
			x = l_coords.."[{"..l_xcoord.."}]",
			y = l_coords.."[{"..l_ycoord.."}]",
			z = l_coords.."[{"..l_zcoord.."}]",
			Px = l_positive.."[{"..l_xcoord.."}]",
			Py = l_positive.."[{"..l_ycoord.."}]",
			Pz = l_positive.."[{"..l_zcoord.."}]",
			Nx = l_negative.."[{"..l_xcoord.."}]",
			Ny = l_negative.."[{"..l_ycoord.."}]",
			Nz = l_negative.."[{"..l_zcoord.."}]",
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
						local dist = (x - lx)
						local diststr
						if dist > 0 then
							diststr = "{%Px}"..tostring(dist)
						else
							diststr = "{%Nx}"..tostring(-dist)
						end
						l[#l+1] = "setadd %x "..diststr
						lx = x
					end
					if ly ~= y then
						local dist = (y - ly)
						local diststr
						if dist > 0 then
							diststr = "{%Py}"..tostring(dist)
						else
							diststr = "{%Ny}"..tostring(-dist)
						end
						l[#l+1] = "setadd %y "..diststr
						ly = y
					end
					if lz ~= z then
						local dist = (z - lz)
						local diststr
						if dist > 0 then
							diststr = "{%Pz}"..tostring(dist)
						else
							diststr = "{%Nz}"..tostring(-dist)
						end
						l[#l+1] = "setadd %z "..diststr
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
		outstructs[#outstructs+1] = table.concat(l, "\n"):gsub("%%(%w+)", function (m)
			if not uuids[m] then
				uuids[m] = "l_"..uuid(m)
			end
			return uuids[m]
		end)
		print("created structure label "..label.." containing "..blockc.." blocks and "..#l.." actions")
	end

	return table.concat(outstructs, "\n\n")
end