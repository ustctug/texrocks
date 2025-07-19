local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/ncctools'

rockspec_format = '3.0'
package = 'ncctools'
version = modrev .. '-' .. specrev

description = {
  summary = [[A collection of general packages for LaTeX]],
  detailed =
  [[The NCCtools bundle contains many packages for general use under LaTeX; many are also used by NCC LaTeX. The bundle includes tools for:

    executing commands after a package is loaded;
    watermarks;
    counter manipulation (dynamic counters, changing counter numbering with another counter);
    improvements to the description environment;
    hyphenation of compound words;
    new levels of footnotes;
    space-filling patterns;
    “poor man’s” Black Board Bold symbols;
    alignment of the content of a box;
    use comma as decimal separator;
    boxes with their own crop marks;
    page cropmarks;
    improvements to fancy headers;
    float “styles”, mini floats, side floats;
    manually marked footnotes;
    extension of amsmath;
    control of paragraph skip; an envelope to the graphicx package;
    dashed and multiple rules;
    alternative techniques for declarations of sections, captions, and toc-entries;
    generalised text-stretching;
    generation of new theorem-like environments;
    control of the text area;
    centred page layouts; and
    un-numbered top-level section.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.0'
}

build_dependencies = { 'lualatex', 'latex-base' }

dependencies = { 'latex-amsmath' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/ncctools.zip',
    dir = 'source'
  }
end

build = {
  type = 'command',
  build_command = [[
    lualatex --interaction=nonstopmode ncctools.ins
  ]],
  copy_directories = { '../doc' },
  install = {
    conf = {
      ['../tex/latex/ncctools/afterpackage.sty'] = 'source/afterpackage.sty',
      ['../tex/latex/ncctools/dcounter.sty'] = 'source/dcounter.sty',
      ['../tex/latex/ncctools/desclist.sty'] = 'source/desclist.sty',
      ['../tex/latex/ncctools/extdash.sty'] = 'source/extdash.sty',
      ['../tex/latex/ncctools/manyfoot.sty'] = 'source/manyfoot.sty',
      ['../tex/latex/ncctools/mboxfill.sty'] = 'source/mboxfill.sty',
      ['../tex/latex/ncctools/nccbbb.sty'] = 'source/nccbbb.sty',
      ['../tex/latex/ncctools/nccboxes.sty'] = 'source/nccboxes.sty',
      ['../tex/latex/ncctools/ncccomma.sty'] = 'source/ncccomma.sty',
      ['../tex/latex/ncctools/ncccropbox.sty'] = 'source/ncccropbox.sty',
      ['../tex/latex/ncctools/ncccropmark.sty'] = 'source/ncccropmark.sty',
      ['../tex/latex/ncctools/nccfancyhdr.sty'] = 'source/nccfancyhdr.sty',
      ['../tex/latex/ncctools/nccfloats.sty'] = 'source/nccfloats.sty',
      ['../tex/latex/ncctools/nccfoots.sty'] = 'source/nccfoots.sty',
      ['../tex/latex/ncctools/nccmath.sty'] = 'source/nccmath.sty',
      ['../tex/latex/ncctools/nccparskip.sty'] = 'source/nccparskip.sty',
      ['../tex/latex/ncctools/nccpic.sty'] = 'source/nccpic.sty',
      ['../tex/latex/ncctools/nccrules.sty'] = 'source/nccrules.sty',
      ['../tex/latex/ncctools/nccsect.sty'] = 'source/nccsect.sty',
      ['../tex/latex/ncctools/nccstretch.sty'] = 'source/nccstretch.sty',
      ['../tex/latex/ncctools/nccthm.sty'] = 'source/nccthm.sty',
      ['../tex/latex/ncctools/textarea.sty'] = 'source/textarea.sty',
      ['../tex/latex/ncctools/tocenter.sty'] = 'source/tocenter.sty',
      ['../tex/latex/ncctools/topsection.sty'] = 'source/topsection.sty',
      ['../tex/latex/ncctools/watermark.sty'] = 'source/watermark.sty',
    }
  }
}
