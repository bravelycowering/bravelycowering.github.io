local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.coal_ore,
			count = 1,
		}
	},
	output = {
		id = ids.coal_lump,
		count = 1,
	},
	condition = "usingStonecutter",
}