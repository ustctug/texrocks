# texdoc

texdoc need a tlpdb database.
Download
[it](https://github.com/ustctug/texrocks/releases/download/0.0.1/Data.tlpdb.lua)
to `~/.local/share/texmf/texdoc/Data.tlpdb.lua`.
Then create `~/.local/share/texmf/texdoc/texdoc.cnf`:

```ini
texlive_tlpdb = /home/user_name/.local/share/texmf/texdoc/Data.tlpdb.lua
```

Now it can work:

```bash
$ texdoc impatient
You don't appear to have any local documentation installed.

There may be online documentation available for "impatient" at
    https://texdoc.org/serve/impatient/0
This documentation may be for a different version than you have installed.

Would you like to search online? (y/N) y
```

<https://texdoc.org/serve/impatient/0> is opened.

For an installed package, you can try `lx doc`:

```bash
$ lx --tree .lux/5.3/build_dependencies doc -p latex-graphics
? Multiple documentation files found. Please select one to open.
^ drivers.pdf
| README.md
| cat.eps
> graphicx.pdf
| keyval.pdf
| grfguide.pdf
v rotating.pdf
[↑↓ to move, enter to select, type to filter]
```
