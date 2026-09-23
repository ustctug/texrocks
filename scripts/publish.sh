#!/usr/bin/env bash
# scripts/publish.sh packages/*
set -e
cd "$(dirname "$(dirname "$(readlink -f "$0")")")"

for dir; do
  cd "$dir"
  rm -f ./*.rock{,spec}
  lx generate-rockspec
  perl -pi -e's/[>=]=/ >= /' ./*.rockspec
  luarocks upload --force ./*.rockspec
  luarocks install ./*.src.rock
  luarocks pack "$(basename "$dir")"
  cd -
  scripts/upload.sh "$dir"/*.all.rock
done
