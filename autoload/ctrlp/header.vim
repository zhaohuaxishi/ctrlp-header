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
let s:default_c_header_list = [
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
" }}} default_c_header_list

" cpp Standard head list from 'http://en.cppreference.com/w/cpp/header {{{
let s:default_cpp_header_list = [
      \ 'algorithm',
      \ 'any',
      \ 'array',
      \ 'atomic',
      \ 'bitset',
      \ 'chrono',
      \ 'complex',
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
      \ 'cinttypes',
      \ 'ciso646',
      \ 'climits',
      \ 'clocale',
      \ 'cmath',
      \ 'codecvt',
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

" The default header list that soupport
let s:default_header_dict = {
      \ 'c'   : s:default_c_header_list,
      \ 'cpp' : s:default_cpp_header_list,
      \}

" The header dict.
"
" The key of this dict is the filetype and the values
" of that key is the header list of that filetype.
"
let s:ctrlp_header_dict = {}

" Filetype that support now.
"
" This variable exists just for convenient implementaion of
" s:is_support_type(filetype)
"
let s:support_types = []

" Trim one line
"
function! s:trim(str)
  return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

" Find the position to insert header include command
" This Function will search backward to find the neares #include
" If not found, just return line 0
"
" Return: The line below which to insert new #include
"
function! s:insert_position()
  " TODO: fix this
  " extern xxx {
  "     #include xxx
  " }
  let pos = search("#include", 'bn')

  return pos
endfunction

" Check whether a:filetype is an supported type.
" If `g:ctrlp_header_path` is set, use the keys in that dict.
" Otherwise use the keys of `s:default_header_dict`
"
" Arguments:
"  a:filetype		the filetype to check
"
" Return:				1 if supported, 0 otherwise
function! s:is_support_type(filetype)
  " lazy init support_types
  if empty(s:support_types)
    if exists('g:ctrlp_header_path')
      let s:support_types = keys(g:ctrlp_header_path)
    else
      let s:support_types = keys(s:default_header_dict)
    endif
  endif

  return index(s:support_types, a:filetype) >=0 ? 1 : 0
endfunction

" Get filetype of buffer
"
" Return: filetype if bufnr
"
function! s:filetype(bufnr)
  return getbufvar(a:bufnr, '&l:filetype')
endfunction

" Load headlist form a:path
"
" Precondition: a:path must exists, and contain one head every line
"
" Arguments:
"  a:path				The path of the file
"
" Return:				Header list get from the file
"
function! s:load_header_list_from_file(path)
  let headers = []
  for header in readfile(a:path)
    call insert(headers, header)
  endfor

  return headers
endfunction

" Load the default headers for a:filetype
"
" Precondition: a:filetype have to be a supported type
"
" Arguments:
"  a:filetype		Load default headers for this file
"
" Return:				The default header list
"
function! s:default_header_list(filetype)
  return s:default_header_dict[a:filetype]
endfunction

" Load the candidate headers for a:filetype
"
" Precondition: a:filetype have to be a supported type
"
" Arguments:
"  a:filetype		Load headers for this file
"
" Return:				The candidate header list
"
function! s:load_header_list(filetype)
  if !exists('g:ctrlp_header_path')
    return s:default_header_list(a:filetype)
  endif

  let headers = []
  let path_list = g:ctrlp_header_path[a:filetype]
  for path in path_list
    let headers += s:load_header_list_from_file(path)
  endfor

  return headers
endfunction

" Check whether we already have candidates list for a:filetype
"
" Arguments:
"  a:filetype		the filetype to check
"
" Return: 1 if have, 0 otherwise
"
function! s:have_candidate_list(filetype)
  return index(keys(s:ctrlp_header_dict), a:filetype) >= 0 ? 1 : 0
endfunction

" Get candidates input list by filetype
"
" Arguments:
"  a:filetype		get the candidates of this filetype
"
" Return:
"  A Vim's List of candidate headers if filetype is supported
"  A empty List otherwise
"
function! s:header_list(filetype)
  let headers = []

  if s:is_support_type(a:filetype)
    " lazy load candidate list of this filetype
    if !s:have_candidate_list(a:filetype)
      let s:ctrlp_header_dict[a:filetype] = s:load_header_list(a:filetype)
    endif
    let headers = s:ctrlp_header_dict[a:filetype]
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
    let candidates = s:header_list(filetype)

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

  let dstlnum = s:insert_position()

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
