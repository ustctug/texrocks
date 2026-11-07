#!/usr/bin/env bash
set -e
WD="$(dirname "$(dirname "$(readlink -f "$0")")")"

for i; do
  luarocks install "$i"
done
# https://github.com/luarocks/luarocks/issues/1817
luarocks list --porcelain |
  sed 's/\(\S\+\).*/luarocks pack --local \1 \&\& luarocks download --rockspec \1/' |
  sh

"$WD/scripts/upload.sh" ./*.rock
luarocks-admin make-manifest .
zip "manifest-$LUA_VERSION.zip" "manifest-$LUA_VERSION"
"$WD/scripts/process-index.html.pl" index.html
rm -f ./*.rockspec manifest{,-5.{1..5}}
