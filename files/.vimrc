

set nocompatible
set backspace=indent,eol,start
set history=5000		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif


" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")


" hi Pmenu
" my config
set encoding=utf8
set fileencodings=iso-2022-jp,utf-8,cp932
set number
set shell=/bin/sh
let spell_auto_type=""
set tabstop=4
set shiftwidth=4
set expandtab

autocmd BufNewFile,BufRead *.tt setf tt2
autocmd BufNewFile,BufRead *.tt2 setf tt2
autocmd BufNewFile,BufRead *.pp set softtabstop=4 shiftwidth=4 expandtab
au BufNewFile,BufRead */*cookbooks/*  call s:SetupChef()

function! s:SetupChef()
    " Mouse:
    " Left mouse click to GO!
    nnoremap <buffer> <silent> <2-LeftMouse> :<C-u>ChefFindAny<CR>
    " Right mouse click to Back!
    nnoremap <buffer> <silent> <RightMouse> <C-o>

    " Keyboard:
    nnoremap <buffer> <silent> <M-a> :<C-u>ChefFindAny<CR>
    nnoremap <buffer> <silent> <M-f> :<C-u>ChefFindAnySplit<CR>
endfunction

set foldmethod=marker
let g:netrw_ftp =1
set showtabline=2
let html_use_css = 1
let use_xhtml = 1
set formatoptions=tcroqlmM
set statusline=%F%m%r%h%w\ FORMAT=%{&ff}\ ft=%y\ [POS=%04l,%04v][%p%%]\ [LEN=%L] 
set laststatus=2 
set cursorline
"set foldcolumn=4
let g:Perl_PerlcriticSeverity = 3

let twitvim_login_b64="dHJvbWJpazpzYWt1cmEx"
let twitvim_count = 100

colorscheme darkblue
highlight Normal ctermbg=None
highlight CursorLine cterm=None ctermbg=235 guibg=236
highlight CursorLineNr ctermfg=11 ctermbg=235
highlight LineNr ctermfg=49
highlight Comment ctermfg=196

runtime ftplugin/man.vim

augroup myfiletypes
    " Clear old autocmds in group
    autocmd!
    " autoindent with two spaces, always expand tabs
    autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et
augroup END

if (v:version >= 700)
highlight SpellBad      ctermfg=Red         term=Reverse        guisp=Red       gui=undercurl   ctermbg=White
highlight SpellCap      ctermfg=Green       term=Reverse        guisp=Green     gui=undercurl   ctermbg=White
highlight SpellLocal    ctermfg=Cyan        term=Underline      guisp=Cyan      gui=undercurl   ctermbg=White
highlight SpellRare     ctermfg=Magenta     term=underline      guisp=Magenta   gui=undercurl   ctermbg=White
endif " version 7+
