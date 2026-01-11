local MAJOR = 4
local MINOR = 1

local fancynumber = "beta "..MAJOR.."."..MINOR
local builddate = os.date("%y%b%d")
local buildno = 1

local f = io.open("survival/buildno", "rb")
if f then
	local line1 = f:read("l")
	local line2 = tonumber(f:read("l"))
	f:close()
	if line1 == builddate then
		buildno = line2 + 1
	end
end

f = assert(io.open("survival/buildno", "w+b"))
f:write(builddate.."\n"..buildno)
f:close()

local buildversion = builddate.."-"..buildno
print("BUILD VERSION: "..buildversion)
return function() return "msg &fVersion &a"..fancynumber.." &7"..buildversion end