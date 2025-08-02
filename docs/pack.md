# Pack

[Some examples](https://github.com/ustctug/texrocks/tree/main/rockspecs).

## Version

Many TeX projects publish TeX package in CTAN or Github/Gitlab release if they
have a git repository. Github release can tag version while CTAN cannot. Such as:

- <https://github.com/latex3/latex2e/releases/download/release-2024-11-01-PL1/latex-graphics.tds.zip>
  is for version 2024-11-01, we package it to 2024.11.01-1
- <http://mirrors.ctan.org/install/macros/latex/contrib/hyperref.tds.zip>
  is for latest version. we package it to scm-1

Version is useful to declare dependency relationship. We recommend stable
version rather than source code managed version.

## Formats

TeX packages have two formats:

- source package `*-ctan.zip`, like lua's `*.src.rock` and python's sdist
  `*.tar.gz`, include `*.dts` and `*.ins`
- binary package `*.tds.zip`, like lua's `*.any.rock` and python's `*-any.whl`,
  include `*.cls` and `*.sty`

We repack `*.tds.zip` if upstream provide else `*-ctan.zip` even git zip file
to `*.src.rock`.

## Dependencies

`*.tds.zip` doesn't have meta information about packages. when we create
`*.rockspec`, we need to add it from [CTAN](https://ctan.org/).

CTAN doesn't provide dependence information. You need search it. e.g.,

`tex/latex/base/ltnews.cls`:

```tex
% ...
\IfFileExists{hyperref.sty}{%
  \RequirePackage[hidelinks]{hyperref}}{}
% ...
```

`hyperref` is an optional dependency of `latex-base`.

## Build Dependencies

Some TeX packages don't provide `*.tds.zip`. You have to build it from
`*-ctan.zip` or git zip.

```sh
luatex --interaction=nonstopmode foo.ins
```

add `{ 'luatex', 'latex-base' }` to `build_dependencies`.
