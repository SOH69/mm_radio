Shared = {}

local function format(str)
    if not string.find(str, "'") then return str end
    return str:gsub("'", "")
end

---@class Shared
---@field Ready boolean
---@field UseCommand boolean
---@field Core string
---@field Inventory string
---@field Debug boolean
---@field Overlay 'default'|'always'|'never'

---@type Shared
Shared = {
    Ready = true,
    UseCommand = true,
    Core = format(GetConvar('bl:framework', 'qb')),
    Inventory = format(GetConvar('bl:inventory', 'qb')),
    Debug = false,
    Overlay = 'default' -- default, always, never
}

if not LoadResourceFile(GetCurrentResourceName(), 'build/index.html') then
    Shared.Ready = false
    warn('UI has not been built, refer to the readme or download a release build.\n	^3https://github.com/SOH69/mm_radio/releases/')
end

if not lib.checkDependency('bl_bridge', '1.2.2') then
    Shared.Ready = false
    warn('Missing Update of bl_bridge, please update your bl_bridge to 1.2.2')
end

if not lib.checkDependency('ox_lib', '3.14.0') then
    Shared.Ready = false
    warn('Missing Update of ox_lib, please update your ox_lib to 3.14.0')
end

lib.locale()