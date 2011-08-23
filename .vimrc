:syn on
:set ai
:set bs=2
:set bg=light
:set ruler
:set wrap
:set encoding=utf-8
:set foldmethod=marker
:set t_Co=256
:set expandtab
":colorscheme eclipse
":colorscheme lucius
":colorscheme sienna
":colorscheme silent
:colorscheme print_bw
:set formatoptions=1
:set lbr
:set nocompatible
:set modeline
:set guioptions-=T
:set errorformat=
":filetype plugin indent on
:set hid
":nnoremap j gj
":nnoremap k gk
":vnoremap j gj
":vnoremap k gk
":set number
":colorscheme delek
:set guifont=Lucida\ Sans\ Typewriter\ 10
:map <F2> <Esc>:read !date "+\%d\%b\%y \%H\%M>"<Esc>$a 
:imap <F2> <Esc><F2>
:map <F3> <Esc>:read !ke<Esc>$a 
:imap <F3> <Esc><F3>

"genius
:inoremap jj <Esc>
":imap <S-Space> <Esc>

:map gl <Esc>wb"ayw:e <C-R>a<CR>
:map gL <Esc>T["ayt]:e "<C-R>a"<CR>
:map gb <Esc>:bprev<CR>
:map ggg <Esc>g<C-G>
:map <C-C> <Esc>
":unmap <Esc>
:map <F9> <Esc>:!pdflatex %<CR>
:map <F10> <Esc>:!ghci %<CR>
:map <F12> <Esc>:ls<CR>
:nnoremap <C-F1> :set go-=mT
:nnoremap <C-F2> :set go+=mT
:nnoremap <C-N> <Esc>:
"c becomes (virtual line) up
:nnoremap c gk
"t becomes (virtual line) down
:nnoremap t gj
"k becomes change
:nnoremap k c
"n becomes right
:nnoremap n l
"l becomes 'tiLL
:nnoremap l t
"what's left: j becomes next
:nnoremap j n
:set ts=4
:set shiftwidth=4

:set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
:set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

:map <A-1> 1gt
:map <A-2> 2gt
:map <A-3> 3gt
:map <A-4> 4gt
:map <A-5> 5gt
:map <A-6> 6gt
:map <A-7> 7gt
:map <A-8> 8gt
:map <A-9> 9gt
:map <A-0> 10gt
:map <A-right> :bnext<CR>
:map <A-left> :bprevious<CR>
:map <A-down> :tabnext<CR>
:map <A-up> :tabprevious<CR>

:map <up>    :wincmd k<CR>
:map <down>  :wincmd j<CR>
:map <left>  :wincmd h<CR>
:map <right> :wincmd l<CR>

augroup mkd
autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
augroup END
