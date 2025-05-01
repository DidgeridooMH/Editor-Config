local Plug = vim.fn["plug#"]

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'leafOfTree/vim-svelte-plugin'
Plug 'neovim/nvim-lspconfig'
Plug 'omnisharp/omnisharp-roslyn'
Plug 'MunifTanjim/prettier.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'vim-autoformat/vim-autoformat'
Plug 'rhysd/vim-clang-format'
Plug('folke/tokyonight.nvim', {branch = 'main' })
Plug('akinsho/toggleterm.nvim', {tag = 'v2.*'})
Plug 'ray-x/lsp_signature.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'onsails/lspkind.nvim'
Plug 'folke/trouble.nvim'

Plug 'lewis6991/gitsigns.nvim'
Plug 'romgrk/barbar.nvim'

-- Autocomplete
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

vim.call('plug#end')

-- Styling commands

vim.cmd[[colorscheme tokyonight-storm]]

vim.api.nvim_command('set number relativenumber')
vim.api.nvim_command('set mouse=a')
vim.api.nvim_command('set expandtab')
vim.api.nvim_command('set tabstop=2')
vim.api.nvim_command('set shiftwidth=2')
vim.api.nvim_command('set number')

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
vim.keymap.set('i', 'kj', '<esc>', opts)
vim.keymap.set('i', 'jk', '<esc>', opts)

local protocol = require('vim.lsp.protocol')
local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", {clear = true}),
      buffer = bufnr,
      callback = function() vim.lsp.buf.format() end
    })
  end

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
  --vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(
  protocol.make_client_capabilities()
)

local null_ls = require('null-ls')
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettierd,
    },
})

require('prettier').setup {
  bin = 'prettierd',
  filetypes = {
    'css',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'json',
    'scss',
    'less'
  }
}

local lspkind = require('lspkind')
local cmp = require('cmp')
cmp.setup{
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
    })
  }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' }
  }),
  formatting = {
    format = lspkind.cmp_format({ with_text = false, maxwidth = 50 })
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  }
}

local symbols = { Error = "󰅙", Info = "󰋼", Hint = "󰌵", Warn = "" }
for name, icon in pairs(symbols) do
  local hl = "DiagnosticSign" .. name
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.cmd [[
  set completeopt=menuone,noinsert,noselect
]]
--highlight! default link CmpItemKind CmpItemMenuDefault

-- Setup for barbar

local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
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
map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

-- Setup for Terminal

require("toggleterm").setup{
  open_mapping = [[<c-\>]],
  shade_terminals = true,
  shading_factor = '1',
  direction = 'float',
  close_on_exit = true,
  persist_size = true,
  float_opts = {
    border = 'curved'
  }
}

-- Setup for LSP's

local lsp = require'lspconfig'
lsp['ts_ls'].setup {
  on_attach = on_attach,
  filetypes = { 'typescript', "typescriptreact", 'typescript.tsx' },
  cmd = {'typescript-language-server', '--stdio'},
  capabilities = capabilities
}
lsp.svelte.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {'svelteserver', '--stdio'}
}
local pid = vim.fn.getpid();
lsp.omnisharp.setup {
  cmd = {'/Users/daniel/.local/bin/omnisharp/run', '--languageserver', '--hostPID',  tostring(pid)},
  capabilities = capabilities,
  on_attach = on_attach
}

lsp.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
    'clangd',
    '--offset-encoding=utf-16'
  }
}
lsp['rust_analyzer'].setup {
  on_attach = on_attach,
  capabilities = capabilities
}

require "lsp_signature".setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  handler_opts = {
    border = "rounded"
  }
})

vim.api.nvim_create_autocmd('FileType', {pattern = {'c','cpp', 'h', 'hpp'}, command = 'ClangFormatAutoEnable'})
vim.api.nvim_create_autocmd('BufWritePre', {pattern = {'tsx', 'ts', 'jsx', 'js'}, command='EslintFixAll'})

require('nvim-tree').setup()
vim.keymap.set('n', '<F5>', ':NvimTreeToggle<CR>', opts)

-- Setup for Telescope

require('telescope').setup{
  defaults = {
    file_ignore_patterns = { "node_modules" }
  }
}

require("trouble").setup()
vim.keymap.set("n", "<leader>xx", function() require("trouble").open() end)
vim.keymap.set("n", "<leader>xw", function() require("trouble").open("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>xd", function() require("trouble").open("document_diagnostics") end)
vim.keymap.set("n", "<leader>xq", function() require("trouble").open("quickfix") end)
vim.keymap.set("n", "<leader>xl", function() require("trouble").open("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").open("lsp_references") end)

-- Setup for LuaLine

require('lualine').setup()

-- Setup for indent_blankline

vim.opt.termguicolors = true
vim.opt.list = true

local highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup { indent = { highlight = highlight } }

-- Custom Commands

-- Save current file.
vim.keymap.set('n', '<C-s>', '<CR>:w<CR>', opts)
vim.keymap.set('i', '<C-s>', '<ESC>:w<CR>i', opts)

-- Format current file.
vim.keymap.set('n', '<F4>', ':Autoformat<CR>', opts)
vim.keymap.set('i', '<F4>', '<ESC>:Autoformat<CR>i', opts)

-- Move lines
vim.keymap.set('n', '<A-Down>', ':m .+1<CR>==', opts)
vim.keymap.set('n', '<A-Up>', ':m .-2<CR>==', opts)
vim.keymap.set('i', '<A-Down>', '<ESC>:m .+1<CR>==gi', opts)
vim.keymap.set('i', '<A-Up>', '<ESC>:m .-2<CR>==gi', opts)
vim.keymap.set('v', '<A-Down>', ':m \'>+1<CR>gv=gv', opts)
vim.keymap.set('v', '<A-Up>', ':m \'<-2<CR>gv=gv',opts)

-- Find Actions
vim.keymap.set('n', '<C-F>', ':Telescope current_buffer_fuzzy_find<CR>', opts)
vim.keymap.set('i', '<C-F>', '<ESC>:Telescope current_buffer_fuzzy_find<CR>', opts)
vim.keymap.set('v', '<C-F>', ':Telescope current_buffer_fuzzy_find<CR>', opts)

vim.keymap.set('n', '<F7>', ':Telescope live_grep<CR>', opts)
vim.keymap.set('i', '<F7>', '<ESC>:Telescope live_grep<CR>', opts)
vim.keymap.set('v', '<F7>', ':Telescope live_grep<CR>', opts)

vim.keymap.set('n', '<F8>', ':Telescope fd<CR>', opts)
vim.keymap.set('i', '<F8>', '<ESC>:Telescope fd<CR>', opts)
vim.keymap.set('v', '<F8>', ':Telescope fd<CR>', opts)


