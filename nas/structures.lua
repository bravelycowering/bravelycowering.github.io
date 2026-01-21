return function(filename)
	local outlines = {}

	local f = assert(io.open(filename, "rb"))
	local filestr = f:read("a")
	f:close()

	for label, body in filestr:gmatch("(%S+)%s*(%b{})") do
		local ox, oy, oz = 0, 0, 0
		for x, y, z in filestr:gmatch("origin:%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)") do
			ox, oy, oz = x, y, z
		end
		local lx, ly, lz = 0, 0, 0
	end

	return table.concat(outlines, "\n")
end