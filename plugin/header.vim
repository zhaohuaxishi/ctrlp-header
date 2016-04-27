" File: plugin/header.vim
" Description: The default map of ctrlp header

" create new command CtrlPHeader
command! CtrlPHeader call ctrlp#init(ctrlp#header#id())
