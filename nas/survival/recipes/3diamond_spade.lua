local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.diamond_gem,
			count = 1,
		},
		{
			id = ids.stick,
			count = 2,
		}
	},
	output = {
		id = "spade",
		count = 8,
	},
	condition = "usingWorkbench"
}