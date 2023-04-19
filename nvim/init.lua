local Plug = vim.fn["plug#"]

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'rust-lang/rust.vim'
Plug('neoclide/coc.nvim', {branch = 'release'})
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'vim-autoformat/vim-autoformat'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'rhysd/vim-clang-format'
Plug 'mfussenegger/nvim-dap'
Plug 'klen/nvim-config-local'
Plug 'shaunsingh/nord.nvim'
Plug 'simrat39/rust-tools.nvim'
Plug 'romgrk/barbar.nvim'
Plug('akinsho/toggleterm.nvim', {tag = 'v2.*'})

vim.call('plug#end')

-- Styling commands

vim.cmd[[colorscheme nord]]

vim.api.nvim_command('set mouse=a')
vim.api.nvim_command('set expandtab')
vim.api.nvim_command('set tabstop=2')
vim.api.nvim_command('set shiftwidth=2')
vim.api.nvim_command('set number')
vim.api.nvim_command('set exrc')
vim.api.nvim_command('set secure')

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Setup for local nvim config

require'config-local'.setup {
  config_files = { '.nvimrc.lua', '.nvimrc' },
  hashfile = vim.fn.stdpath('data') .. '/config-local',
  autocommands_create = true,
  commands_create = true,
  silent = false,
  lookup_parents = false
}

-- Setup for Barbar

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
-- Re-order to previous/next
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
-- Goto buffer in position...
map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
-- Pin/unpin buffer
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
-- Close buffer
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
-- Sort automatically by...
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

require('bufferline').setup{
-- Enable/disable animations
  animation = true,

  -- Enable/disable auto-hiding the tab bar when there is a single buffer
  auto_hide = false,

  -- Enable/disable current/total tabpages indicator (top right corner)
  tabpages = true,

  -- Enable/disable close button
  closable = true,

  -- Enables/disable clickable tabs
  --  - left-click: go to buffer
  --  - middle-click: delete buffer
  clickable = true,

  -- Excludes buffers from the tabline
  exclude_ft = {'javascript'},
  exclude_name = {'package.json'},

  -- Enable/disable icons
  -- if set to 'numbers', will show buffer index in the tabline
  -- if set to 'both', will show buffer index and icons in the tabline
  icons = true,

  -- If set, the icon color will follow its corresponding buffer
  -- highlight group. By default, the Buffer*Icon group is linked to the
  -- Buffer* group (see Highlighting below). Otherwise, it will take its
  -- default value as defined by devicons.
  icon_custom_colors = false,

  -- Configure icons on the bufferline.
  icon_separator_active = '▎',
  icon_separator_inactive = '▎',
  icon_close_tab = '',
  icon_close_tab_modified = '●',
  icon_pinned = '車',

  -- If true, new buffers will be inserted at the start/end of the list.
  -- Default is to insert after current buffer.
  insert_at_end = false,
  insert_at_start = false,

  -- Sets the maximum padding width with which to surround each tab
  maximum_padding = 1,

  -- Sets the minimum padding width with which to surround each tab
  minimum_padding = 1,

  -- Sets the maximum buffer name length.
  maximum_length = 30,

  -- If set, the letters for each buffer in buffer-pick mode will be
  -- assigned based on their name. Otherwise or in case all letters are
  -- already assigned, the behavior is to assign letters in order of
  -- usability (see order below)
  semantic_letters = true,

  -- New buffer letters are assigned in this order. This order is
  -- optimal for the qwerty keyboard layout but might need adjustement
  -- for other layouts.
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',

  -- Sets the name of unnamed buffers. By default format is "[Buffer X]"
  -- where X is the buffer number. But only a static string is accepted here.
  no_name_title = nil
}

-- Setup for Terminal

require'toggleterm'.setup{
  open_mapping = [[<c-\>]],
  shading_factor = '0',
  direction = 'float',
  float_opts = {
    border = 'curved'
  },
  winbar = {
    enabled = true
  }
}

-- Move lines

vim.keymap.set('n', '<A-Down>', ':m .+1<CR>==', opts)
vim.keymap.set('n', '<A-Up>', ':m .-2<CR>==', opts)
vim.keymap.set('i', '<A-Down>', '<ESC>:m .+1<CR>==gi', opts)
vim.keymap.set('i', '<A-Up>', '<ESC>:m .-2<CR>==gi', opts)
vim.keymap.set('v', '<A-Down>', ':m \'>.+1<CR>gv==gv', opts)
vim.keymap.set('v', '<A-Up>', ':m \'<.-2<CR>gv==gv', opts)

-- Setup for LSP

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local lsp_flags = {
  debounce_text_changes = 150
}

vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]

local lsp = require'lspconfig'

--[[ lsp.eslint.setup {
  on_attach = on_attach,
  flags = lsp_flags
} --]]

lsp["rust_analyzer"].setup {
  on_attach = on_attach,
  flags = lsp_flags,
  settings = {
    ["rust-analyzer"] = {
      procMacro = { enable = true },
      diagnostic = { disabled = {"unresolved-proc-macro"} }
    }
  }
}

vim.g.rustfmt_autosave = 1

require('rust-tools').setup{}


lsp.ccls.setup {
  init_options = {
    compilationDatabaseDirectory = 'builddir'
  }
}

--- Setup for DAP

local dap = require('dap')
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '~/.local/bin/extension/debugAdapters/bin/OpenDebugAD7'
}

-- Setup for NVIM Tree

require('nvim-tree').setup()
vim.keymap.set('n', '<F5>', ':NvimTreeToggle<CR>', opts)

-- Setup for Telescope

require('telescope').setup()
vim.keymap.set('n', '<F6>', ':Telescope live_grep<CR>', opts)
vim.keymap.set('n', '<C-F>', ':Telescope current_buffer_fuzzy_find<CR>', opts)
vim.keymap.set('i', '<F6>', '<ESC>:Telescope live_grep<CR>', opts)
vim.keymap.set('i', '<C-F>', '<ESC>:Telescope current_buffer_fuzzy_find<CR>', opts)
vim.keymap.set('n', '<F7>', ':Telescope fd<CR>', opts)
vim.keymap.set('i', '<F7>', '<ESC>:Telescope fd<CR>', opts)

-- Setup for LuaLine
require('lualine').setup()

-- Setup for indent_blankline

vim.opt.termguicolors = true

vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

vim.opt.list = true

require('indent_blankline').setup {
  space_char_blankline = ' ',
  char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
    "IndentBlanklineIndent3",
    "IndentBlanklineIndent4",
    "IndentBlanklineIndent5",
    "IndentBlanklineIndent6",
  },
}

-- Custom Commands

vim.keymap.set('n', '<C-s>', ':w<CR>', opts)
vim.keymap.set('i', '<C-s>', '<ESC>:w<CR>i', opts)
vim.keymap.set('n', '<F8>', ':Autoformat<CR>', opts)
vim.keymap.set('i', '<F8>', '<ESC>:Autoformat<CR>i', opts)

--- C/C++ Styling
vim.api.nvim_create_autocmd('FileType c,cpp,h,hpp', {
  command = 'silent! ClangFormatAutoEnable'
})
