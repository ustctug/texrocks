# texcat

![screenshot](https://github.com/user-attachments/assets/e0692a72-c8c4-4d17-a95f-a9018e3bed27)

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
$ texcat --list languages --syntax-type=tree-sitter
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
$ texcat --list languages --syntax-type=tree-sitter
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

<!-- markdownlint-disable MD013 -->

```sh
$ texcat --help
Usage: /home/wzy/Desktop/texrocks/packages/texcat/.lux/5.3/bin/texcat
       [-h] [--completion {bash,zsh,fish}] [--output <output>]
       [--language <language>] [--theme <theme>]
       [--syntax-type {textmate,tree-sitter}]
       [--theme-type {textmate}] [--extensions-dir <extensions_dir>]
       [--output-format {tex,latex,ansi,test,empty,txt}]
       [--list {none,themes,languages,extensions_dirs,colors,links}]
       [--command-prefix <command_prefix>] [<file>] ...

Arguments:
   file                  file name

Options:
   -h, --help            Show this help message and exit.
   --completion {bash,zsh,fish}
                         Output a shell completion script for the specified shell.
   --output <output>     output file name, - means stdout
   --language <language> set language, auto means decided by extension
   --theme <theme>       set theme, auto means first theme such as Abyss
   --syntax-type {textmate,tree-sitter}
                         syntax highlight type (default: tree-sitter)
   --theme-type {textmate}
                         color scheme type (default: textmate)
   --extensions-dir <extensions_dir>
                         directories for VSCode extensions (~/.vscode) and tree-sitter grammars/queries (/usr/lib/nvim, /usr/share/nvim/runtime)
   --output-format {tex,latex,ansi,test,empty,txt}
                         output format, latex means full code not a snippet (default: ansi)
   --list {none,themes,languages,extensions_dirs,colors,links}
                         list all themes/languages/... (default: none)
   --command-prefix <command_prefix>
                         command prefix for TeX (default: PY)
$ texcat lua/texcat.lua --output-format=latex --output=main.tex
$ lualatex main.tex
```

For a source code:

`test.lua`:

```lua
---comment
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
% ...
\begin{Verbatim}[commandchars=\\\{\},codes={\catcode`\$=3\catcode`\^=7\catcode`\_=8\relax}]
\PY{comment}{\PYZhy{}\PYZhy{}\PYZhy{}comment}
\PY{keyword}{local}\PY{source}{ }\PY{keyword.function}{function}\PY{source}{ }\PY{variable}{get\PYZus{}last\PYZus{}index}\PY{source}{(}\PY{variable}{input}\PY{source}{)}
\PY{source}{    }\PY{keyword}{local}\PY{source}{ }\PY{variable}{offsets}\PY{source}{ }\PY{operator}{=}\PY{source}{ }\PY{constructor}{\PYZob{}}\PY{source}{ }\PY{number}{1}\PY{source}{ }\PY{constructor}{\PYZcb{}}
\PY{source}{    }\PY{keyword.conditional}{if}\PY{source}{ }\PY{variable}{input}\PY{source}{ }\PY{operator}{\PYZti{}=}\PY{source}{ }\PY{constant.builtin}{nil}\PY{source}{ }\PY{keyword.conditional}{then}
\PY{source}{        }\PY{variable}{print}\PY{source}{(}\PY{operator}{\PYZsh{}}\PY{variable}{input}\PY{source}{ }\PY{operator}{\PYZhy{}}\PY{source}{ }\PY{variable}{offsets}\PY{source}{[}\PY{number}{1}\PY{source}{])}
\PY{source}{    }\PY{keyword.conditional}{end}
\PY{source}{    }\PY{keyword.return}{return}\PY{source}{ true}
\PY{keyword.function}{end}
\PY{keyword.return}{return}\PY{source}{ }\PY{variable}{get\PYZus{}last\PYZus{}index}
\end{Verbatim}
```

You can directly use it in your LuaLaTeX document.

```sh
lualatex --shell-escape main.tex
```

```tex
\documentclass{article}
\usepackage{fancyvrb}
\usepackage{color}
\begin{document}

\directlua{require'texcat'.main{'test.lua'}}

\end{document}
```
