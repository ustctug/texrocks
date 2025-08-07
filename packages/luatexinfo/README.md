# TeXinfo

TeXinfo is a TeX dialect designed by GNU. It uses `@` to start a control sequence,
which is different from other TeX dialects. GNU also create some perl programs
to convert texinfo to `info`, `HTML`, ..., while other TeX dialects doesn't have
good support for outputting HTML like [TeX4ht](https://tug.org/tex4ht/) for
PlainTeX/LaTex/ConTeXt.

`main.texi`:

```texinfo
@node Top
@top Example

@node First Chapter
@nodedescription The first chapter is the only chapter in this sample.
@chapter Hello, @TeX{}info

@cindex chapter, first
This is the first chapter.
@bye
```

```sh
lx add -b luatexinfo
lx shell --build
luatexinfo main.texi
```

![texinfo](https://github.com/user-attachments/assets/35507747-65ba-4d76-bfec-a614826ce4c7)
