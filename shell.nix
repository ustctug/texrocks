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
    (builtins.elemAt texlive.luatex.pkgs 2)
  ];
  shellHook = ''
    export LUAINPUTS="${./.}/lua;${builtins.elemAt buildInputs 0}/share/lua/5.3"
    export CLUAINPUTS="${builtins.elemAt buildInputs 0}/lib/lua/5.3"
  '';
}
