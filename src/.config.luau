return {
	lute = {
		lint = {
			rulepaths = { "./init.luau" },
			ruleconfigs = {
				["std"] = {
					options = {
						allow = { "path", "stringext", "syntax", "syntax/query", "syntax/utils" },
					},
				},
			},
		},
	},
}
