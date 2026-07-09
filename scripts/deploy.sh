#!/usr/bin/env bash
set -e
cd "$(dirname "$(dirname "$(readlink -f "$0")")")"

luarocks config variables.ZIP rpzip
# https://github.com/luarocks/luarocks/issues/1817
echo local_by_default = true >>~/work/texrocks/texrocks/.luarocks/etc/luarocks/config-5.3.lua
luarocks install rpzip
# https://github.com/speedata/publisher/issues/665
luarocks install publisher --server=https://ustctug.github.io/texrocks
luarocks install luahbtex --server=https://ustctug.github.io/texrocks
luarocks install nvim-textmate --server=https://ustctug.github.io/texrocks
luarocks install ltreesitter --server=https://ustctug.github.io/texrocks
luarocks install luatexinfo
luarocks install lualatex
luarocks install texcat
luarocks install texdef
luarocks install standalone
luarocks install hologo
luarocks install citation-style-language
luarocks install beamer
luarocks install ctex
luarocks install markdown2tex
luarocks install babel-base
luarocks install hypdoc
luarocks install ydoc
rm -f ./*.rock
luarocks list --porcelain |
  sed 's/\(\S\+\).*/luarocks pack \1 \&\& luarocks download --rockspec \1/' |
  sh
# https://github.com/luarocks/luarocks/issues/1817
rename -f s/linux-x86_64/all/ texrocks-*.rock
luarocks-admin make-manifest .
zip manifest-5.3.zip manifest-5.3
scripts/process-index.html.pl index.html
rm -f ./*.rockspec manifest{,-5.{1..5}}
