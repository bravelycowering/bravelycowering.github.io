local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.cobblestone,
			count = 1,
		},
		{
			id = ids.stick,
			count = 2,
		}
	},
	output = {
		id = "spade",
		count = 2,
	},
	condition = "usingWorkbench"
}