#!/usr/bin/env bash
set -e
cd "$(dirname "$(dirname "$(readlink -f "$0")")")"
cd packages

dirs=("$1")
if (( ${#dirs} == 0 )); then
  dirs=(./*/)
fi

rm -f ./*/*.rock{,spec}
for dir in "${dirs[@]}"; do
  if [[ "$dir" = ./demo-*/ ]]; then
    continue
  fi
  cd "$dir"
  lx generate-rockspec
  perl -pi -e's/[>=]=/ >= /' ./*.rockspec
  luarocks upload --force ./*.rockspec
  cd ..
done
rm -f ./*/*.rock{,spec}
