{
  pkgs ? import <nixpkgs> { },
}:

let
  nur =
    import
      (fetchTarball {
        url = "https://github.com/nix-community/NUR/archive/c4c8c2c84de63e1abb84953d4ac4f550f4069347.tar.gz";
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
