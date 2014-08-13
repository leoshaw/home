execute pathogen#infect()

syntax on
set background=dark
let g:solarized_termcolors=256
colorscheme solarized
filetype plugin indent on

set runtimepath^=~/.vim/bundle/ctrlp.vim
set ruler

map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

let g:rspec_command = "!bin/rspec {spec}"

" Run currently open cucumber feature file
map <Leader>cf :w<cr>:!cucumber %<cr>
" Run current cucumber scenario
map <Leader>cl :w<cr>:exe "!bin/cucumber %" . ":" . line(".") . " --require features"<cr>
" Run all cucumber feature files
map <Leader>ct :w<cr>:!cucumber<cr>

" The Silver Searcher
if executable('ag')
	" Use ag over grep
	set grepprg=ag\ --nogroup\ --nocolor

	" Use ag in CtrlP for listing files. Lightning fast and respects
	" .gitignore
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

	" ag is fast enough that CtrlP doesn't need to cache
	let g:ctrlp_use_caching = 0
endif

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
