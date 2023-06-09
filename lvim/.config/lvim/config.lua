vim.opt.relativenumber = true
vim.opt.colorcolumn = "80"
-- vim.opt.listchars = {eol = '↲', tab = '▸ ', trail = '·', lead = '·'}
vim.opt.listchars = { eol = '↲', tab = '«-»', trail = '·', lead = '·' }

lvim.lsp.document_highlight = false
-- lvim.builtin.autopairs.active = false
lvim.transparent_window = true

-- general
-- lvim.log.level = "info"
lvim.format_on_save = {
  enabled = true,
  pattern = "*.lua",
  timeout = 1000,
}

lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- -- Change theme settings
-- lvim.colorscheme = "lunar"
-- lvim.colorscheme = "tokyonight"
-- lvim.colorscheme = "onedarker"
-- lvim.colorscheme = "gruvbox"
vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha
lvim.colorscheme = "catppuccin"

lvim.plugins = {
  -- { "folke/tokyonight.nvim" },
  -- {
  --   "folke/trouble.nvim",
  --   cmd = "TroubleToggle",
  -- },
  -- "lukoshkin/highlight-whitespace",
  "johnfrankmorgan/whitespace.nvim",
  "google/vim-jsonnet",
  -- "itspriddle/vim-shellcheck",
  "lukas-reineke/indent-blankline.nvim",
  "lunarvim/colorschemes",
  -- "folke/tokyonight.nvim",
  "ellisonleao/gruvbox.nvim",
  "catppuccin/nvim",
  "mbbill/undotree",
  {
    "nacro90/numb.nvim",
    event = "BufRead",
    config = function()
      require("numb").setup {
        show_numbers = true,    -- Enable 'number' for the window while peeking
        show_cursorline = true, -- Enable 'cursorline' for the window while peeking
      }
    end,
  },
  {
    "ggandor/leap.nvim",
    name = "leap",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  {
    "windwp/nvim-spectre",
    event = "BufRead",
    config = function()
      require("spectre").setup()
    end,
  },
  {
    "wfxr/minimap.vim",
    build = "cargo install --locked code-minimap",
    config = function()
      vim.cmd("let g:minimap_width = 10")
      vim.cmd("let g:minimap_auto_start = 1")
      vim.cmd("let g:minimap_auto_start_win_enter = 1")
    end,
  },
}

vim.cmd("let g:minimap_width = 10")
vim.cmd("let g:minimap_auto_start = 1")
vim.cmd("let g:minimap_auto_start_win_enter = 1")
