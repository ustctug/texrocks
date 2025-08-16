# luarocks-build-l3build

Luarocks build backend for l3build.

## Write rockspec

Pack a TeX package needs a rockspec:

`package-name-X.Y.Z-1.rockspec`:

```lua
rockspec_format = '3.0'
package = 'package-name'

description = {
  summary = [[Copied from CTAN homepage]],
  detailed = [[Copied from CTAN homepage]],
  labels = { 'topics of CTAN homepage' },
  homepage = "copied from CTAN homepage. use CTAN homepage if empty",
  license = 'copied from CTAN homepage'
}
```

### Version and Source

Many TeX projects publish TeX package in CTAN or Github/Gitlab release if they
have a git repository. Github release can tag version while CTAN cannot. Such as:

- <https://github.com/latex3/latex2e/releases/download/release-2024-11-01-PL1/latex-graphics.tds.zip>
  is for version 2024-11-01, we package it to 2024.11.01-1
- <http://mirrors.ctan.org/install/macros/latex/contrib/hyperref.tds.zip>
  is for latest version. we package it to scm-1

Version is useful to declare dependency relationship. We recommend stable
version rather than source code managed version.

`package-name-X.Y.Z-1.rockspec`:

```lua
-- ...
local modrev = 'X.Y.Z'
local revision = '1'
version = modrev .. '-' .. specrev

source = {
  url = 'https://github.com/author-name/package-name/archive/' .. modrev .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/package-name.tds.zip',
    dir = '.'
  }
end
```

### Dependencies

CTAN doesn't provide dependence information. You need search it. e.g.,

`tex/latex/base/ltnews.cls`:

```tex
% ...
\IfFileExists{hyperref.sty}{%
  \RequirePackage[hidelinks]{hyperref}}{}
% ...
```

`hyperref` is an optional dependency of `latex-base`.

`package-name-X.Y.Z-1.rockspec`:

```lua
-- ...
dependencies = { 'dependency1', 'dependency2' }
```

### Build Dependencies

#### Build Without Build Systems

Some TeX projects use literal programming. `*.cls` and `*.sty` are generated from
`*.ins` by `docstrip.tex` of `latex-base`:

```sh
luatex --interaction=nonstopmode package-name.ins
```

`package-name-X.Y.Z-1.rockspec`:

```lua
-- ...
build_dependencies = { 'luatex', 'latex-base' }

build = {
  type = 'command',
  build_command = [[
      luatex --interaction=nonstopmode package-name.ins
  ]],
  install = {
    conf = {
      ['../tex/latex/package-name/package-name.sty'] = 'package-name.sty',
    }
  }
}
```

#### Build With Build Systems

There are 3 major build systems for TeX:

- Make: use `Makefile`. such as [texinfo](https://github.com/debian-tex/texinfo)
- Rake: use `Rakefile`. such as [texdoc](https://github.com/TeX-Live/texdoc)
- l3build: use `build.lua`. The most packages use it.

So we create a build backend for l3build.

`package-name-X.Y.Z-1.rockspec`:

```lua
-- ...
build_dependencies = { 'luatex', 'latex-base' }

build = {
  type = 'l3build',
}
```

#### Without Building

For [fonts packages](https://luarocks.org/labels/font), `build.type == 'none'`
is enough:

`package-name-X.Y.Z-1.rockspec`:

```lua
-- ...

build = {
  type = 'none',
  install = {
    conf = {
      ['../fonts/opentype/public/package-name/font-name.otf'] = 'font-name.otf',
    }
  }
}
```

For pure Lua packages like
[chinese-jfm](https://luarocks.org/modules/freed-wu/chinese-jfm),
`build.type == 'builtin'` is enough.

`package-name-X.Y.Z-1.rockspec`:

```lua
-- ...

build = {
  type = 'builtin',
}
```

It will install all `*.lua`, `lua/*.lua` and `src/*.lua`.
If you want to rename them, try:

`package-name-X.Y.Z-1.rockspec`:

```lua
-- ...

build = {
  type = 'builtin',
  modules = {
      ["package-name/new"] = "original.lua",
  }
}
```

It will install `original.lua` to `package-name/new.lua` and skip the
installations of other lua files.

### Test Dependencies

Test dependencies are optional. Such as `l3build`:

`package-name-X.Y.Z-1.rockspec`:

```lua
-- ...

test_dependencies = { 'l3build' }

test = {
  type = 'command',
  command = 'l3build',
  flags = { 'check' },
}
```

## Upload

```sh
luarocks upload package-name-X.Y.Z-1.rockspec
```

<https://luarocks.org/modules/user-name/package-name> will be created.

Remember to add the package to [manifest texmf](https://luarocks.org/m/texmf).

We provide
[all rockspec examples](https://github.com/ustctug/texrocks/tree/main/rockspecs)
for reference.
