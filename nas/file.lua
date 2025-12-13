local function randstr(n)
	local chars = {}
	for i = 1, n do
		chars[#chars+1] = string.char(math.random(65, 90) + math.random(0, 1)*32)
	end
	return table.concat(chars)
end

local conflicts = {}

return function(inpath)
	local infile = assert(io.open(inpath, "rb"))
	local incontent = infile:read("a")
	infile:close()
	local lines = {}
	local ends = {}
	for line in incontent:gmatch("[^\n]*") do
		local condition, condargs, condargcount, action, args = nil, {}, 0, nil, {}
		for word in line:gmatch("%S+") do
			if condargcount > 0 then
				condargs[#condargs+1] = word
				if condargcount == 2 and (word == "item" or word == "label") then
					condargcount = condargcount - 1
				else
					condargcount = 0
				end
			else
				if action then
					args[#args+1] = word
				elseif word == "if" or word == "ifnot" or word == "while" then
					condition = word
					condargcount = 2
				elseif word == "else" then
					condition = word
				else
					action = word
				end
			end
		end
		if condition == "while" then
			local label
			repeat
				label = "#"..condition.."_"..randstr(16)
			until not conflicts[label]
			ends[#ends+1] = line:gsub("%s*while%s*", "", 1).." jump "..label
			line = line:gsub("while[^\n]+", label)
		end
		if action == "include" then
			line = tostring(require(args[1])(table.unpack(args, 2)))
		end
		if action == "then" then
			local validthen = false
			if condition == "if" then
				line = line:gsub("if", "ifnot", 1)
				validthen = true
			elseif condition == "ifnot" then
				line = line:gsub("ifnot", "if", 1)
				validthen = true
			end
			if validthen then
				local label
				repeat
					label = "#"..condition.."_"..randstr(16)
				until not conflicts[label]
				conflicts[label] = true
				ends[#ends+1] = label
				line = line:gsub("then[^\n%S]*", "jump "..label)
			end
		end
		if action == "end" then
			if #ends > 0 then
				line = line:gsub("end", ends[#ends], 1)
				ends[#ends] = nil
			end
		end
		lines[#lines+1] = line
	end

	return table.concat(lines, "\n")
end