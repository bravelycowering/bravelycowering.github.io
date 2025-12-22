local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.gold_bar,
			count = 3,
		},
		{
			id = ids.stick,
			count = 2,
		}
	},
	output = {
		id = "axe",
		count = 6,
	},
	condition = "usingWorkbench"
}