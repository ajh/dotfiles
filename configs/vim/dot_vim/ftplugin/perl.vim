"perltidy
set formatprg=perltidy\ -q
nmap <silent> <F12> :%!perltidy -q<CR>
vnoremap <silent> <F12> :!perltidy -q<CR>

set shiftwidth=2
set tabstop=2
set expandtab
