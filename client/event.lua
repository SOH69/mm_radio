AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        if Shared.Core and Framework.core.playerLoaded() then
            Radio:Init()
            Radio.playerLoaded = true
            TriggerServerEvent('mm_radio:server:createdefaultjammer')
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        Radio:toggleRadioAnimation(false)
        Radio:RemoveJammerZone()
        if Radio.onRadio then
            Radio:leaveradio()
        end
    end
end)

RegisterNetEvent('mm_radio:client:use', function(slot)
    if Radio.PlayerDead or IsPedFatallyInjured(cache.ped) then return end
    Radio.usingRadio = true
    SetNuiFocus(true, true)
    Radio:toggleRadioAnimation(true)
    local battery, radioId = lib.callback.await('mm_radio:server:getradiodata', false, slot)
    local userdata = Radio.userData[Radio.identifier]
    Radio:SendSvelteMessage("setRadioVisible", {
        radioId = radioId,
        onRadio = Radio.onRadio,
        channel = Radio.RadioChannel,
        volume = Radio.Volume,
        favourite = Radio.favourite,
        recomended = Radio.recomended,
        userData = userdata,
        time = Radio:CalculateTimeToDisplay(),
        street = Radio:getCrossroads(),
        maxChannel = Shared.MaxFrequency,
        locale = Radio.locale,
        channelName = Shared.RadioNames,
        insideJammerZone = Radio.signalJammed,
        battery = battery,
        overlay = Shared.Overlay
    })
    UpdateTime()
    if userdata.allowMovement then
        SetNuiFocusKeepInput(true)
        DisableControls()
    end
end)

RegisterNetEvent('mm_radio:client:usejammer', function()
    if not Shared.Jammer.permission or not (lib.table.contains(Shared.Jammer.permission, Radio.PlayerJob) or lib.table.contains(Shared.Jammer.permission, Radio.PlayerGang)) then
        return Framework.notify({
            title = 'You dont have permission to use this item',
            type = 'error'
        })
    end
    local plyCoords = GetEntityCoords(cache.ped)
    local forward = GetEntityForwardVector(cache.ped)
    local x, y, z = table.unpack(plyCoords + forward * 1.0)
    local id = math.random(1000, 9999)
    TriggerServerEvent('mm_radio:server:spawnobject', {
        coords = vec4(x, y, z - 1.0, GetEntityHeading(cache.ped)),
        id = id,
        range = Shared.Jammer.range.default,
        allowedChannels = {},
        canRemove = true,
        canDamage = true
    })
end)

RegisterNetEvent('mm_radio:client:syncobject', function(data)
    local entity = NetworkGetEntityFromNetworkId(data.object)
    SetEntityCanBeDamaged(entity, data.canDamage)
    Radio.jammer[#Radio.jammer+1] = {
        id = data.id,
        entity = entity,
        coords = data.coords,
        allowedChannels = data.allowedChannels,
        range = data.range,
        enable = data.enable,
        canRemove = data.canRemove,
        zone = lib.zones.sphere({
            coords = data.coords,
            radius = data.range,
            debug = Shared.Debug,
            jammerid = data.id,
            entity = entity,
            onEnter = OnEnterJammerZone,
            onExit = OnExitJammerZone
        }),
        zoneJammer = lib.zones.sphere({
            coords = data.coords,
            radius = 2.5,
            debug = Shared.Debug,
            jammerid = data.id,
            entity = entity,
            onEnter = OnEnterJammer,
            onExit = OnExitJammer
        })
    }
end)

RegisterNetEvent('mm_radio:client:changeJammerRange', function(id, range)
    for i=1, #Radio.jammer do
        local entity = Radio.jammer[i]
        if entity.id == id then
            entity.zone:remove()
            Wait(1000)
            entity.range = range
            entity.zone = lib.zones.sphere({
                coords = entity.coords,
                radius = range,
                debug = Shared.Debug,
                jammerid = id,
                entity = entity.entity,
                onEnter = OnEnterJammerZone,
                onExit = OnExitJammerZone
            })
            break
        end
    end
end)

RegisterNetEvent('mm_radio:client:removeallowedchannel', function(id, allowedChannels)
    for i=1, #Radio.jammer do
        local entity = Radio.jammer[i]
        if entity.id == id then
            entity.allowedChannels = allowedChannels
            Radio:UpdateJammerZone(id, allowedChannels)
            break
        end
    end
end)

RegisterNetEvent('mm_radio:client:addallowedchannel', function(id, allowedChannels)
    for i=1, #Radio.jammer do
        local entity = Radio.jammer[i]
        if entity.id == id then
            entity.allowedChannels = allowedChannels
            Radio:UpdateJammerZone(id, allowedChannels)
            break
        end
    end
end)

RegisterNetEvent('mm_radio:client:togglejammer', function(id, state)
    for i=1, #Radio.jammer do
        local entity = Radio.jammer[i]
        if entity.id == id then
            entity.enable = state
            if state then
                entity.zone = lib.zones.sphere({
                    coords = entity.coords,
                    radius = entity.range,
                    debug = Shared.Debug,
                    jammerid = id,
                    entity = entity.entity,
                    onEnter = OnEnterJammerZone,
                    onExit = OnExitJammerZone
                })

            else
                entity.zone:remove()
                Radio:UpdateJammerRemove(id)
            end
            break
        end
    end
end)

RegisterNetEvent('mm_radio:client:removejammer', function(id)
    for i=1, #Radio.jammer do
        local entity = Radio.jammer[i]
        if entity.id == id then
            entity.zone:remove()
            entity.zoneJammer:remove()
            Radio:UpdateJammerRemove(id)
            table.remove(Radio.jammer, i)
        end
    end
end)

RegisterNetEvent('mm_radio:client:remove', function()
    SetNuiFocus(false, false)
    if Radio.userData[Radio.identifier].allowMovement then
        SetNuiFocusKeepInput(false)
    end
    Radio:toggleRadioAnimation(false)
    Radio:SendSvelteMessage("setRadioHide", nil)
    SetTimeout(100, function()
        Radio.usingRadio = false
    end)
end)

RegisterNetEvent('mm_radio:client:radioListUpdate', function(players, channel)
    if Radio.RadioChannel == channel then
        Radio:SendSvelteMessage("updateRadioList", players)
    end
end)

RegisterNetEvent('mm_radio:client:nocharge', function()
    Radio:leaveradio()
end)

RegisterNetEvent("mm_radio:client:recharge", function()
    TriggerServerEvent('mm_radio:server:rechargeBattery')
end)

RegisterNetEvent("pma-voice:radioActive", function(talkingState)
    Radio:SendSvelteMessage("updateRadioTalking", {
        radioId = tostring(Radio.playerServerID),
        radioTalking = talkingState
    })
end)

RegisterNetEvent("pma-voice:setTalkingOnRadio", function(source, talkingState)
    Radio:SendSvelteMessage("updateRadioTalking", {
        radioId = tostring(source),
        radioTalking = talkingState
    })
end)

RegisterNetEvent('bl_bridge:client:playerLoaded', function()
    Radio.playerLoaded = true
    Radio:Init()
    TriggerServerEvent('mm_radio:server:createdefaultjammer')
    local jammer = lib.callback.await('mm_radio:server:getjammer', false)
    for i = 1, #jammer do
        jammer[i].entity = NetworkGetNetworkIdFromEntity(jammer[i].entity)
        TriggerEvent('mm_radio:client:syncobject', jammer[i])
    end
end)

RegisterNetEvent('bl_bridge:client:playerUnloaded', function()
    Radio.hasRadio = false
    Radio:leaveradio()
    Radio.playerLoaded = false
end)

RegisterNetEvent('bl_bridge:client:jobUpdated', function(job)
    local player = Framework.core.getPlayerData()
    player.job = job
    Radio:Init(player)
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    if Radio.playerLoaded then
        Wait(1000)
        Radio:doRadioCheck(val.items)
        Radio.PlayerDead = val.metadata.isdead or val.metadata.inlaststand
    end
end)

RegisterNetEvent('bl_bridge:client:gangUpdated', function(gang)
    local player = Framework.core.getPlayerData()
    player.gang = gang
    Radio:Init(player)
end)

RegisterNetEvent("QBCore:Client:SetDuty", function(newDuty)
    Radio.PlayerDuty = newDuty
end)

RegisterNetEvent("ND:updateCharacter", function(character)
    Radio.PlayerDead = character.metadata.dead
end)

AddEventHandler('ox_inventory:updateInventory', function()
    Radio:doRadioCheck()
end)

AddEventHandler('gameEventTriggered', function(event, data)
    if event == "CEventNetworkEntityDamage" then
        if not IsEntityAPed(data[1]) then return end
        if data[4] and NetworkGetPlayerIndexFromPed(data[1]) == cache.playerId and IsEntityDead(cache.ped) then
            if Radio.usingRadio then
                TriggerEvent('mm_radio:client:remove')
            end
            if Radio.playerLoaded and Radio.onRadio and Radio.hasRadio and Radio.RadioChannel ~= 0 then
                Radio:leaveradio()
            end
        end
    end
end)

AddStateBagChangeHandler('dead', ('player:%s'):format(cache.serverId), function(_, _, value)
    Radio.PlayerDead = value
end)