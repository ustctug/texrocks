# lua-open

Open compiled PDF. lux only provide a variable `$(PREFIX)` for `lux.toml`, no
any method to get built package path. So we read `lux.toml` to get package name
and package version, then search it in `package.path`.
