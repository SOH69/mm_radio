function Radio:SendSvelteMessage(name, data)
    if not Shared.Ready then return end
    SendNUIMessage({
        action = name,
        data = data
    })
end

RegisterNUICallback('join', function(data, cb)
    local rchannel = tonumber(data)
    JoinRadio(rchannel)
    cb("ok")
end)

RegisterNUICallback('leave', function(_, cb)
    if Radio.RadioChannel ~= 0 then
        Radio:leaveradio()
    end
    cb("ok")
end)

RegisterNUICallback('toggleMute', function(volume, cb)
    volume = tonumber(volume)
    Radio:Notify(locale(volume == 0 and 'toggle_defean' or 'toggle_undeafen'))
	exports["pma-voice"]:setRadioVolume(volume)
    Radio.Volume = volume
    cb('ok')
end)

RegisterNUICallback("volumeChange", function(data, cb)
    data = tonumber(data)
    Radio:Notify(locale('volume_notify_description', data))
	exports["pma-voice"]:setRadioVolume(data)
    Radio.Volume = data
    cb('ok')
end)

RegisterNUICallback("hideUI", function(_, cb)
    TriggerEvent('mm_radio:client:remove')
    cb('ok')
end)

RegisterNUICallback('addFav', function(data, cb)
    data = tonumber(data)
    if Radio.RadioChannel == data then
        Radio.favourite[#Radio.favourite+1] = data
        Radio.userData[Radio.identifier].favourite[#Radio.userData[Radio.identifier].favourite+1] = data
        SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    end
    cb("ok")
end)

RegisterNUICallback('removeFav', function(data, cb)
    data = tonumber(data)
    if Radio.RadioChannel == data then
        for index, val in ipairs(Radio.favourite) do
            if val == data then
                table.remove(Radio.favourite, index)
            end
        end
        for index, val in ipairs(Radio.userData[Radio.identifier].favourite) do
            if val == data then
                table.remove(Radio.userData[Radio.identifier].favourite, index)
            end
        end
        SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    end
    cb("ok")
end)

RegisterNUICallback('showPlayerList', function(data, cb)
    Radio.userData[Radio.identifier].playerlist.show = data
    SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    cb("ok")
end)

RegisterNUICallback('updatePlayerListPosition', function(data, cb)
    Radio.userData[Radio.identifier].playerlist.coords = {
        x = data.x,
        y = data.y
    }
    SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    cb("ok")
end)

RegisterNUICallback('updateRadioPosition', function(data, cb)
    Radio.userData[Radio.identifier].radio.coords = data
    SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    cb("ok")
end)

RegisterNUICallback('updateRadioSize', function(data, cb)
    Radio.userData[Radio.identifier].radioSizeMultiplier = data.radio
    Radio.userData[Radio.identifier].overlaySizeMultiplier = data.overlay
    SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    cb("ok")
end)

RegisterNUICallback('saveData', function(data, cb)
    local player = Framework.core.getPlayerData()
    local identifier = player.cid
    if not identifier then return Radio:Notify(locale('unsuccess_name', channel)) end
    Radio.userData[Radio.identifier].name = data
    Radio:update()
    TriggerServerEvent('mm_radio:server:addToRadioChannel', Radio.RadioChannel, data)
    SetResourceKvp('radioSettings2', json.encode(Radio.userData))
    cb("ok")
end)