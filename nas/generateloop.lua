local lines1 = {}
local lines2 = {}

local function li(txt)
	lines1[#lines1+1] = txt
	lines2[#lines2+1] = txt
end

local function l1(txt)
	lines1[#lines1+1] = txt
end

local function l2(txt)
	lines2[#lines2+1] = txt
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
l1 "		set l_id {world[{l_x},{l_y},{l_z}]}"
l1 "		if l_id|=|\"\" setblockid l_id {l_x} {l_y} {l_z}"
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
l1("		setrandlist l_id "..chance)
			end
l1("		ifnot label #d[{l_id}] jump #exp"..labelno)
			if x ~= 0 or y ~= 0 or z ~= 0 then
l1 "			ifnot particle[{l_id}]|=|\"\" effect {particle[{l_id}]} {l_x} {l_y} {l_z} 0 0 0"
			end
l1 "			tempblock 0 {l_x} {l_y} {l_z}"
l1 "			set world[{l_x},{l_y},{l_z}] 0"
			if dorandom then
l2 "		if label #d[{l_id}] tempblock 117 {l_x} {l_y} {l_z}"
			else
l2 "		if label #d[{l_id}] tempblock 115 {l_x} {l_y} {l_z}"
			end
l1("		#exp"..labelno)
			labelno = labelno + 1
		end
	end
end

assert(io.open("loop.txt", "w+b")):write(table.concat(lines1, "\n")):close()
assert(io.open("loop2.txt", "w+b")):write(table.concat(lines2, "\n")):close()