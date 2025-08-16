# Structure

TeXRocks are consist of 3 parts:

## texrocks library

[A core library](https://texrocks.readthedocs.io/en/latest/modules/texrocks.html)
to support all. Its principle is to provide an isolated environment for luahbtex.
[More details](https://texrocks.readthedocs.io/en/latest/topics/principle.md.html).

LOC: ~ 200

## TeX Tools

[Many tools](https://github.com/ustctug/texrocks/tree/main/packages) developed
by us. They aim to replace other TeX tools written in other languages than lua.

In original TeX ecosystem:

- when you want to syntax highlight code in a TeX documents, you need minted
  written in Python.
- When you want to install a TeX package from CTAN, you need tlmgr written
  in Perl.
- When you want to build a LaTeX project, you need arara written in Java or
  latexmk written in Perl.
- When you want to use bibliography, you need biber written in Perl.
- When you want to install TeXLive, you need TeXLive installer GUI written in
  tcl/tk.
- ...

We try to provide a choice of pure lua. We don't reject other languages because
we also provide CLI interfaces like
[`kpsewhich`](https://texrocks.readthedocs.io/en/latest/topics/kpathsea.md.html)
for them. However, if you are tired to install many other languages, we give you
a simple and clean world. Only two dependencies: `lx` and `luahbtex`. Others are
unnecessary.
[More details](https://texrocks.readthedocs.io/en/latest/topics/install.md.html).

LOC: ~ 2000

## TeX Packages

We pack all TeX packages as rock file format different from `*-ctan.zip` and
`*.tds.zip` because rock file format contain a `rockspec` file to provide meta
information, especially dependency relationship.
[More details](https://texrocks.readthedocs.io/en/latest/topics/luarocks-build-l3build.md.html).

LOC: ~ 8000
