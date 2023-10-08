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
    if GetCurrentResourceName() == resource and LocalPlayer.state.isLoggedIn then
        if Shared.Core == 'qb' then
            Radio:QBInit()
        elseif Shared.Core == 'esx' then
            Radio:ESXInit()
        end
        Radio:setSubmixEffect()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() == resource then
        Radio:toggleRadioAnimation(false)
    end
end)

AddEventHandler('gameEventTriggered', function(event, data)
    if event == "CEventNetworkEntityDamage" then
        if not IsEntityAPed(data[1]) then return end
        if data[4] and NetworkGetPlayerIndexFromPed(data[1]) == cache.playerId and IsEntityDead(cache.ped) then
            if LocalPlayer.state.isLoggedIn and Radio.onRadio then
                if Radio.hasRadio then
                    if RadioChannel ~= 0 then
                        Radio:leaveradio()
                    end
                end
            end
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
            time = Radio:CalculateTimeToDisplay(),
            street = Radio:getCrossroads()
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

function Radio:setSubmixEffect()
	local radioEffectId = CreateAudioSubmix('Radio_Default')
    SetAudioSubmixEffectRadioFx(radioEffectId, 0)
    SetAudioSubmixEffectParamInt(radioEffectId, 0, `default`, 1)
    for filter, value in pairs(Shared.DefaultRadioFilter) do
        SetAudioSubmixEffectParamFloat(radioEffectId, 0, filter, value)
    end
    SetAudioSubmixOutputVolumes(
        radioEffectId,
        0,
        0.5 ,
        0.5,
        0.0,
        0.0,
        1.0,
        1.0
    )
    AddAudioSubmixOutput(radioEffectId, 0)
    if GetResourceState('pma-voice') == 'started' then
        exports['pma-voice']:setEffectSubmix('radio', radioEffectId)
    end
end