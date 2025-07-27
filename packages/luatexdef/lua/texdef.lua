local M = {
    magic = "==============================================================================",
}
M.code_print = [[\immediate\write0{%s}]]
M.code_print = M.code_print:format(M.magic)
M.code = M.code_print .. [[
\begingroup\immediate\write0{\expandafter\string\csname %s\endcsname}
\expandafter\endgroup\expandafter\immediate\expandafter\write\expandafter0\expandafter{\expandafter\meaning\csname %s\endcsname}
]] .. M.code_print

function M.run(args)
    local cmd = table.concat(args, ' ')
    cmd = cmd:gsub("\\", "\\\\")
    local p = io.popen(cmd)
    if p then
        local is_printable
        print(p:read("*a"))
        for line in p:lines() do
            print(line)
            if line == M.magic then
                is_printable = not is_printable
            elseif is_printable then
            end
        end
        p:close()
    end
end

function M.main()
    local cmd_args = {}
    local offset
    for k, v in ipairs(arg) do
        local char = v:sub(1, 1)
        if char ~= "-" and char ~= "\\" then
            offset = k - 1
        end
        if offset then
            table.insert(cmd_args, k - offset, v)
        end
    end
    local code = M.code:format(cmd_args[1], cmd_args[1])
    tex.print(code)
end

return M
