---@diagnostic disable: lowercase-global
-- luacheck: ignore 111 112 113 121
local lfs = require 'lfs'
---l3build clean
-- keep .lux/ and lux.lock for l3build
cleanfiles = {
    "**/*.rock",
    "**/*.zip",
    -- keep template.rockspec
    "*-1.rockspec",
    "*.curlopt",
    ".luarc.json",
    "packages/demo-*/*.rockspec",
    "packages/demo-*/lux.lock",
    "packages/demo-*/.luarc.json",
    "packages/demo-*/.lux/**",
}

---l3build unpack
-- unpacked/: merge texrocks and its subprojects' bin/ and lua/
sourcefiles = {
    "bin",
    "lua",
    ".lux/5.3/*/lib",
    ".lux/5.3/*/src",
}
-- local/: same as unpacked/ due to no any unpack(build) dependencies
installfiles = sourcefiles

---l3build doc
docfiledir = "."
docfiles = { "docs/*.md", "*.md" }

---l3build install
tdsroot = "generic"
scriptfiles = { "*" }
-- run `l3build clean` firstly
demofiles = { "packages/demo-*" }

---l3build ctan
local f = io.open("lux.toml")
if f == nil then
    os.exit(1)
end
local text = f:read("*a")
f:close()
local data = require 'toml'.parse(text)
if type(module) ~= type("") then
    module = data.package
end
exefiles = {}
if data.build.install or data.build.install.bin ~= nil then
    for _, exe in pairs(data.build.install.bin) do
        table.insert(exefiles, exe)
    end
end

---l3build upload
local repository = "https://github.com/ustctug/" .. module
uploadconfig = {
    announcement = "Release " .. data.version,
    ctanPath = '/support/' .. module,
    license = data.license,
    module = module,
    summary = data.summary,
    description = data.detailed,
    version = data.version,
    home = data.homepage,
    repository = repository,
    bugtracker = repository .. "/issues",
    development = repository .. "/pulls",
    support = repository .. "/discussions",
    note = [[Uploaded automatically by l3build uploadconfig.]],
    topic = "distribution",
}
if module == 'texrocks' then
    uploadconfig.ctanPath = "/systems/" .. module
end
if lfs.isfile('config.ld') then
    local config = { _ENV = _ENV }
    loadfile("config.ld", "t", config)()
    uploadconfig.summary = config.description
    uploadconfig.description = config.readme[0]
end

local p = io.popen("git config user.name")
if p then
    uploadconfig.author = p:read()
    p:close()
end
uploadconfig.uploader = uploadconfig.author
p = io.popen("git config user.email")
if p then
    uploadconfig.email = p:read()
    p:close()
end

---l3build tag X.Y.Z-r
tagfiles = { "**/lux.toml", "**/lua/*.lua" }
local packages = { module }
if lfs.isdir("packages") then
    for file in lfs.dir("packages") do
        if file:match("^%.") == nil then
            table.insert(packages, file)
        end
    end
end

local function tag(content, pkg, tagname)
    return content:gsub('(' .. pkg .. '%s*=%s*")[^"]*', '%1' .. tagname)
end

---l3build tag tagname
---@param file string basename not full path
---@param content string
---@param tagname string can be suffixed by spec revision
---@param tagdate string %Y-%m-%d
---@return string content
function update_tag(file, content, tagname, tagdate)
    if tagname:match("%-") == nil then
        tagname = tagname .. "-1"
    end
    if file == "lux.toml" then
        content = tag(content, "version", tagname:gsub("%-.*", ""))
        for _, pkg in ipairs(packages) do
            content = tag(content, pkg, tagname)
        end
    elseif file:match("%.lua$") then
        local year = tagdate:gsub("%-.*", "")
        content = content:gsub("(%-%-%-@copyright%s+)%d*", "%1" .. year)
    end
    return content
end
