return {
  "uhs-robert/sshfs.nvim",
  opts = {
    connections = {
      ssh_configs = { -- Table of ssh config file locations to use
        "~/.ssh/config",
        --  "/etc/ssh/ssh_config",
      },
      -- SSHFS mount options (table of key-value pairs converted to sshfs -o arguments)
      -- Boolean flags: set to true to include, false/nil to omit
      -- String/number values: converted to key=value format
      sshfs_options = {
        reconnect = true, -- Auto-reconnect on connection loss
        ConnectTimeout = 5, -- Connection timeout in seconds
        compression = "yes", -- Enable compression
        ServerAliveInterval = 15, -- Keep-alive interval (15s × 3 = 45s timeout)
        ServerAliveCountMax = 3, -- Keep-alive message count
        dir_cache = "yes", -- Enable directory caching
        dcache_timeout = 300, -- Cache timeout in seconds
        dcache_max_size = 10000, -- Max cache size
        -- allow_other = true,        -- Allow other users to access mount
        -- uid = "1000,gid=1000",     -- Set file ownership (use string for complex values)
        -- follow_symlinks = true,    -- Follow symbolic links
      },
      control_persist = "10m", -- How long to keep ControlMaster connection alive after last use
    },
    mounts = {
      base_dir = vim.fn.expand("$HOME") .. "/mount", -- where remote mounts are created
    },
    host_paths = {
      -- Optionally define default mount paths for specific hosts
      -- Single path (string):
      -- ["my-server"] = "/var/www/html"
      --
      -- Multiple paths (array):
      -- ["dev-server"] = { "/var/www", "~/projects", "/opt/app" }
    },
    hooks = {
      on_exit = {
        auto_unmount = true, -- auto-disconnect all mounts on :q or exit
        clean_mount_folders = true, -- optionally clean up mount folders after disconnect
      },
      on_mount = {
        auto_change_to_dir = false, -- auto-change current directory to mount point
        auto_run = "find", -- "find" (default), "grep", "live_find", "live_grep", "terminal", "none", or a custom function(ctx)
      },
    },
    ui = {
      local_picker = {
        preferred_picker = "auto", -- one of: "auto", "snacks", "fzf-lua", "mini", "telescope", "oil", "neo-tree", "nvim-tree", "yazi", "lf", "nnn", "ranger", "netrw"
        fallback_to_netrw = true, -- fallback to netrw if no picker is available
        netrw_command = "Explore", -- netrw command: "Explore", "Lexplore", "Sexplore", "Vexplore", "Texplore"
      },
      live_remote_picker = {
        preferred_picker = "auto", -- one of: "auto", "snacks", "fzf-lua", "telescope", "mini"
      },
    },
    lead_prefix = "<leader>M", -- change keymap prefix (default: <leader>m)
    keymaps = {
      mount = "<leader>Mm", -- creates an ssh connection and mounts via sshfs
      unmount = "<leader>Mu", -- disconnects an ssh connection and unmounts via sshfs
      explore = "<leader>Me", -- explore an sshfs mount using your native editor
      change_dir = "<leader>Md", -- change dir to mount
      command = "<leader>Mo", -- run command on mount
      config = "<leader>Mc", -- edit ssh config
      reload = "<leader>Mr", -- manually reload ssh config
      files = "<leader>Mf", -- browse files using chosen picker
      grep = "<leader>Mg", -- grep files using chosen picker
      terminal = "<leader>Mt", -- open ssh terminal session
    },
  }, -- Refer to the configuration section below
} -- or leave empty for defaults
