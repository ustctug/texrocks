{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;
mkShell {
  name = "rpzip";
  buildInputs = [
    # how lx find lua
    pkg-config
    lux-cli

    (lua5_3.withPackages (
      p: with p; [
        busted
        ldoc
      ]
    ))
  ];
}
