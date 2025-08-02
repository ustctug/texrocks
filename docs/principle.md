# Principle

texrocks is a lua library to provide a fake texlua/luatex. It does two things:

1. set correct environment variables
2. use correct command line arguments to call luahbtex

## Introduction

For example, you create a virtual environment named `my-thesis`:

```sh
lx new my-thesis
cd my-thesis
lx add your-needed-luatex-package1 you-loved-luatex-package2
"$EDITOR" main.tex
```

If you build it directly:

```sh
luahbtex main.tex
```

It will fail, because luatex doesn't know where is
`your-needed-luatex-package1.sty` in `\usepackage{your-needed-luatex-package1}`
and `your-needed-luatex-package1.lua` in `\directlua{require"your-needed-luatex-package1"}`.
So you try:

```sh
lx lua --lua=luahbtex -- main.tex
# or
lx shell
luahbtex main.tex
```

`lx` will add lua paths of `your-needed-luatex-package1` and
`you-loved-luatex-package2` to `$LUA_PATH` and `$CLUA_PATH`.
lua recognize these variables to set `package.path` and `package.cpath`.
Any `require"package_name"` will search `package_name.lua` in `package.path` and
`package.cpath`.

However, luahbtex is not a standard lua. It recognizes `$LUAINPUTS` and
`$CLUAINPUTS` for lua files. So we must modify `package.path` and
`package.cpath` to get them. And luatex recognize `$TEXINPUTS` for tex files.
Notice we install tex files in the same directory of lua files, so we also can
get them. Font files are similar.

So we create a lua wrapper named `luatex` to do this work. it calls
`os.setenv()` to set correct environment variables to make luahbtex work:

```sh
luatex main.tex
```

If you don't like virtual environment, just use `lx install` to replace `lx add`.
These packages will be installed to system globally.

```sh
lx install your-needed-luatex-package1 you-loved-luatex-package2
```

It is advised that add `lux.lock` to VCS to keep reproducible of your TeX
documents.

## Related Projects

Except environment variables, TeX compilers also read a config file:

`texmf.cnf`:

```texmf
% comment
VAR = XXX
```

is equal to shell's:

```sh
VAR=XXX texlua
```

or lua's:

```lua
os.setenv("VAR", "XXX")
io.popen("texlua")
```

Many TeX distributions, like TeX Live and MikTeX, don't use environment
variables. They use `texmf.cnf` to declare a fixed path, like
`/usr/share/texmf`. It is hard to support virtual environments.

And these huge TeX distributions usually provide many TeX compilers: pdfTeX,
XeTeX, LuaTeX, ... and many TeX tools written in lua/perl/python/java/...
We only provide luahbtex and those TeX tools written in lua.
