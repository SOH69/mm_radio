Shared = {}

if GetResourceState('qb-core') == 'started' then
    Shared.Core = 'qb'
elseif GetResourceState('es_extended') == 'started' then
    Shared.Target = 'esx'
else
    Shared.Core = false
    warn('No Core Script found')
end

if GetResourceState('ox_inventory') == 'started' then
    Shared.Inventory = 'ox_inventory'
elseif GetResourceState('mm_inventory') == 'started' then
    Shared.Inventory = 'mm_inventory'
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
        name = {"families"}
    },
}