function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction

" Status line
if !exists('*fugitive#statusline')
  set statusline=%F\ %m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}[L%l/%L,C%03v]
  set statusline+=%=
  set statusline+=%{fugitive#statusline()}
  set statusline+=%{GitStatus()}
endif

cnoreabbrev git Git
cnoreabbrev gopen GBrowse

nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>
nmap <leader>gs :G<CR>
nmap <leader>gb :Git blame<CR>
nnoremap <leader>gd :GitGutterDiffOrig<CR>
nnoremap <leader>gp :G push<CR>
