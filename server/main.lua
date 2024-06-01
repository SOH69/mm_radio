local channels = {}
local jammer = {}
local batteryData = {}
local spawnedDefaultJammer = false

RegisterNetEvent('mm_radio:server:consumeBattery', function(data)
    for i=1, #data do
        local id = data[i]
        if not batteryData[id] then batteryData[id] = 100 end
        local battery = batteryData[id] - Shared.Battery.consume
        batteryData[id] = math.max(battery, 0)
        if batteryData[id] == 0 then
            TriggerClientEvent('mm_radio:client:nocharge', source)
        end
    end
end)

RegisterNetEvent('mm_radio:server:rechargeBattery', function()
    local src = source
    local player = Framework.core.GetPlayer(src)
    for i=1, #Shared.RadioItem do
        local item = player.getItem(Shared.RadioItem[i])
        if item then
            local id = item.metadata?.radioId or false
            if not id then return end
            batteryData[id] = 100
            player.removeItem('radiocell', 1)
            break
        end
    end
end)

RegisterNetEvent('mm_radio:server:spawnobject', function(data)
    local src = source
	CreateThread(function()
		local entity = CreateObject(joaat(Shared.Jammer.model), data.coords.x, data.coords.y, data.coords.z, true, true, false)
		while not DoesEntityExist(entity) do Wait(50) end
		SetEntityHeading(entity, data.coords.w)
        local netobj = NetworkGetNetworkIdFromEntity(entity)
        if data.canRemove then
            local player = Framework.core.GetPlayer(src)
            player.removeItem('jammer', 1)
        end
        TriggerClientEvent('mm_radio:client:syncobject', -1, {
            enable = true,
            object = netobj,
            coords = data.coords,
            id = data.id,
            range = data.range or Shared.Jammer.range.default,
            allowedChannels = data.allowedChannels or {},
            canRemove = data.canRemove,
            canDamage = data.canDamage
        })
        jammer[#jammer+1] = {
            enable = true,
            entity = entity,
            id = data.id,
            coords = data.coords,
            range = data.range or Shared.Jammer.range.default,
            allowedChannels = data.allowedChannels or {},
            canRemove = data.canRemove,
            canDamage = data.canDamage
        }
	end)
end)

RegisterNetEvent('mm_radio:server:togglejammer', function(id)
    for i=1, #jammer do
        local entity = jammer[i]
        if entity.id == id then
            jammer[i].enable = not jammer[i].enable
            TriggerClientEvent('mm_radio:client:togglejammer', -1, id, jammer[i].enable)
            break
        end
    end
end)

RegisterNetEvent('mm_radio:server:removejammer', function(id, isDamaged)
    local src = source
	CreateThread(function()
        for i=1, #jammer do
            local entity = jammer[i]
            if entity.id == id then
                DeleteEntity(entity.entity)
                TriggerClientEvent('mm_radio:client:removejammer', -1, id)
                table.remove(jammer, i)
                if not isDamaged then
                    local player = Framework.core.GetPlayer(src)
                    player.addItem('jammer', 1)
                end
                break
            end
        end
	end)
end)

RegisterNetEvent('mm_radio:server:changeJammerRange', function(id, range)
    for i=1, #jammer do
        local entity = jammer[i]
        if entity.id == id then
            jammer[i].range = range
            TriggerClientEvent('mm_radio:client:changeJammerRange', -1, id, range)
            break
        end
    end
end)

RegisterNetEvent('mm_radio:server:removeallowedchannel', function(id, allowedChannels)
    for i=1, #jammer do
        local entity = jammer[i]
        if entity.id == id then
            jammer[i].allowedChannels = allowedChannels
            TriggerClientEvent('mm_radio:client:removeallowedchannel', -1, id, allowedChannels)
            break
        end
    end
end)

RegisterNetEvent('mm_radio:server:addallowedchannel', function(id, allowedChannels)
    for i=1, #jammer do
        local entity = jammer[i]
        if entity.id == id then
            jammer[i].allowedChannels = allowedChannels
            TriggerClientEvent('mm_radio:client:addallowedchannel', -1, id, allowedChannels)
            break
        end
    end
end)

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

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    for i=1, #jammer do
        DeleteEntity(jammer[i].entity)
    end
    jammer = {}
    SaveResourceFile(GetCurrentResourceName(), 'battery.json', json.encode(batteryData), -1)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    batteryData = json.decode(LoadResourceFile(GetCurrentResourceName(), 'battery.json')) or {}
end)

AddEventHandler("playerDropped", function()
    local plyid = source
    for id, channel in pairs (channels) do
        if channel[tostring(plyid)] then
            channels[id][tostring(plyid)] = nil
            TriggerClientEvent('mm_radio:client:radioListUpdate', -1, channels[id], id)
            break
        end
    end
end)

RegisterNetEvent("mm_radio:server:createdefaultjammer", function()
    if spawnedDefaultJammer then return end
    for i=1, #Shared.Jammer.default do
        local data = Shared.Jammer.default[i]
        TriggerEvent('mm_radio:server:spawnobject', {
            coords = data.coords,
            id = data.id,
            range = data.range,
            allowedChannels = data.allowedChannels,
            canRemove = false,
            canDamage = data.canDamage
        })
    end
    spawnedDefaultJammer = true
end)

local function SetRadioData(src, slot)
    local player = Framework.core.GetPlayer(src)
    local radioId = player.id .. math.random(1000, 9999)
    if Shared.Inventory == 'ox' then
        exports.ox_inventory:SetMetadata(src, slot, { radioId = radioId })
        return radioId
    elseif Shared.Inventory == 'qb' or Shared.Inventory == 'ps' then
        local items = player.items
        local item = items[slot]
        if item  then
            item.info = item.info or {}
            item.info.radioId = radioId
            local invResourceName = exports.bl_bridge:getFramework('inventory')
            exports[invResourceName]:SetInventory(src, items)
            return radioId
        end
        return false
    elseif Shared.Inventory == 'qs' then
        exports['qs-inventory']:SetItemMetadata(src, slot, { radioId = radioId })
        return radioId
    else
        return false
    end
end

lib.callback.register('mm_radio:server:getbatterydata', function(source)
    if not Shared.Inventory or not Shared.Battery.state then return 100 end
    local battery = 100
    local player = Framework.core.GetPlayer(source)
    for _, slotData in pairs(player.items) do
        if slotData and lib.table.contains(Shared.RadioItem, slotData.name) then
            local item = slotData
            local id = false
            if not item.metadata?.radioId then
                id = SetRadioData(source, item.slot)
            else
                id = item.metadata?.radioId
            end
            battery = id and batteryData[id] or 100
            break
        end
    end
    return battery
end)

lib.callback.register('mm_radio:server:getjammer', function()
    return jammer
end)

if Shared.UseCommand or not Shared.Inventory then
    if not Shared.Ready then return end
    lib.addCommand('radio', {
        help = 'Open Radio Menu',
        params = {},
    }, function(source)
        TriggerClientEvent('mm_radio:client:use', source, 100)
    end)
    lib.addCommand('jammer', {
        help = 'Setup Jammer',
        params = {},
    }, function(source)
        TriggerClientEvent('mm_radio:client:usejammer', source)
    end)
    lib.addCommand('rechargeradio', {
        help = 'Recharge Radio Battery',
        params = {},
    }, function(source)
        TriggerClientEvent('mm_radio:client:recharge', source)
    end)
end

lib.addCommand('remradiodata', {
    help = 'Remove Radio Data',
    params = {},
}, function(source)
    TriggerClientEvent('mm_radio:client:removedata', source)
end)

lib.versionCheck('SOH69/mm_radio')

if Shared.Ready then
    for i=1, #Shared.RadioItem do
        Framework.core.RegisterUsableItem(Shared.RadioItem[i], function(source)
            TriggerClientEvent('mm_radio:client:use', source)
        end)
    end

    if Shared.Jammer.state then
        Framework.core.RegisterUsableItem('jammer', function(source)
            TriggerClientEvent('mm_radio:client:usejammer', source)
        end)
    end

    if Shared.Battery.state then
        Framework.core.RegisterUsableItem('radiocell', function(source)
            TriggerClientEvent('mm_radio:client:recharge', source)
        end)
    end
else
    return error('Cannot Start Resource, MISSING DEPENDENCIES', 0)
end