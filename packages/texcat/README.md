# texcat

<!-- markdownlint-disable MD013 -->

![screenshot](https://github.com/user-attachments/assets/6c5b13b2-6d8a-498c-a519-8ff6cfe82af0)

It supports syntax parser:

- [x] [tree-sitter grammars](https://nvim-neorocks.github.io/rocks-binaries/)
- [x] textmate/VS Code language XML/json

It supports color themes:

- [x] textmate/VS Code theme XML/json
- [ ] [syncat themes](https://github.com/foxfriends/syncat-themes)

## Dependencies

### TextMate

By default, it will search color themes or syntax parsers in VS Code directory.

```sh
git clone --depth=1 https://github.com/microsoft/vscode ~/.vscode
```

Then you can see:

```sh
$ texcat --list themes
Abyss: /home/wzy/.vscode/extensions/theme-abyss/./themes/abyss-color-theme.json
Abyss theme for Visual Studio Code
publisher: vscode

# ...
$ texcat --list syntaxes --syntax-type=textmate
bat: .bat
%description%

# ...
```

If you use texrocks, there is a package for you:

```sh
lx add -b vscode-extensions
```

### Tree-sitter

By default, it will search syntax parsers in Neovim directory.

```sh
$ texcat --list syntaxes
c: /usr/lib/nvim/parser/c.so

# ...
```

If you use texrocks, you can install parsers by yourself.

```sh
lx add -b tree-sitter-XXX
```

Add <https://nvim-neorocks.github.io/rocks-binaries/> to
`~/.config/lux/config.toml` to save compile time.

```toml
extra_servers = [
  "https://nvim-neorocks.github.io/rocks-binaries/",
  "https://ustctug.github.io/texrocks/",
]
```

## Usage

```sh
$ texcat --help
Usage: /home/wzy/Desktop/texrocks/packages/texcat/bin/texcat [-h]
       [--completion {bash,zsh,fish}] [--output <output>]
       [--syntax <syntax>] [--theme <theme>]
       [--syntax-type {textmate,tree-sitter}]
       [--theme-type {textmate}] [--extensions-dir <extensions_dir>]
       [--output-format {ansi,empty,latex,preamble.tex,test,tex,txt}]
       [--list {themes,syntaxes,extensions_dirs,colors,links}]
       [--command-prefix <command_prefix>]
       [--math-escape <math_escape>] [<file>] ...

Arguments:
   file                  file name

Options:
   -h, --help            Show this help message and exit.
   --completion {bash,zsh,fish}
                         Output a shell completion script for the specified shell.
   --output <output>     output file name, - means stdout
   --syntax <syntax>     set syntax, auto means decided by extension
   --theme <theme>       set theme, auto means first theme such as Abyss
   --syntax-type {textmate,tree-sitter}
                         syntax highlight type (default: tree-sitter)
   --theme-type {textmate}
                         color scheme type (default: textmate)
   --extensions-dir <extensions_dir>
                         directories for VSCode extensions and tree-sitter grammars/queries
   --output-format {ansi,empty,latex,preamble.tex,test,tex,txt}
                         output format (default: ansi)
   --list {themes,syntaxes,extensions_dirs,colors,links}
                         list all themes/syntaxes/... (default: themes)
   --command-prefix <command_prefix>
                         command prefix for TeX
   --math-escape <math_escape>
                         the scope to escape $math TeX code$ (default: comment)
$ texcat lua/texcat.lua --output-format=latex --output=main.tex
$ lualatex main.tex
```

For a source code:

`test.lua`:

```lua
---last index $i\in\mathbb{Z}$
local function get_last_index(input)
    local offsets = { 1 }
    if input ~= nil then
        print(#input - offsets[1])
    end
    return true
end
return get_last_index
```

`texcat test.lua --output-format=tex` will generate:

```tex
\PYAbyss{comment}{\PYAbyssZhy{}\PYAbyssZhy{}\PYAbyssZhy{}last index $i\in\mathbb{Z}$}
\PYAbyss{keyword}{local}\PYAbyss{source}{ }\PYAbyss{keyword.function}{function}\PYAbyss{source}{ }\PYAbyss{variable}{get\PYAbyssZus{}last\PYAbyssZus{}index}\PYAbyss{source}{(}\PYAbyss{variable}{input}\PYAbyss{source}{)}
\PYAbyss{source}{    }\PYAbyss{keyword}{local}\PYAbyss{source}{ }\PYAbyss{variable}{offsets}\PYAbyss{source}{ }\PYAbyss{operator}{=}\PYAbyss{source}{ }\PYAbyss{constructor}{\PYAbyssZob{}}\PYAbyss{source}{ }\PYAbyss{number}{1}\PYAbyss{source}{ }\PYAbyss{constructor}{\PYAbyssZcb{}}
\PYAbyss{source}{    }\PYAbyss{keyword.conditional}{if}\PYAbyss{source}{ }\PYAbyss{variable}{input}\PYAbyss{source}{ }\PYAbyss{operator}{\PYAbyssZti{}=}\PYAbyss{source}{ }\PYAbyss{constant.builtin}{nil}\PYAbyss{source}{ }\PYAbyss{keyword.conditional}{then}
\PYAbyss{source}{        }\PYAbyss{variable}{print}\PYAbyss{source}{(}\PYAbyss{operator}{\PYAbyssZsh{}}\PYAbyss{variable}{input}\PYAbyss{source}{ }\PYAbyss{operator}{\PYAbyssZhy{}}\PYAbyss{source}{ }\PYAbyss{variable}{offsets}\PYAbyss{source}{[}\PYAbyss{number}{1}\PYAbyss{source}{])}
\PYAbyss{source}{    }\PYAbyss{keyword.conditional}{end}
\PYAbyss{source}{    }\PYAbyss{keyword.return}{return}\PYAbyss{source}{ true}
\PYAbyss{keyword.function}{end}
\PYAbyss{keyword.return}{return}\PYAbyss{source}{ }\PYAbyss{variable}{get\PYAbyssZus{}last\PYAbyssZus{}index}
```

See [example](https://github.com/ustctug/texrocks/tree/main/packages/texcat) to
know how to use it in your LuaLaTeX document.

For texlive's `ctan.zip` and `tds.zip`, vscode-extensions, tree-sitter-lua and
tree-sitter-latex for GNU/Linux are attached. Tell correct environment variables:

```sh
LUA_CPATH="$HOME/.texlive/texmf-config/scripts/texcat/lib/?.so" CLUAINPUTS='$LUAINPUTS' lualatex --shell-escape test.tex
```

![PDF](https://github.com/user-attachments/assets/3ebe9d8f-4ea9-495c-8cd9-187b2dc0200b)
