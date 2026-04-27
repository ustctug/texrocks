# tlua

Tlua uses luatex as Lua interpreter and provides a REPL for debug.

## Lua interpreter

```sh
$ tlua -h
Usage: tlua [-h] [-e STMT] [-l NAME] [-p] [-v] [-i] [<SCRIPT>] ...

A Lua command prompt with pretty-printing and auto-completion.

Arguments:
SCRIPT                A Lua script to be executed.  Any arguments
specified after the script name, are passed to
the script.

Options:
-h                    Show this help message and exit.
-e STMT               Execute string 'STMT'.
-l NAME               Require library 'NAME'.
-p                    Force plain, uncolored output.
-v                    Print version information.
-i                    Enter interactive mode.
```

It is similar to standard lua:

```sh
$ lua -h
/usr/bin/lua: unrecognized option '-h'
usage: /usr/bin/lua [options] [script [args]]
Available options are:
-e stat  execute string 'stat'
-i       enter interactive mode after executing 'script'
-l name  require library 'name' into global 'name'
-v       show version information
-E       ignore environment variables
--       stop handling options
-        stop handling options and execute stdin
```

The name of tlua comes from [nlua](https://github.com/mfussenegger/nlua).
However, it has been occcupied, So it has an alias of texluap, means prompt for
texlua. Because it support another prompt mode:

## Lua prompt

```sh
$ tlua
> status.banner
_[1] = "This is LuaHBTeX, Version 1.23.3 (TeX Live 2026/dev)"
>
```

You can config it by `~/.config/luaprc.lua` which is used by all programs based
on [luaprompt](https://github.com/dpapavas/luaprompt).

```sh
local prompt = require'prompt'
if kpse then
    -- for tlua
    kpse.set_program_name'tlua'
    prompt.history = kpse.expand_path'~' .. '/.lua_history'
    prompt.prompts = { "> ", "    " }
elseif vim then
    -- for nvimp
    prompt.history = vim.fs.joinpath(vim.fn.stdpath'data', '.lua_history')
    prompt.prompts = { "> ", "    " }
else
    -- for luap
    prompt.history = (os.getenv'HOME' or os.getenv'USERPROFILE' or '.') .. '/.lua_history'
    prompt.prompts = { "> ", "    " }
end
```
