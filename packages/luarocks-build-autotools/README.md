# luarocks-build-autotools

A luarocks build module based on autotools.

## Usage

```lua
build = {
   type = "autotools",
   variables = {
      autotools = {
         CFLAGS = "-O2 -fPIC -std=c99 -D_GNU_SOURCE",
      }
   },
   autoreconf = false,
   configure_command = "./configure",
   configure_options = {
      "--disable-dbus",
   }
}
```

It will do:

- call `autoreconf -vif` when `configure` doesn't exist
- call `./configure` with correct `prefix`, `libdir`, `datadir`
- `make`
- copy dynamic libraries in `.libs` and `_libs` to luarocks lib directory
- copy lua files to luarocks lua directory
