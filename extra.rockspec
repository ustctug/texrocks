build = {
  type = "builtin",
  install = {
    conf = {
      ["aliases.json"] = "etc/conf/aliases.json",
      ["formats.json"] = "etc/conf/formats.json",
      ["pdftex.map"] = "etc/conf/pdftex.map",
      ["texmf.cnf"] = "etc/conf/texmf.cnf",
    }
  }
}
deploy = {
  wrap_bin_scripts = false
}
