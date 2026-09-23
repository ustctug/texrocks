#!/usr/bin/env bash
set -e
WD="$(dirname "$(dirname "$(readlink -f "$0")")")"

for i; do
  luarocks install "$i"
done
luarocks list --porcelain |
  sed 's/\(\S\+\).*/luarocks pack \1 \&\& luarocks download --rockspec \1/' |
  sh

# https://github.com/luarocks/luarocks/issues/1817
for f in texrocks-*.rock texdef-*.rock; do
  if [ -f "$f" ]; then
    rename -f 's/linux-x86_64/all/' "$f"
  fi
done

"$WD/scripts/upload.sh" ./*.rock
luarocks-admin make-manifest .
zip "manifest-$LUA_VERSION.zip" "manifest-$LUA_VERSION"
"$WD/scripts/process-index.html.pl" index.html
rm -f ./*.rockspec manifest{,-5.{1..5}}
