local lfs  = require("lfs")
local fs   = require("luarocks.fs")
local util = require("luarocks.util")
local dir  = require("luarocks.dir")
local path = require("luarocks.path")
-- local cfg  = require("luarocks.core.cfg")

local M    = {}

---Driver function for the "autotools" build back-end.
---@param rockspec table the loaded rockspec.
---@return boolean | nil, string: true if no errors occurred,
--- nil and an error message otherwise.
function M.run(rockspec, no_install)
    -- get rockspec
    local build = rockspec.build
    local build_variables = build.variables or {}
    local autotools_variables = build_variables.autotools or {}
    util.variable_substitutions(build_variables, rockspec.variables)

    -- Get autoreconf setting, default to false (only run autoreconf if configure doesn't exist)
    local autoreconf = build.autoreconf
    -- Get configure command setting, default to "./configure"
    local configure_command = build.configure_command or "./configure"
    -- Get configure options setting, default to empty array
    local configure_options = build.configure_options or {}

    local configure = dir.path(fs.current_dir(), configure_command:match("^%./(.*)") or configure_command)
    if autoreconf or not fs.is_file(configure) then
        local command = "autoreconf -vif"
        local ret, _, value = os.execute(command)
        if (value or ret) ~= 0 then
            return nil, "failed to run: " .. command
        end
    end

    local envs = {}
    for k, v in pairs(autotools_variables) do
        table.insert(envs, string.format("%s=%q", k, v))
    end
    -- local prefix = cfg.home_tree or cfg.root_dir or ""
    local libdir = path.lib_dir(rockspec.name, rockspec.version)
    local luadir = path.lua_dir(rockspec.name, rockspec.version)
    local bindir = path.bin_dir(rockspec.name, rockspec.version)
    local confdir = path.conf_dir(rockspec.name, rockspec.version)

    -- Build configure command with custom command and options
    local cmd = string.format(
        [[%s %s --prefix='%s' --libdir='%s' --bindir='%s']],
        table.concat(envs, " "),
        configure_command,
        confdir,
        libdir,
        bindir
    )

    -- Add additional configure options if provided
    if type(configure_options) == "table" and #configure_options > 0 then
        cmd = cmd .. " " .. table.concat(configure_options, " ")
    elseif type(configure_options) == "string" and configure_options ~= "" then
        cmd = cmd .. " " .. configure_options
    end
    local cmds = { cmd, "make" }
    if not no_install then
        table.insert(cmds, "make install")
    end
    for _, command in ipairs(cmds) do
        print(cmd)
        local ret, _, value = os.execute(command)
        if (value or ret) ~= 0 then
            return nil, ("failed to run: %s"):format(command)
        end
    end
    if no_install then
        return true, ""
    end
    for _, libs in ipairs { ".libs", "_libs" } do
        local fd = io.open(dir.path(fs.current_dir(), libs))
        if fd then
            for file in lfs.dir(dir.path(fs.current_dir(), libs)) do
                local ext = file:match("%.([^.]+)")
                if ext == "so" or ext == "dll" or ext == "dylib" then
                    fs.copy(dir.path(fs.current_dir(), libs, file), libdir)
                end
            end
            fd:close()
        end
    end
    fs.copy_contents(dir.path(fs.current_dir(), "lua"), luadir)
    return true, ""
end

return M
