# TeXinfo

TeXinfo is a TeX dialect designed by GNU. It uses `@` to start a control sequence,
which is different from other TeX dialects. GNU also create some perl programs
to convert texinfo to `info`, `HTML`, ..., while other TeX dialects doesn't have
good support for outputting HTML like [TeX4ht](https://tug.org/tex4ht/) for
PlainTeX/LaTex/ConTeXt.

```sh
dvipdfmx main.dvi
pdftocairo -png main.pdf
magick convert main-1.png -crop 50%x10% main.png
```

![texinfo](https://github.com/user-attachments/assets/35507747-65ba-4d76-bfec-a614826ce4c7)
