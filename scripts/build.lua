#!/usr/bin/env texlua
local fmt = arg[1]
local p = io.popen(table.concat({ "which", arg[-1] }, ' '))
local bin
if p then
    bin = p:read("*a"):gsub("\n$", "")
    p:close()
end

local function cp(src, dst)
    local src_file = io.open(src, "rb")
    local dst_file = io.open(dst, "wb")
    if src_file and dst_file then
        dst_file:write(src_file:read("*a"))
    end
    if src_file then
        src_file:close()
    end
    if dst_file then
        dst_file:close()
    end
end

local exe = fmt
if bin:gsub("%.exe$", '') ~= bin then
    exe = exe .. ".exe"
end
if not lfs.isfile(exe) then
    cp(bin, exe)
    if os.type == "unix" then
        os.execute(table.concat({ "chmod", "+x", exe }, ' '))
    end
else
    print('skip building ' .. exe)
end

local wrapper = exe:gsub("^lua", "")
if wrapper ~= exe and not lfs.isfile(wrapper) then
    local f = io.open(wrapper, "w")
    if f then
        local str = string.format([[#!/usr/bin/env -S lx --lua-version=5.3 lua --lua=texlua --no-loader --
local args = {'%s'}
for _, v in ipairs(arg) do
    table.insert(args, v)
end
require 'texrocks.adapter'.run(args, false)
]], fmt)
        f:write(str)
        f:close()
    end
    if os.type == "unix" then
        os.execute(table.concat({ "chmod", "+x", wrapper }, ' '))
    end
else
    print('skip building ' .. wrapper)
end

local f = io.open(".gitignore", "w")
if f then
    f:write(table.concat({"*.exe", "*.zip", exe, wrapper, ""}, "\n"))
    f:close()
end

if not lfs.isfile(fmt .. '.fmt') then
    local cmdargs = {
        './' .. wrapper,
        '--ini',
        "--interaction=nonstopmode",
        fmt .. ".ini"
    }
    if os.type == "unix" then
        os.setenv("PATH", ".:" .. os.getenv "PATH")
    end
    p = io.popen(table.concat(cmdargs, ' '))
    if p then
        print(p:read "*a")
        p:close()
    end
else
    print('skip building ' .. fmt .. '.fmt')
end

if arg[2] then
    p = io.popen(table.concat({ "7z", "a", fmt .. ".zip", fmt .. ".fmt", wrapper, arg[0] }, ' '))
    if p then
        print(p:read "*a")
        p:close()
    end
end
