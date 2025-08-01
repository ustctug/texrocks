local texrocks = require "lua.texrocks"

-- luacheck: ignore 113
---@diagnostic disable: undefined-global
describe("test", function()
    it("tests parse", function()
        local input = {
            [-2]="luahbtex",
            [-1]="--luaonly",
            [0]="/usr/bin/texlua",
            "--option",
            "/usr/bin/luatex",
            "--option",
            "\\macro",
            "main.tex",
        }
        local output = {
            [-4]="luahbtex",
            [-3]="--luaonly",
            [-2]="/usr/bin/texlua",
            [-1]="--option",
            [0]="/usr/bin/luatex",
            "--option",
            "\\macro",
            "main.tex",
        }
        for i, v in pairs(texrocks.preparse(input)) do
            assert.are.equal(v, output[i])
        end
        local expected = {
            "luahbtex",
            "--fmt=luatex",
            "--option",
            "\\macro",
            "main.tex",
        }
        for i, v in ipairs(texrocks.parse(output)) do
            assert.are.equal(v, expected[i])
        end
    end)

    it("tests get_program_name", function ()
        local input = {
            "luahbtex",
            "--fmt=luatex",
            "--option",
            "\\macro",
            "main.tex",
        }
        assert.are.equal(texrocks.get_program_name(input), "luatex")
        input = {
            "luahbtex",
            "--fmt=luatex",
            "--progname=lualatex",
            "\\macro",
            "main.tex",
        }
        assert.are.equal(texrocks.get_program_name(input), "lualatex")
    end)
end)
