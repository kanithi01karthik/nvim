return {
	"CRAG666/code_runner.nvim",
	config = function()
		require("code_runner").setup({
			filetype = {
				c = "cd $dir && gcc $fileName -o /tmp/$fileNameWithoutExt && /tmp/$fileNameWithoutExt",
				cpp = "cd $dir && g++ -std=c++17 $fileName -o /tmp/$fileNameWithoutExt && /tmp/$fileNameWithoutExt",
				py = "cd $dir && python $fileName",
				-- cs  = 'cd $dir && dotnet run',
			},
		})
	end,
}
