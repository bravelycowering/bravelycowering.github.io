local conflicts = {}

local retainNames = true

local function uuid(from)
	local str
	local n = 1
	repeat
		if retainNames then
			str = from.."_"..n
			n = n + 1
		else
			local chars = {}
			for i = 1, 16 do
				chars[#chars+1] = string.char(math.random(65, 90) + math.random(0, 1)*32)
			end
			str = table.concat(chars)
		end
	until not conflicts[str]
	conflicts[str] = true
	return str
end

return uuid