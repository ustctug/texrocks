{
  pkgs ? import <nixpkgs> { },
}:

let
  nur =
    import
      (fetchTarball {
        url = "https://github.com/nix-community/NUR/archive/2a187cd9c92887f2af5833696b510288844eb49b.tar.gz";
      })
      {
        inherit pkgs;
      };
in
with pkgs;
mkShell {
  name = "texrocks";
  buildInputs = [
    # how lx find lua
    pkg-config
    lux-cli
    nur.repos.Freed-Wu.luahbtex

    rename

    (lua5_3.withPackages (
      p: with p; [
        busted
        ldoc
      ]
    ))
  ];
}
