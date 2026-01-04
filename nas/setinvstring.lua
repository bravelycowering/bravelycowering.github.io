return function(name, init)
	local pieces = {}
	local tbl = require(name)
	for i = 1, #tbl do
		if init then
			pieces[#pieces+1] = "0"
		else
			pieces[#pieces+1] = "{inventory["..tbl[i].id.."]}"
		end
	end
	return "set inventory "..table.concat(pieces, ",")
end