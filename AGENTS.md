# Develop Guide

- This project is a monorepo for many Lua projects
  - `bin/` and `lua/` under root directory is the main project `texrocks`
  - every directory under `packages/` is a sub project
  - `packages/{luatex,lualatex,luatexinfo,initex}` always keep same version as
    texrocks to avoid fatal format file error
- Package manager: lux/nix
  - environment variable `$IN_NIX_SHELL` detects if the project is running in a
    nix shell, which provides lx command of lux-cli.
  - environment variable `$LUX_SHELL` detects if the project is running in a
    lux shell, which allows to `require()` packages in texlua.

## Coding Style

- Use `foo_bar` for all names
- Every function must have a docstring for luadoc

## Project Structure

- `assets/`: static resource for <https://texrocks.readthedocs.io>
- `bin/`: executable lua scripts. `foo` will source `lua/texrocks/foo.lua`.
- `docs/`: documents
- `lua/`: source for Lua modules
- `packages/`: internal packages
- `rockspecs/`: external packages
- `scripts/`: scripts for development
- `spec/`: unit test for busted
- `action.yml`: will be used for `.github/workflows/deploy.yml`
- `config.ld`: config for ldoc to build documentation
- `shell.nix`: config for `nix-shell`

### Internal Packages

Every sub project under `packages/` is an internal package.

- `lx build`: build a sub project
- `lx generate-rockspec`: generate rockspec
- `luarocks upload *.rockspec`: upload a rockspec to luarocks.org.
- `luarocks install *.rockspec`: Install a package
- `luarocks pack XXX`: generate rock
- `scripts/upload.sh *.all.rock`: upload a rock to luarocks.org. need
  `$LUAROCKS_API_KEY` never emit it!

In lux shell:

- `texlua -e 'XXX'`: run a lua command in texlua.
- `texlua XXX.lua`: run a lua script in texlua.

Outside lux shell, try: `lx lua --lua .lux/5.3/bin/texlua -- --XXX`

`bin/XXX` looks like:

```lua
#!/usr/bin/env texlua
require 'XXX'.main(arg)
```

The core code is in `lua/XXX.lua`. If `run.command` is set in `lux.toml`,
`lx run` will run the command in lux shell.

### External Packages

Every rockspec under `rockspecs/` is an external package.
When they have new version, it should be updated by:

1. Rename the rockspec to `foo-X.Y.Z-1.rockspec`
2. Update `git_ref` of `foo-X.Y.Z-1.rockspec`
3. `luarocks upload foo-X.Y.Z-1.rockspec`: upload it to luarocks.org

How to pack new package:

Write a rockspec, which `build.type` can be:

- `builtin`: if source is a `*.tds.zip` and doesn't have any `*.lua` or
  `scripts/`
- `tds`: if source is a `*.tds.zip` or can be extracted to get a `*.tds.zip`
  refer `packages/luarocks-build-tds/`
- `l3build`: if source contain a `build.lua` and can be built by l3build.
  refer `packages/luarocks-build-l3build/`.
- `command`: avoid to use this type, try to add a `build.lua` by
  `build.patches` then use `l3build`.

Write correct dependencies. Every `\RequirePackage{}` in `*.sty` or `*.cls`
should be a dependency in rockspec.

Upload it like an internal project.

## Commands

- `scripts/ldoc.sh`: build website in `_readthedocs/html/`.
