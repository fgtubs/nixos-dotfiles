require("snacks").setup({
  -- Enable the indent guide module
  indent = {
    enabled = true,
    -- You can tweak colors, chunking, and animations here later if you want
  },

  -- Snacks has a bunch of other modules you can enable here later if needed:
  -- dashboard = { enabled = true },
  -- notifier = { enabled = true },
  -- toggle = { enabled = true },
  terminal = { 
    enabled = true,
    win = {
      position = "bottom", -- Spawns as a horizontal split at the bottom
      height = 0.3,        -- Takes up 30% of your screen height
      -- border = "top",   -- Optional: Adds a border line at the top of the split
    },
  },
  dashboard = {
    enabled = true,

    -- Dual-pane layout structure
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
      { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      {
        pane = 2,
        icon = " ",
        title = "Git Status",
        section = "terminal",
        enabled = function()
          return Snacks.git.get_root() ~= nil
        end,
        cmd = "git status --short --branch --renames",
        height = 5,
        padding = 1,
        ttl = 5 * 60,
        indent = 3,
      },
    },

    preset = {
      -- Your custom ASCII Art
      header = [[
       ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
       ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
       ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
       ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
       ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
       ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]],

      -- Your custom Keybindings mapped to the left pane
      keys = {
        -- Telescope
        { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
        { icon = " ", key = "g", desc = "Git Files", action = ":Telescope git_files" },

        -- Harpoon
        { icon = "󰛢 ", key = "h", desc = "Harpoon Quick Menu", action = ":lua require('harpoon.ui').toggle_quick_menu()" },

        -- File Tree
        { icon = "󰙅 ", key = "e", desc = "Toggle NvimTree", action = ":NvimTreeToggle" },

        -- Copilot
        { icon = " ", key = "c", desc = "Enable Copilot", action = ":Copilot enable" },

        -- Snacks Terminal
        { icon = " ", key = "t", desc = "Toggle Split Terminal", action = ":lua Snacks.terminal.toggle()" },

        -- Utilities
        { icon = "󰝰 ", key = "a", desc = "New Tab", action = ":tabnew" },
        { icon = " ", key = "n", desc = "New Empty File", action = ":ene | startinsert" },
        { icon = " ", key = "q", desc = "Quit Neovim", action = ":qa" },
      },
    },
  },
})


vim.keymap.set("n", "<leader>ter", function() Snacks.terminal.toggle() end, { desc = "Toggle Terminal" })
