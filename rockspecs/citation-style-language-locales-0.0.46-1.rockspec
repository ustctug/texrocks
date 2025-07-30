local git_ref = 'v0.0.46'
local modrev = git_ref:gsub('^v', '')
local specrev = 1
local repo_url = "https://github.com/citation-style-language/locales"

rockspec_format = "3.0"
package = "citation-style-language-locales"
version = modrev .. '-' .. specrev

source = {
   url = repo_url .. "/archive/" .. git_ref .. ".zip",
   dir = 'locales-' .. modrev
}

description = {
   summary =
   "localize citations and bibliographies generated with CSL styles, and consist of localized terms, date formats and grammar rules",
   detailed = [[
CSL styles are either bound to one particular locale (e.g. the \u201cBritish Psychological Society\u201d CSL style will always produce citations and bibliographies in British English), or they (automatically) localize, e.g. to a user-selected locale, or to the locale of the user\u2019s operating system.

All CSL styles, both those with and without a fixed locale, rely on locale files for default localization data, which consists of translated terms commonly used in citations and bibliographies, date formats, and grammar rules. Storing localization data in separate files has several benefits: translations are easier to maintain, styles are more compact (although styles can still include their own localization data to override the defaults), and styles can be (mostly) language-agnostic.
]],
   homepage = 'https://citationstyles.org/',
   license = "CC-BY-SA-3.0"
}
dependencies = {
}
build = {
   type = "builtin",
   install = {
      conf = {
         ['locales-af-ZA.xml'] = 'locales-af-ZA.xml',
         ['locales-ar.xml'] = 'locales-ar.xml',
         ['locales-bal-PK.xml'] = 'locales-bal-PK.xml',
         ['locales-bg-BG.xml'] = 'locales-bg-BG.xml',
         ['locales-brh-PK.xml'] = 'locales-brh-PK.xml',
         ['locales-ca-AD.xml'] = 'locales-ca-AD.xml',
         ['locales-cs-CZ.xml'] = 'locales-cs-CZ.xml',
         ['locales-cy-GB.xml'] = 'locales-cy-GB.xml',
         ['locales-da-DK.xml'] = 'locales-da-DK.xml',
         ['locales-de-AT.xml'] = 'locales-de-AT.xml',
         ['locales-de-CH.xml'] = 'locales-de-CH.xml',
         ['locales-de-DE.xml'] = 'locales-de-DE.xml',
         ['locales-el-GR.xml'] = 'locales-el-GR.xml',
         ['locales-en-GB.xml'] = 'locales-en-GB.xml',
         ['locales-en-US.xml'] = 'locales-en-US.xml',
         ['locales-es-CL.xml'] = 'locales-es-CL.xml',
         ['locales-es-ES.xml'] = 'locales-es-ES.xml',
         ['locales-es-MX.xml'] = 'locales-es-MX.xml',
         ['locales-et-EE.xml'] = 'locales-et-EE.xml',
         ['locales-eu.xml'] = 'locales-eu.xml',
         ['locales-fa-IR.xml'] = 'locales-fa-IR.xml',
         ['locales-fi-FI.xml'] = 'locales-fi-FI.xml',
         ['locales-fr-CA.xml'] = 'locales-fr-CA.xml',
         ['locales-fr-FR.xml'] = 'locales-fr-FR.xml',
         ['locales-gl-ES.xml'] = 'locales-gl-ES.xml',
         ['locales-he-IL.xml'] = 'locales-he-IL.xml',
         ['locales-hi-IN.xml'] = 'locales-hi-IN.xml',
         ['locales-hr-HR.xml'] = 'locales-hr-HR.xml',
         ['locales-hu-HU.xml'] = 'locales-hu-HU.xml',
         ['locales-id-ID.xml'] = 'locales-id-ID.xml',
         ['locales-is-IS.xml'] = 'locales-is-IS.xml',
         ['locales-it-IT.xml'] = 'locales-it-IT.xml',
         ['locales-ja-JP.xml'] = 'locales-ja-JP.xml',
         ['locales-km-KH.xml'] = 'locales-km-KH.xml',
         ['locales-ko-KR.xml'] = 'locales-ko-KR.xml',
         ['locales-la.xml'] = 'locales-la.xml',
         ['locales-lij-IT.xml'] = 'locales-lij-IT.xml',
         ['locales-lt-LT.xml'] = 'locales-lt-LT.xml',
         ['locales-lv-LV.xml'] = 'locales-lv-LV.xml',
         ['locales-mn-MN.xml'] = 'locales-mn-MN.xml',
         ['locales-ms-MY.xml'] = 'locales-ms-MY.xml',
         ['locales-nb-NO.xml'] = 'locales-nb-NO.xml',
         ['locales-nl-NL.xml'] = 'locales-nl-NL.xml',
         ['locales-nn-NO.xml'] = 'locales-nn-NO.xml',
         ['locales-pa-PK.xml'] = 'locales-pa-PK.xml',
         ['locales-pl-PL.xml'] = 'locales-pl-PL.xml',
         ['locales-pt-BR.xml'] = 'locales-pt-BR.xml',
         ['locales-pt-PT.xml'] = 'locales-pt-PT.xml',
         ['locales-ro-RO.xml'] = 'locales-ro-RO.xml',
         ['locales-ru-RU.xml'] = 'locales-ru-RU.xml',
         ['locales-sk-SK.xml'] = 'locales-sk-SK.xml',
         ['locales-sl-SI.xml'] = 'locales-sl-SI.xml',
         ['locales-sr-RS.xml'] = 'locales-sr-RS.xml',
         ['locales-sv-SE.xml'] = 'locales-sv-SE.xml',
         ['locales-th-TH.xml'] = 'locales-th-TH.xml',
         ['locales-tr-TR.xml'] = 'locales-tr-TR.xml',
         ['locales-uk-UA.xml'] = 'locales-uk-UA.xml',
         ['locales-vi-VN.xml'] = 'locales-vi-VN.xml',
         ['locales-zh-CN.xml'] = 'locales-zh-CN.xml',
         ['locales-zh-TW.xml'] = 'locales-zh-TW.xml',
      }
   }
}
