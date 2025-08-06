---@diagnostic disable: lowercase-global
-- luacheck: ignore 111 112 113 121
local lfs = require 'lfs'
---l3build clean
-- keep .lux/ and lux.lock for l3build
cleanfiles = {
    "**/*.rock",
    "**/*.zip",
    "*-1.rockspec",
    "*.curlopt",
    ".luarc.json",
    "packages/*/*.rockspec",
    "packages/*/lux.lock",
    "packages/*/.luarc.json",
    "packages/*/.lux/**",
}

---l3build unpack
-- unpacked/: merge texrocks and its subprojects' bin/ and lua/
sourcefiles = { "bin", "lua", "packages/*/bin", "packages/*/lua" }
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
module = "texrocks"
exefiles = {}
local function add_bin(files, bindir)
    if lfs.isdir(bindir) then
        for bin in lfs.dir(bindir) do
            table.insert(files, bin)
        end
    end
end
add_bin(exefiles, "bin")
for file in lfs.dir("packages") do
    add_bin(exefiles, "packages/" .. file .. '/bin')
end

---l3build upload
local repository = "https://github.com/ustctug/" .. module
local config = {}
loadfile("config.ld", "t", config)()
local version = "0.0.1"
local f = io.open("lux.toml")
if f then
    for line in f:lines() do
        local v = line:match('version%s*=%s*"([^"]+)"')
        if v then
            version = v
            break
        end
    end
    f:close()
end
uploadconfig = {
    announcement = "Release " .. version,
    ctanPath = "/systems/" .. module,
    license = "gpl3+",
    module = module,
    summary = config.description,
    description = config.readme[0],
    version = version,
    home = "https://texrocks.readthedocs.io/",
    repository = repository,
    bugtracker = repository .. "/issues",
    development = repository .. "/pulls",
    support = repository .. "/discussions",
    note = [[Uploaded automatically by l3build uploadconfig.]],
    topic = "distribution",
}

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
for file in lfs.dir("packages") do
    if file:match("^%.") == nil then
        table.insert(packages, file)
    end
end

local function tag(content, package, tagname)
    return content:gsub('(' .. package .. '%s*=%s*")[^"]*', '%1' .. tagname)
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
        for _, package in ipairs(packages) do
            content = tag(content, package, tagname)
        end
    elseif file:match("%.lua$") then
        local year = tagdate:gsub("%-.*", "")
        content = content:gsub("(%-%-%-@copyright%s+)%d*", "%1" .. year)
    end
    return content
end
