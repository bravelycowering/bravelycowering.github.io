local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.gold_ore,
			count = 1,
		}
	},
	output = {
		id = ids.gold_bar,
		count = 1,
	},
	condition = "usingStonecutter",
}