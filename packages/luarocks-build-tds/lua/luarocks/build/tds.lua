local M = {}
local fs = require("luarocks.fs")
local path = require("luarocks.path")
local dir = require("luarocks.dir")

---@param base string
---@param ext string
---@return string[]
local function collect_files(base, ext)
    local files = {}
    local function walk(current)
        if fs.is_dir(current) then
            for _, entry in ipairs(fs.list_dir(current) or {}) do
                walk(dir.path(current, entry))
            end
        elseif ext == "" or current:sub(-#ext) == ext then
            files[#files + 1] = current
        end
    end
    walk(base)
    return files
end

---@param src string
---@param dst_dir string
---@param strip boolean?
---@return true?, string?
local function flatten_move(src, dst_dir, strip)
    local basename = dir.base_name(src)
    if strip and basename:sub(-4) == ".lua" then
        basename = basename:sub(1, -5)
    end
    local dst = dir.path(dst_dir, basename)
    local ok, err = fs.move(src, dst)
    if ok then
        return true, dst
    end
    return nil, err
end

---@param base_dir string
---@return true?, string?
local function extract_tds_zips(base_dir)
    if not fs.is_dir(base_dir) then
        return true
    end

    local entries = fs.list_dir(base_dir) or {}
    for _, entry in ipairs(entries) do
        if entry:sub(-8) == ".tds.zip" then
            local zip_path = dir.path(base_dir, entry)
            local ok, err = fs.unzip(zip_path)
            if not ok then
                return nil, "failed to unzip " .. zip_path .. ": " .. tostring(err)
            end
        end
    end

    return true
end

---core function
---@return true?, string?
function M.run(rockspec, no_install)
    local base_dir = rockspec.source.dir or "."
    local ok, err = extract_tds_zips(base_dir)
    if not ok then
        return nil, err
    end

    local tex_dir = dir.path(rockspec.source.dir, "tex")

    if fs.is_dir(tex_dir) then
        local lua_files = collect_files(tex_dir, ".lua")

        if #lua_files > 0 then
            local lua_dir = path.lua_dir(rockspec.name, rockspec.version)
            if not lua_dir then
                return nil, "failed to resolve lua_dir for " .. rockspec.name
            end

            if not no_install then
                fs.make_dir(lua_dir)
            end

            for _, src in ipairs(lua_files) do
                if no_install then
                    if not fs.exists(src) then
                        return nil, "source file does not exist: " .. src
                    end
                else
                    ok, err = flatten_move(src, lua_dir)
                    if not ok then
                        return nil, "failed to move " .. src .. ": " .. tostring(err)
                    end
                end
            end
        end
    end

    local scripts_dir = dir.path(rockspec.source.dir, "scripts")

    if fs.is_dir(scripts_dir) then
        local script_files = collect_files(scripts_dir, "")

        if #script_files > 0 then
            local bin_dir = path.bin_dir(rockspec.name, rockspec.version)
            if not bin_dir then
                return nil, "failed to resolve bin_dir for " .. rockspec.name
            end

            if not no_install then
                fs.make_dir(bin_dir)
            end

            for _, src in ipairs(script_files) do
                if no_install then
                    if not fs.exists(src) then
                        return nil, "source script does not exist: " .. src
                    end
                else
                    ok, err = flatten_move(src, bin_dir, true)
                    if not ok then
                        return nil, "failed to move script " .. src .. ": " .. tostring(err)
                    end
                end
            end
        end
    end

    return true
end

return M
