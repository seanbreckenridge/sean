" Template from: https://gist.github.com/simonista/8703722

" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" load plugins/lua

call plug#begin('~/.local/plugged')
Plug 'junegunn/goyo.vim'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}  " for tutorial: 'nvim -Nu .local/plugged/vim-visual-multi/tutorialrc'
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'
Plug 'kevinhwang91/rnvimr'
Plug 'airblade/vim-gitgutter'
Plug 'psliwka/vim-smoothie'
Plug 'airblade/vim-rooter'
Plug 'seanbreckenridge/yadm-git.vim'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
call plug#end()

" load my lua configuration -- i.e. my init.lua
lua require("seanbreckenridge")

"""""""""""""
"           "
"  OPTIONS  "
"           "
"""""""""""""

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on
let mapleader =" "

" Dont execute arbitrary modelines
set modelines=0
set number relativenumber  " line number
" Blink cursor on error instead of beeping
set visualbell

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set textwidth=0  wrapmargin=0" stop line wrapping
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround
set smartindent

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬

" prevents truncated yanks, deletes, etc.
" makes sure that you can lots of lines across
" files/vim instances without truncating the buffer
set viminfo='20,<1000,s1000

" enable persistent undo (save undo history across file closes) if possible
if has("persistent_undo")
  set undodir=$HOME/.cache/undodir
  set undofile
endif

""""""""""
"        "
"  PATH  "
"        "
""""""""""

" Allow find commands to search the current directory recursively
set path+=**

" display all matching files for tab completion
set wildmenu
set wildmode=longest,list,full
" Ignore files
set wildignore+=*__pycache__/*
set wildignore+=*.mypy_cache/*
set wildignore+=*.pytest_cache/*
set wildignore+=*egg-info/*
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/dist/*
set wildignore+=**/build/*
set wildignore+=**/.git/*

""""""""""""""
"            "
"  MAPPINGS  "
"            "
""""""""""""""

" mapping to toggle spellcheck
map <leader>s :set spell!<CR>

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Wrap long lines of text (use Qq to run)
" (obviously, 5Qq to do multiple lines)
nnoremap Q gq

" center/fix cursor when jumping around text
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" disable arrow keys
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap <Up> <Nop>
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>
vnoremap <Up> <Nop>

" copy visual selection to clipboard
vmap <leader>c "+y
vmap <leader>y "+y
nnoremap <leader>y V"+y

" open netrw like a sidebar file manager
nnoremap <leader>e :wincmd v<bar> :Explore <bar> :vertical resize 30<CR>
" open netrw full screen
nnoremap <leader>E :Explore<CR>

" window/buffers

" swap to previous buffer
map <leader><leader> :bprevious<CR>

" nicer binding for window management
map <leader>w <C-W>
" can use <leader>w+ and <leader>w- to increase
" vertical resizing
nnoremap <leader>= :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>

nnoremap <leader>+ :wincmd +<CR>
nnoremap <leader>_ :wincmd -<CR>

""""""""""""""""""""""""""
"                        "
"  PLUGIN CONFIGURATION  "
"                        "
""""""""""""""""""""""""""

" Note: more extensive plugins have their own file in plugin/

" goyo
map <leader>G :Goyo<CR>

" yadm
let g:yadm_git_verbose = 1

" undotree
nnoremap <leader>u :UndotreeToggle<CR>

" fzf
map <leader>b :Buffers<CR>
map <leader>f :Files<CR>
map <leader>l :Lines<CR>
map <C-p> :GitFiles<CR>
" match all lines/files recursively using the_silver_searcher
map <leader>r :Ag<CR>

if executable('rg')
  let g:rg_derive_root='true'
endif

" seanbreckenridge (personal functions/plugins)
map <leader>c :Ec<CR>
map <leader>j :Jump<CR>

"""""""""""""
"           "
"  AUTOCMD  "
"           "
"""""""""""""

" run set spell when editing markdown
" dont autocomplete in markdown
autocmd VimEnter * if expand('%:e') == 'md' | set spell | let b:coc_suggest_disable = 1
" or when writing a git commit
autocmd BufRead,BufNewFile * if expand('%:t') == 'COMMIT_EDITMSG' | set spell
