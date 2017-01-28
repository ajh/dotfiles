" Basic Settings -------------------- {{{

"Use comma instead of backslash for leader commands
let mapleader = ","
set expandtab
set hidden
set magic
set noerrorbells
set number
set ruler
set showcmd
set showmatch
set showmode

"setup folding for vim files
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" }}}

" Some Functions -------------------- {{{

"Remove whitespace from end of lines
function! Preserve(command)
  " Preparation - save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
map <leader>$ :call Preserve("%s/\\s\\+$//e")<CR>

" }}}

" Configure plugins -------------------- {{{
"
"Buffergator customizations
let g:buffergator_sort_regime="filepath"
let g:buffergator_suppress_keymaps=1
let g:buffergator_viewport_split_policy="B"
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#rust#racer_binary='$HOME/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path='$HOME/.rust/src'
let g:tmux_navigator_no_mappings = 1

"CtrlP customizations
let g:ctrlp_map = '<C-P><C-P>'

let g:airline_theme='luna'

call plug#begin('~/.local/share/nvim/plugged')

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ajh/vim-misc'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ddollar/nerdcommenter'
Plug 'easymotion/vim-easymotion'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'majutsushi/tagbar'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'sebastianmarkow/deoplete-rust'
Plug 'tomtom/tlib_vim'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'vim-syntastic/syntastic'

call plug#end()

" }}}

" Plugin customizations -------------------- {{{

"" buffergator is <M-F>
nnoremap ƒ :BuffergatorToggle<CR>
nnoremap <M-F> :BuffergatorToggle<CR>
"
"" ctrlp prefix is <C-P>
"" Note: <C-P><C-P> is set in vimrc.before
"call janus#add_mapping("ctrlp", "nnoremap", "<C-P><C-U>", ":CtrlPBuffer<CR>")
"" this is better for brazil workspaces
"let g:ctrlp_working_path_mode = '0'

"" gundo is <M-G>
"call janus#add_mapping("gundo", "nnoremap", "©", ":GundoToggle<CR>")
"call janus#add_mapping("gundo", "nnoremap", "<M-G>", ":GundoToggle<CR>")

"" nerdtree prefix is <M-R>
nnoremap ®® :NERDTreeToggle<CR>
nnoremap <M-R><M-R> :NERDTreeToggle<CR>
nnoremap ®ƒ :NERDTreeFind<CR>
nnoremap <M-R><M-F> :NERDTreeFind<CR>

"" tagbar is <M-A>
"call janus#add_mapping("tagbar", "nnoremap", "å", ":TagbarToggle<CR>")
"call janus#add_mapping("tagbar", "nnoremap", "<M-A>", ":TagbarToggle<CR>")
"let g:tagbar_sort=0 " sort methods by file order, not name
"
"" zoomwin is <C-W><C-M> to be beside the other window commands (See :help
"" CTRL-W)
"call janus#add_mapping("zoomwin", "nnoremap", "<C-W><C-M>", ":ZoomWin<CR>")

" If C-H doesn't work try:
"
"     infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
"     tic $TERM.ti
"
nnoremap <C-H> :TmuxNavigateLeft<cr>
nnoremap <C-J> :TmuxNavigateDown<cr>
nnoremap <C-K> :TmuxNavigateUp<cr>
nnoremap <C-L> :TmuxNavigateRight<cr>

" deoplete uses TAB (taken from deoplete help file)
inoremap <silent><expr> <TAB>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<TAB>" :
	\ deoplete#mappings#manual_complete()
	function! s:check_back_space() abort "{{{
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~ '\s'
	endfunction"}}}
" }}}

" Language settings -------------------- {{{

"setup markdown filetype using my naming convention
:autocmd BufNewFile,BufRead *.md.txt set filetype=markdown

"Configure Rails to not build tags for java
let g:rails_ctags_arguments='--languages=-javascript --languages=-java --exclude=vendor'

"golang plugins
if exists("$GOROOT")
  set runtimepath+=$GOROOT/misc/vim
endif

"rust tags
"setlocal tags=rusty-tags.vi;/,path-to-rust-source-code/rusty-tags.vi
"autocmd BufWrite *.rs :silent !rusty-tags vi

" }}}
