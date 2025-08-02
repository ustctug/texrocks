# Future

## Features

- [x] install packages in parallel, thanks to lx
- [x] package version control, thanks to rockspec
- [x] virtual environment, thanks to lx
- [x] minimal preinstalled packages
- [x] no extra dependencies while TeXLive needs perl, tcl/tk, ...
- [x] support Unix
- [ ] support Win32. We use shebang so a cmd wrapper is needed
- [x] a server to host packages: <https://ustctug.github.io/texrocks/>

## TODO

- read `~/.config/lux/config.toml` to know real installed TeX files's paths.
- more TeX dialects:
  - ConTeXt
  - [publisher](https://github.com/speedata/publisher/)
- more TeX packages: CTAN ~3000 v.s. <https://ustctug.github.io/texrocks/> ~100
  - luaotfload: Opentype font support, necessary for some languages like
    Chinese.
- Use lua to rewrite some TeX tools written in perl
  - [epstopdf](https://ctan.org/pkg/epstopdf): convert eps to pdf for
    `\includegraphics{XXX.eps}`. Since now, you have to convert it by yourself:
    `gs -sOutputFile=XXX.pdf XXX.eps` then `\includegraphics{XXX.pdf}`.
  - [latexmk](https://github.com/debian-tex/latexmk): read XXX.log to decide if
    rerun TeX compiler. Since now, you have to rerun lualatex by yourself.

## Credit

- [rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim): a neovim package
  manager powered by luarocks
- [apltex](https://github.com/RadioNoiseE/apltex): inspiration origin
