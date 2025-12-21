local function comptbl(tbl, prefix, lines)
	local indexoffset = -1
	if tbl[0] ~= nil then
		indexoffset = 0
	end
	for key, value in pairs(tbl) do
		local keystr
		if type(key) == "string" then
			keystr = prefix.."."..key
		elseif type(key) == "number" then
			keystr = prefix.."["..(key + indexoffset).."]"
		end
		if type(value) == "table" then
			comptbl(value, keystr, lines)
		else
			lines[#lines+1] = "set "..keystr.." "..tostring(value)
		end
	end
	if #tbl > 0 then
		lines[#lines+1] = "set "..prefix..".Length "..#tbl
	end
	return lines
end

return function(name, location)
	return table.concat(comptbl(require(location), name, {}), "\n")
end