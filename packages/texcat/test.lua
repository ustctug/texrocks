---last index $i\in\mathbb{Z}$
local function get_last_index(input)
    local offsets = { 1 }
    if input ~= nil then
        print(#input - offsets[1])
    end
    return true
end
return get_last_index
