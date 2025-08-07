local git_ref = '1.102.3'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/microsoft/vscode'

rockspec_format = '3.0'
package = 'vscode-extensions'
version = modrev .. '-' .. specrev

description = {
  summary = "Visual Studio Code's builtin extensions for syntax highlight",
  detailed =
  [[See https://github.com/icedman/nvim-textmate/]],
  labels = { 'vscode' },
  homepage = repo_url,
  license = 'GPL-2.0'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'vscode-' .. git_ref,
}

build = {
  type = 'none',
  copy_directories = { 'extensions' },
}
