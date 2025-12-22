local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.wood,
			count = 3,
		},
		{
			id = ids.stick,
			count = 2,
		}
	},
	output = {
		id = "pickaxe",
		count = 1,
	},
	condition = "usingWorkbench"
}