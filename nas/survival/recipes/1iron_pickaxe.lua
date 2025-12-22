local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.iron_bar,
			count = 3,
		},
		{
			id = ids.stick,
			count = 2,
		}
	},
	output = {
		id = "pickaxe",
		count = 3,
	},
	condition = "usingWorkbench"
}