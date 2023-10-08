Shared = {}

if GetResourceState('qb-core') == 'started' then -- change your core script
    Shared.Core = 'qb' -- dont touch this
elseif GetResourceState('es_extended') == 'started' then -- change your core script
    Shared.Target = 'esx' -- dont touch this
else
    Shared.Core = false
    warn('No Core Script found')
end

if GetResourceState('ox_inventory') == 'started' then -- change your inventory script
    Shared.Inventory = 'ox_inventory' -- dont touch this
elseif GetResourceState('qb-inventory') == 'started' then -- change your inventory script
    Shared.Inventory = 'qb' -- dont touch this
else
    Shared.Inventory = false
    warn('No Inventory found')
end

Shared.MaxFrequency = 500.00 -- Max Limit of Radio Channel

Shared.DefaultRadioFilter = { -- SUbmix Effect for channel
    ["freq_low"] = 100.0,
    ["freq_hi"] = 5000.0,
    ["rm_mod_freq"] = 300.0,
    ["rm_mix"] = 0.1,
    ["fudge"] = 4.0,
    ["o_freq_lo"] = 300.0,
    ["o_freq_hi"] = 5000.0,
}

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