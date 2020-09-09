" Use Vim settings, rather than Vi settings
set nocompatible
syntax on

let s:at_work = filereadable(expand('~/.dotfiles-at-work/vimrc-work.vim'))
if s:at_work
  source ~/.dotfiles-at-work/vimrc-work.vim
endif

" Remap leader to ,
noremap \ ,
let mapleader = ","

" Plugins
call plug#begin('~/.vim/plugged')

let g:redtt_path = '/home/scott/Projects/redtt/result/bin/redtt'
Plug '~/Projects/redtt/vim'

" Visual Studio Code Dark+ colorscheme
Plug 'tomasiser/vim-code-dark'

Plug 'bling/vim-airline'
set noshowmode
let g:airline_theme = 'codedark_scott'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.readonly = '🛇 '

let g:airline#extensions#ctrlp#show_adjacent_modes = 0
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#wordcount#enabled = 0

function! SolsonBetterFfenc()
  let l:ff  = strlen(&ff) ? '['.&ff.']' : ''
  let l:bom = &l:bomb ? '[bom]' : ''
  let l:out = &fenc . l:ff . l:bom
  if l:out is# 'utf-8[unix]' || l:out is# '[unix]'
    return ''
  else
    return l:out
  endif
endfunction

function! SolsonAirlineInit()
  call airline#parts#define_function('better_ffenc', 'SolsonBetterFfenc')
  let g:airline_section_y = airline#section#create(['better_ffenc'])
endfunction
autocmd User AirlineAfterInit call SolsonAirlineInit()

" See `:help mode()` for an explanation of the mode names.
let g:airline_mode_map = {
  \ '__' : ' ',
  \ 'c'  : ':',
  \ 'i'  : 'I',
  \ 'ic' : 'I',
  \ 'ix' : 'I',
  \ 'n'  : 'N',
  \ 'ni' : 'Ṇ',
  \ 'R'  : 'R',
  \ 'Rv' : 'R̰',
  \ 's'  : 'S',
  \ 'S'  : 'S̲',
  \ '' : 'S̪',
  \ 't'  : '>',
  \ 'v'  : 'V',
  \ 'V'  : 'V̲',
  \ '' : 'V̪',
  \ }

Plug 'mhinz/vim-signify'
let g:signify_vcs_list = ['git', 'svn']
let g:signify_sign_change = '~'

Plug 'kien/ctrlp.vim'
Plug 'd11wtq/ctrlp_bdelete.vim'
let g:ctrlp_switch_buffer = ''
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
nmap <leader>b :CtrlPBuffer<CR>
nmap <leader>e :CtrlP<CR>
nmap <leader>t :CtrlPTag<CR>

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

Plug 'tpope/vim-commentary'
autocmd FileType c,cpp  setlocal commentstring=//\ %s
autocmd FileType idris  setlocal commentstring=--\ %s
autocmd FileType julia  setlocal commentstring=#\ %s
autocmd FileType matlab setlocal commentstring=%\ %s
autocmd FileType racket setlocal commentstring=;\ %s
autocmd FileType redtt  setlocal commentstring=--\ %s
autocmd FileType sml    setlocal commentstring=(*%s*)
autocmd FileType xquery setlocal commentstring=(:%s:)

Plug 'JuliaEditorSupport/julia-vim'
Plug 'LnL7/vim-nix'
Plug 'Nonius/cargo.vim'
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
Plug 'wlangstroth/vim-racket'
Plug 'mk12/vim-lean', { 'for': 'lean' }

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
set fillchars=vert:│,fold:\ 
set formatoptions+=cqtrol
set gdefault
set hidden
set history=50
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

" Setting 'hlsearch' has the annoying side-effect of immediately turning on
" highlights if a search term is set. To avoid highlights re-enabling whenever
" .vimrc is sourced, we check if they were on or off and keep it that way.
let s:hl = v:hlsearch
set hlsearch
if !s:hl
  nohlsearch
endif

if has('nvim')
  set inccommand=nosplit
endif

" Spell checking
set spelllang=en_ca
set complete+=kspell
autocmd FileType markdown,tex setlocal spell

" Use <leader>l to switch to the last active buffer instead of C-^ since C-^ is
" mosh's prefix command.
noremap <leader>l <C-^>

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

  if !has('nvim')
    set ttymouse=xterm2
  endif
endif

" GUI options
set guifont=Terminus\ 10
set guioptions-=mrLtT " Disable menus, toolbar, scrollbars
set browsedir=buffer " GUI open starts in dir of buffer's file

" Indentation exceptions
autocmd FileType go setlocal noet
autocmd FileType asm setlocal sw=8 ts=8 nosmartindent
autocmd FileType c,cpp setlocal sw=4 ts=4
autocmd FileType nix setlocal sw=2 ts=2

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

" Clear search highlights. Note that <C-_> matches Ctrl+/ in Vim.
nmap <silent> <C-_> :silent :nohlsearch<CR>

" Copy and paste using X11 clipboard.
vnoremap <leader>y "+y
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
if $COLORTERM == 'gnome-terminal' || $COLORTERM == 'xfce4-terminal' || exists("$KONSOLE_PROFILE_NAME")
  set t_Co=256
endif

" Use a nice colorscheme if 256 colors are available
if &t_Co == 256 || has("gui_running")
  colorscheme codedark
endif

" Fix handling of Ctrl-arrowkeys inside tmux, which provides xterm-style keys
" but has a screen-256color TERM variable.
if &term =~ '^screen'
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif
