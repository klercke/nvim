" NVIM Config
" Author: @klercke

" Credits:
" Initially based on https://github.com/theniceboy/nvim

" === Auto install plugins ===
" Install vim-plug if it isn't already installed
if has('win32') || has('win64')
	" Windows
	if empty(glob('$LOCALAPPDATA\nvim\autoload\plug.vim'))
  	silent ! powershell -Command "
  	\   New-Item -Path ~\AppData\Local\nvim -Name autoload -Type Directory -Force;
  	\   Invoke-WebRequest
  	\   -Uri 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  	\   -OutFile ~\AppData\Local\nvim\autoload\plug.vim
		\ "
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
else
	" *nix
	if empty(glob('~/.config/nvim/autoload/plug.vim'))
  	silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
endif

" Check if all plugins are installed. If not, install them (we check wildfire
" because it alphabetically the last plugin ((I think))
let g:nvim_plugins_installation_completed=1
if has('win32') || has('win64')
	" Windows
	if empty(glob('$LOCALAPPDATA\nvim-data\plugged\wildfire.vim\autoload\wildfire.vim'))
		let g:nvim_plugins_installation_complete=0
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
else 
	" Unix
	if empty(glob('~/.local/share/nvim/plugged/wildfire.vim'))
		let g:nvim_plugins_installation_completed=0
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
endif

" === Colemak Movement ===
"			^
"    	e
" < h	*   i > 
"    	n
"    	v
noremap <silent> n j
noremap <silent> e k
noremap <silent> i l

" Window movement
nnoremap <C-h> <C-w>h
nnoremap <C-n> <C-w>j
nnoremap <C-e> <C-w>k
nnoremap <C-i> <C-w>l

" === Basic Keybinds ===
" Comma as leader
let mapleader=","

" Quicksave and exit
nnoremap Q :q<CR>
nnoremap S :w<CR>

" Quick edit vimrc
nnoremap <LEADER>rc :e $MYVIMRC<CR>
augroup NVIMRC
    autocmd!
    autocmd BufWritePost *.nvimrc,init.vim exec ":so %"
augroup END

" Insert mode
noremap l i
noremap L I

" Other Colemak fixes
noremap k n
noremap K N
noremap f e 

" hh -> esc
imap hh <Esc>

" === Editor Settings
" Hybrid line numbers
set number relativenumber

" Disable bell, keep visual bell
set visualbell

" Set tab width to two spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Enable filetype detection, plugin, and indentation
filetype plugin indent on

" Set status line to always show
set laststatus=2

" Set 24-bit colors for colorschemes to work
set tgc

" Open splits to the bottom and to the right
set splitbelow
set splitright

" Smart case sensitivity in searches
set ignorecase
set smartcase

" Enable spellcheck in certain files
autocmd BufNewFile,BufRead *.md,*.txt setlocal spell

" === Custom commands ===
" Insert datestring for Hugo
command! Date :normal a<C-R>=strftime('%Y-%m-%dT%H:%M:%S%z')<CR>

" === Plugins ===
call plug#begin()

" Libraries
Plug 'nvim-lua/plenary.nvim'

" Editor enhancement
Plug 'gcmt/wildfire.vim' " in Visual mode, type k' to select all text in '', or type k) k] k} kp (not configured yet)
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'norcalli/nvim-colorizer.lua'
Plug 'cohama/lexima.vim'

" Eye candy
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'gbprod/nord.nvim'
Plug 'ellisonleao/gruvbox.nvim'

" Completion
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'
Plug 'honza/vim-snippets'

" Git
Plug 'tpope/vim-fugitive'
Plug 'petertriho/cmp-git'
Plug 'f-person/git-blame.nvim'

" Terraform
Plug 'hashivim/vim-terraform'

" Markdown
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown' 

" Misc
Plug 'lambdalisue/suda.vim' " On Windows, requires https://github.com/gerardog/gsudo

call plug#end()

" === Plugin Config ===

" Colorscheme
lua << EOF
-- detect os and set colorscheme accordingly
local uname = vim.loop.os_uname().sysname:lower()

if uname == "linux" then
  -- check if it's nixos
  local handle = io.popen("grep -q NixOS /etc/os-release && echo nixos || echo other-os")
  local result = handle:read("*a")
  handle:close()

  if result:find("nixos") then
    vim.cmd("colorscheme gruvbox")
    require('lualine').setup {
      options = { theme = 'gruvbox' }
    }
  else
    vim.cmd("colorscheme nord")
    require('lualine').setup {
      options = { theme = 'nord' }
    }
  end
else
  vim.cmd("colorscheme nord") -- default to nord for non-linux systems
  require('lualine').setup {
    options = { theme = 'nord' }
  }
end
EOF


" lualine
"lua << EOF
"require('lualine').setup{
"	options = { theme = 'nord' }
"}
"EOF

" suda
let g:suda_smart_edit = 1

" nvim-treesitter
lua << EOF
require 'nvim-treesitter.configs'.setup {
	ensure_installed = { "python", "lua", "vim", "vimdoc", "rust", "hcl" },
	auto_install = false,
}
EOF
autocmd FileType vim lua vim.treesitter.start()

" Auto-fmt Terraform using vim-terraform
augroup TERRAFORMFMT
    autocmd!
    autocmd BufWritePost *.tf exec ":Terraform fmt"
augroup END

" Colorizer
lua << EOF
require 'colorizer'.setup ({
	filetypes = { "*" },
	options = {
		names = false
	}
})
EOF

" vim-markdown
let g:vim_markdown_folding_disabled = 1
"let g:vim_markdown_folding_level = 2
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_new_list_item_indent = 2

" lexima
let g:lexima_enable_basic_rules = 1

" cmp-git
lua <<EOF
require("cmp").setup({
    sources = {
        { name = "git" },
        -- more sources
    }
})

require("cmp_git").setup()
EOF

" nvim-cmp
lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<Cr>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
  -- Set configuration for specific filetype.
  --[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'git' },
    }, {
      { name = 'buffer' },
    })
 })
 require("cmp_git").setup() ]] 

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['pyright'].setup {
    capabilities = capabilities
  }
EOF

" UltiSnips
" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" Easy bold and italics for markdown
call lexima#add_rule({'char': '*', 'input_after': '*', 'filetype': 'markdown'})
call lexima#add_rule({'char': '*', 'at': '\*\%#', 'input': '*', 'input_after': '*', 'priority': 1, 'filetype': 'markdown'})
call lexima#add_rule({'char': '*', 'at': '\*\*\%#', 'input': '*', 'input_after': '*', 'priority': 2, 'filetype': 'markdown'})
call lexima#add_rule({'char': '*', 'at': '\%#\*', 'leave': 1, 'filetype': 'markdown'})
call lexima#add_rule({'char': '*', 'at': '\%#\*\*', 'leave': 2, 'filetype': 'markdown'})
call lexima#add_rule({'char': '*', 'at': '\%#\*\*\*', 'leave': 3, 'filetype': 'markdown'})
call lexima#add_rule({'char': '<BS>', 'at': '\*\%#\*', 'delete': 1, 'filetype': 'markdown'})

