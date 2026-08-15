# texcat

<!-- markdownlint-disable MD013 -->

![screenshot](https://github.com/user-attachments/assets/5d608baf-5b48-4d0b-b371-7eb0cc36008b)

## Bench

### Terminal output

```sh
$ hyperfine -Nw10 'texcat lux.toml' 'tree-sitter highlight lux.toml' 'pygmentize lux.toml' 'bat lux.toml'
Benchmark 1: texcat lux.toml
  Time (mean ± σ):      2.259 s ±  0.152 s    [User: 1.573 s, System: 0.670 s]
  Range (min … max):    2.145 s …  2.649 s    10 runs

Benchmark 2: tree-sitter highlight lux.toml
  Time (mean ± σ):       7.5 ms ±   0.9 ms    [User: 3.1 ms, System: 3.7 ms]
  Range (min … max):     5.9 ms …  12.0 ms    410 runs

Benchmark 3: pygmentize lux.toml
  Time (mean ± σ):     377.9 ms ±  25.1 ms    [User: 334.1 ms, System: 36.7 ms]
  Range (min … max):   338.0 ms … 412.2 ms    10 runs

Benchmark 4: bat lux.toml
  Time (mean ± σ):      15.0 ms ±   1.2 ms    [User: 12.0 ms, System: 6.9 ms]
  Range (min … max):    13.3 ms …  18.6 ms    205 runs

Summary
  tree-sitter highlight lux.toml ran
    2.00 ± 0.28 times faster than bat lux.toml
   50.43 ± 6.78 times faster than pygmentize lux.toml
  301.45 ± 40.65 times faster than texcat lux.toml
```

### LaTeX output

```sh
$ hyperfine -Nw10 'texcat --format=latex lux.toml' 'pygmentize -f latex -O full=True lux.toml'
Benchmark 1: texcat --format=latex lux.toml
  Time (mean ± σ):      2.367 s ±  0.134 s    [User: 1.646 s, System: 0.704 s]
  Range (min … max):    2.149 s …  2.585 s    10 runs

Benchmark 2: pygmentize -f latex -O full=True lux.toml
  Time (mean ± σ):     319.9 ms ±   6.2 ms    [User: 285.1 ms, System: 31.5 ms]
  Range (min … max):   313.7 ms … 328.7 ms    10 runs

Summary
  pygmentize -f latex -O full=True lux.toml ran
    7.40 ± 0.44 times faster than texcat --format=latex lux.toml
```

## Dependencies

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
texcat lua/texcat.lua --format=latex > main.tex
lualatex main.tex
```

See [example](https://github.com/ustctug/texrocks/tree/main/packages/texcat) to
know how to use it in your LuaLaTeX document.

![PDF](https://github.com/user-attachments/assets/1c8a8dd1-57a8-4ab7-8b06-b801f4f74f97)
