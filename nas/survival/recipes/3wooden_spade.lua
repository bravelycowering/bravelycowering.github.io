local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.wood,
			count = 1,
		},
		{
			id = ids.stick,
			count = 2,
		}
	},
	output = {
		id = "spade",
		count = 1,
	},
	condition = "usingWorkbench"
}