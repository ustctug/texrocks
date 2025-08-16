# LaTeX

LaTeX is the most popular TeX Dialect. It can use all LuaTeX registers, which
means you can create a bigger document than PlainTeX.

`main.tex`:

```tex
\documentclass{article}
\begin{document}

Hello, \LaTeX!
$$\sum_{n = 1}^\infty\frac1{n^2} = \frac{\pi^2}{6}$$

\end{document}
```

```sh
lx add -b lualatex
lx shell --build
lualatex main.tex
```

![lualatex](https://github.com/user-attachments/assets/09dd5ddb-8bac-4207-9cc5-ee61724ef7c0)

LaTeX require some [required packages](https://ctan.org/pkg/required).
You can install them by yourself.

- [amscls](https://luarocks.org/modules/ustctug/amscls):
  AMSLaTeX contains some documentclasses and packages for mathematics.
- [babel-base](https://luarocks.org/modules/ustctug/babel-base): multilanguages
- [latex-cyrillic](https://luarocks.org/modules/ustctug/latex-cyrillic):
  cyrillic alphabet fonts.
- [latex-graphics](https://luarocks.org/modules/ustctug/latex-graphics):
  graphics and colours.
- psnfss: WIP
- [latex-tools](https://luarocks.org/modules/ustctug/latex-tools): tables.

Some packages are recommended:

- [hyperref](https://luarocks.org/modules/ustctug/hyperref): hyperlinks.
- [pgf](https://luarocks.org/modules/ustctug/pgf): PGF/TikZ.
- [beamer](https://luarocks.org/modules/ustctug/beamer): slides.
- [ctex](https://luarocks.org/modules/ustctug/ctex): Chinese support.
- [citation-style-language](https://luarocks.org/modules/ustctug/citation-style-language):
  use [csl](https://citationstyles.org/) for bibliography.
