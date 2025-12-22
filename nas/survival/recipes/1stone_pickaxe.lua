local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.cobblestone,
			count = 3,
		},
		{
			id = ids.stick,
			count = 2,
		}
	},
	output = {
		id = "pickaxe",
		count = 2,
	},
	condition = "usingWorkbench"
}