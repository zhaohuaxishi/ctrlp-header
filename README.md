# ctrlp-header

Use ctrlp.vim to include C/CPP standard header

This is my first vim plugin, and i shamelessly copy same code from
[ctrlp-funky][funky]

[funky]: https://github.com/tacahiroy/ctrlp-funky

Its not very powerful now, I just get standard header from

 - cpp : http://en.cppreference.com/w/cpp/header
 - c   : http://en.cppreference.com/w/c/header

# Demo

# cpp

![ctrlp-header-demon][democpp]

[democpp]: http://blog.guorongfei.com/img/posts/ctrlp-header-cpp.gif

# c

![ctrlp-header-demon][democ]

[democ]: http://blog.guorongfei.com/img/posts/ctrlp-header-c.gif

# Requirement

[ctrlp.vim][ctrlp]

[ctrlp]: https://github.com/ctrlpvim/ctrlp.vim

# Usage

Add this to your `.vimrc`

```
let g:ctrlp_extensions = ['header', 'other_extensions']
```

# `CtrlPHeader` command

you can use `CtrlPHeader` command to include normal stype header like this:

```
#include <string>
```

# `CtrlPEHeader` command

you can use `CtrlPEHeader` command to include normal header with `extren "C"`
guard like this:

```
extern "C" { #include <libswscale/swscale.h> }
```

you can map this two command to some short cut like this

```
nnoremap <silent> <Leader>i :CtrlPHeader<CR>
```

# TODO LIST

[ ] add the support of include header at certain line

[ ] cache

[ ] semantic map of type and headers
