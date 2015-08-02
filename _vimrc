" use pathogen to autoload plugins in bundle
"

" Required Vundle setup
let &shellslash=0
filetype off
if has("win32") || has("win16")
    set rtp+=~/vimfiles/bundle/Vundle.vim
    let path='~/vimfiles/bundle'
    call vundle#begin(path)
else
    set rtp+=~/.vim/bundle/Vundle.vim/
    call vundle#begin()
endif

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/syntastic'
"Plugin 'MarcWeber/vim-addon-mw-utils' " required for vim-snipmate
"Plugin 'tomtom/tlib_vim'              " required for vim-snipmate
"Plugin 'garbas/vim-snipmate'          " vim-snipmate gives an error TriggerUpdate() not found 
"Plugin 'msanders/snipmate.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-git'
"Plugin 'ervandew/supertab'           
"Plugin 'sjl/gundo' " causes vundle to stall
Plugin 'fs111/pydoc.vim'
Plugin 'alfredodeza/pytest.vim'
Plugin 'vim-scripts/TaskList.vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'derekwyatt/vim-scala'
Plugin 'nvie/vim-flake8'
Plugin 'flazz/vim-colorschemes'
Plugin 'kevinw/pyflakes-vim'

call vundle#end()         "vundle required
filetype plugin indent on "vundle required

"Bundle 'vim-scripts/pep8'


" Syntastic plugin settings
let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" eclim plugin settings
let g:EclimDisabled=1

" indent plugin settings
let g:indent_guides_start_level=2
let g:indent_guides_guide_size=1

map j gj
map k gk

" Gundo
map <leader>g :GundoToggle<CR>

" Pep8
let g:pep8_map='<leader>8'

" use SuperTab plugin for context aware autocomplete
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

" tell vim to recognize .r extension as an GNU R file, not rexx or rebol
au BufNewFile,Bufread *.r,*.R setf r

" wall when vim loses focus
" autocmd BufLeave,FocusLost * silent! wall
" autocmd BufLeave,FocusLost * wall

set nocompatible 
filetype plugin indent on

" for tasklist.vim
" show TODOs
map <leader>td <Plug>TaskList

" auto pair creation, decided not to use
" inoremap {      {}<Left>
" inoremap {<CR>  {<CR>}<Esc>O
" inoremap {{     {
" inoremap {}     {}
" inoremap [      []<Left>
" inoremap [<CR>  [<CR>]<Esc>O
" inoremap [[     [
" inoremap []     []
" inoremap (      ()<Left>
" inoremap (<CR>  (<CR>)<Esc>O
" inoremap ((     (
" inoremap ()     ()
" inoremap '      ''<Left>
" inoremap ''     '
" inoremap "      ""<Left>
" inoremap ""     "
"
"

" disable beeping and window flashing
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>
" find all non-ascii charaters
noremap <F11> /[^\x00-\x7F]<CR>
inoremap <F11> <C-o>/[^\x00-\x7F]<CR>
" set nowrap


" aesthetics
if has('gui_win32')
    colorscheme codeschool
else
    colorscheme wombat
endif

let $snip = 'C:\Users\matthew.plourde\vimfiles\snippets'


" highlight trailing argument commas in red
"match Error /,\_s*[)}]/ 

" show tabs as arrows, and nonbreaking and trailing whitespace as dots
set list
set listchars=tab:->,trail:·,nbsp:·

" for vb syntax
autocmd BufNewFile,BufRead *.vb set ft=vbnet

" toogle relative line numbers
function! g:ToggleNuMode()
  if(&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc
map <C-l> :call g:ToggleNuMode()<CR>

"let &winheight = 3 " set minimum num lines for current window. set to 999 for 'rolodex mode'
set noea " don't equalize window height after splitting

nnoremap + <c-w>+
nnoremap - <c-w>-
nnoremap <A-n> <c-w><
nnoremap <A-m> <c-w>>
nnoremap <A-j> <c-w>j
nnoremap <A-k> <c-w>k
nnoremap <A-h> <c-w>h
nnoremap <A-l> <c-w>l

" make <C-p> and <C-n> work like <Up> and <Down> in command-line mode
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" autoload matchit plugin.
" matchit ships with vim. when enabled, % will jump to corresponding keywords 
" such as opening and closing xml tags.
runtime macros/matchit.vim

" center window on next/prev search result
noremap <Leader>n nzz
noremap <Leader>N Nzz
"
" tab navigation like firefox
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>

let $WS = "D:\\Data\\MatthewPlourde\\"
let $VSS = "C:\\Users\\matthew.plourde\\vimsessions\\"

" type double quote in insert mode with Alt+quote
imap <A-'> <ESC>2i'<ESC>i
imap <A-"> <ESC>2i"<ESV>i

imap <A-(> ()<ESC>i
imap <A-{> {}<ESC>i
imap <A-[> []<ESC>i

"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l
" status line 
set laststatus=2
set statusline=
set statusline=\%t       "tail of the filename
set statusline+=\ %{fugitive#statusline()}
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=\ %y      "filetype
set statusline+=\ %m      "modified flag
set statusline+=\ %r      "read only flag
set statusline+=\ %h      "help file flag
set statusline+=%=      "left/right separator
set statusline+=b%n\ -\  " buffer number
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file

" syntastic status line
set statusline+=\ %#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"function! AirlineInit()
"    let g:airline_section_a = airline#section#create(['mode', ' ', 'branch'])
"    let g:airline_section_b = airline#section#create_left(['ffenc', 'hunks', '%f'])
"    let g:airline_section_c = airline#section#create(['filetype'])
"    let g:airline_section_d = airline#section#create(['%m', '%r', '%h'])
"    let g:airline_section_y = airline#section#create(['%l/%L', '%c'])
"    let g:airline_section_z = airline#section#create_right(['%P'])
"endfunction
"autocmd VimEnter * call AirlineInit()

" scala tab settings
autocmd FileType scala setlocal tabstop=2
autocmd FileType scala setlocal shiftwidth=2
autocmd FileType scala setlocal softtabstop=2


set ruler
let $TMP="c:/temp"
set backupdir=~/tmp
set directory=~/tmp
set hlsearch  "highlight search results. nohl to turn off
set number  "turn on line numbers
set tabstop=4  "sets tab width
set shiftwidth=4  "sets tab for block indent
set expandtab  "tabs as spaces
set softtabstop=4  "multi-spaces = tab, only <BS> needed to delete
set autoindent  "auto indent, language specific
set spelllang=en_us  "set dictionary
set spellsuggest=best,10 "show 10 best matches with z= (alt: spellsuggest=fast,20)
set showmatch  "show matching brackets when cursor is over one
set autochdir  "set cwd to that of file in buffer.
set guioptions-=T  "remove toolbar in gui
set guioptions-=m  "Remove menubar 
" use :set go+=m to show the menu
set guioptions-=l "remove left scrollbar
set guioptions-=r "remove right scroll bar
set guioptions-=b "remove bottom scroll bar
set hidden  "allows for unsaved, non-active buffers
set history=1000  "increase history
set undolevels=100
set mouse=a  "full mouse support in the console
set backspace=2  "allow backspacing over lines
set cino=(0<Enter>  "align function parameters on multi-lines
"set cmdheight=2  "allow room for errors to display
set textwidth=120  "always limit the width of text to 80
set backup  "keep a backup file
set backupext=.bak
set nrformats= "treat all numbers as decimal when using <C-a>. default is to treat 007 as octal.
set wildmode=longest,list "instead of autocompleting to the first match in ex mode, autocomplete to longest, display list


" set pep8 textwidth for python
autocmd bufreadpre *.py setlocal textwidth=120

" omni completion
set ofu=syntaxcomplete#Complete "Turn on omni completion
"" auto close omni complete preview window upon making a selection
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" folding settings
"set foldmethod=indent ""fold based on indent
set foldmethod=manual
set foldnestmax=10
set nofoldenable ""don't automatically fold
set foldlevel=1
" save folds
" autocmd BufWinLeave *.* mkview
" autocmd BufWinEnter *.* silent loadview

" map omni completion to Ctrl+Space
imap <c-space> <c-x><c-o> 


if has("gui_gtk2")
    set guifont=Consolas\ 11
elseif has("gui_macvim")
    set guifont=Consolas:h12
elseif has("gui_win32")
    set guifont=Consolas:h11
end
if has("gui_running")
    set mousehide
endif

""For Vim-R
syntax enable
syntax on
syntax sync fromstart
syntax region msSpeech start=/"/ end=/"\|\n\n/
highlight msSpeech guifg=#FFFFFF
filetype plugin on
filetype indent on

""Toggle line numbers and fold column for easy copying:
noremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
filetype plugin indent on " turn on ftplugins


" PYTHON
"" set indent
"autocmd Filetype python set complete+=k~/.vim/sythax/python.vim isk+=.,(
"""set path to pydiction autocomplete dictionary
"let g:pydiction_location = '/home/matthew/.vim/ftplugin/pydiction/complete-dict' 
"" auto indent python keywords
"autocmd BufRead *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
"""Trims trailing whitespace at the end of a line
"autocmd BufWritePre *.py normal m`:%s/\s\+$//e ``


"" Plugins included
"" pydoc
"" bufexplorer
"" VIM-R

" latex-suite settings ----------------------------------------
" IMPORTANT: win32 users will need to have 'shellslash' set so that latex
" can be called correctly.
set shellslash

" IMPORTANT: grep will sometimes skip displaying the file name if you
" search in a singe file. This will confuse Latex-Suite. Set your grep
" program to always generate a file-name.
set grepprg=grep\ -nH\ $*

" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

map <MiddleMouse> <LeftMouse>
imap <MiddleMouse> <LeftMouse>
map <2-MiddleMouse> <LeftMouse>
imap <2-MiddleMouse> <LeftMouse>
map <3-MiddleMouse> <LeftMouse>
imap <3-MiddleMouse> <LeftMouse>
"---------------------------------------------------------------

imap <F3> <Esc>:w<CR>
map <F3> <Esc>:w<CR>
imap <A-Space> <Esc>:w<CR>
map <A-Space> <Esc>:w<CR>
"set laststatus=1 " only show the previous status

" Lines added by the Vim-R-plugin command :RpluginConfig (2014-Jan-03 16:05):
" Change the <LocalLeader> key:
let maplocalleader = ","
" Press the space bar to send lines (in Normal mode) and selections to R:
vmap <Space> <Plug>RDSendSelection
nmap <Space> <Plug>RDSendLine
