local git_ref = '0.0.1'
local modrev = git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'latex-fonts'
version = modrev .. '-' .. specrev

description = {
  summary = 'A collection of fonts used in LaTeX distributions',
  detailed =
  [[This is a collection of fonts for use with standard LaTeX packages and classes. It includes ‘invisible’ fonts (for use with the slides class), line and circle fonts (for use in the picture environment) and ‘LaTeX symbol’ fonts.

For full support of a LaTeX installation, some Computer Modern font variants cmbsy(6-9), cmcsc(8,9), cmex(7-9) and cmmib(5-9) from the amsfonts distribution, are also necessary.

The fonts are available as METAFONT source, and metric (tfm) files are also provided. Most of the fonts are also available in Adobe Type 1 format, in the amsfonts distribution.]],
  labels = { 'tex', 'metafont', 'font' },
  homepage = 'https://ctan.org/pkg/latex-fonts',
  license = 'Knuth'
}

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/latex.zip",
  dir = "latex"
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/fonts/latex.zip',
    dir = "latex"
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../fonts/tfm/public/latex-fonts/icmcsc10.tfm'] = 'tfm/icmcsc10.tfm',
      ['../fonts/tfm/public/latex-fonts/icmex10.tfm'] = 'tfm/icmex10.tfm',
      ['../fonts/tfm/public/latex-fonts/icmmi8.tfm'] = 'tfm/icmmi8.tfm',
      ['../fonts/tfm/public/latex-fonts/icmsy8.tfm'] = 'tfm/icmsy8.tfm',
      ['../fonts/tfm/public/latex-fonts/icmtt8.tfm'] = 'tfm/icmtt8.tfm',
      ['../fonts/tfm/public/latex-fonts/ilasy8.tfm'] = 'tfm/ilasy8.tfm',
      ['../fonts/tfm/public/latex-fonts/ilcmss8.tfm'] = 'tfm/ilcmss8.tfm',
      ['../fonts/tfm/public/latex-fonts/ilcmssb8.tfm'] = 'tfm/ilcmssb8.tfm',
      ['../fonts/tfm/public/latex-fonts/ilcmssi8.tfm'] = 'tfm/ilcmssi8.tfm',
      ['../fonts/tfm/public/latex-fonts/lasy5.tfm'] = 'tfm/lasy5.tfm',
      ['../fonts/tfm/public/latex-fonts/lasy6.tfm'] = 'tfm/lasy6.tfm',
      ['../fonts/tfm/public/latex-fonts/lasy7.tfm'] = 'tfm/lasy7.tfm',
      ['../fonts/tfm/public/latex-fonts/lasy8.tfm'] = 'tfm/lasy8.tfm',
      ['../fonts/tfm/public/latex-fonts/lasy9.tfm'] = 'tfm/lasy9.tfm',
      ['../fonts/tfm/public/latex-fonts/lasy10.tfm'] = 'tfm/lasy10.tfm',
      ['../fonts/tfm/public/latex-fonts/lasyb10.tfm'] = 'tfm/lasyb10.tfm',
      ['../fonts/tfm/public/latex-fonts/lcircle10.tfm'] = 'tfm/lcircle10.tfm',
      ['../fonts/tfm/public/latex-fonts/lcirclew10.tfm'] = 'tfm/lcirclew10.tfm',
      ['../fonts/tfm/public/latex-fonts/lcmss8.tfm'] = 'tfm/lcmss8.tfm',
      ['../fonts/tfm/public/latex-fonts/lcmssb8.tfm'] = 'tfm/lcmssb8.tfm',
      ['../fonts/tfm/public/latex-fonts/lcmssi8.tfm'] = 'tfm/lcmssi8.tfm',
      ['../fonts/tfm/public/latex-fonts/line10.tfm'] = 'tfm/line10.tfm',
      ['../fonts/tfm/public/latex-fonts/linew10.tfm'] = 'tfm/linew10.tfm',
    }
  }
}
