" Language: CDDL (Concise Data Definition Language, RFC 8610)
if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal comments=:;
setlocal commentstring=;\ %s
setlocal formatoptions-=t formatoptions+=croql

let b:undo_ftplugin = "setlocal comments< commentstring< formatoptions<"
