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
				ts_ls = {},
				eslint = {},
				clangd = {
					keys = {
						{ "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
					},
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
