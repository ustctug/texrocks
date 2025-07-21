# LaTeX

LaTeX is the most popular TeX Dialect. It can use all LuaTeX registers, which
means you can create a bigger document than PlainTeX.

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
- [ctex](https://luarocks.org/modules/ustctug/ctex): Chinese support. **bug**
- [citation-style-language](https://luarocks.org/modules/ustctug/citation-style-language):
  use [csl](https://citationstyles.org/) for bibliography.

[More packages](https://luarocks.org/m/texmf).

[A more complicated example](packages/demo).
