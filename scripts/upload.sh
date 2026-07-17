#!/usr/bin/env bash
set -e

for i; do
  json="$(curl -sLF "rockspec_file=@$i" "https://luarocks.org/api/1/$LUAROCKS_API_KEY/upload")"
  name="$(echo "$json" | jq -Sr '.manifests[].name')"
  if [[ $name == *texmf* ]]; then
    version="$(echo "$json" | jq -S .version.id)"
    for file in "${i%%rockspec}"*.rock; do
      curl -sLF "rock_file=@$file" "https://luarocks.org/api/1/$LUAROCKS_API_KEY/upload_rock/$version"
    done
  fi
done
