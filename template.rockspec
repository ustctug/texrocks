local git_ref = '$git_ref'
local modrev = '$modrev'
local specrev = '$specrev'

local repo_url = '$repo_url'

rockspec_format = '3.0'
package = '$package'
version = modrev ..'-'.. specrev

description = {
  summary = '$summary',
  detailed = $detailed_description,
  labels = $labels,
  homepage = '$homepage',
  $license
}

-- for luatex/lualatex/luatexinfo/initex
-- luahbtex versions of build/run time must be same
-- (Fatal format file error; I'm stymied)
-- so pin versions:
-- 1. luahbtex -> texrocks
-- 2. texrocks -> luatex/lualatex/luatexinfo/initex
dependencies = { "luahbtex == 1.27.0", "argparse", "lua-cjson", "prompt-style" }

test_dependencies = $test_dependencies

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = '$repo_name-' .. '$archive_dir_suffix',
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = repo_url:gsub('https', 'git')
  }
end

build = {
  type = 'builtin',
  install = {
    bin = { "bin/texlua" },
  }
}

test = {
   type = "busted",
}

deploy = {
  wrap_bin_scripts = false
}
