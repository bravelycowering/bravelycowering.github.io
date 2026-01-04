return function()
	local invpieces = {}
	local tbl = require("survival.blocks")
	for i = 1, #tbl do
		invpieces[#invpieces+1] = "{inventory["..tbl[i].id.."]}"
	end
	local invstr = table.concat(invpieces, ",")
	local saveformat = require("survival.saveformat")
	local pieces = {"placemessageblock 7 {saveSlot} /nothing2 @p"}
	for i = 2, #saveformat do
		if saveformat[i] == "inventory" then
			pieces[#pieces+1] = invstr
		else
			pieces[#pieces+1] = "{"..saveformat[i].."}"
		end
	end
	return table.concat(pieces, "|")
end