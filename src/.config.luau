return {
	lute = {
		lint = {
			rulepaths = { "./init.luau" },
			ruleconfigs = {
				["std"] = {
					options = {
						allow = { "path", "syntax", "syntax/utils", "syntax/query", "stringext" },
					},
				},
			},
		},
	},
}
