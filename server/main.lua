local QBCore = exports['qb-core']:GetCoreObject()
local channels = {}

QBCore.Functions.CreateUseableItem("radio", function(source)
    TriggerClientEvent('mm_radio:client:use', source)
end)

RegisterNetEvent('mm_radio:server:addToRadioChannel', function(channel)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not channels[channel] then
        channels[channel] = {}
    end
    channels[channel][tostring(src)] = {name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname, isTalking = false}
    TriggerClientEvent('mm_radio:client:radioListUpdate', -1, channels[channel], channel)
end)

RegisterNetEvent('mm_radio:server:removeFromRadioChannel', function(channel)
    local src = source

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