" =============================================================================
" File:          autoload/ctrlp/header.vim
" Description:   include c/cpp header use ctrlp
" =============================================================================

" Load guard
if ( exists('g:loaded_ctrlp_header') && g:loaded_ctrlp_header )
	\ || v:version < 700 || &cp
	finish
endif
let g:loaded_ctrlp_header = 1

" c Standard header list from 'http://en.cppreference.com/w/c/header' {{{
let s:ctrlp_c_header_list = [
  \ 'assert.h',
  \ 'complex.h',
  \ 'ctype.h',
  \ 'errno.h',
  \ 'fenv.h',
  \ 'float.h',
  \ 'inttypes.h',
  \ 'iso646.h',
  \ 'limits.h',
  \ 'locale.h',
  \ 'math.h',
  \ 'setjmp.h',
  \ 'signal.h',
  \ 'stdalign.h',
  \ 'stdarg.h',
  \ 'stdatomic.h',
  \ 'stdbool.h',
  \ 'stddef.h',
  \ 'stdint.h',
  \ 'stdio.h',
  \ 'stdlib.h',
  \ 'stdnoreturn.h',
  \ 'string.h',
  \ 'tgmath.h',
  \ 'threads.h',
  \ 'time.h',
  \ 'uchar.h',
  \ 'wchar.h',
  \ 'wctype.h',
  \]
" }}} ctrlp_c_header_list

" cpp Standard head list from 'http://en.cppreference.com/w/cpp/header {{{
let s:ctrlp_cpp_header_list = [
  \ 'algorithm',
  \ 'any',
  \ 'array',
  \ 'atomic',
  \ 'bitset',
  \ 'deque',
  \ 'exception',
  \ 'exception_list',
  \ 'execution_policy',
  \ 'filesystem',
  \ 'forward_list',
  \ 'fstream',
  \ 'functional',
  \ 'future',
  \ 'initializer_list',
  \ 'iomanip',
  \ 'ios',
  \ 'iosfwd',
  \ 'iostream',
  \ 'istream',
  \ 'iterator',
  \ 'limits',
  \ 'list',
  \ 'locale',
  \ 'map',
  \ 'memory',
  \ 'memory_resource',
  \ 'mutex',
  \ 'new',
  \ 'numeric',
  \ 'optional',
  \ 'ostream',
  \ 'queue',
  \ 'random',
  \ 'ratio',
  \ 'regex',
  \ 'scoped_allocator',
  \ 'set',
  \ 'shared_mutex',
  \ 'sstream',
  \ 'stack',
  \ 'stdexcept',
  \ 'streambuf',
  \ 'string',
  \ 'string_view',
  \ 'strstream',
  \ 'system_error',
  \ 'thread',
  \ 'tuple',
  \ 'type_traits',
  \ 'typeindex',
  \ 'typeinfo',
  \ 'unordered_map',
  \ 'unordered_set',
  \ 'utility',
  \ 'valarray',
  \ 'vector',
  \ 'cassert',
  \ 'ccomplex',
  \ 'cctype',
  \ 'cerrno',
  \ 'cfenv',
  \ 'cfloat',
  \ 'chrono',
  \ 'cinttypes',
  \ 'ciso646',
  \ 'climits',
  \ 'clocale',
  \ 'cmath',
  \ 'codecvt',
  \ 'complex',
  \ 'condition_variable',
  \ 'csetjmp',
  \ 'csignal',
  \ 'cstdalign',
  \ 'cstdarg',
  \ 'cstdbool',
  \ 'cstddef',
  \ 'cstdint',
  \ 'cstdio',
  \ 'cstdlib',
  \ 'cstring',
  \ 'ctgmath',
  \ 'ctime',
  \ 'cuchar',
  \ 'cwchar',
  \ 'cwctype',
  \ 'experimental/algorithm',
  \ 'experimental/any',
  \ 'experimental/chrono',
  \ 'experimental/deque',
  \ 'experimental/exception_list',
  \ 'experimental/execution_policy',
  \ 'experimental/filesystem',
  \ 'experimental/forward_list',
  \ 'experimental/functional',
  \ 'experimental/future',
  \ 'experimental/list',
  \ 'experimental/map',
  \ 'experimental/memory',
  \ 'experimental/memory_resource',
  \ 'experimental/numeric',
  \ 'experimental/optional',
  \ 'experimental/ratio',
  \ 'experimental/regex',
  \ 'experimental/set',
  \ 'experimental/string',
  \ 'experimental/string_view',
  \ 'experimental/system_error',
  \ 'experimental/tuple',
  \ 'experimental/type_traits',
  \ 'experimental/unordered_map',
  \ 'experimental/unordered_set',
  \ 'experimental/utility',
  \ 'experimental/vector',
	\]
" }}} ctrlp_cpp_header_list

" private {{{

let s:ctrlp_header_default = {
	\ 'c' : s:ctrlp_c_header_list,
	\ 'cpp' : s:ctrlp_cpp_header_list,
  \ }

let s:support_types = keys(s:ctrlp_header_default)

function! s:trim(str)
	return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! s:getinsertpos()
	" TODO fix this :
	" extern xxx {
	"     #include xxx
	" }
	let pos = search("#include", 'bn')

	return pos
endfunction

" Get filetype of buffer
"
" Return: filetype if bufnr
"
function! s:filetype(bufnr)
  return getbufvar(a:bufnr, '&l:filetype')
endfunction


" Get candidates input list by filetype
"
" Return: a Vim's List
"
function! s:getstdheader(filetype)
	let idx = index(s:support_types, a:filetype)

	if (idx >= 0)
		let headers = s:ctrlp_header_default[a:filetype]
	else
		let headers = []
	endif

	return headers
endfunction

" }}} private

call add(g:ctrlp_ext_vars, {
	\ 'init': 'ctrlp#header#init(s:crbufnr)',
	\ 'accept': 'ctrlp#header#accept',
	\ 'lname': 'include header',
	\ 'sname': 'header',
	\ 'type': 'path',
	\ 'sort': 0,
	\ 'specinput': 0,
	\ })

" Provide a list of strings to search in
"
" Arguments:
"  a:bufnr The bufnr get from ctrlp
"
" Return: a Vim's List
"
function! ctrlp#header#init(bufnr)
  try
    " NOTE: To prevent ctrlp error. this is a bug on ctrlp itself, perhaps?
    let saved_ei = &eventignore
    let &eventignore = 'BufLeave'

    let ctrlp_winnr = bufwinnr(bufnr(''))
    execute bufwinnr(a:bufnr) . 'wincmd w'
    let pos = getpos('.')
    let filetype = s:filetype(a:bufnr)

    let candidates = s:getstdheader(filetype)

    " activate the former buffer
    execute 'buffer ' . bufname(a:bufnr)
    call setpos('.', pos)

    execute ctrlp_winnr . 'wincmd w'

    return candidates
  finally
    let &eventignore = saved_ei
  endtry
endfunction


" The action to perform on the selected string
"
" Arguments:
"  a:mode   not using
"  a:str    the selected header name
"
function! ctrlp#header#accept(mode, str)
	call ctrlp#exit()

	let dstlnum = s:getinsertpos()

	" if next line is not empty, insert new empty line
	if !empty(s:trim(getline(dstlnum + 1)))
		call append(dstlnum, '')
	endif

	let content = '#include <' . a:str . '>'
	call append(dstlnum, content)
endfunction

" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

" Allow it to be called later
function! ctrlp#header#id()
	return s:id
endfunction


" vim:nofen:fdl=0:ts=2:sw=2:sts=2
