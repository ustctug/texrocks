#!/usr/bin/env bash
set -e
cd "$(dirname "$(dirname "$(readlink -f "$0")")")"

cd packages
rm -f ./*/*.rock{,spec}
for dir in ./*/; do
  if [[ "$dir" = ./demo-*/ ]]; then
    continue
  fi
  cd "$dir"
  lx generate-rockspec
  luarocks upload --force ./*.rockspec
  cd ..
done
rm -f ./*/*.rock{,spec}
