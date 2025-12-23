local ids = require "survival.ids"
return {
	ingredients = {
		{
			id = ids.stick,
			count = 1,
		},
		{
			id = ids.coal_lump,
			count = 1,
		}
	},
	output = {
		id = ids.unlit_torch,
		count = 4,
	}
}