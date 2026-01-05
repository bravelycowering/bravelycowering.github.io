return function()
	local invpieces = {}
	local tbl = require("survival.blocks")
	for i = 1, #tbl do
		invpieces[#invpieces+1] = "{inventory["..tbl[i].id.."]}"
	end
	return "set inventory "..table.concat(invpieces, ",")
end