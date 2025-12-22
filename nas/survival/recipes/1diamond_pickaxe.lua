local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.diamond_gem,
			count = 3,
		},
		{
			id = ids.stick,
			count = 2,
		}
	},
	output = {
		id = "pickaxe",
		count = 8,
	},
	condition = "usingWorkbench"
}