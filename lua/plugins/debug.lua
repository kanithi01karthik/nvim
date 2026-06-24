-- LazyVim provides mason; all other dap dependencies are managed here.
-- Custom adapters/configurations are set up in nvim-dap's config function.
return {
	-- mason-nvim-dap: auto-install debug adapters
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = { "mason-org/mason.nvim", "mfussenegger/nvim-dap" },
		opts = {
			automatic_installation = true,
			handlers = {},
			ensure_installed = { "js-debug-adapter", "codelldb", "python" },
		},
		-- Ensure debugpy and java-debug-adapter are also installed
		config = function(_, opts)
			require("mason-nvim-dap").setup(opts)
			local has_registry, registry = pcall(require, "mason-registry")
			if has_registry then
				local function ensure_package(name)
					local ok, pkg = pcall(registry.get_package, name)
					if ok and not pkg:is_installed() then
						pcall(pkg.install, pkg)
					end
				end
				ensure_package("debugpy")
				ensure_package("java-debug-adapter")
			end
		end,
	},

	-- dapui: UI for nvim-dap (opts is passed to dapui.setup())
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		opts = {},
		config = function(_, opts)
			local dapui = require("dapui")
			dapui.setup(opts)
			-- Auto-open/close dapui with dap session lifecycle
			local dap = require("dap")
			dap.listeners.before.attach.dapui_config = function() dapui.open() end
			dap.listeners.before.launch.dapui_config = function() dapui.open() end
			dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
			dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
		end,
	},

	-- nvim-dap: core debugger + custom adapters and configurations
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"mfussenegger/nvim-dap-python",
		},
		config = function()
			local dap = require("dap")
			local data = vim.fn.stdpath("data")

			-- ── JavaScript / TypeScript (pwa-node) ──────────────────────────
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "js-debug-adapter",
					args = { "${port}" },
				},
			}
			for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
				dap.configurations[ft] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}"
					},
				}
			end

			-- ── Python (debugpy) ────────────────────────────────────────────
			require("dap-python").setup(data .. "/mason/packages/debugpy/venv/bin/python")

			-- ── Java (java-debug-adapter) ───────────────────────────────────
			dap.adapters.java = {
				type = "executable",
				command = "java",
				args = {
					"-jar",
					vim.fn.glob(data ..
					"/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
				},
			}
			dap.configurations.java = {
				{
					type = "java",
					request = "launch",
					name = "Launch Java main",
					mainClass = function() return vim.fn.input("Main class (e.g. com.example.Main): ") end,
					projectName = function() return vim.fn.input("Project name: ") end,
					cwd = "${workspaceFolder}"
				},
				{
					type = "java",
					request = "attach",
					name = "Attach to JVM :5005",
					hostName = "127.0.0.1",
					port = 5005
				},
			}

			-- ── C / C++ / Rust (codelldb) ────────────────────────────────────
			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = { command = "codelldb", args = { "--port", "${port}" } },
			}
			for _, ft in ipairs({ "c", "cpp", "rust" }) do
				dap.configurations[ft] = {
					{
						name = "Launch executable",
						type = "codelldb",
						request = "launch",
						program = function()
							return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
						end,
						cwd = "${workspaceFolder}",
						stopOnEntry = false
					},
				}
			end
		end,
	},
}
