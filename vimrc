" ============================================================================
" Startup {{{
" ============================================================================

augroup startup
  autocmd!

  " If we launched vim without specifying a target, we want to open the pwd
  autocmd VimEnter * if empty(argv()) | silent! edit . | endif
augroup END

" }}}

" ============================================================================
" PLUGINS {{{
" ============================================================================

" Using vim-plug
" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" ==========
" Completion
" ==========

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'mitsuse/autocomplete-swift'

" ======
" Search
" ======

Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

" ==========
" Git/GitHub
" ==========

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'christoomey/vim-conflicted'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'

" ====
" Tmux
" ====

Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'

" ====================
" Languages/Frameworks
" ====================

Plug 'raichoo/haskell-vim'
Plug 'pbrisbin/vim-syntax-shakespeare'
Plug 'elixir-lang/vim-elixir'
Plug 'c-brenn/phoenix.vim'
Plug 'cespare/vim-toml'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'lambdatoast/elm.vim'
Plug 'keith/swift.vim'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-markdown'
Plug 'ericpruitt/tmux.vim', {'rtp': 'vim/'}

" ==========
" Appearance
" ==========

Plug 'itchyny/lightline.vim'
Plug 'flazz/vim-colorschemes'

" =======
" Writing
" =======

Plug 'nicholaides/words-to-avoid.vim'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" ====
" Misc
" ====

" Asynchronous file linting/formatting
Plug 'w0rp/ale'
" Language agnostic testing support
Plug 'janko-m/vim-test'
" Work with Xcode projects from inside Vim
Plug 'gfontenot/vim-xcode'
" Easily comment code
Plug 'tpope/vim-commentary'
" Allow . to make plugin actions repeat
Plug 'tpope/vim-repeat'
" Surround text objects with characters
Plug 'tpope/vim-surround'
" Project specific configurations
Plug 'tpope/vim-projectionist'
" Automatically create non-existent directories
Plug 'pbrisbin/vim-mkdir'
" Rename files in place
Plug 'pbrisbin/vim-rename-file'
" Easily copy to the system clipboard
Plug 'christoomey/vim-system-copy'
" Perform sort operations on text objects
Plug 'christoomey/vim-sort-motion'
" Automatically add closing statements for a number of languages
Plug 'cohama/lexima.vim'
" Remember last position in files
Plug 'dietsche/vim-lastplace'
" Quickly add attachments to emails
" Also checks for emails that _should_ have attachments but don't.
Plug 'chrisbra/CheckAttach'

call plug#end()
" }}}

" ============================================================================
" Appearance {{{
" ============================================================================

colorscheme lucius                " Use Lucius for our color scheme
LuciusDark                        " Use the dark version of Lucius

set colorcolumn=80                " Highlight the 80 character column
set relativenumber                " Use relative line numbers
set number                        " Also show the current line number
set cursorline                    " Highlight the current line

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" status bar
let g:lightline = { 'colorscheme': 'wombat' }

let g:lightline.active = {
      \   'right': [
      \      ['fugitive'],
      \      ['filetype'],
      \   ]
\}

let g:lightline.component_function = {
      \  'fugitive': 'LightLineFugitive'
\}

let g:lightline.inactive = { 'right': [ ] }

function! LightLineFugitive()
  return exists('*fugitive#head') ? fugitive#head() : ''
endfunction

" }}}

" ============================================================================
" Splits {{{
" ============================================================================

" Open splits to the bottom right
set splitbelow
set splitright

" }}}

" ============================================================================
" Functions {{{
" ============================================================================

" Reload our vim config
command! Reload execute "source $MYVIMRC"

" Source a file if readable
function! g:Source(file)
  if filereadable(expand(a:file))
    execute 'source' a:file
  endif
endfunction

" Toggle markdown checkboxes
function! ToggleCheckbox()
  let current_line = getline('.')
  let cursor_pos = getpos('.')
  if match(current_line, '\V[ ]') >= 0
    exe 's/\V[ ]/[x]/'
  elseif match(current_line, '\V[x]') >= 0
    exe 's/\V[x]/[ ]/'
  endif
  call setpos('.', cursor_pos)
endfunction

" Remove the file for the current buffer
command! -complete=file -nargs=?
      \ Remove
      \ call <sid>remove(<f-args>)

function! s:remove(...)
  if empty(a:000)
    let filename = @%
  else
    let filename = join(a:000)
  endif

  call delete(filename) | bdelete!
endfunction

" Trim trailing whitespace from files
command! TrimWhitespace call s:trim_whitespace()

function! s:trim_whitespace()
  let l:pos = getpos(".")
  %s/\s\+$//g
  call setpos(".", l:pos)
endfunction
" }}}

" ============================================================================
" Keybindings {{{
" ============================================================================

let mapleader = " "

" Map <leader><leader> to switch to previous file
nnoremap <leader><leader> <c-^>

" Set <leader>c to clear search highlighting
nnoremap <leader>c :noh<cr>

" Map <leader>v to open the current file in a vertical split and jump the
" original split back to the previous buffer
nnoremap <leader>v <C-^>:vsp #<Cr>

" Map <leader>x to open the current file in a horizontal split and jump the
" original split back to the previous buffer
nnoremap <leader>x <C-^>:sp #<Cr>

nnoremap <leader>. :call ToggleCheckbox()<Cr>

" }}}

" ============================================================================
" Spellcheck {{{
" ============================================================================

set spellfile=~/.vim/spell/en.utf-8.add

augroup spellcheck
  autocmd!

  " recreate the spelling dictionary at startup
  autocmd VimEnter * execute "silent mkspell! " . &spellfile
augroup END

" }}}

" ============================================================================
" Undo {{{
" ============================================================================

set undofile
set undodir=~/.vim/undo
set undolevels=1000
set undoreload=10000

" }}}

" ============================================================================
" Search/Replace {{{
" ============================================================================

" default to global substitutions on lines
set gdefault
" Case-insensitive searching.
set ignorecase
" But case-sensitive if expression contains a capital letter.
set smartcase
" Highlight matches.
set hlsearch
" Show all matches
set showmatch

" Clear search highlight when opening a file
autocmd BufReadCmd set nohlsearch

" Use Ag over Grep
set grepprg=ag\ --nogroup\ --nocolor

" Map Ag directly to \ for speeeed
nnoremap \ :Ag<SPACE>

" bind K to grep word under cursor
nnoremap K :Ag <C-R><C-W><CR>

" Move the search term to the middle of the screen if the screen has changed
" position.
" Stolen from @keith:
" https://github.com/keith/dotfiles/commit/20f98a645dd9ebcd24fa96d3aac0e9fe34a21a6a
" https://github.com/keith/dotfiles/commit/38822fd4353909177ea8e49649156531736596e4
function! s:NextAndCenter(cmd)
  let view = winsaveview()

  try
    execute "normal! " . a:cmd
  catch /^Vim\%((\a\+)\)\=:E486/
    " Fake a 'rethrow' of an exception without causing a 3 line error message
    echohl ErrorMsg
    echo "E486: Pattern not found: " . @/
    echohl None
  endtry

  if view.topline != winsaveview().topline
    normal! zzzv
  endif
endfunction

nnoremap <silent> n :call <SID>NextAndCenter('n')<CR>
nnoremap <silent> N :call <SID>NextAndCenter('N')<CR>

" }}}

" ============================================================================
" Completion {{{
" ============================================================================

set wildmenu
set wildmode=list:longest,list:full
set completeopt=menu,menuone,longest,preview

" Enable deoplete automatically
let g:deoplete#enable_at_startup = 1
let g:deoplete#file#enable_buffer_path = 1

inoremap <silent><expr><tab> pumvisible() ? "\<C-n>" : "\<tab>"

" neosnippets config
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" }}}

" ============================================================================
" Testing {{{
" ============================================================================

" Use VimTmuxRunner for our testing strategy
let test#strategy = 'vtr'

" Add keybindings for test actions
nmap <silent> <leader>tt :TestNearest<CR>
nmap <silent> <leader>tT :TestFile<CR>
nmap <silent> <leader>ta :TestSuite<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tg :TestVisit<CR>

" }}}

" ============================================================================
" Writing {{{
" ============================================================================

let g:markdown_fenced_languages =
      \ [ 'swift'
      \ , 'ruby'
      \ , 'sh'
      \ , 'yaml'
      \ , 'objc'
      \ , 'haskell'
      \ ]

let g:limelight_conceal_ctermfg = 'gray'

function! s:goyo_enter()
  if exists('$TMUX')
    " Turn off tmux statusline
    silent !tmux set status off

    " Zoom current pane to fullscreen
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif

  set scrolloff=999
  Limelight
endfunction

function! s:goyo_leave()
  if exists('$TMUX')
    " Turn on tmux statusline
    silent !tmux set status on

    " Unzoom current pane if currently zoomed
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif

  set scrolloff=0
  Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" }}}

" ============================================================================
" Ale {{{
" ============================================================================

let g:ale_linters = {
      \ 'haskell': ['hlint', 'stack-build']
      \ }

augroup AleConfig
  autocmd!
  set updatetime=1000
  let g:ale_lint_on_text_changed = 0
  autocmd CursorHold * call ale#Lint()
  autocmd CursorHoldI * call ale#Lint()
  autocmd InsertEnter * call ale#Lint()
  autocmd InsertLeave * call ale#Lint()
augroup END

nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['swift'] = ['swiftformat']
let g:ale_fix_on_save = 1
let g:ale_echo_msg_format = '[%linter%]: %s'

" }}}

" ============================================================================
" FZF {{{
" ============================================================================

" Mimic ctrl-p because muscle memory
nmap <C-p> :Files<CR>

" Don't take up too much space (40% is the default)
let g:fzf_layout = { 'down': '~20%' }


" Override `:Ag` to include preview support. The preview window is hidden by
" default, but can be shown by hitting `?` while viewing the results.
"
" Adding a `!` suffix to this command presents a fullscreen version of the
" preview window instead.
command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

" }}}

" ============================================================================
" Tmux {{{
" ============================================================================

let g:VtrGitCdUpOnOpen = 1

nnoremap <leader>kr :VtrKillRunner<cr>
nnoremap <leader>ar :VtrAttachToPane<cr>
nnoremap <leader>fr :VtrFocusRunner<cr>
nnoremap <leader>rr :VtrSendCommandToRunner! !!<cr>

nnoremap <leader>r :VtrSendCommandToRunner!

" }}}

" ============================================================================
" Git/GitHub {{{
" ============================================================================

let g:gist_post_private = 1
set stl+=%{ConflictedVersion()}

" }}}

" ============================================================================
" Ctags {{{
" ============================================================================

command! Ctags call s:generate_ctags()

function! s:generate_ctags()
  call system("git ls-files | ctags -L -")
endfunction

" }}}

" ============================================================================
" Xcode {{{
" ============================================================================

let g:xcode_runner_command = 'VtrSendCommandToRunner! {cmd}'
let g:xcode_xcpretty_testing_flags = '--test'

nnoremap <leader>b :Xbuild<CR>
nnoremap <leader>u :Xtest<CR>

" }}}

" ============================================================================
" Javascript {{{
" ============================================================================

let g:jsx_ext_required = 0

" }}}

" ============================================================================
" Misc {{{
" ============================================================================

" Automatically resize splits when the parent window size changes
autocmd VimResized * wincmd =

set nobackup                      " Don't make a backup before overwriting a file.
set nowritebackup                 " And again.
set noswapfile                    " Don't use swapfiles
set hidden                        " Don't kill unwritten buffers when hidden

set tabstop=2                     " Global tab width.
set shiftwidth=2                  " And again, related.
set expandtab                     " Use spaces instead of tabs
set wrap                          " Turn on line wrapping.
set nojoinspaces                  " Don't add two spaces after punctuation
                                  " when joining lines
" }}}

" Finally, source local vimrc files, but only if we're in a safe repo
call Source('./.git/safe/../../.vimrc')
