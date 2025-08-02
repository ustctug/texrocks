# TeXdef

A reimplementation of <https://github.com/MartinScharrer/texdef/>.

## Show definitions of TeX commands

```sh
$ lx add -b texdef
$ texdef TeX
This is LuaHBTeX, Version 1.23.3 (TeX Live 2026/dev)
 system commands enabled.

\TeX -> T\kern -.1667em\lower .5ex\hbox {E}\kern -.125emX
$ lx remove -b texdef
# it is not a build dependency, just for debug
```

## Search which TeX package define the macro

Only for LaTeX.

<!-- markdownlint-disable MD013 -->

```sh
$ latexdef -fv LaTeX
# ...
\LaTeX: defined by lualatex.fmt
\LaTeX = 0L\kern -.36em{\protect \setbox \z@ \hbox {\color@begingroup T\endgraf \global \let }}
$ latexdef -ffpurl url
# ...
\url: defined by /home/wzy/Desktop/texrocks/packages/texdef/.lux/5.3/9d30c278ce6738129492ba18692faf0bd87368b477c94e5db31e632f16acee21-latex-url@3.4-1/etc/tex/latex/url/url.sty
\url -> \leavevmode \begingroup \Url
```

## List all macros defined by a TeX package

Only for LaTeX.

```sh
$ latexdef -lpurl
# ...
url.sty

\CurrentFile
\CurrentFilePath
\CurrentFilePathUsed
\CurrentFileUsed
\CurrentOption
\DeclareUrlCommand
\Url
\Url Error
\UrlBigBreakPenalty
\UrlBigBreaks
\UrlBreakPenalty
\UrlBreaks
\UrlFont
\UrlLeft
\UrlNoBreaks
\UrlOrds
\UrlRight
\UrlSpecials
\UrlTildeSpecial
\Urlmuskip
\count128
\count13
\count21
\count32
\muskip17
\nolocaldirs
\nolocalwhatsits
\path
\protect
\toks0
\url
\url (moving)
\urldef
\urlstyle
$ latexdef -llpurl
# ...
url.sty
\CurrentFile->
\CurrentFilePath->
\CurrentFilePathUsed->
\CurrentFileUsed->
\CurrentOption->
\DeclareUrlCommand#1#2->\def #1{\leavevmode \begingroup ...
\Url->\Url@movingtest \ifmmode \@inmatherr ...
\Url Error->\url (moving)
\UrlBigBreakPenalty=\mathchar"01F4
\UrlBigBreaks->\do \:\do@url@hyp
\UrlBreakPenalty=\mathchar"02BC
\UrlBreaks->\do \.\do \@ \do \\\do \/\do \!\do ...
\UrlFont->\ttfamily
\UrlLeft->
\UrlNoBreaks->\do \(\do \[\do \{\do \<
\UrlOrds->\do \*\do \-\do \~\do \'\do \"\do ...
\UrlRight->
\UrlSpecials->\do \ {\Url@space }\do \%{\Url@percent ...
\UrlTildeSpecial->\do \~{\raise .45ex\hbox {\m@th ...
\Urlmuskip=\muskip17
\count128=0
\count13=17
\count197=0
\count21=17
\count32=0
\currfilebase->latexdef
\currfiledir->
\currfileext->tex
\currfilename->latexdef.tex
\currfilepath->latexdef.tex
\muskip17=0.0mu
\nolocaldirs=0
\nolocalwhatsits=0
\path->\leavevmode \begingroup \urlstyle ...
\protect=\relax
\toks0=\expandafter \let \csname unproc...
\tracingassigns=0
\unprocessedoptions-url.sty=\unprocessedoptions-url.sty=undefined
\url->\leavevmode \begingroup \Url
\url (moving)=\url (moving)=undefined
\urldef#1#2->\begingroup \setbox \z@ \hbox ...
\urlstyle#1->\expandafter \protect \csname ...
```
