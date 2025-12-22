local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.gold_bar,
			count = 1,
		},
		{
			id = ids.stick,
			count = 2,
		}
	},
	output = {
		id = "shovel",
		count = 6,
	},
	condition = "usingWorkbench"
}