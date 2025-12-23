local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.diamond_ore,
			count = 1,
		}
	},
	output = {
		id = ids.diamond_gem,
		count = 1,
	},
	condition = "usingStonecutter",
}