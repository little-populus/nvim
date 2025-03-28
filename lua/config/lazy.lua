local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    -- bootstrap lazy.nvim
    -- stylua: ignore
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                   lazypath})
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)
require("lazy").setup({
  spec = { -- add LazyVim and import its plugins
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
    }, -- import any extras modules here
    -- { import = "lazyvim.plugins.extras.lang.typescript" },
    -- { import = "lazyvim.plugins.extras.lang.json" },
    -- { import = "lazyvim.plugins.extras.ui.mini-animate" },
    -- import/override with your plugins
    { "Exafunction/codeium.vim", event = "BufEnter" },
    {
      "nvim-cmp",
    -- stylua: ignore
    keys = {
      {
        "<tab>",
          function()
          local luasnip = require("luasnip")
          local fn = vim.fn
          if luasnip.jumpable(1) then
            return "<Plug>luasnip-jump-next"
          elseif fn["codeium#Accept"]() ~= "" then
            return fn["codeium#Accept"]()
          else
            return "<tab>"
          end
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
    },
    {
      "tokyonight.nvim",
      lazy = true,
      priority = 1000,
      opts = { transparent = true, styles = { sidebars = "transparent", floats = "transparent" } },
    },
    {
      import = "plugins",
    },
    {
      "rachartier/tiny-inline-diagnostic.nvim",
      -- event = "LspAttach", -- Or `LspAttach`
      priority = 3000, -- needs to be loaded in first
      branch = "main",
      init = function()
        vim.diagnostic.config({
          virtual_text = false,
          update_in_insert = true,
          virtual_lines = {
            -- only_current_line = true,
            highlight_whole_line = false,
          },
        })
      end,
      config = function()
        -- Default configuration
        require("tiny-inline-diagnostic").setup({
          preset = "ghost", -- Can be: "modern", "classic", "minimal", "ghost", "simple", "nonerdfont", "amongus"

          options = {
            -- Throttle the update of the diagnostic when moving cursor, in milliseconds.
            -- You can increase it if you have performance issues.
            -- Or set it to 0 to have better visuals.
            throttle = 0,

            -- The minimum length of the message, otherwise it will be on a new line.
            softwrap = 30,

            -- If multiple diagnostics are under the cursor, display all of them.
            multiple_diag_under_cursor = true,

            -- Enable diagnostic message on all lines.
            multilines = true,

            -- Show all diagnostics on the cursor line.
            show_all_diags_on_cursorline = true,

            -- Enable diagnostics on Insert mode. You should also se the `throttle` option to 0, as some artefacts may appear.
            enable_on_insert = true,
          },
        })
      end,
    },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = {
    colorscheme = { "tokyonight", "habamax" },
  },
  checker = {
    enabled = true,
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip", -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
require("lspconfig").clangd.setup({
  cmd = { "/Users/meyeryouth/.local/share/nvim/mason/bin/clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
  root_dir = require("lspconfig").util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
  on_attach = function(client, bufnr)
    -- 设置允许增量同步
    client.config.flags = client.config.flags or {}
    client.config.flags.allow_incremental_sync = true
  end,
})

-- vim.opt.shiftwidth = 2
-- vim.opt.tabstop = 2
-- vim.opt.expandtab = true
-- vim.diagnostic.config({
--   update_in_insert = true,
-- })
