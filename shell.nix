{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;
mkShell {
  name = "texrocks";
  buildInputs = [
    # https://github.com/nvim-neorocks/lux/issues/789
    pkg-config

    # too old
    # lux-cli

    (lua5_3.withPackages (
      p: with p; [
        # busted
        # ldoc
      ]
    ))
    # too large
    # (builtins.elemAt texlive.luatex.pkgs 2)
  ];
}
