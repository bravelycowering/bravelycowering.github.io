local blocks = require "survival.blocks"
local ids = {}

for index, value in ipairs(blocks) do
	ids[value.name:lower():gsub("%s", "_")] = index - 1
end

return ids