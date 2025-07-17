local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/lm'

rockspec_format = '3.0'
package = 'lm'
version = modrev .. '-' .. specrev

description = {
  summary = [[Latin modern fonts in outline formats]],
  detailed =
  [[The Latin Modern family of fonts consists of 72 text fonts and 20 mathematics fonts, and is based on the Computer Modern fonts released into public domain by AMS (copyright © 1997 AMS). The lm font set contains a lot of additional characters, mainly accented ones, but not exclusively. There is one set of fonts, available both in Adobe Type 1 format (*.pfb) and in OpenType format (*.otf). There are five sets of TeX Font Metric files, corresponding to: Cork encoding (cork-*.tfm); QX encoding (qx-*.tfm); TeX’n’ANSI aka LY1 encoding (texnansi-*.tfm); T5 (Vietnamese) encoding (t5-*.tfm); and Text Companion for EC fonts aka TS1 (ts1-*.tfm).]],
  labels = { 'tex', 'font' },
  homepage = 'https://www.gust.org.pl/projects/e-foundry/latin-modern',
  license = 'GFL'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/fonts/lm.zip',
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'fonts', 'tex' }
}
