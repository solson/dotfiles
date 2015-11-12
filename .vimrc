" Use Vim settings, rather than Vi settings
set nocompatible
syntax on

" Remap leader to ,
noremap \ ,
let mapleader = ","

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'bling/vim-airline'
Plug 'asenac/vim-airline-loclist'
set noshowmode
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline#extensions#ctrlp#show_adjacent_modes = 0
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#loclist#enabled = 1
let g:airline#extensions#whitespace#enabled = 0

Plug 'mhinz/vim-signify'
let g:signify_vcs_list = ['git', 'svn']
let g:signify_sign_change = '~'

Plug 'kien/ctrlp.vim'
Plug 'd11wtq/ctrlp_bdelete.vim'
let g:ctrlp_switch_buffer = ''
nmap <leader>b :CtrlPBuffer<CR>
nmap <leader>e :CtrlP<CR>
nmap <leader>t :CtrlPTag<CR>
nmap <leader>l :CtrlPLine<CR>

Plug 'junegunn/vim-easy-align'
vnoremap <silent> <Enter> :EasyAlign<Enter>

" Custom text objects library plugin
Plug 'kana/vim-textobj-user'
" `ac/ic` for a comment
Plug 'glts/vim-textobj-comment'
" `a,/i,` for a function parameter
Plug 'sgur/vim-textobj-parameter'

Plug 'lervag/vimtex'
let g:tex_flavor = 'latex' " Never use the plaintex filetype.
let g:vimtex_latexmk_build_dir = 'out'
let g:vimtex_syntax_minted = [
  \ { 'lang': 'c' },
  \ { 'lang': 'rust' },
\ ]

" Snippets engine
Plug 'SirVer/ultisnips'
let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsExpandTrigger = "<c-j>"
let g:UltiSnipsJumpForwardTrigger = "<c-j>"
let g:UltiSnipsJumpBackwardTrigger = "<c-k>"
nnoremap <leader>u :UltiSnipsEdit<CR>

" Plug 'Valloric/YouCompleteMe'
" let g:ycm_add_preview_to_completeopt = 1
" let g:ycm_always_populate_location_list = 1
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_enable_diagnostic_signs = 0
" let g:ycm_extra_conf_globlist = ["~/code/*"]
" " Close preview window when leaving insert mode
" autocmd InsertLeave * if pumvisible() == 0|pclose|endif

let g:racer_cmd = "/home/scott/code/y/racer/target/release/racer"
let $RUST_SRC_PATH = "/home/scott/code/y/rust-for-racer/src"
if isdirectory($RUST_SRC_PATH) && filereadable(g:racer_cmd)
  Plug 'racer-rust/vim-racer'
endif

Plug 'tpope/vim-commentary'
autocmd FileType c,cpp  setlocal commentstring=//\ %s
autocmd FileType idris  setlocal commentstring=--\ %s
autocmd FileType racket setlocal commentstring=;\ %s

Plug 'cespare/vim-toml'
Plug 'dag/vim-fish'
Plug 'idris-hackers/idris-vim'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'rking/ag.vim'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/syntastic'
Plug 'sickill/vim-pasta'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'travitch/hasksyn'
Plug 'tsion/jellybeans.vim'
Plug 'wlangstroth/vim-racket'

call plug#end()
call ctrlp_bdelete#init()

" Place all backup files in ~/.vim/backup
set backup
set backupdir=~/.vim/backup

" General
set autoindent
set backspace=indent,eol,start
set colorcolumn=+1
set display+=lastline
set fillchars=vert:\|,fold:\ 
set formatoptions+=cqtrol
set gdefault
set hidden
set history=50
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set nojoinspaces
set number
set ruler
set shiftround
set shortmess=atI
set showcmd
set smartcase
set smartindent
set smarttab
set textwidth=80
set title
set ttimeoutlen=100
set wildignore=*.o,*~
set wildmode=longest,list:longest

" Spell checking
set spelllang=en_ca
set complete+=kspell
autocmd FileType markdown,tex setlocal spell

" Correct the nearest previous spelling error.
inoremap <C-s> <Esc>[s1z=`]a

" Visuall bell must be disabled after the GUI starts.
set visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Default to 2-space indents, 2-character tabs
set expandtab
set shiftwidth=2
set tabstop=2

" Use Google C++ style
set cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4,N-s

if &encoding == 'utf-8'
  " Visible trailing whitespace
  set list
  set listchars=tab:\ \ ,trail:·
  " Hide trailing whitespace in insert mode
  autocmd InsertEnter * setlocal nolist
  autocmd InsertLeave * setlocal list
endif

" Enable mouse in terminals
if has('mouse')
  set mouse=a
endif

" GUI options
set guifont=Terminess\ Powerline\ 10
set guioptions-=mrLtT " Disable menus, toolbar, scrollbars
set browsedir=buffer " GUI open starts in dir of buffer's file

" Indentation exceptions
autocmd FileType go setlocal noet
autocmd FileType asm setlocal sw=8 ts=8 nosmartindent
autocmd FileType c,cpp setlocal sw=4 ts=4

" Disable annoying as-you-type trailing whitespace highlighting
let go_highlight_trailing_whitespace_error = 0

" Filetypes
autocmd BufRead,BufNewFile *.apr set filetype=clojure
autocmd BufRead,BufNewFile SConstruct,SConscript set filetype=python

" Smarter %
runtime macros/matchit.vim

" Scroll up and down, keeping the cursor in the same place on the screen, as if
" the lines are scrolling past and the cursor is stationary.
nnoremap <silent> <C-j> :call <SID>ScrollDown()<CR>
nnoremap <silent> <C-k> :call <SID>ScrollUp()<CR>

function! s:ScrollDown()
  if winline() == winheight(0)
    normal! j
  else
    exec "normal! j\<C-e>"
  endif
endfunction

function! s:ScrollUp()
  if winline() == 1
    normal! k
  else
    exec "normal! k\<C-y>"
  endif
endfunction

" Clear search highlights
nmap <silent> <leader>n :silent :nohlsearch<CR>

" Paste from X11 clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" Use Q for formatting, not Ex mode
noremap Q gq

" Make Y an alias for y$ instead of yy
nnoremap Y y$

" Quickly edit and source this file
nnoremap <leader>ve :split $MYVIMRC<cr>
nnoremap <leader>vs :source $MYVIMRC<cr>

" Set the dictionary for ctrl-x ctrl-k word completion.
set dictionary=/usr/share/dict/words

" Because vim is too stupid to figure out these support 256 colors
if $COLORTERM == 'gnome-terminal' || $COLORTERM == 'xfce4-terminal'
  set t_Co=256
endif

" Use a nice colorscheme if 256 colors are available
if &t_Co == 256 || has("gui_running")
  colorscheme jellybeans
endif

" Adjust spelling error syntax highlighting. Must come after `colorscheme`.
highlight clear SpellBad
highlight clear SpellCap
highlight clear SpellLocal
highlight SpellBad   cterm=bold,undercurl ctermfg=red
highlight SpellCap   cterm=bold,undercurl ctermfg=blue
highlight SpellLocal cterm=bold,undercurl ctermfg=cyan
