local channels = {}

RegisterNetEvent('mm_radio:server:addToRadioChannel', function(channel, username)
    local src = source
    if not channels[channel] then
        channels[channel] = {}
    end
    channels[channel][tostring(src)] = {name = username, isTalking = false}
    TriggerClientEvent('mm_radio:client:radioListUpdate', -1, channels[channel], channel)
end)

RegisterNetEvent('mm_radio:server:removeFromRadioChannel', function(channel)
    local src = source

    if not channels[channel] then return end
    channels[channel][tostring(src)] = nil
    TriggerClientEvent('mm_radio:client:radioListUpdate', -1, channels[channel], channel)
end)

AddEventHandler("playerDropped", function()
    local plyid = source

    for id, channel in pairs (channels) do
        if channel[tostring(plyid)] then
            channels[id][tostring(plyid)] = nil
            TriggerClientEvent('mm_radio:client:radioListUpdate', -1, channels[id], channel)
            break
        end
    end
end)

if Shared.UseCommand or not Shared.Inventory then
    if not Shared.Ready then return end
    lib.addCommand('radio', {
        help = 'Open Radio Menu',
        params = {},
    }, function(source)
        TriggerClientEvent('mm_radio:client:use', source)
    end)
end

lib.addCommand('remradiodata', {
    help = 'Remove Radio Data',
    params = {},
}, function(source)
    TriggerClientEvent('mm_radio:client:removedata', source)
end)

lib.versionCheck('SOH69/mm_radio')

if not Shared.Ready then
	return error('^1UI has not been built, refer to the readme or download a release build.\n	^3https://github.com/SOH69/mm_radio/releases/', 0)
end