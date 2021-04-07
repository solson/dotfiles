" Remap leader to ,
noremap \ ,
let mapleader = ","

" Plugins
call plug#begin(stdpath('config') . '/plugged')

let g:redtt_path = '/home/scott/Projects/redtt/result/bin/redtt'
Plug '~/Projects/redtt/vim'

Plug 'bling/vim-airline'
set noshowmode
let g:airline_theme = 'codedark_solson'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.readonly = '🛇 '
let g:airline_symbols.branch = ''
let g:airline_symbols.dirty = '~'
let g:airline_symbols.notexists = '?'
let g:airline_symbols.spell = 'SP'
let g:airline_symbols.paste = 'PASTE'

let g:airline#extensions#ctrlp#show_adjacent_modes = 0
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#hunks#enabled = 0
let g:airline#extensions#fugitiveline#enabled = 0
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#wordcount#enabled = 0

function! s:BetterFfenc() abort
  let l:ff  = strlen(&ff) ? '['.&ff.']' : ''
  let l:bom = &l:bomb ? '[bom]' : ''
  let l:out = &fenc . l:ff . l:bom
  if l:out is# 'utf-8[unix]' || l:out is# '[unix]'
    return ''
  else
    return l:out
  endif
endfunction

function! s:CocGit() abort
  let l:global = get(g:, 'coc_git_status', '')
  let l:buffer = get(b:, 'coc_git_status', '')
  return l:global . l:buffer
endfunction

function! s:AirlineInit() abort
  call airline#parts#define_function('better_ffenc', string(function('s:BetterFfenc')))
  call airline#parts#define_function('coc_git', string(function('s:CocGit')))
  call airline#parts#define_function('better_file', string(function('SolsonPath')))
  let g:airline_section_b = airline#section#create(['coc_git'])
  let g:airline_section_c = airline#section#create(['%<', 'better_file', g:airline_symbols.space, 'readonly', 'coc_status', 'lsp_progress'])
  let g:airline_section_y = airline#section#create(['better_ffenc'])
endfunction
autocmd User AirlineAfterInit call <SID>AirlineInit()

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

Plug 'kien/ctrlp.vim'
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

Plug 'tpope/vim-commentary'
autocmd FileType c,cpp,typescript
  \ setlocal commentstring=//\ %s
autocmd FileType idris  setlocal commentstring=--\ %s
autocmd FileType julia  setlocal commentstring=#\ %s
autocmd FileType matlab setlocal commentstring=%\ %s
autocmd FileType racket setlocal commentstring=;\ %s
autocmd FileType redtt  setlocal commentstring=--\ %s
autocmd FileType sml    setlocal commentstring=(*%s*)
autocmd FileType xquery setlocal commentstring=(:%s:)

Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [
  \'coc-deno',
  \'coc-diagnostic',
  \'coc-git',
  \'coc-go',
  \'coc-json',
  \'coc-rust-analyzer',
  \'coc-sh',
  \'coc-tsserver',
  \'coc-vimlsp',
  \]
inoremap <silent><expr> <c-space> coc#refresh()
highlight link CocRustChainingHint NonText
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gD <Plug>(coc-declaration)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> <F2> <Plug>(coc-rename)
nnoremap <silent> gh :call CocAction('doHover')<CR>
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd FileType rust nnoremap <buffer><silent> <M-i> :CocCommand rust-analyzer.toggleInlayHints<CR>

Plug 'mattn/vim-gist'
let g:gist_token_file = $XDG_CONFIG_HOME . '/vim-gist/token'

Plug 'JuliaEditorSupport/julia-vim'
Plug 'LnL7/vim-nix'
Plug 'cespare/vim-toml'
Plug 'dag/vim-fish'
Plug 'idris-hackers/idris-vim'
Plug 'jeroenp/vim-xquery-syntax'
Plug 'mattn/webapi-vim'
Plug 'mattn/vim-gomod'
Plug 'rust-lang/rust.vim'
Plug 'sickill/vim-pasta'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-characterize'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'wincent/terminus'
Plug 'wlangstroth/vim-racket'
Plug 'mk12/vim-lean', { 'for': 'lean' }

call plug#end()

" General
set colorcolumn=+1
set fillchars=vert:│,fold:\ ,diff:╱
set formatoptions+=rol
set gdefault
set hidden
set ignorecase
set inccommand=nosplit
set mouse=a
set nojoinspaces
set number
set shiftround
set shortmess+=I
set smartcase
set smartindent
set textwidth=80
set undofile
set updatetime=100
set wildignore=*.o,*~
set wildmode=longest,list:longest

" Title
set title
set titlestring=%{SolsonPath()}\ :\ nvim

function! SolsonPath() abort
  if &buftype == "help"
    return '[help] '. expand('%:t')
  endif
  let l:path = expand('%:p:~')
  if l:path =~ '^/mut/platform/'
    return substitute(l:path, '/mut/platform/', '//', '')
  elseif getcwd() == $HOME
    return expand('%:~')
  else
    return expand('%:~:.')
  end
endfunction

" Disable netrw history files.
let g:netrw_dirhistmax = 0

" Setting 'hlsearch' has the annoying side-effect of immediately turning on
" highlights if a search term is set. To avoid highlights re-enabling whenever
" init.vim is sourced, we check if they were on or off and keep it that way.
let s:hl = v:hlsearch
set hlsearch
if !s:hl
  nohlsearch
endif

" Remap switching to the last active buffer away from C-^ since C-^ is mosh's
" prefix command.
noremap <leader><tab> <C-^>

" Default to 2-space indents, 2-character tabs
set expandtab
set shiftwidth=2
set tabstop=2

" Use Google C++ style
set cinoptions=h1,l1,g1,t0,i4,+4,(0,w1,W4,N-s

" Visible trailing whitespace
set list
set listchars=tab:\ \ ,trail:·
" Hide trailing whitespace in insert mode
autocmd InsertEnter * setlocal nolist
autocmd InsertLeave * setlocal list

" Indentation exceptions
autocmd FileType go    setlocal noet
autocmd FileType asm   setlocal sw=8 ts=8 nosmartindent
autocmd FileType c,cpp setlocal sw=4 ts=4

" Disable annoying as-you-type trailing whitespace highlighting
let go_highlight_trailing_whitespace_error = 0

" Filetypes
autocmd BufRead,BufNewFile *.apr set filetype=clojure
autocmd BufRead,BufNewFile SConstruct,SConscript set filetype=python

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
nnoremap <silent> <C-_> :silent :nohlsearch<CR>
imap <silent> <C-_> <C-o><C-_>

" Copy and paste using X11 clipboard.
vnoremap <leader>y "+y
nnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" Use Q for formatting, not Ex mode
noremap Q gq

" Make Y an alias for y$ instead of yy
nnoremap Y y$

" Quickly edit and source this file
nnoremap <leader>ve :edit $MYVIMRC<CR>
nnoremap <leader>vs :source $MYVIMRC<CR>

colorscheme codedark_solson
