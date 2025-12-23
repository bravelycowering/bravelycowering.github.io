local conflicts = {}

local function uuid()
	local str
	repeat
		local chars = {}
		for i = 1, 6 do
			chars[#chars+1] = string.char(math.random(65, 90) + math.random(0, 1)*32)
		end
		str = table.concat(chars)
	until not conflicts[str]
	conflicts[str] = true
	return str
end

local function resolveVarName(locals, name)
	for i = #locals, 1, -1 do
		local scope = locals[i]
		if scope[name] then
			return scope[name]
		end
	end
	return name
end

local function resolvePackageUnwraps(locals, word)
	return word:gsub("%b{}", function(m)
		return "{"..resolveVarName(locals, resolvePackageUnwraps(locals, m:sub(2, -2))).."}"
	end):gsub("%*(%w+)", function(m)
		return resolveVarName(locals, m)
	end)
end

return function(inpath)
	local infile = assert(io.open(inpath, "rb"))
	local incontent = infile:read("a")
	infile:close()
	local lines = {}
	local ends = {}
	local locals = {}
	for line in incontent:gmatch("[^\n]*") do
		line = resolvePackageUnwraps(locals, line)
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
			local label = "#"..condition.."_"..uuid()
			ends[#ends+1] = line:gsub("%s*while%s*", "", 1).." jump "..label
			locals[#locals+1] = {}
			line = line:gsub("while[^\n]+", label)
		end
		if action == "function" then
			ends[#ends+1] = "quit"
			locals[#locals+1] = {}
			line = line:gsub("function.+", args[1])
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
				local label = "#"..condition.."_"..uuid()
				ends[#ends+1] = label
				locals[#locals+1] = {}
				line = line:gsub("then[^\n%S]*", "jump "..label)
			end
		end
		if action == "start" then
			line = line:gsub("start[^\n]*", "// start scope")
			ends[#ends+1] = "// end scope"
			locals[#locals+1] = {}
		end
		if action == "local" then
			local scope = locals[#locals]
			local varname = args[1]
			local localname = "l_"..uuid().."_"..varname
			scope[varname] = localname
			line = line:gsub("local[^\n%S]*%S+[^\n%S]*", "set "..localname.." ")
		end
		if action == "end" then
			if #ends > 0 then
				locals[#locals] = nil
				line = line:gsub("end", ends[#ends], 1)
				ends[#ends] = nil
			end
		end
		lines[#lines+1] = line
	end

	return table.concat(lines, "\n")
end