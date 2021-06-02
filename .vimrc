" https://coderoncode.com/tools/2018/04/16/vim-the-perfect-ide.html
" This must be first, because it changes other options as a side effect.
set nocompatible

" {{{ Plugin Manager: vim-plug

" Command Description
" PlugInstall [name ...] [#threads]   Install plugins
" PlugUpdate [name ...] [#threads]    Install or update plugins
" PlugClean[!]    Remove unused directories (bang version will clean without prompt)
" PlugUpgrade Upgrade vim-plug itself
" PlugStatus  Check the status of plugins
" PlugDiff    Examine changes from the previous update and the pending changes
" PlugSnapshot[!] [output path]   Generate script for restoring the current snapshot of the plugins

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'

call plug#begin('~/.vim/plugged')

" Utility
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'majutsushi/tagbar'
" Vim plugin that shows keybindings in popup
Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
"Plug 'Valloric/YouCompleteMe', { 'do': 'nice python3 install.py' }
"Plug 'ervandew/supertab'
"Plug 'BufOnly.vim'
" FIXME: This maps C-n to it overwriting NERDTree
" also depcrecated use https://github.com/mg979/vim-visual-multi
"Plug 'terryma/vim-multiple-cursors'
"Plug 'wesQ3/vim-windowswap'
"Plug 'SirVer/ultisnips'
"Plug 'junegunn/fzf.vim'
"Plug 'junegunn/fzf'
Plug 'godlygeek/tabular'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'benmills/vimux' " VimuxRunCommand, VimuxRunLastCommand
"Plug 'jeetsukumaran/vim-buffergator'
"Plug 'gilsondev/searchtasks.vim'
"Plug 'Shougo/neocomplete.vim'
"Plug 'tpope/vim-dispatch'

" Generic Programming Support
"Plug 'jakedouglas/exuberant-ctags'
Plug 'editorconfig/editorconfig-vim'
Plug 'honza/vim-snippets'
Plug 'Townk/vim-autoclose'
"Plug 'tomtom/tcomment_vim'
"Plug 'tobyS/vmustache'
"Plug 'janko-m/vim-test'
"Plug 'maksimr/vim-jsbeautify'
Plug 'vim-syntastic/syntastic'
"Plug 'neomake/neomake'
"Plug 'pearofducks/ansible-vim', { 'do': 'cd ./UltiSnips; python2 generate.py' }
Plug 'vim-scripts/taglist.vim'
"Plug 'ekalinin/Dockerfile.vim'
Plug 'sheerun/vim-polyglot'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }

" Markdown / Writing
Plug 'reedes/vim-pencil', { 'for': 'markdown' }
Plug 'tpope/vim-markdown', { 'for': 'markdown' }
Plug 'jtratner/vim-flavored-markdown', { 'for': 'markdown' }
"Plug 'dpelle/vim-LanguageTool'
Plug 'hashivim/vim-terraform', { 'branch': 'fixTfstate' }

" Git Support
Plug 'kablamo/vim-git-log'
Plug 'gregsexton/gitv'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Theme / Interface
Plug 'mhinz/vim-startify'
Plug 'edkolev/tmuxline.vim'
Plug 'altercation/vim-colors-solarized'
"Plug 'AnsiEsc.vim'
" Adds file type icons to Vim plugins such as: NERDTree, vim-airline, CtrlP, unite, Denite, lightline, vim-startify and many more
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Initialize plugin system
call plug#end()

" }}}
" {{{ Syntastic Config
" Syntastic
" Disable if taking too long
"let g:syntastic_disabled_filetypes = ['sass', 'python']

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"}}}
" {{{ FZF Config

" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
let g:fzf_layout = { 'down': '~40%' }

" In Neovim, you can set up fzf window using a Vim command
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'
" }}}
" {{{ General

" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Disable youcompleteme error
if v:version < 703 || !has( 'patch584' )
    let g:loaded_youcompleteme = 1
endif

let g:ctrlp_user_command = {
    \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
    \ },
    \ 'fallback': 'find %s -type f'
\ }
let g:ctrlp_lazy_update = 150

" make backspace work
set backspace=indent,eol,start
set showmatch
" have % bounce between angled brackets, as well as other kinds:
set matchpairs+=<:>
set comments=s1:/*,mb:*,ex:*/,f://,b:#,:%,:XCOMM,n:>,fb:-

" allow you to have multiple files open and change between them without saving
set hidden

set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set wildmenu
set wildmode=list:longest
set wildchar=<TAB>
set ttyfast
set ruler
set laststatus=2
set pastetoggle=<F2>
set foldmethod=marker
set wildignore+=*.o,*~,*.pyc,.git,.git-heroku,.hg,.svn,.sass-cache,node_modules

if version >= 703
    set relativenumber
    set number
    set undofile
    set undodir=~/.vim/backups
else
    set number
endif


if has("gui_running")
    " invisible characters
    set list
    set listchars=tab:▸\ ,eol:¬
endif

" No swap files.
set noswapfile
set nobackup
set nowb

" Keep undo history across sessions, by storing in file.
" Only works in MacVim (gui) mode.

if has('gui_running')
  set undodir=~/.vim/backups
  set undofile
endif

" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

" }}}
" {{{ File types

" HTML and HTMLDjango
au BufNewFile,BufRead *.html setlocal filetype=htmldjango
au BufNewFile,BufRead *.html setlocal foldmethod=manual
au BufNewFile,BufRead *.html setlocal textwidth=0
au BufNewFile,BufRead urls.py setlocal nowrap

" Use <localleader>f to fold the current tag.
au FileType html,jinja,htmldjango nnoremap <buffer> <localleader>f Vatzf

" Use Shift-Return to turn this:
"     <tag>|</tag>
"
" into this:
"     <tag>
"         |
"     </tag>
au BufNewFile,BufRead *.html inoremap <buffer> <s-cr> <cr><esc>kA<cr>
au BufNewFile,BufRead *.html nnoremap <buffer> <s-cr> vit<esc>a<cr><esc>vito<esc>i<cr><esc>

" Django tags
au FileType jinja,htmldjango inoremap <buffer> <c-t> {%<space><space>%}<left><left><left>

" Django variables
au FileType jinja,htmldjango inoremap <buffer> <c-f> {{<space><space>}}<left><left><left>

" Spell checking for latex files
au FileType tex set spl=en_us spell

au BufNewFile,BufRead *.md set filetype=markdown

" }}}
" {{{ Tabs

" when at 3 spaces, and I hit > ... go to 4, not 5
set shiftround

function! Indent_tabs()
    setl softtabstop=4
    setl shiftwidth=4
    setl tabstop=4
    setl noexpandtab
endfunction

function! Indent_4_spaces()
    setl expandtab
    setl autoindent
    setl shiftwidth=4
    setl tabstop=4
    setl softtabstop=4
endfunction

function! Indent_2_spaces()
    setl expandtab
    setl autoindent
    setl shiftwidth=2
    setl tabstop=2
    setl softtabstop=2
endfunction

set expandtab autoindent shiftwidth=4 tabstop=4 softtabstop=4
au FileType coffee call Indent_2_spaces()
au FileType eruby call Indent_2_spaces()
au FileType html call Indent_2_spaces()
au FileType htmldjango call Indent_2_spaces()
au FileType handlebars call Indent_2_spaces()
au FileType javascript call Indent_2_spaces()
au FileType python call Indent_4_spaces()
au FileType ruby call Indent_2_spaces()
au FileType sass call Indent_2_spaces()
au FileType scss.css call Indent_2_spaces()

" }}}
" {{{ Searching

" don't use vim's crazy regex
nnoremap / /\v
vnoremap / /\v

" highlight search
set hlsearch
" case inferred by default
set infercase
" make searches case-insensitive
set ignorecase
"unless they contain upper-case letters:
set smartcase
" show the `best match so far' as search strings are typed:
set incsearch
" assume the /g flag on :s substitutions to replace all matches in a line:
set gdefault

" tab to match bracket pairs
nnoremap <tab> %
vnoremap <tab> %

" }}}
" {{{ Themes and colors

" set t_Co=256
"set background=light
"set background=dark
"colorscheme solarized
let g:solarized_termcolors=256
syntax on
set guioptions-=T
set guioptions-=m

let g:airline_powerline_fonts=1
let g:airline_solarized_bg='light'
" show buffers as a tabline
let g:airline#extensions#tabline#enabled=1
" only show the file name
let g:airline#extensions#tabline#fnamemod = ':t'

" Fix colours in sign column
highlight clear SignColumn

" }}}
" {{{ Line wrapping

" normally don't automatically format `text' as it is typed, IE only do this
" with comments, at 79 characters:
set formatoptions=qrn1
set textwidth=79

function! No_Line_Breaks()
    " http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
    set wrap
    set linebreak
    set nolist  " list disables linebreak
    set textwidth=0
    set wrapmargin=0
endfunction

au FileType markdown,tex,rst call No_Line_Breaks()


" }}}
" {{{ Key Mappings

let mapleader = ","
nnoremap <silent> <leader> :WhichKey '<leader>'<CR>

map <C-n> :NERDTreeToggle<CR>
" does not work on mobaxterm
map <C-m> :TagbarToggle<CR>

" ,<space> to get rid of search highlighting
nnoremap <leader><space> :noh<cr>

nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

" Professor VIM says '87% of users prefer jj over esc', jj abrams strongly disagrees
imap jj <Esc>

" Buffers replicating non vim tabs
" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <leader>T :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>

" Show all open buffers and their status
nmap <leader>bl :ls<CR>

" sudo save!
cmap w!! %!sudo tee > /dev/null %

nnoremap j gj
nnoremap k gk

" open a new split and switch to it
nnoremap <leader>w <C-w>v<C-w>l
" cmd-hjkl for moving around splits
nnoremap <D-h> <C-w>h
nnoremap <D-j> <C-w>j
nnoremap <D-k> <C-w>k
nnoremap <D-l> <C-w>l

" Change inside quotes with Cmd-" and Cmd-'
nnoremap <D-'> ci'
nnoremap <D-"> ci"

" Don't have to use Shift to get into command mode, just hit semicolon
nnoremap ; :

"Go to last edit location with ,.
nnoremap ,. '.

" }}}
