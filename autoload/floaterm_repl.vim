let s:scriptdir = expand('<sfile>:p:h')

function! floaterm_repl#run() range
    let l:filetype= &filetype
    let l:filerunner=s:scriptdir.'/terminal_preview.sh'
    let l:args=''
    let l:filepath=''
    if !empty(g:floaterm_repl_runner)
      let l:filerunner=g:floaterm_repl_runner
    endif

    if l:filetype == 'markdown'
        let startLine=search('```.','bn')
        let endLine =search('```$','n')
        if startLine!=0 && endLine !=0 && endLine>startLine
            let lines = getline(startLine+1, endLine-1)
            if len(lines) == 0
                return ''
            endif
            let query=join(lines,"\n")
            let mdHeader=trim(substitute(getline(startLine),'```','','g'))
            let splitHeadder=split(mdHeader,' ')
            if len(splitHeadder) >0
                let l:filetype=splitHeadder[0]
            end

            let l:args=join(splitHeadder[1:-1])
            let l:filepath='/tmp/vim_floaterm.'.l:filetype
            let w= system("echo " .shellescape(query)." > " .l:filepath )
        endif 
    else
        let l:filepath='/tmp/vim_floaterm.'.l:filetype
        silent execute "\'<,\'>w! " . l:filepath
    endif 

    silent execute ':FloatermKill! repl'

    if len(l:filetype)>0 && !empty(l:filepath)
        let l:command=':FloatermNew --name=repl --position=bottom --autoclose=0 --height=0.4 --width=0.9 '
        let l:command= l:command. printf(" %s %s %s %s",l:filerunner,l:filetype,l:filepath,l:args)
        silent execute l:command
        stopinsert
    endif


endfunction


function! s:setupfloaterm_popup() abort
    nmap<buffer> q :q<CR>
    nmap<buffer> <ESC> :q<CR>
endfunction

augroup floatermrepl
  " Remove all vimrc autocommands
    autocmd!
    autocmd FileType floaterm call <SID>setupfloaterm_popup()
augroup END


