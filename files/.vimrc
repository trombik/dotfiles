set nocompatible
if isdirectory($HOME . '/.vim/bundle/Vundle.vim')
    " if Vunldle has been installed, use it.
    " requires git, curl.
    "
    " see :h vundle after running `:PluginInstall`
    filetype off
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'

    Plugin 'kopischke/vim-fetch'

    Plugin 'vim-airline/vim-airline'
    let g:airline#extensions#tabline#enabled = 1

    Plugin 'tpope/vim-fugitive'
    call vundle#end()
    filetype plugin indent on
    " or
    " filetype plugin on
else
    " no fancy plug-ins are available, fall back to minimal status line
    set statusline=%F%m%r%h%w\ FORMAT=%{&ff}\ ft=%y\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
endif
set backspace=indent,eol,start
set history=5000
set ruler
set showcmd
set incsearch
set autoindent
set encoding=utf8
set fileencodings=ucs-bom,utf-8,latin1
set number
set shell=/bin/sh
set tabstop=4
set shiftwidth=4
set expandtab
set foldmethod=marker
set showtabline=2
set formatoptions=tcroqlmM
set laststatus=2
set cursorline
set hlsearch
set autoindent
set textwidth=78
set scrolloff=4
set ttyfast
set wildmenu

" don't use Ex mode, use Q for formatting
map Q gq
" map Ctrl+A in command mode to `move the cursor to the beginning of the line
cnoremap <C-A> <Home>
augroup myfiletypes
    autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif
    " autoindent with two spaces, always expand tabs
    autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et
    autocmd FileType text setlocal textwidth=78
    autocmd BufNewFile,BufRead *.md set spell
augroup END

" execute a command and show it's output in a split window
" example:
" :Shell dmesg
command! -nargs=* -complete=shellcmd Shell execute "new | r! <args>"

colorscheme darkblue
highlight Normal ctermbg=None
highlight CursorLine cterm=None ctermbg=235
highlight CursorLineNr ctermfg=11 ctermbg=235
highlight LineNr ctermfg=49
highlight Comment ctermfg=196
highlight SpellBad      ctermfg=Red         term=Reverse        guisp=Red       ctermbg=White
highlight SpellCap      ctermfg=Green       term=Reverse        guisp=Green     ctermbg=White
highlight SpellLocal    ctermfg=Cyan        term=Underline      guisp=Cyan      ctermbg=White
highlight SpellRare     ctermfg=Magenta     term=underline      guisp=Magenta   ctermbg=White
highlight ExtraWhitespace ctermbg=red
highlight DiffAdd         ctermbg=235  ctermfg=108  cterm=reverse
highlight DiffChange      ctermbg=235  ctermfg=103  cterm=reverse
highlight DiffDelete      ctermbg=235  ctermfg=131  cterm=reverse
highlight DiffText        ctermbg=235  ctermfg=208  cterm=reverse
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
