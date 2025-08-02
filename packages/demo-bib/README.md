# Use Bibliography

One convenient feature is that TeX supports bibliography. For the data of
bibliography, there are many file formats to record data:

- bib: introduced by [bibtex](https://tug.org/bibtex/). Many websites provides
  bib file, such as <https://scholar.google.com/>. <https://arxiv.org/> even
  only provides bib files.
- ris: supported by many software. such as EndNote, Zotero, Mendeley and TeX's
  [biber](https://github.com/plk/biber).
- [hayagriva YAML](https://github.com/typst/hayagriva): introduced by
  [typst](typst.app/). However, there still doesn't exist any TeX package to
  handle it.

There still needs some file formats record the style of bibliography:

- bst: introduced by [bibtex](https://tug.org/bibtex/)
- [csl XML](https://citationstyles.org/): supported by many software.

There exist some tools to handle bibliography for TeX:

- bibtex: accept bib and bst. Written in C.
- biber: accept bib/ris and bst. Written in Perl.
- citeproc-lua: accept bib and csl. Written in Lua.

We only support [citeproc-lua](https://github.com/zepinglee/citeproc-lua/)
currently. Run `lx build` for
[this example](https://github.com/ustctug/texrocks/tree/main/packages/demo-bib).
