{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;
mkShell {
  name = "epstopdf";
  buildInputs = [
    # how lx find lua
    pkg-config
    lux-cli

    ghostscript

    (lua5_3.withPackages (
      p: with p; [
        busted
        ldoc
      ]
    ))
  ];
}
