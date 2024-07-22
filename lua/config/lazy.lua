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
    -- {
    --   "tokyonight.nvim",
    --   lazy = true,
    --   priority = 1000,
    --   opts = { transparent = true, styles = { sidebars = "transparent", floats = "transparent" } },
    -- },
    {
      import = "plugins",
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
-- require("lspconfig").clangd.setup({
--   -- on_attach = on_attach,
--   cmd = { "clangd", "--fallback-style=Microsoft", "--completion-style=detailed", "--compile-commands-dir=build/" },
--   filetypes = { "c", "cpp", "objc", "objcpp" },
-- })

-- vim.opt.shiftwidth = 2
-- vim.opt.tabstop = 2
-- vim.opt.expandtab = true
-- vim.diagnostic.config({
--   update_in_insert = true,
-- })
