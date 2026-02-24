return {
	"epwalsh/obsidian.nvim",
	version = "*", -- recommended, use latest release instead of latest commit
	lazy = true,
	-- ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	event = {
		"BufReadPre " .. vim.fn.expand("~") .. "/Syncthing/Obsidian/**.md",
		"BufNewFile " .. vim.fn.expand("~") .. "/Syncthing/Obsidian/**.md",
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
		--   "BufReadPre path/to/my-vault/**.md",
		--   "BufNewFile path/to/my-vault/**.md",
	},
	dependencies = {
		-- Required.
		"nvim-lua/plenary.nvim",

		-- see below for full list of optional dependencies 👇
	},
	opts = {
		workspaces = {
			{
				name = "personal",
				path = "~/Nextcloud/Obsidian",
			},
			{
				name = "work",
				path = "~/Nextcloud/Obsidian",
			},
		},
		completion = {
			nvim_cmp = true, -- automatically configure completion
		},
		daily_notes = {
			folder = "05 - Notes/Daily Notes",
			-- Optional, if you want to change the date format for the ID of daily notes.
			-- date_format = "%Y-%m-%d",
			-- Optional, if you want to change the date format of the default alias of daily notes.
			-- alias_format = "%B %-d, %Y",
		},

		disable_frontmatter = true,

		-- TODO: configure to my liking
		-- Optional, alternatively you can customize the frontmatter data.
		note_frontmatter_func = function(note)
			-- This is equivalent to the default frontmatter function.
			-- local out = { id = note.id, aliases = note.aliases, tags = note.tags }
			-- -- `note.metadata` contains any manually added fields in the frontmatter.
			-- -- So here we just make sure those fields are kept in the frontmatter.
			-- if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
			--   for k, v in pairs(note.metadata) do
			--     out[k] = v
			--   end
			-- end
			-- return out
		end,

		-- Optional, for templates (see below).
		templates = {
			subdir = "templates",
			date_format = "%Y-%m-%d-%a",
			time_format = "%H:%M",
		},

		follow_url_func = function(url)
			vim.fn.jobstart({ "open", url })
		end,

		-- Optional, set to true if you use the Obsidian Advanced URI plugin.
		-- https://github.com/Vinzent03/obsidian-advanced-uri
		use_advanced_uri = true,

		-- see below for full list of options 👇
	},
	-- config = function()
	--  require("obsidian").setup()
	-- end
}
