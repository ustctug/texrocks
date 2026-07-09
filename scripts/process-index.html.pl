#!/usr/bin/env -S perl -pi
s@href="([^"/]+).rockspec"@href="https://github.com/ustctug/texrocks/tree/main/\1.rockspec"@;
$_ = '' if /Lua 5.[1245] manifest file/;
