return function()
	local pieces = {}
	local tbl = require("survival.blocks")
	for i = 1, #tbl do
		pieces[#pieces+1] = "0"
	end
	return "set inventory "..table.concat(pieces, ",")
end