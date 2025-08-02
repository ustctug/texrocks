{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;
mkShell {
  name = "texrocks";
  env = {
    HISTORY_INCDIR = "${readline.dev}/include";
    HISTORY_LIBDIR = "${readline.out}/lib";
    READLINE_INCDIR = "${readline.dev}/include";
    READLINE_LIBDIR = "${readline.out}/lib";
  };
  buildInputs = [
    # https://github.com/nvim-neorocks/lux/issues/789
    pkg-config

    readline
    rename

    # too old
    # lux-cli

    (lua5_3.withPackages (
      p: with p; [
        busted
        ldoc
      ]
    ))
  ];
}
