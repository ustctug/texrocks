{
  pkgs ? import <nixpkgs> { },
}:

with pkgs;
mkShell rec {
  name = "texrocks";
  buildInputs = [
    (lua5_3.withPackages (
      p: with p; [
        argparse
        luafilesystem
        luarocks

        busted
        ldoc
      ]
    ))
  ];
  shellHook = ''
    export LUAINPUTS_luahbtex="${./.}/lua;${builtins.elemAt buildInputs 0}/share/lua/5.3"
    export CLUAINPUTS_luahbtex="${builtins.elemAt buildInputs 0}/lib/lua/5.3"
  '';
}
