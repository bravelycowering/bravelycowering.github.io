local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.iron_bar,
			count = 1,
		},
		{
			id = ids.stick,
			count = 2,
		}
	},
	output = {
		id = "spade",
		count = 3,
	},
	condition = "usingWorkbench"
}