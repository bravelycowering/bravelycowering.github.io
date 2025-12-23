local ids = require "survival.ids"

local recipes = {}

local f = assert(io.open("survival/recipes", "rb"))
local recipestr = f:read("a")
f:close()

for line in recipestr:gmatch("%s*([^\n]+)") do
	if line:sub(1, 2) ~= "//" then
		line = "+"..line
		local recipe = {
			ingredients = {},
			output = {
				id = 0,
				count = 0,
			},
		}
		for t, countstr, id in line:gmatch("([%+%=%?])%s*(%d*)%s*([%w_%|]+)") do
			local count = 1
			if #countstr > 0 then
				count = assert(tonumber(countstr), "fucked up number u got there")
			end
			if t == "+" then
				recipe.ingredients[#recipe.ingredients+1] = {
					id = ids[id],
					count = count,
				}
			elseif t == "=" then
				recipe.output = {
					id = ids[id],
					count = count,
				}
			elseif t == "?" then
				recipe.condition = id
			end
		end
		recipes[#recipes+1] = recipe
	end
end

return recipes