local git_ref = 'v3.29'
local modrev = git_ref:gsub('v', '')
local specrev = '1'

local repo_url = 'https://github.com/latex3/luaotfload'

rockspec_format = '3.0'
package = 'luaotfload'
version = modrev .. '-' .. specrev

build_dependencies = { 'luatex', 'latex-base', 'kpathsea' }

dependencies = { 'lualibs', 'lua-uni-algos' }

description = {
  summary = 'OpenType ‘loader’ for Plain TeX and LaTeX',
  detailed =
  [[The package adopts the TrueType/OpenType Font loader code provided in ConTeXt, and adapts it to use in Plain TeX and LaTeX. It works under LuaLaTeX only.]],
  labels = { 'Font use', 'LuaTeX' },
  homepage = repo_url,
  license = 'GPL-2.0'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = repo_url:gsub('https', 'git+https')
  }
end

build = {
  type = 'l3build',
  variables = {
    GITHUB_REF_TYPE = 'tag',
    GITHUB_REF_NAME = git_ref,
  }
}

deploy = {
  wrap_bin_scripts = false
}
