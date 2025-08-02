# Install and Configure

## Dependencies

### lux-cli

In [tutorial](../README.md.html), you have found the core program is `lx`, a
package manager written in rust. It is provided by `lux-cli`.
The version must be `> 0.11.1` due to many bug fixes.

### luahbtex

luahbtex is a TeX compiler and Lua 5.3 interpreter. Its sisters, luatex,
luajittex and ..., are not supported by LaTeX.
It is contained in mostly TeX distribution like TeXLive and MikTeX.
However, you can install it standalone.

## Install

```sh
cargo install lux-cli
lx install luahbtex
```

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

Remember to check `lux-cli`'s version.

## Configure

`~/.config/lux/config.toml`:

```toml
extra_servers = [
  # Add our server to install compiled packages without compiling by yourself.
  "https://ustctug.github.io/texrocks/",
]
# luahbtex uses lua 5.3.
lua_version = "5.3"
```

For some regions like China, access github is slow. You can download recent
[github action](https://github.com/ustctug/texrocks/actions/)
`pages build and deployment`'s artifact `github-pages`. Then extract it:

```sh
unzip github-pages.zip
tar vxaf artifact.tar
# you can delete them
rm artifact.tar github-pages.zip
```

start a server:

```sh
python -m http.server
```

Open <http://127.0.0.1:8000> to check it. Then edit your
`~/.config/lux/config.toml`:

```toml
extra_servers = [
  "http://127.0.0.1:8000",
]
```
