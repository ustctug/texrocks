local M = {}
M.LUA_VERSION = _VERSION:gsub('[^ ]* ', '')
M.ROCKS_VERSION = "0.0.1"
M.texmf_cnf = string.gsub([[% ---------------------------
% Search Path and Directories
% ---------------------------
% TDS
TEXMFROOT     = $SELFAUTODIR
TEXMFDIST     = $TEXMFROOT/texmf
MINGW_PREFIX  = /mingw
% Android termux will set it to /data/data/com.termux/files/usr
PREFIX        = $MINGW_PREFIX;/usr;/usr/local;/run/current-system/sw
PREFIXS        = {~/.local,$PREFIX}
% https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
XDG_DATA_HOME = ~/.local/share
XDG_CACHE_HOME= ~/.cache
XDG_CONFIG_HOME= ~/.config
TEXMFHOME     = $XDG_DATA_HOME/texmf
TEXMFVAR      = $XDG_CACHE_HOME/texmf
TEXMFCONFIG   = $XDG_CONFIG_HOME/texmf
TEXMF         = {$TEXMFCONFIG,$TEXMFHOME,$TEXMFVAR,$TEXMFDIST,%s}
TEXMFCACHE    = $TEXMFVAR
WEB2C         = $TEXMF/web2c
TEXMFDOTDIR   = .
TEXINPUTS     = $TEXMFDOTDIR;$TEXMF/tex/{luatex,plain,generic,latex,}//
LUAINPUTS     = $TEXMFDOTDIR;$PREFIXS/share/lua/5.3
CLUAINPUTS    = $TEXMFDOTDIR;$PREFIXS/lib/lua/5.3
MFINPUTS      = $TEXMFDOTDIR;$TEXMF/metafont//
MPINPUTS      = $TEXMFDOTDIR;$TEXMF/metapost//
TEXFORMATS    = $TEXMFDOTDIR;$TEXMF/web2c{/$engine,}
TEXFONTMAPS   = $TEXMFDOTDIR;$TEXMF/fonts/map/{$progname,}//
OSFONTDIR     = {/System,}/Library/Fonts//;$PREFIXS/share/fonts//
T1FONTS       = $TEXMFDOTDIR;$TEXMF/fonts/type1//;$OSFONTDIR
TTFONTS       = $TEXMFDOTDIR;$TEXMF/fonts/truetype//;$OSFONTDIR
OPENTYPEFONTS = $TEXMFDOTDIR;$TEXMF/fonts/opentype//;$OSFONTDIR
OFMFONTS      = $TEXMFDOTDIR;$TEXMF/fonts/ofm//;$OSFONTDIR
TFMFONTS      = $TEXMFDOTDIR;$TEXMF/fonts/tfm//;$OSFONTDIR
OVFFONTS      = $TEXMFDOTDIR;$TEXMF/fonts/ovf//;$OSFONTDIR
VFFONTS       = $TEXMFDOTDIR;$TEXMF/fonts/vf//;$OSFONTDIR
% it has been determined during compiling
% TEXMFCNF      = {$TEXMFCONFIG,$TEXMFHOME,$SELFAUTODIR}/web2c
TEXMFOUTPUT   = /tmp
MISSFONT_LOG  = missfont.log
% -------
% Options
% -------
try_std_extension_first = t
shell_escape            = p
shell_escape_commands   = f
openin_any              = a
openout_any             = p
parse_first_line        = t
log_openout             = t
file_line_error_style   = t
texmf_casefold_search   = 1
% -------------
% Sizes for TeX
% -------------
main_memory      = 5000000
extra_mem_top    = 0
extra_mem_bot    = 0
font_mem_size    = 8000000
font_max         = 9000
hash_extra       = 600000
pool_size        = 6250000
string_vacancies = 90000
max_strings      = 500000
pool_free        = 47500
strings_free     = 100
buf_size         = 200000
trie_size        = 1100000
hyph_size        = 8191
nest_size        = 1000
max_in_open      = 15
param_size       = 20000
save_size        = 200000
stack_size       = 10000
ocp_buf_size     = 500000
ocp_stack_size   = 10000
ocp_list_size    = 1000
error_line       = 79
half_error_line  = 50
max_print_line   = 79]], '%% ', '%%%% ')
M.luatex_map = string.gsub([[% Copyright (C) 1999, 2000, 2001 Donald E. Knuth <knuth-bug@cs.stanford.edu>.
% Copyright (C) 2001, 2009, 2013 American Mathematical Society <tech-support@ams.org>.
% Licensed under the SIL Open Font License, Version 1.1.

%s

% ex: filetype=texmf]], '%% ', '%%%% ')
return M
