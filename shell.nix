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
    # how lx find lua
    pkg-config
    lux-cli

    rename
    # texrocks -> prompt-style -> luaprompt
    readline

    (lua5_3.withPackages (
      p: with p; [
        busted
        ldoc

        luarocks
      ]
    ))

    # ghostscript
    autoconf
    automake

    # texdef -> minijinja-lua
    rustup

    # bibtex -> web2c
    flex
    bison
  ];
}
