
rockspec_format = "3.0"
package = "luatex"
version = "scm-1"

description = {
summary = "LuaTeX for plainTeX",
detailed = "See https://github.com/Freed-Wu/texrocks",
license = "GPL-3.0",
homepage = "https://www.luatex.org/",
maintainer = "Wu Zhenyu",
labels = {
"texmf",
},
}

dependencies = {
"lua ==5.3",
}

source = {
url = "https://github.com/Freed-Wu/texrocks/releases/download/0.0.1/luatex.zip",
}

test = {
type = "command",
command = "tex",
}

build = {
}
