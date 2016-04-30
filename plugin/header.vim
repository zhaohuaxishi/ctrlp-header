" =============================================================================
" File:					plugin/header.vim
" Description:	The default map of ctrlp header
" =============================================================================

" create new command CtrlPHeader
command! -range CtrlPHeader <line1>call ctrlp#header#header()

command! -range CtrlPEHeader <line1>call ctrlp#header#eheader()

" vim:nofen:fdl=0:ts=2:sw=2:sts=2
