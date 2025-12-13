local recipes = {}

for line in io.popen("ls -1 --color=no survival/recipes"):lines() do
	local name = line:gsub("%..+", "")
	recipes[#recipes+1] = require("survival.recipes."..name)
end

return recipes