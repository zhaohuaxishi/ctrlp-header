# ctrlp-header

Use ctrlp.vim to include C/CPP standard header

This is my first vim plugin, and i Shamelessly copy same code from
[ctrlp-funky][funky]

[funky]: https://github.com/tacahiroy/ctrlp-funky

Its not very powerful now, I just get standard header from

 - cpp : http://en.cppreference.com/w/cpp/header
 - c   : http://en.cppreference.com/w/c/header

# Demo

![ctrlp-header-demon][]

# Requirement

[ctrlp.vim][ctrlp]

[ctrlp]: https://github.com/ctrlpvim/ctrlp.vim

# Usage

This extension create a new command `:CtrlPHeader`, you can map it to anything
you like:

```
nnoremap <silent> <Leader>i :CtrlPHeader<CR>
```

# TODO LIST

[ ] cache
[ ] semantic map of type and headers
