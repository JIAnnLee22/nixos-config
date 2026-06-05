require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide" },
		["<CR>"] = { "accept", "fallback" },
		["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
		menu = {
			border = "rounded",
			auto_show = function(ctx)
				return ctx.mode ~= "cmdline"
			end,
		},
		accept = {
			auto_brackets = {
				enabled = true,
			},
		},
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
		providers = {
			lsp = {
				min_keyword_length = 0,
			},
		},
	},
	snippets = {
		preset = "default",
	},
	signature = {
		enabled = true,
	},
	cmdline = {
		enabled = true,
		keymap = { preset = "inherit" },
		completion = {
			menu = { auto_show = true },
		},
	},
})
