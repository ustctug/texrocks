local git_ref = '0.0.1'
local modrev = git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'cm-tfm'
version = modrev .. '-' .. specrev

description = {
  summary = 'Model TeX format creation files',
  detailed =
  [[Knuth's final iteration of his re-interpretation of a c.19 Modern-style font from Monotype. The family is comprehensive, offering both sans and roman styles, and a monospaced font, together with mathematics fonts closely integrated with the mathematical facilities of TeX itself.
  The base fonts are distributed as METAFONT source, but autotraced PostScript Type 1 versions are available (one version in the AMS fonts distribution, and also the BaKoMa distribution).
  The Computer Modern fonts have inspired many later families, notably the European Computer Modern and the Latin Modern families.]],
  labels = { 'tex', 'metafont', 'font' },
  homepage = 'https://ctan.org/pkg/cm-tfm',
  license = 'Knuth'
}

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/tfm.zip",
  dir = 'tfm'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/fonts/cm/tfm.zip',
    dir = 'tfm'
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../fonts/tfm/public/cm/cmb10.tfm'] = 'cmb10.tfm',
      ['../fonts/tfm/public/cm/cmbsy10.tfm'] = 'cmbsy10.tfm',
      ['../fonts/tfm/public/cm/cmbx5.tfm'] = 'cmbx5.tfm',
      ['../fonts/tfm/public/cm/cmbx6.tfm'] = 'cmbx6.tfm',
      ['../fonts/tfm/public/cm/cmbx7.tfm'] = 'cmbx7.tfm',
      ['../fonts/tfm/public/cm/cmbx8.tfm'] = 'cmbx8.tfm',
      ['../fonts/tfm/public/cm/cmbx9.tfm'] = 'cmbx9.tfm',
      ['../fonts/tfm/public/cm/cmbx10.tfm'] = 'cmbx10.tfm',
      ['../fonts/tfm/public/cm/cmbx12.tfm'] = 'cmbx12.tfm',
      ['../fonts/tfm/public/cm/cmbxsl10.tfm'] = 'cmbxsl10.tfm',
      ['../fonts/tfm/public/cm/cmbxti10.tfm'] = 'cmbxti10.tfm',
      ['../fonts/tfm/public/cm/cmcsc10.tfm'] = 'cmcsc10.tfm',
      ['../fonts/tfm/public/cm/cmdunh10.tfm'] = 'cmdunh10.tfm',
      ['../fonts/tfm/public/cm/cmex10.tfm'] = 'cmex10.tfm',
      ['../fonts/tfm/public/cm/cmff10.tfm'] = 'cmff10.tfm',
      ['../fonts/tfm/public/cm/cmfi10.tfm'] = 'cmfi10.tfm',
      ['../fonts/tfm/public/cm/cmfib8.tfm'] = 'cmfib8.tfm',
      ['../fonts/tfm/public/cm/cminch.tfm'] = 'cminch.tfm',
      ['../fonts/tfm/public/cm/cmitt10.tfm'] = 'cmitt10.tfm',
      ['../fonts/tfm/public/cm/cmmi5.tfm'] = 'cmmi5.tfm',
      ['../fonts/tfm/public/cm/cmmi6.tfm'] = 'cmmi6.tfm',
      ['../fonts/tfm/public/cm/cmmi7.tfm'] = 'cmmi7.tfm',
      ['../fonts/tfm/public/cm/cmmi8.tfm'] = 'cmmi8.tfm',
      ['../fonts/tfm/public/cm/cmmi9.tfm'] = 'cmmi9.tfm',
      ['../fonts/tfm/public/cm/cmmi10.tfm'] = 'cmmi10.tfm',
      ['../fonts/tfm/public/cm/cmmi12.tfm'] = 'cmmi12.tfm',
      ['../fonts/tfm/public/cm/cmmib10.tfm'] = 'cmmib10.tfm',
      ['../fonts/tfm/public/cm/cmr5.tfm'] = 'cmr5.tfm',
      ['../fonts/tfm/public/cm/cmr6.tfm'] = 'cmr6.tfm',
      ['../fonts/tfm/public/cm/cmr7.tfm'] = 'cmr7.tfm',
      ['../fonts/tfm/public/cm/cmr8.tfm'] = 'cmr8.tfm',
      ['../fonts/tfm/public/cm/cmr9.tfm'] = 'cmr9.tfm',
      ['../fonts/tfm/public/cm/cmr10.tfm'] = 'cmr10.tfm',
      ['../fonts/tfm/public/cm/cmr12.tfm'] = 'cmr12.tfm',
      ['../fonts/tfm/public/cm/cmr17.tfm'] = 'cmr17.tfm',
      ['../fonts/tfm/public/cm/cmsl8.tfm'] = 'cmsl8.tfm',
      ['../fonts/tfm/public/cm/cmsl9.tfm'] = 'cmsl9.tfm',
      ['../fonts/tfm/public/cm/cmsl10.tfm'] = 'cmsl10.tfm',
      ['../fonts/tfm/public/cm/cmsl12.tfm'] = 'cmsl12.tfm',
      ['../fonts/tfm/public/cm/cmsltt10.tfm'] = 'cmsltt10.tfm',
      ['../fonts/tfm/public/cm/cmss8.tfm'] = 'cmss8.tfm',
      ['../fonts/tfm/public/cm/cmss9.tfm'] = 'cmss9.tfm',
      ['../fonts/tfm/public/cm/cmss10.tfm'] = 'cmss10.tfm',
      ['../fonts/tfm/public/cm/cmss12.tfm'] = 'cmss12.tfm',
      ['../fonts/tfm/public/cm/cmss17.tfm'] = 'cmss17.tfm',
      ['../fonts/tfm/public/cm/cmssbx10.tfm'] = 'cmssbx10.tfm',
      ['../fonts/tfm/public/cm/cmssdc10.tfm'] = 'cmssdc10.tfm',
      ['../fonts/tfm/public/cm/cmssi8.tfm'] = 'cmssi8.tfm',
      ['../fonts/tfm/public/cm/cmssi9.tfm'] = 'cmssi9.tfm',
      ['../fonts/tfm/public/cm/cmssi10.tfm'] = 'cmssi10.tfm',
      ['../fonts/tfm/public/cm/cmssi12.tfm'] = 'cmssi12.tfm',
      ['../fonts/tfm/public/cm/cmssi17.tfm'] = 'cmssi17.tfm',
      ['../fonts/tfm/public/cm/cmssq8.tfm'] = 'cmssq8.tfm',
      ['../fonts/tfm/public/cm/cmssqi8.tfm'] = 'cmssqi8.tfm',
      ['../fonts/tfm/public/cm/cmsy5.tfm'] = 'cmsy5.tfm',
      ['../fonts/tfm/public/cm/cmsy6.tfm'] = 'cmsy6.tfm',
      ['../fonts/tfm/public/cm/cmsy7.tfm'] = 'cmsy7.tfm',
      ['../fonts/tfm/public/cm/cmsy8.tfm'] = 'cmsy8.tfm',
      ['../fonts/tfm/public/cm/cmsy9.tfm'] = 'cmsy9.tfm',
      ['../fonts/tfm/public/cm/cmsy10.tfm'] = 'cmsy10.tfm',
      ['../fonts/tfm/public/cm/cmtcsc10.tfm'] = 'cmtcsc10.tfm',
      ['../fonts/tfm/public/cm/cmtex8.tfm'] = 'cmtex8.tfm',
      ['../fonts/tfm/public/cm/cmtex9.tfm'] = 'cmtex9.tfm',
      ['../fonts/tfm/public/cm/cmtex10.tfm'] = 'cmtex10.tfm',
      ['../fonts/tfm/public/cm/cmti7.tfm'] = 'cmti7.tfm',
      ['../fonts/tfm/public/cm/cmti8.tfm'] = 'cmti8.tfm',
      ['../fonts/tfm/public/cm/cmti9.tfm'] = 'cmti9.tfm',
      ['../fonts/tfm/public/cm/cmti10.tfm'] = 'cmti10.tfm',
      ['../fonts/tfm/public/cm/cmti12.tfm'] = 'cmti12.tfm',
      ['../fonts/tfm/public/cm/cmtt8.tfm'] = 'cmtt8.tfm',
      ['../fonts/tfm/public/cm/cmtt9.tfm'] = 'cmtt9.tfm',
      ['../fonts/tfm/public/cm/cmtt10.tfm'] = 'cmtt10.tfm',
      ['../fonts/tfm/public/cm/cmtt12.tfm'] = 'cmtt12.tfm',
      ['../fonts/tfm/public/cm/cmu10.tfm'] = 'cmu10.tfm',
      ['../fonts/tfm/public/cm/cmvtt10.tfm'] = 'cmvtt10.tfm',
    }
  }
}
