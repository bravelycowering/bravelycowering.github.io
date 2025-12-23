local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.iron_ore,
			count = 1,
		}
	},
	output = {
		id = ids.iron_bar,
		count = 1,
	},
	condition = "usingStonecutter",
}