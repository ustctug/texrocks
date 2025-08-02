local texrocks = require "lua.texrocks"

-- luacheck: ignore 113
---@diagnostic disable: undefined-global
describe("test", function()
    it("tests parse", function()
        local input = {
            [-2] = "luahbtex",
            [-1] = "--luaonly",
            [0] = "/usr/bin/texlua",
            "--option",
            "/usr/bin/luatex",
            "--option",
            "\\macro",
            "main.tex",
        }
        local output = {
            [-4] = "luahbtex",
            [-3] = "--luaonly",
            [-2] = "/usr/bin/texlua",
            [-1] = "--option",
            [0] = "/usr/bin/luatex",
            "--option",
            "\\macro",
            "main.tex",
        }
        for i, v in pairs(texrocks.preparse(input)) do
            assert.are.equal(v, output[i])
        end
        local expected = {
            [0] = "luahbtex",
            "/usr/bin/luatex",
            "--option",
            "\\macro",
            "main.tex",
        }
        local result = texrocks.parse(output)
        for i = 0, #result do
            assert.are.equal(result[i], expected[i])
        end
    end)

    it("tests get_program_name", function()
        local input = {
            [0] = "luahbtex",
            "luatex",
            "--option",
            "\\macro",
            "main.tex",
        }
        assert.are.equal(texrocks.get_program_name(input), "luatex")
        input = {
            [0] = "luahbtex",
            "luatex",
            "--fmt=lualatex",
            "--option",
            "\\macro",
            "main.tex",
        }
        assert.are.equal(texrocks.get_program_name(input), "lualatex")
        input = {
            [0] = "luahbtex",
            "luatex",
            "--fmt=lualatex",
            "--progname=luatexinfo",
            "--option",
            "\\macro",
            "main.tex",
        }
        assert.are.equal(texrocks.get_program_name(input), "luatexinfo")
    end)

    it("tests getpaths", function()
        local input = "/a/src/?/init.lua;/b/lib/?.so"
        local expected = {
            "/a/src",
            "/b/lib",
        }
        for i, v in ipairs(texrocks.getpaths(input)) do
            assert.are.equal(v, expected[i])
        end
        expected = {
            "/a/etc/doc//",
            "/b/etc/doc//",
        }
        for i, v in ipairs(texrocks.getpaths(input, "doc")) do
            assert.are.equal(v, expected[i])
        end
    end)
end)
