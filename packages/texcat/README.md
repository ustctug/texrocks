# texcat

<!-- markdownlint-disable MD013 -->

![screenshot](https://github.com/user-attachments/assets/5d608baf-5b48-4d0b-b371-7eb0cc36008b)

## Bench

### Terminal output

```sh
$ hyperfine -Nw10 'texcat lux.toml' 'pygmentize lux.toml' 'bat lux.toml'
Benchmark 1: texcat lux.toml
  Time (mean ± σ):      2.156 s ±  0.059 s    [User: 1.470 s, System: 0.676 s]
  Range (min … max):    2.108 s …  2.289 s    10 runs

Benchmark 2: pygmentize lux.toml
  Time (mean ± σ):     458.1 ms ±  58.2 ms    [User: 409.2 ms, System: 39.6 ms]
  Range (min … max):   372.8 ms … 535.9 ms    10 runs

Benchmark 3: bat lux.toml
  Time (mean ± σ):      18.7 ms ±   4.0 ms    [User: 14.8 ms, System: 8.1 ms]
  Range (min … max):    12.9 ms …  36.2 ms    158 runs

Summary
  bat lux.toml ran
   24.45 ± 6.03 times faster than pygmentize lux.toml
  115.05 ± 24.51 times faster than texcat lux.toml
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
