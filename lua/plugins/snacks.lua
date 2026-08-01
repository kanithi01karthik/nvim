return {
	{
		"folke/snacks.nvim",
		opts = {
			explorer = { enabled = true },
			image = { enabled = true },
			picker = {
				layout = {
					backdrop = false,
				},
				win = {
					input = {
						wo = {
							winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:SnacksBorder,FloatTitle:SnacksBorder",
						},
					},
					list = {
						wo = {
							winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:SnacksBorder,FloatTitle:SnacksBorder",
						},
					},
					preview = {
						wo = {
							winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:SnacksBorder,FloatTitle:SnacksBorder",
						},
					},
				},
			},
			styles = {
				picker = {
					wo = {
						winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:SnacksBorder,FloatTitle:SnacksBorder",
					},
				},
				explorer = {
					wo = {
						winhighlight = "Normal:Normal,NormalFloat:Normal,FloatBorder:SnacksBorder,FloatTitle:SnacksBorder",
					},
				},
			},
		},
	},
}
