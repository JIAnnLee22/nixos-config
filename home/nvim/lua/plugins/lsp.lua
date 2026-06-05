local config = require("plugins.config")

local capabilities = require("blink.cmp").get_lsp_capabilities()

local function with_capabilities(opts)
	return vim.tbl_deep_extend("force", {}, opts, {
		capabilities = vim.tbl_deep_extend("force", {}, capabilities, opts.capabilities or {}),
	})
end

local function setup_server(name, opts)
	vim.lsp.config(name, with_capabilities(opts))
	vim.lsp.enable(name)
end

local function setup_servers()
	for name, opts in pairs(config.servers) do
		setup_server(name, opts)
	end

	local kotlin_server = config.kotlin_server()
	setup_server(kotlin_server, config.kotlin_overrides[kotlin_server])
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.diagnostic.config({ virtual_text = true, update_in_insert = true })
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if not client then
			return
		end

		vim.keymap.set("n", "<leader>d", function()
			vim.diagnostic.open_float()
		end, { desc = "诊断信息", buffer = args.buf })

		vim.keymap.set("n", "<leader>lf", function()
			require("conform").format({ bufnr = args.buf })
		end, { desc = "format", buffer = args.buf })
	end,
})

setup_servers()

vim.api.nvim_create_autocmd("User", {
	pattern = "LazyFile",
	callback = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		})
	end,
})
