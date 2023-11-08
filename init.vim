" NVIM Config
" Author: @klercke
" Updated: 2023-11-08

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
	let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
	if empty(glob(data_dir . '/autoload/plug.vim'))
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
	if empty(glob($HOME.'/.config/nvim/plugged/wildfire.vim/autoload/wildfire.vim'))
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

" Enable filetype detection, plugin, and indentation
filetype plugin indent on

" Set status line to always show
set laststatus=2

" Set 24-bit colors for colorschemes to work
set tgc

" === Plugins ===
call plug#begin()

" Editor enhancement
Plug 'gcmt/wildfire.vim' " in Visual mode, type k' to select all text in '', or type k) k] k} kp (not configured yet)
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Eye candy
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'gbprod/nord.nvim'

" Git
Plug 'tpope/vim-fugitive'

" Completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Misc
Plug 'lambdalisue/suda.vim' " On Windows, requires https://github.com/gerardog/gsudo

call plug#end()

" === Plugin Config ===

" Nord
colorscheme nord

" lualine
lua << EOF
require('lualine').setup()
EOF

" suda
let g:suda_smart_edit = 1

" nvim-treesitter
lua << EOF
require 'nvim-treesitter.configs'.setup {
	ensure_installed = { "python", "lua", "vim", "vimdoc", "rust" },
	auto_install = false,
}
EOF
autocmd FileType vim lua vim.treesitter.start()

