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
li("		setadd l_x "..dx)
			end
			if ly ~= y then
				local dy = y - ly
				ly = y
li("		setadd l_y "..dy)
			end
			if lz ~= z then
				local dz = z - lz
				lz = z
li("		setadd l_z "..dz)
			end
li "		set l_id {world[{l_x},{l_y},{l_z}]}"
li "		if l_id|=|\"\" setblockid l_id {l_x} {l_y} {l_z}"
			local chance = "{l_id}"
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
li("		setrandlist l_id "..chance)
			end
li("		ifnot label #d[{l_id}] jump #exp"..labelno)
			if x ~= 0 or y ~= 0 or z ~= 0 then
li "			ifnot particle[{l_id}]|=|\"\" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0"
			end
li "			tempblock 0 {l_x} {l_y} {l_z}"
li "			set world[{l_x},{l_y},{l_z}] 0"
li("		#exp"..labelno)
			labelno = labelno + 1
		end
	end
end

assert(io.open("loop.txt", "w+b")):write(table.concat(lines, "\n")):close()