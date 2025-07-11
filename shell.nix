{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;
mkShell rec {
  name = "texrocks";
  buildInputs = [
    lux-cli

    (lua5_3.withPackages (
      p: with p; [
        argparse

        busted
        ldoc
      ]
    ))
    (builtins.elemAt texlive.luatex.pkgs 2)
  ];
}
