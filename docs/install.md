# Install and Configure

## Dependencies

### lux-cli

In [tutorial](README.md.html), you have found the core program is `lx`, a
package manager written in rust. It is provided by
[`lux-cli`](https://github.com/lumen-oss/lux).
The version must be `> 0.11.1` due to many bug fixes.

Without any package managers: you can download compiled programs from Internet.
This is an example for GNU/Linux. For other OSes, search
[download link](https://github.com/lumen-oss/lux/releases/).

```sh
curl -O https://github.com/lumen-oss/lux/releases/download/v0.15.1/lx_0.15.1_x86_64.AppImage
install -D lx_0.15.1_x86_64.AppImage /usr/local/bin/lx
```

For cargo:

```sh
cargo install lux-cli
```

For ArchLinux:

```sh
paru -S lux-cli
```

For Nix:

```sh
nix-env -iA nixos.lux-cli
```

## Configure

`~/.config/lux/config.toml`:

```toml
# lualatex uses lua 5.3.
lua_version = "5.3"
```
