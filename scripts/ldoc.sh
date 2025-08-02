#!/usr/bin/env bash
set -e
cd "$(dirname "$(dirname "$(readlink -f "$0")")")"

asdf_path="$HOME/.asdf/installs/lua/5.1/luarocks/bin"
if [[ -d "$asdf_path" ]]; then
  PATH="$asdf_path:$PATH"
fi

rm -rf _readthedocs/{markdown,lua}
install -d _readthedocs/{markdown,lua}
if [ -z "$READTHEDOCS_OUTPUT" ]; then
  rename 's|packages/([^/]+)/README\.md|_readthedocs/markdown/\1.md|' packages/*/README.md
else
  rename 'packages/([^/]+)/README\.md' '_readthedocs/markdown/\1.md'
fi
cp -r packages/*/lua/* _readthedocs/lua
ldoc .
