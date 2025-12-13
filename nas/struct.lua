local function comptbl(tbl, prefix, lines)
	for key, value in pairs(tbl) do
		local keystr
		if type(key) == "string" then
			keystr = prefix.."."..key
		elseif type(key) == "number" then
			keystr = prefix.."["..(key - 1).."]"
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