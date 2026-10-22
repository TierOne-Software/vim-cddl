" Test harness for vim-cddl. Run with:
"   nvim --headless --clean -c "set rtp+=$PWD" -c "filetype off" -c "filetype on" \
"        test/fixture.cddl -c "edit!" -S test/probe.vim
" Exits 0 and prints "ALL TESTS PASSED" on success; exits 1 on any failure.
set nocompatible
let s:fail = 0
let s:count = 0

function! s:Check(cond, label) abort
  let s:count += 1
  if !a:cond
    let s:fail += 1
    echo "FAIL: " . a:label
  endif
endfunction

function! s:SynAt(pat, want, label) abort
  call cursor(1, 1)
  let pos = searchpos(a:pat, 'cW')
  if pos[0] == 0
    let s:count += 1
    let s:fail += 1
    echo "FAIL: " . a:label . " (pattern not found: " . a:pat . ")"
    return
  endif
  let name = synIDattr(synID(pos[0], pos[1], 1), "name")
  call s:Check(name ==# a:want,
        \ printf("%s @%d,%d: got '%s', want '%s'", a:label, pos[0], pos[1], name, a:want))
endfunction

call s:Check(&filetype ==# 'cddl', "filetype is cddl, got '" . &filetype . "'")
call s:Check(&commentstring ==# '; %s', "commentstring is '; %s', got '" . &commentstring . "'")

call s:SynAt('^test-rule', 'cddlRuleName', 'rule name (type rule)')
call s:SynAt('^group-rule', 'cddlRuleName', 'rule name (group rule =<)')
call s:SynAt('\h[[:alnum:]_-]*\ze\s*:', 'cddlKey', 'map key')
call s:SynAt('; fixture', 'cddlComment', 'comment')
call s:SynAt('TODO', 'cddlTodo', 'TODO in comment')
call s:SynAt('\.size', 'cddlCtlOp', 'control operator .size')
call s:SynAt('\.cbor', 'cddlCtlOp', 'control operator .cbor')
call s:SynAt('#6\.1', 'cddlTag', 'tag #6.1')
call s:SynAt('\<uint\>', 'cddlType', 'type uint')
call s:SynAt('\<true\>', 'cddlKeyword', 'literal true')
call s:SynAt('\<nil\>', 'cddlKeyword', 'literal nil')
call s:SynAt('\<undefined\>', 'cddlKeyword', 'literal undefined')
call s:SynAt('\.\.\.', 'cddlOperator', 'exclusive range ...')
call s:SynAt('\.\.', 'cddlOperator', 'inclusive range ..')
call s:SynAt('=\%(<\)\?', 'cddlOperator', 'operator =')
call s:SynAt('=>', 'cddlOperator', 'map arrow =>')
call s:SynAt('//', 'cddlOperator', 'choice //')
call s:SynAt('?', 'cddlOperator', 'occurrence ?')
call s:SynAt('\*', 'cddlOperator', 'occurrence *')
call s:SynAt('&( ', 'cddlOperator', 'group choice &')
call s:SynAt('\~ ', 'cddlOperator', 'unwrap ~')
call s:SynAt(':\s', 'cddlOperator', 'map colon :')
call s:SynAt('\<\d\+\>', 'cddlNumber', 'number')
call s:SynAt("h'", 'cddlByteString', "byte string h'..'")
call s:SynAt("b64'", 'cddlByteString', "byte string b64'..'")
call s:SynAt('b64p"', 'cddlByteString', 'byte string b64p".."')
call s:SynAt('h"', 'cddlByteString', 'byte string h".."')
call s:SynAt('\$\$\?[A-Za-z_-]\+', 'cddlSocket', 'socket/plug $name')

" Text strings: append to the buffer (not written to disk) and probe.
call setline(line('$') + 1, 'str-test = { s: "hello \"world\"" / ''plain'' }')
call s:SynAt('"hello', 'cddlString', 'text string "..."')
call cursor(line('$'), 1)
call s:SynAt('''plain''', 'cddlString', "text string '...'")

if s:fail == 0
  echo "ALL TESTS PASSED (" . s:count . " checks)"
  qa!
else
  echo s:fail . " of " . s:count . " checks FAILED"
  cquit 1
endif
