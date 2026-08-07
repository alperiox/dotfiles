vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

vim.opt.relativenumber = true
vim.keymap.set('t', '<C-w><leader>', "<C-\\><C-n><C-w>h",{silent = true})
vim.keymap.set('n', '<leader>cp', ':let @+ = expand("%:p")<CR>', { desc = 'Copy filepath' })
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
vim.keymap.set('n', '<C-s>', ':w')
vim.lsp.enable("pyright")
vim.lsp.enable("biome")

if vim.env.VIRTUAL_ENV then
  vim.g.python3_host_prog = vim.env.VIRTUAL_ENV .. "/bin/python"
end

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)


vim.lsp.config('pyright', {
  before_init = function(_, config)
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = venv .. "/bin/python"
    end
  end,
})
vim.lsp.enable('pyright')

require('render-markdown').enable()

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)

vim.api.nvim_create_autocmd("FileType", {
  pattern = "csv",
  callback = function()
    vim.cmd("CsvViewEnable display_mode=border header_lnum=1")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "tsv",
  callback = function()
    vim.cmd("CsvViewEnable display_mode=border header_lnum=1")
  end,
})
