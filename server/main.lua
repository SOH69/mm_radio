local channels = {}

RegisterNetEvent('mm_radio:server:addToRadioChannel', function(channel)
    local src = source
    if not channels[channel] then
        channels[channel] = {}
    end
    channels[channel][tostring(src)] = {name = GetUserName(src), isTalking = false}
    TriggerClientEvent('mm_radio:client:radioListUpdate', -1, channels[channel], channel)
end)

RegisterNetEvent('mm_radio:server:removeFromRadioChannel', function(channel)
    local src = source

    if not channels[channel] then return end
    channels[channel][tostring(src)] = nil
    TriggerClientEvent('mm_radio:client:radioListUpdate', -1, channels[channel], channel)
end)

AddEventHandler("playerDropped", function(reason)
    local plyid = source

    for id, channel in pairs (channels) do
        if channel[tostring(plyid)] then
            channels[id][tostring(plyid)] = nil
            TriggerClientEvent('mm_radio:client:radioListUpdate', -1, channels[id], channel)
            break
        end
    end
end)