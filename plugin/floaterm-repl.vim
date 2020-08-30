" vim:sw=2:
" ============================================================================
" FileName: plugin/floaterm-repl.vim
" GitHub: https://github.com/windwp
" ============================================================================
"
let g:floaterm_repl_runner = get(g:, 'floaterm_repl_runner','')
let g:floaterm_repl_keymap = get(g:, 'floaterm_repl_keymap', '')

command! -nargs=0 -range FloatermRepl   call floaterm_repl#run()

if !empty(g:floaterm_repl_keymap)
  exe printf('nnoremap <silent> %s :FloatermRepl<CR>', g:floaterm_repl_keymap)
  exe printf('vnoremap <silent> %s :FloatermRepl<CR>', g:floaterm_repl_keymap)
endif
