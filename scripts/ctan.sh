#!/usr/bin/env bash
set -e
cd "$(dirname "$(dirname "$(readlink -f "$0")")")"

l3build ctan
cd packages
for dir in ./*/; do
  if [[ ! -e "$dir/build.lua" ]]; then
    continue
  fi
  cd "$dir"
  l3build ctan
  cp build/distrib/ctan/*-ctan.zip ../../build/distrib/ctan
  cp build/distrib/tds/*.tds.zip ../../build/distrib/tds
  cd ..
done
