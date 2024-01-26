local function get_codelldb()
	local mason_registry = require("mason-registry")
	local codelldb = mason_registry.get_package("codelldb")
	local extension_path = codelldb:get_install_path() .. "/extension/"
	local codelldb_path = extension_path .. "adapter/codelldb"
	local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
	return codelldb_path, liblldb_path
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "c", "cpp" })
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "codelldb" })
		end,
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = { "p00f/clangd_extensions.nvim" },
		opts = {
			servers = {
				clangd = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(
							"compile_commands.json",
							"compile_flags.txt",
							"configure.ac",
							".git"
						)(...)
					end,
					capabilities = {
						offsetEncoding = { "utf-16" },
					},
					cmd = {
						"clangd",
						-- "--background-index",
						-- "--clang-tidy",
						-- "--header-insertion=iwyu",
						-- "--completion-style=detailed",
						-- "--function-arg-placeholders",
						-- "--fallback-style=llvm",
					},
					init_options = {
						usePlaceholders = true,
						completeUnimported = true,
						clangdFileStatus = true,
					},

					extensions = {
						inlay_hints = {
							inline = false,
						},
						ast = {
							--These require codicons (https://github.com/microsoft/vscode-codicons)
							role_icons = {
								type = "",
								declaration = "",
								expression = "",
								specifier = "",
								statement = "",
								["template argument"] = "",
							},
							kind_icons = {
								Compound = "",
								Recovery = "",
								TranslationUnit = "",
								PackExpansion = "",
								TemplateTypeParm = "",
								TemplateTemplateParm = "",
								TemplateParamObject = "",
							},
						},
					},
				},
			},
			setup = {
				clangd = function(_, opts)
					require("clangd_extensions").setup({
						server = {
							root_dir = function(...)
								return require("lspconfig.util").root_pattern(
									"compile_commands.json",
									"compile_flags.txt",
									"configure.ac",
									".git"
								)(...)
							end,
							capabilities = {
								offsetEncoding = { "utf-16" },
							},
							cmd = {
								"clangd",
								"--background-index",
								"--clang-tidy",
								"--header-insertion=iwyu",
								"--completion-style=detailed",
								"--function-arg-placeholders",
								"--fallback-style=llvm",
							},
							init_options = {
								usePlaceholders = true,
								completeUnimported = true,
								clangdFileStatus = true,
							},
						},
						extensions = opts.extensions,
					})

					local overseer = require("overseer")
					local build_cpp = function(task)
						if task then
							task:add_component({
								"dependencies",
								task_names = { "cmake" },
								sequential = true,
							})
							task:add_component({
								"run_after",
								-- On my dual GPU laptop,
								-- use prime-run to launch programs with RTX gpu
								task_names = { { "shell", cmd = "prime-run ./bin/game" } },
								detach = true,
							})
							task:start()
						end
					end
					require("plugin.lsp.utils").on_attach(function(client, bufnr)
						if client.name == "clangd" then
							vim.keymap.set("n", "<C-g>", "<cmd>ClangdSwitchSourceHeader<cr>", { buffer = bufnr })
							vim.keymap.set("n", "<leader>o", function()
								overseer.run_template({ name = "cpp_build", autostart = false }, build_cpp)
							end, {})

							-- For small projects, I prefer using the built-in make,
							vim.keymap.set("n", "<S-b>", "<cmd>BuildCppAndRun<cr>", { buffer = bufnr }) -- see config/autocmds.lua
						end
					end)
				end,
			},
		},
	},

	{
		"mfussenegger/nvim-dap",
		opts = {
			setup = {
				codelldb = function()
					local codelldb_path, _ = get_codelldb()
					local dap = require("dap")
					dap.adapters.codelldb = {
						type = "server",
						port = "${port}",
						executable = {
							command = codelldb_path,
							args = { "--port", "${port}" },
						},
					}
					dap.configurations.cpp = {
						{
							name = "Launch file",
							type = "codelldb",
							request = "launch",
							program = function()
								return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/bin/", "file")
							end,
							cwd = "${workspaceFolder}",
							stopOnEntry = false,
						},
					}

					dap.configurations.c = dap.configurations.cpp
					dap.configurations.rust = dap.configurations.cpp
				end,
			},
		},
	},
}
