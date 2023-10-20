local function updateTime()
    while Radio.usingRadio do
        SendNUIMessage({
            action = "UpdateTime",
            InGameTime = Radio:CalculateTimeToDisplay(),
        })
        Wait(1500)
    end
end

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        if Shared.Core == 'qb' and LocalPlayer.state.isLoggedIn  then
            Radio:QBInit()
        elseif Shared.Core == 'esx' and ESX.IsPlayerLoaded() then
            Radio:ESXInit()
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        Radio:toggleRadioAnimation(false)
        if Radio.onRadio then
            Radio:leaveradio()
        end
    end
end)

RegisterNetEvent('mm_radio:client:use', function()
    Radio.usingRadio = true
    SetNuiFocus(true, true)
    Radio:toggleRadioAnimation(true)
    SendNUIMessage({
        action = "setRadioVisible",
        data = {
            onRadio = Radio.onRadio,
            channel = Radio.RadioChannel,
            volume = Radio.Volume,
            favourite = Radio.favourite,
            recomended = Radio.recomended,
            userData = Radio.userData,
            time = Radio:CalculateTimeToDisplay(),
            street = Radio:getCrossroads(),
            maxChannel = Shared.MaxFrequency,
        }
    })

    updateTime()
end)

RegisterNetEvent('mm_radio:client:remove', function()
    Radio.usingRadio = false
    SetNuiFocus(false, false)
    Radio:toggleRadioAnimation(false)
    SendNUIMessage({
        action = "setRadioHide"
    })
end)

RegisterNetEvent('mm_radio:client:radioListUpdate', function(players, channel)
    if Radio.RadioChannel == channel then
        SendNUIMessage({
            action = "updateRadioList",
            data = players
        })
    end
end)

RegisterNetEvent("pma-voice:radioActive", function(talkingState)
    SendNUIMessage({
        action = "updateRadioTalking",
        data = {
            radioId = tostring(Radio.playerServerID),
            radioTalking = talkingState
        }
    })
end)

RegisterNetEvent("pma-voice:setTalkingOnRadio", function(source, talkingState)
    SendNUIMessage({
        action = "updateRadioTalking",
        data = {
            radioId = tostring(source),
            radioTalking = talkingState
        }
    })
end)