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
      ['../fonts/source/public/latex-fonts/circle.mf'] = 'mf/circle.mf',
      ['../fonts/source/public/latex-fonts/icmcsc10.mf'] = 'mf/icmcsc10.mf',
      ['../fonts/source/public/latex-fonts/icmex10.mf'] = 'mf/icmex10.mf',
      ['../fonts/source/public/latex-fonts/icmmi8.mf'] = 'mf/icmmi8.mf',
      ['../fonts/source/public/latex-fonts/icmsy8.mf'] = 'mf/icmsy8.mf',
      ['../fonts/source/public/latex-fonts/icmtt8.mf'] = 'mf/icmtt8.mf',
      ['../fonts/source/public/latex-fonts/ilasy8.mf'] = 'mf/ilasy8.mf',
      ['../fonts/source/public/latex-fonts/ilcmss8.mf'] = 'mf/ilcmss8.mf',
      ['../fonts/source/public/latex-fonts/ilcmssb8.mf'] = 'mf/ilcmssb8.mf',
      ['../fonts/source/public/latex-fonts/ilcmssi8.mf'] = 'mf/ilcmssi8.mf',
      ['../fonts/source/public/latex-fonts/lasy.mf'] = 'mf/lasy.mf',
      ['../fonts/source/public/latex-fonts/lasy5.mf'] = 'mf/lasy5.mf',
      ['../fonts/source/public/latex-fonts/lasy6.mf'] = 'mf/lasy6.mf',
      ['../fonts/source/public/latex-fonts/lasy7.mf'] = 'mf/lasy7.mf',
      ['../fonts/source/public/latex-fonts/lasy8.mf'] = 'mf/lasy8.mf',
      ['../fonts/source/public/latex-fonts/lasy9.mf'] = 'mf/lasy9.mf',
      ['../fonts/source/public/latex-fonts/lasy10.mf'] = 'mf/lasy10.mf',
      ['../fonts/source/public/latex-fonts/lasyb10.mf'] = 'mf/lasyb10.mf',
      ['../fonts/source/public/latex-fonts/lcircle10.mf'] = 'mf/lcircle10.mf',
      ['../fonts/source/public/latex-fonts/lcirclew10.mf'] = 'mf/lcirclew10.mf',
      ['../fonts/source/public/latex-fonts/lcmss8.mf'] = 'mf/lcmss8.mf',
      ['../fonts/source/public/latex-fonts/lcmssb8.mf'] = 'mf/lcmssb8.mf',
      ['../fonts/source/public/latex-fonts/lcmssi8.mf'] = 'mf/lcmssi8.mf',
      ['../fonts/source/public/latex-fonts/line.mf'] = 'mf/line.mf',
      ['../fonts/source/public/latex-fonts/line10.mf'] = 'mf/line10.mf',
      ['../fonts/source/public/latex-fonts/linew10.mf'] = 'mf/linew10.mf',
      ['../fonts/source/public/latex-fonts/sroman.mf'] = 'mf/sroman.mf',
      ['../fonts/source/public/latex-fonts/sromanu.mf'] = 'mf/sromanu.mf',
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
