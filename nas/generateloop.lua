local lines = {}

local function li(txt)
	lines[#lines+1] = txt
end

local lx, ly, lz = 0, 0, 0
local labelno = 0

for x = -3, 3 do
	for y = -3, 3 do
		for z = -3, 3 do
			if lx ~= x then
				local dx = x - lx
				lx = x
li("		setadd x "..dx)
			end
			if ly ~= y then
				local dy = y - ly
				ly = y
li("		setadd y "..dy)
			end
			if lz ~= z then
				local dz = z - lz
				lz = z
li("		setadd z "..dz)
			end
li "		set id {world[{x},{y},{z}]}"
li "		if id|=|\"\" setblockid id {x} {y} {z}"
			local chance = "{id}"
			local dorandom = false
			if math.abs(x) == 3 then
				dorandom = true
				chance = chance.."|7"
			end
			if math.abs(y) == 3 then
				dorandom = true
				chance = chance.."|7"
			end
			if math.abs(z) == 3 then
				dorandom = true
				chance = chance.."|7"
			end
			if dorandom then
li("		setrandlist id "..chance)
			end
li "		ifnot particle[{id}]|=|\"\" effect {particle[{id}]} {x} {y} {z} 0 0 0"
li("		ifnot label #d[{id}] jump #exp"..labelno)
li "			tempblock 0 {x} {y} {z}"
li "			set world[{x},{y},{z}] 0"
li("		#exp"..labelno)
			labelno = labelno + 1
		end
	end
end

assert(io.open("loop.txt", "w+b")):write(table.concat(lines, "\n")):close()