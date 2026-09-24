#!/usr/bin/env bash
set -e

MANIFEST_URL="https://luarocks.org/manifest.json"
# cache
MANIFEST_JSON="$(curl -fsSL "$MANIFEST_URL")"

have_arch() {
  # $1 = pkg, $2 = ver, $3 = arch
  printf '%s' "$MANIFEST_JSON" |
    jq -e --arg p "$1" --arg v "$2" --arg a "$3" '.repository[$p][$v] | map(.arch) | index($a)' >/dev/null 2>&1
}

for i; do
  [ -e "$i" ] || {
    echo "skip: no such file: $i" >&2
    continue
  }

  bn=$(basename "$i")

  case "$bn" in
  *.rock) ;;
  *)
    echo "skip: not a .rock: $i" >&2
    continue
    ;;
  esac

  # luahbtex-1.27.0-1.linux-x86_64.rock -> luahbtex-1.27.0-1.linux-x86_64
  base=${bn%.rock}

  # luahbtex-1.27.0-1.linux-x86_64 -> linux-x86_64
  arch=${base##*.}
  # luahbtex-1.27.0-1.linux-x86_64 -> luahbtex-1.27.0-1
  rest=${base%.*}
  # luahbtex-1.27.0-1 -> 1.27.0-1
  ver=${rest#*-}
  # luahbtex-1.27.0-1 -> luahbtex
  pkg=${rest%%-*}

  if [ -z "$pkg" ] || [ -z "$ver" ] || [ -z "$arch" ]; then
    echo "skip: cannot parse $bn" >&2
    continue
  fi

  # luahbtex-1.27.0-1.linux-x86_64.rock -> luahbtex-1.27.0-1.rockspec
  file=${i%.*.rock}.rockspec
  if [ ! -e "$file" ]; then
    echo "skip: rockspec not found: $file" >&2
    continue
  fi

  if [ -n "$SKIP" ] && have_arch "$pkg" "$ver" "$arch"; then
    echo "skip: $bn already on luarocks"
    continue
  fi

  resp=$(curl -sLF "rockspec_file=@$file" "https://luarocks.org/api/1/$LUAROCKS_API_KEY/upload")
  version=$(printf '%s' "$resp" | jq -S .version.id)

  if [ -z "$version" ] || [ "$version" = "null" ]; then
    echo "upload rockspec failed, resp: $resp" >&2
    continue
  fi

  curl -sLF "rock_file=@$i" "https://luarocks.org/api/1/$LUAROCKS_API_KEY/upload_rock/$version"
done
