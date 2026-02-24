return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
      defaults = {
      file_ignore_patterns = { ".git/", "node_modules" },
      layout_config = {
        height = 0.90,
        width = 0.90,
        preview_cutoff = 0,
        horizontal = { preview_width = 0.60 },
        vertical = { width = 0.55, height = 0.9, preview_cutoff = 0 },
        prompt_position = "top",
      },
      path_display = { "smart" },
      prompt_position = "top",
      prompt_prefix = " ",
      selection_caret = " ",
      sorting_strategy = "ascending",
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--hidden",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim", -- add this value
      },
      },
    },
			pickers = {
				find_files = {
          hidden=true,
					--  `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
					find_command = { "rg", "--files", "--glob", "!**/.git/*", "-L", "--hidden" },
				},
			},
		
		config = function()
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
      vim.keymap.set("n", "<leader>/", builtin.current_buffer_fuzzy_find)
      vim.keymap.set("n", "<leader>en", function()
      builtin.find_files { cwd = vim.fs.joinpath(vim.fn.stdpath "config")}
    end)
  end,
  },
	{
		"nvim-telescope/telescope-ui-select.nvim",
    -- we use ui-select to pretivy the code actionmenue (leader-ca)
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({ winblend = 10}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
 -- {
 --   "nvim-telescope/telescope-symbols.nvim",
 -- },
}
