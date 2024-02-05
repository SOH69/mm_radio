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
        Radio.userData.favourite[#Radio.userData.favourite+1] = data
        SetResourceKvp('radioSettings', json.encode(Radio.userData))
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
        for index, val in ipairs(Radio.userData.favourite) do
            if val == data then
                table.remove(Radio.userData.favourite, index)
            end
        end
        SetResourceKvp('radioSettings', json.encode(Radio.userData))
    end
    cb("ok")
end)

RegisterNUICallback('showPlayerList', function(data, cb)
    Radio.userData.playerlist.show = data
    SetResourceKvp('radioSettings', json.encode(Radio.userData))
end)

RegisterNUICallback('updatePlayerListPosition', function(data, cb)
    Radio.userData.playerlist.coords = {
        x = data.x,
        y = data.y
    }
    SetResourceKvp('radioSettings', json.encode(Radio.userData))
end)

RegisterNUICallback('saveData', function(data, cb)
    Radio.userData.name = data
    Radio:update()
    TriggerServerEvent('mm_radio:server:addToRadioChannel', Radio.RadioChannel, data)
    SetResourceKvp('radioSettings', json.encode(Radio.userData))
end)