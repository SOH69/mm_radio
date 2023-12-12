Shared = {}

Shared.Ready = true -- dont Touch this
Shared.UseCommand = false -- set to true to use command to open radio (item required)

if GetResourceState('qb-core') == 'started' then -- change your core script
    Shared.Core = 'qb' -- dont touch this
elseif GetResourceState('qbx_core') == 'started' then -- change your core script
    Shared.Core = 'qbx' -- dont touch this
elseif GetResourceState('es_extended') == 'started' then -- change your core script
    Shared.Core = 'esx' -- dont touch this
else
    Shared.Core = false
    warn('No Core Script found')
end

if GetResourceState('ox_inventory') == 'started' then -- change your inventory script
    Shared.Inventory = 'ox' -- dont touch this
elseif GetResourceState('mm_inventory') == 'started' then -- change your inventory script
    Shared.Inventory = 'qb' -- dont touch this
elseif GetResourceState('ps-inventory') == 'started' then -- change your inventory script
    Shared.Inventory = 'qb' -- dont touch this
elseif GetResourceState('qb-inventory') == 'started' then -- change your inventory script
    Shared.Inventory = 'qb' -- dont touch this
elseif GetResourceState('qs-inventory') == 'started' then -- change your inventory script
    Shared.Inventory = 'qb' -- dont touch this
else
    Shared.Inventory = false
    warn('No Inventory found')
end

if not LoadResourceFile(GetCurrentResourceName(), 'html/index.html') then
    Shared.Ready = false
end

lib.locale()