" NVIM Config
" Author: @klercke
" Updated: 2023-11-08

" === Colemak Movement ===
"	^
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

" Enable filetype detection, plugin, and indentation
filetype plugin indent on
