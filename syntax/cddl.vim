" Language: CDDL (Concise Data Definition Language, RFC 8610)
" Comments start with ';'. Rules look like:  name = type  or  name =< group
if exists("b:current_syntax")
  finish
endif

syn case match

" Comments and TODOs
syn keyword cddlTodo contained TODO FIXME XXX NOTE
syn match cddlComment ";.*$" contains=cddlTodo

" Rule definitions: name = type, name =< group, name<$a> = ...
syn match cddlRuleName "^\s*\zs[A-Za-z_][A-Za-z0-9_-]*\>\ze\%(<[^>]*>\)\?\s*=\%(<\)\?"

" Map member keys: key: value  (line start or after ( , { )
syn match cddlKey "\%(^\|[(,{]\)\s*\zs[A-Za-z_][A-Za-z0-9_-]*\ze\s*:"

" Prelude and builtin type names
syn keyword cddlType uint nint int float16 float32 float64 float16or32 float
syn keyword cddlType number text tstr tdate time uri regexp mime
syn keyword cddlType bstr bytes cborseq any bool
syn match cddlType "\<\%(encoded-cbor\|cbor-any\|message-stream\|b64url\|b64u\|b64p\|b64\|eb64url\|eb64\|eb16\)\>\ze\%(\s*['\"]\)\@!"

" Literal values
syn keyword cddlKeyword true false nil undefined

" Sockets and plugs: $name, $$name
syn match cddlSocket "\$\$\?[A-Za-z_][A-Za-z0-9_-]*"

" Tag tags: #6.1, #7.7
syn match cddlTag "#\d\+\%(\.\d\+\)\?"

" Control operators: tstr .size 4, bstr .cbor type
syn match cddlCtlOp "\.\(size\|cbor\|cborseq\|bits\|regexp\|plus\|and\|det\|cat\|lt\|le\|gt\|ge\|eq\|ne\|default\)\>"

" Numbers
syn match cddlNumber "\<0[xX]\x\+\>"
syn match cddlNumber "\<0[bB][01]\+\>"
syn match cddlNumber "\<0[oO]\o\+\>"
syn match cddlNumber "\<\d\+\%(\.\d*\)\?\%(e[-+]\?\d\+\)\?\>"

" Operators: =  =<  =>  //  ..  ...  :  ~  &  and occurrence * + ?
syn match cddlOperator "=>\|=\%(<\)\?\|//\|\.\.\.\?\|[*+?~&:]"

" Text strings ('...' and "..." with backslash escapes)
syn region cddlString start=+'+ skip=+\\\\\|\\'+ end=+'+
syn region cddlString start=+"+ skip=+\\\\\|\\"+ end=+"+

" Byte strings: h'..', h"..", b64'..', b64p'..', b64u'..' (RFC 8610 and later)
syn match cddlByteString "\<\%(h\|b64url\|b64u\|b64p\|b64\)\%(''\|'''\|'[^']*'\|\"[^\"]*\"\)"

hi def link cddlComment    Comment
hi def link cddlTodo       Todo
hi def link cddlRuleName   Define
hi def link cddlKey        Identifier
hi def link cddlType       Type
hi def link cddlKeyword    Constant
hi def link cddlSocket     Special
hi def link cddlTag        Special
hi def link cddlCtlOp      Operator
hi def link cddlNumber     Number
hi def link cddlOperator   Operator
hi def link cddlString     String
hi def link cddlByteString String

let b:current_syntax = "cddl"
