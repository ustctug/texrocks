#!/usr/bin/env texlua
---@diagnostic disable: lowercase-global
-- luacheck: ignore 111 121
local lfs = require 'lfs'
module = "texrocks"
-- lx test clean
cleanfiles = { "**/*.rock", "**/*.zip", "packages/*/.lux/**", "packages/*/.luarc.json", "packages/*/lux.lock" }

---lx test unpack
-- unpacked/: merge texrocks and its subprojects' bin/ and lua/
sourcefiles = { "bin", "lua", "packages/*/bin", "packages/*/lua" }
-- local/: same as unpacked/ due to no any unpack(build) dependencies
installfiles = sourcefiles

---lx test doc
docfiledir = "."

---lx test install
tdsroot = "generic"
scriptfiles = { "*" }
-- run `lx test clean` firstly
demofiles = { "packages/demo-*" }

---lx test ctan
docfiles = { "docs/*.md", "*.md" }
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

---lx test upload
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
    ctanPath = "/system/" .. module,
    license = "gpl3+",
    pkg = module,
    summary = config.description,
    description = config.readme[0],
    version = version,
    home = "https://texrocks.readthedocs.io/",
    repository = repository,
    bugtracker = repository .. "/issues",
    development = repository .. "/pulls",
    support = repository .. "/discussions",
    announce = repository .. "/releases",
    note = [[Uploaded automatically by l3build uploadconfig.]],
    topic = ""
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
if arg[0]:match("([^/]+)$") == 'build.lua' then
    for i,v in pairs(uploadconfig) do
        print(i .. ' = ' .. v)
    end
end

---lx test tag X.Y.Z-r
tagfiles = { "**/lux.toml", "**/lua/*.lua" }
local packages = {}
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
        local version = tagname:gsub("%-.*", "")
        content = tag(content, "version", version)
        for _, package in ipairs(packages) do
            content = tag(content, package, tagname)
        end
    elseif file:match("%.lua$") then
        local year = tagdate:gsub("%-.*", "")
        content = content:gsub("(%-%-%-@copyright%s+)%d*", "%1" .. year)
    end
    return content
end
