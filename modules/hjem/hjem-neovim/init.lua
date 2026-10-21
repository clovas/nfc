vim.opt.number = true
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 2147483647
vim.opt.mouse = ""
vim.g.mapleader = " "
vim.cmd [[
  colorscheme modus
]]
if os.getenv('SSH_TTY') ~= nil then
  local osc52 = require('vim.ui.clipboard.osc52')
  local function paste() 
      local content = vim.fn.getreg('"')
      return vim.split(content, "\n")
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ['+'] = osc52.copy('+'),
      ['*'] = osc52.copy('*'),
    },
    paste = {
      ['+'] = paste(),
      ['*'] = paste(),
    },
  }
end
local ok, builtin = pcall(require, "telescope.builtin")
if ok then
  vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
  vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
  vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Find old files" })
  vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Find help" })
end
require("ibl").setup()
require('blink.cmp').setup({
  keymap = {
    preset = 'default',
    ['<C-Tab>'] = { 'show', 'show_documentation', 'hide_documentation' },
  },
  completion = {
    documentation = { auto_show = false },
    menu = {
      draw = {
        columns = { 
          { "label", "label_description", gap = 1 }, 
          { "kind" } 
        },
      },
    }, 
  },
  fuzzy = {
    implementation = "lua"
  }
})

vim.keymap.set('n', ']e', function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Next Error' })
vim.keymap.set('n', '[e', function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Previous Error' })
vim.keymap.set('n', ']w', function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN })
end, { desc = 'Next Warn' })
vim.keymap.set('n', '[w', function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN })
end, { desc = 'Previous Warn' })
vim.keymap.set('n', ']h', function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.HINT })
end, { desc = 'Next Hint' })
vim.keymap.set('n', '[h', function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.HINT})
end, { desc = 'Previous Hint' })
vim.keymap.set('n', ']i', function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.INFO })
end, { desc = 'Next Info' })
vim.keymap.set('n', '[i', function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.INFO })
end, { desc = 'Previous Info' })

vim.lsp.enable("rust_analyzer")
local orig_notify = vim.notify
vim.notify = function(msg, level, opts)
    if type(msg) == "string" and msg:match("failed to unify type owners") then
        return
    end
    orig_notify(msg, level, opts)
end

vim.lsp.enable("nixd")
vim.lsp.enable("texlab")
