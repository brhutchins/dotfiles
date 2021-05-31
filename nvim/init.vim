
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2019 Dec 17
"
" To use it, copy it to
"	       for Unix:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"	 for MS-Windows:  $VIM\_vimrc
"	      for Haiku:  ~/config/settings/vim/vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings, bail
" out.
if v:progname =~? "evim"
  finish
endif

" Get the defaults that most users want.
" source $VIMRUNTIME/defaults.vim

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  if has('persistent_undo')
    set undofile	" keep an undo file (undo changes after closing)
  endif
endif

if &t_Co > 2 || has("gui_running")
  " Switch on highlighting the last used search pattern.
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" Activate line numbers
:set number

" Indentation
:set tabstop=4
:set shiftwidth=4
:set expandtab

"
" vim-plug
"
call plug#begin()

" lightline
Plug 'itchyny/lightline.vim'

" coc
Plug 'neoclide/coc.nvim', {'branch': 'release'} 

" commentary
Plug 'tpope/vim-commentary'

" vim-lion
Plug 'tommcdo/vim-lion'

" elm.vim
Plug 'andys8/vim-elm-syntax'

" goyo
" Plug 'junegunn/goyo.vim'

" limelight
" Plug 'junegunn/limelight.vim'

" vim-indent-guides
Plug 'nathanaelkane/vim-indent-guides'

" THEMES
"" ayu-theme
Plug 'ayu-theme/ayu-vim'

"" ocenaic-next
Plug 'mhartington/oceanic-next'

" Initialise plugin system
call plug#end()

" lightline config
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

"
" limelight config
"
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

" Color name (:help gui-colors) or RGB color
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'

" Default: 0.5
let g:limelight_default_coefficient = 0.8

" Number of preceding/following paragraphs to include (default: 0)
let g:limelight_paragraph_span = 1

" Beginning/end of paragraph
"   When there's no empty line between the paragraphs
"   and each paragraph starts with indentation
let g:limelight_bop = '^\s'
let g:limelight_eop = '\ze\n^\s'

" Highlighting priority (default: 10)
"   Set it to -1 not to overrule hlsearch
let g:limelight_priority = -1

" Indentation guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#171d22  ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#25272a  ctermbg=4

" Whitespace
set list
set listchars=
set listchars+=tab:░\ 
set listchars+=trail:·
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:⣿

"
"" Theme
"
set termguicolors
let ayucolor="dark"

colorscheme ayu
