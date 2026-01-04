return function(name)
	local pieces = {}
	local tbl = require(name)
	for i = 1, #tbl do
		pieces[#pieces+1] = "{inventory["..tbl[i].id.."]}"
	end
	return "set inventory "..table.concat(pieces, ",")
end