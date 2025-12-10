return {
	"stevearc/conform.nvim",
	config = function()
		vim.g.disable_autoformat = false

		require("conform").setup({
			formatters_by_ft = {
				purescript = { "purstidy", stop_after_first = true },
				lua = { "stylua", stop_after_first = true },
				ocaml = { "ocamlformat", stop_after_first = true },
				python = { "black" },
				rust = { "rustfmt" },
				javascript = { "prettier", stop_after_first = true },
				javascriptreact = { "prettier", stop_after_first = true },
				typescript = { "prettier", stop_after_first = true },
				typescriptreact = { "prettier", stop_after_first = true },
				astro = { "astro", stop_after_first = true },
				go = { "gofumpt", "golines", "goimports-reviser" },

				-- Désactivation totale du formatage C / C++ pour éviter la destruction des tabs
				c = {},
				cpp = {},

				haskell = { "fourmolu" },
				yaml = { "yamlfmt" },
				html = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				gleam = { "gleam" },
				asm = { "asmfmt" },
				css = { "prettier", stop_after_first = true },
				fennel = { "fnlfmt" },
			},

			-- On coupe le format à l'enregistrement pour C / C++
			format_on_save = function(bufnr)
				local ft = vim.bo[bufnr].filetype

				if ft == "c" or ft == "cpp" then
					return
				end
				if vim.g.disable_autoformat then
					return
				end

				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
			end,
		})

		-- Autocmd format-on-save que l’on protège aussi pour C / C++
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				local ft = vim.bo[args.buf].filetype

				if ft == "c" or ft == "cpp" then
					return
				end
				if vim.g.disable_autoformat then
					return
				end

				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}
