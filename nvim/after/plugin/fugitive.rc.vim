" Status line
if !exists('*fugitive#statusline')
  set statusline=%F\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}[L%l/%L,C%03v]
  set statusline+=%=
  set statusline+=%{fugitive#statusline()}
endif

cnoreabbrev g Git
cnoreabbrev gopen GBrowse

nmap <leader>gj :diffget //3<cr>
nmap <leader>gf :diffget //2<cr>
nmap <leader>gs :G<cr>
nmap <leader>gb :Git blame<cr>
