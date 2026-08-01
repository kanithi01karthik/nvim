-- LazyVim manages mason, mason-lspconfig, and nvim-lspconfig.
-- Extend them here using opts instead of re-calling setup().
return {
	-- Ensure external LSP binaries are installed via Mason registry package names
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			if not vim.tbl_contains(opts.ensure_installed, "emmet-language-server") then
				table.insert(opts.ensure_installed, "emmet-language-server")
			end
		end,
	},

	-- Let mason-lspconfig auto-install servers declared in nvim-lspconfig opts.servers
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			ensure_installed = {
				"lua_ls",
				"html",
				"cssls",
				"pyright",
				"emmet_language_server",
				"ts_ls",
				"eslint",
				"clangd",
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		opts = {
			-- Diagnostic display
			diagnostics = {
				virtual_text = {
					prefix = "●",
					format = function(diagnostic)
						return diagnostic.message
					end,
				},
				float = {
					border = "rounded",
					source = true,
				},
			},

			-- Server configurations; LazyVim feeds these into lspconfig[server].setup()
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
						},
					},
				},
				pyright = {},
				html = {},
				cssls = {},
				emmet_language_server = {
					filetypes = { "html", "css" },
					init_options = {
						showSuggestionsAsSnippets = true,
					},
				},
				ts_ls = {
					on_attach = function(client, bufnr)
						local fname = vim.api.nvim_buf_get_name(bufnr)
						if fname:match("%.test%.js$") or fname:match("%.spec%.js$") or fname:match("%.test%.ts$") or fname:match("%.spec%.ts$") then
							local root = client.config.root_dir
							if root then
								local pkg_path = root .. "/package.json"
								local f = io.open(pkg_path, "r")
								if f then
									local content = f:read("*a")
									f:close()
									local ok, pkg = pcall(vim.json.decode, content)
									if ok and pkg then
										local has_jest = (pkg.dependencies and pkg.dependencies.jest) or (pkg.devDependencies and pkg.devDependencies.jest)
										if has_jest then
											local has_types = (pkg.devDependencies and pkg.devDependencies["@types/jest"]) or (pkg.dependencies and pkg.dependencies["@types/jest"])
											local types_dir = root .. "/node_modules/@types/jest"
											local types_exists = vim.loop.fs_stat(types_dir) ~= nil
											if not (has_types or types_exists) then
												vim.schedule(function()
													vim.notify(
														"Jest is installed, but @types/jest is missing. Run `npm install --save-dev @types/jest` to get Jest auto-suggestions.",
														vim.log.levels.WARN,
														{ title = "LSP: Jest Types" }
													)
												end)
											end
										end
									end
								end
							end
						end
					end,
				},
				eslint = {},
				clangd = {
					capabilities = {
						offsetEncoding = { "utf-16" },
					},
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--header-insertion=never",
						"--fallback-style=llvm",
					},
				},

				-- ast_grep with custom root_dir (require deferred to avoid eager load at spec-parse time)
				ast_grep = {
					cmd = { "ast_grep", "lsp" },
					filetypes = {
						"c",
						"cpp",
						"rust",
						"go",
						"java",
						"python",
						"javascript",
						"typescript",
						"html",
						"css",
						"kotlin",
						"dart",
						"lua",
					},
					root_dir = function(fname)
						return require("lspconfig.util").root_pattern("sgconfig.yaml", "sgconfig.yml")(fname)
					end,
				},
			},
		},
	},
}
