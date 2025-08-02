# Kpathsea

Some TeX tools written in other languages will call `kpsewhich`. This program
provide this CLI API. You can search package by:

```sh
$ lx add -b kpathsea
$ kpsewhich url.sty
/home/wzy/Desktop/texrocks/packages/kpathsea/.lux/5.3/test_dependencies/5.3/9d30c278ce6738129492ba18692faf0bd87368b477c94e5db31e632f16acee21-latex-url@3.4-1/etc/tex/latex/url/url.sty
$ lx remove -b kpathsea
# it is not a build dependency, just for debug
```
