# Install

## Dependencies

- A LuaTeX compiler named luahbtex. Because LaTeX only support it, not others
  luatex, luajittex, ... It contained in mostly TeX distribution like TeXLive
  and MikTeX. However, you can install it standalone.
- [lx](https://github.com/nvim-neorocks/lux) > 0.9.1 as package manager. Note
  many distributions' `lux-cli` is not latest.

For ArchLinux:

```sh
paru -S lux-cli
paru -S luahbtex
```

For Nix:

```sh
nix-env -iA nixos.lux-cli
nix-env -iA nur.repos.Freed-Wu.luahbtex
```

For others:

```sh
cargo install lux-cli
lx install luahbtex
```

## Configure

1. luahbtex uses lua 5.3.
1. Add our server to install compiled packages without compiling by yourself.

`~/.config/lux/config.toml`:

```toml
extra_servers = [
  "https://ustctug.github.io/texrocks/",
]
lua_version = "5.3"
```
