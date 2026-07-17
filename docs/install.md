# Install and Configure

## Dependencies

### lux-cli

In [tutorial](README.md.html), you have found the core program is `lx`, a
package manager written in rust. It is provided by `lux-cli`.
The version must be `> 0.11.1` due to many bug fixes.

### luahbtex

luahbtex is a TeX compiler and Lua 5.3 interpreter. Its sisters, luatex,
luajittex and ..., are not supported by LaTeX. That's why we choose it.
It is contained in mostly TeX distribution such as TeXLive and MikTeX.
However, you can install it standalone.

## Install

Without any package managers: you can download compiled programs from Internet.
This is an example for GNU/Linux. For other OSes, search
[download link](https://github.com/nvim-neorocks/lux/releases/).

```sh
curl -O https://download.speedata.de/files/extra/luatex_115-win-mac-linux.zip
unzip luatex_115-win-mac-linux.zip
install -D luatex/linux/sdluatex /usr/local/bin/luahbtex
curl -O https://github.com/nvim-neorocks/lux/releases/download/v0.15.1/lx_0.15.1_x86_64.AppImage
install -D lx_0.15.1_x86_64.AppImage /usr/local/bin/lx
```

For cargo:

```sh
cargo install lux-cli
lx install luahbtex
```

For ArchLinux:

```sh
paru -S lux-cli luahbtex
```

For Nix:

```sh
nix-env -iA nixos.lux-cli
nix-env -iA nur.repos.Freed-Wu.luahbtex
```

## Configure

`~/.config/lux/config.toml`:

```toml
# luahbtex uses lua 5.3.
lua_version = "5.3"
```
