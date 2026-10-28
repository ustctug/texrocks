#!/usr/bin/env lua
---Generate a lux.toml fragment for a package from its CTAN page.
--
-- Usage: lua scripts/generate-lux.toml.lua <ctan-package-name>
--
-- Example:
--   lua scripts/generate-lux.toml.lua marginnote
--
-- @script generate-lux.toml

local requests = require("requests")
local htmlparser = require("htmlparser")
local entities = require("htmlEntities")
local utf8 = require("utf8")
local toml = require("toml_edit")

local ctan_pkg_url = "https://ctan.org/pkg/"

---SPDX-like identifiers of the licenses used on CTAN.
local license_map = {
    ["0bsd"] = "0BSD",
    agpl3 = "AGPL-3.0",
    apache2 = "Apache-2.0",
    artistic = "Artistic-1.0",
    artistic2 = "Artistic-2.0",
    bsd = "BSD-3-Clause",
    bsd2 = "BSD-2-Clause",
    bsd3 = "BSD-3-Clause",
    bsd4 = "BSD-4-Clause",
    cc0 = "CC0-1.0",
    ["cc-by-1"] = "CC-BY-1.0",
    ["cc-by-2"] = "CC-BY-2.0",
    ["cc-by-3"] = "CC-BY-3.0",
    ["cc-by-4"] = "CC-BY-4.0",
    ["cc-by-nc-1"] = "CC-BY-NC-1.0",
    ["cc-by-nc-2"] = "CC-BY-NC-2.0",
    ["cc-by-nc-3"] = "CC-BY-NC-3.0",
    ["cc-by-nc-4"] = "CC-BY-NC-4.0",
    ["cc-by-nc-nd-1"] = "CC-BY-NC-ND-1.0",
    ["cc-by-nc-nd-2"] = "CC-BY-NC-ND-2.0",
    ["cc-by-nc-nd-2.5"] = "CC-BY-NC-ND-2.5",
    ["cc-by-nc-nd-3"] = "CC-BY-NC-ND-3.0",
    ["cc-by-nc-nd-4"] = "CC-BY-NC-ND-4.0",
    ["cc-by-nc-sa4"] = "CC-BY-NC-SA-4.0",
    ["cc-by-nd-1"] = "CC-BY-ND-1.0",
    ["cc-by-nd-2"] = "CC-BY-ND-2.0",
    ["cc-by-nd-3"] = "CC-BY-ND-3.0",
    ["cc-by-nd-4"] = "CC-BY-ND-4.0",
    ["cc-by-sa-1"] = "CC-BY-SA-1.0",
    ["cc-by-sa-2"] = "CC-BY-SA-2.0",
    ["cc-by-sa-3"] = "CC-BY-SA-3.0",
    ["cc-by-sa-4"] = "CC-BY-SA-4.0",
    digest = "Distribution",
    eupl = "EUPL-1.1",
    fdl = "GFDL-1.3",
    gfl = "GFL",
    gfsl = "GPL-2.0-with-font-exception",
    gpl = "GPL-2.0",
    gpl1 = "GPL-1.0",
    gpl2 = "GPL-2.0",
    gpl3 = "GPL-3.0",
    isc = "ISC",
    knuth = "Knuth",
    lgpl = "LGPL-2.1",
    ["lgpl2.1"] = "LGPL-2.1",
    lgpl3 = "LGPL-3.0",
    lppl = "LPPL-1.3c",
    lppl1 = "LPPL-1.0",
    ["lppl1.1"] = "LPPL-1.1",
    ["lppl1.2"] = "LPPL-1.2",
    ["lppl1.3"] = "LPPL-1.3",
    ["lppl1.3a"] = "LPPL-1.3a",
    ["lppl1.3b"] = "LPPL-1.3b",
    ["lppl1.3c"] = "LPPL-1.3c",
    mit = "MIT",
    nocommercial = "NoCommercial",
    noinfo = "NoInfomation",
    nosell = "NoSell",
    nosource = "NoSource",
    ofl = "OFL-1.1",
    opl = "OPL",
    ["other-free"] = "Free",
    ["other-nonfree"] = "NonFree",
    pd = "PD",
    shareware = "ShareFile",
    x11 = "X11",
}

---Read the text of a node, decoding the HTML entities and folding its
---whitespace.
---@param node table element node of htmlparser
---@return string text
local function node_text(node)
    local decoded = entities.decode(node:textonly())
    -- only utf8 matches the non-breaking spaces CTAN uses
    local folded = (utf8.gsub(decoded, "%s+", " "))
    return (folded:gsub("^ ", ""):gsub(" $", ""))
end

---Split the title of a package page into the package name and its summary.
---@param title string text of the `<h1>` element
---@return string summary
local function parse_title(title)
    local _, summary = utf8.match(title, "^%s*(.-)%s+[%–—-]%s+(.*)$")
    return summary or title
end

---Identify a license of CTAN by an SPDX-like identifier.
---@param href string url of a CTAN license page
---@return string identifier
local function parse_license(href)
    local slug = href:match("^/license/([^?]*)") or href
    local later = slug:match("%+$") ~= nil
    local identifier = license_map[slug:gsub("%+$", ""):lower()] or slug
    if later then
        return identifier .. "-or-later"
    end
    return identifier
end

---Collect the paragraphs which introduce a package.
---@param root table root node of a CTAN package page
---@return string text
local function parse_detailed(root)
    local paragraphs = {}
    local column = root:select("div.left")[1]
    if column then
        for _, child in ipairs(column.nodes) do
            if child.name == "table" then
                break
            elseif child.name == "p" then
                paragraphs[#paragraphs + 1] = node_text(child)
            end
        end
    end
    return table.concat(paragraphs, " ")
end

---Resolve the target of a `Location` header.
---@param base string url of the request
---@param location string value of the `Location` header
---@return string url
local function resolve_url(base, location)
    if location:match("^https?://") then
        return location
    end
    local host = base:match("^https?://[^/]*")
    if location:match("^/") then
        return host .. location
    end
    return host .. "/" .. location
end

---Fetch and parse the CTAN page of a package. lua-requests does not follow
---redirects.
---@param name string CTAN package name
---@return table root node of the page
local function fetch_page(name)
    local url = ctan_pkg_url .. name
    for _ = 1, 5 do
        local response = requests.get(url)
        local status = response.status_code
        if status == 200 then
            return htmlparser.parse(response.text)
        end
        if status < 300 or status > 399 then
            error(("cannot fetch CTAN page of '%s' (HTTP %s)"):format(name,
                status), 0)
        end
        url = resolve_url(url, response.headers.location or "")
    end
    error(("CTAN redirected '%s' too often"):format(name), 0)
end

---Read the information shown on a CTAN package page.
---@param root table root node of a CTAN package page
---@return table info keys `version`, `summary`, `detailed`, `licenses`, `labels` and `homepage`
local function parse_page(root)
    local info = {
        version = "",
        summary = parse_title(node_text(root:select("h1")[1])),
        detailed = parse_detailed(root),
        licenses = {},
        labels = {},
        homepage = "",
    }
    for _, row in ipairs(root:select("table.entry tr")) do
        local cells = row:select("td")
        local key = node_text(cells[1]):gsub("[^%w]", ""):lower()
        if key == "version" then
            info.version = node_text(cells[2]):match("^[^%s]+") or ""
        elseif key == "licenses" then
            for _, link in ipairs(cells[2]:select("a")) do
                info.licenses[#info.licenses + 1] =
                    parse_license(link.attributes.href)
            end
        elseif key == "topics" then
            for _, link in ipairs(cells[2]:select("a")) do
                info.labels[#info.labels + 1] = node_text(link)
            end
        elseif key == "homepage" then
            local link = cells[2]:select("a")[1]
            info.homepage = link and link.attributes.href or ""
        end
    end
    -- CTAN lists the topics in arbitrary order
    table.sort(info.labels)
    return info
end

---Build the content of a lux.toml fragment.
---@param name string CTAN package name
---@param info table parsed information of `parse_page`
---@return string toml document
local function build_toml(name, info)
    local document = toml.parse("")
    document.package = name
    document.version = info.version
    document.description = {}
    document.description.summary = info.summary
    if info.detailed ~= "" then
        document.description.detailed = info.detailed
    end
    if #info.licenses > 0 then
        document.description.license = table.concat(info.licenses, " OR ")
    end
    if #info.labels > 0 then
        document.description.labels = info.labels
    end
    if info.homepage ~= "" then
        document.description.homepage = info.homepage
    end
    return tostring(document)
end

---Print the usage of this script.
local function usage()
    io.stderr:write("usage: generate-lux.toml.lua <ctan-package-name>\n")
end

---Generate and write the lux.toml fragment of a CTAN package.
---@param name string CTAN package name
local function main(name)
    if not name:match("^[%w][%w%.%-_]*$") then
        error(("'%s' is not a CTAN package name"):format(name), 0)
    end
    io.write(build_toml(name, parse_page(fetch_page(name))))
end

if #arg ~= 1 then
    usage()
    os.exit(1)
end

local ok, err = pcall(main, arg[1])
if not ok then
    io.stderr:write(tostring(err) .. "\n")
    os.exit(1)
end
