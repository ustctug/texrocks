# epstopdf

Reimplement <https://ctan.org/pkg/epstopdf> by texlua to reduce dependency of perl.

For:

```tex
\includegraphics{XXX.pdf}
```

```sh
lx add -b graphics-cfg
```

is enough. For:

```tex
\includegraphics{XXX.eps}
```

Extra build dependency is needed, and make sure you have installed ghostscript in
your system.

```sh
lx add -b epstopdf
```
