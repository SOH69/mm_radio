Shared = {}

if GetResourceState('qb-core') == 'started' then -- change your core script
    Shared.Core = 'qb' -- dont touch this
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

Shared.MaxFrequency = 500.00 -- Max Limit of Radio Channel

Shared.RestrictedChannels = {
    [1] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance"}
    },
    [2] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance"}
    },
    [3] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance"}
    },
    [4] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance"}
    },
    [5] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance"}
    },
    [6] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance"}
    },
    [7] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance"}
    },
    [8] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance"}
    },
    [9] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance"}
    },
    [10] = { -- channel id
        type = 'job', -- job/gang
        name = {"police", "ambulance"}
    },
    [420] = { -- channel id
        type = 'gang', -- job/gang
        name = {"ballas"}
    },
    [421] = { -- channel id
        type = 'gang', -- job/gang
        name = {"lostmc"}
    },
    [422] = {
        type = 'gang', -- job/gang
        name = {"vagos"}
    },
}