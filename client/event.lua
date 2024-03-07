local function updateTime()
    while Radio.usingRadio do
        Radio:SendSvelteMessage("UpdateTime", Radio:CalculateTimeToDisplay())
        Wait(1500)
    end
end

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() == resource then
        if Shared.Core == 'qb' and LocalPlayer.state.isLoggedIn  then
            Radio:QBInit()
            Radio.playerLoaded = true
        elseif Shared.Core == 'qbx' and LocalPlayer.state.isLoggedIn then
            Radio:QboxInit()
            Radio.playerLoaded = true
        elseif Shared.Core == 'esx' and ESX.IsPlayerLoaded() then
            Radio:ESXInit()
            Radio.playerLoaded = true
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
    Radio:SendSvelteMessage("setRadioVisible", {
        onRadio = Radio.onRadio,
        channel = Radio.RadioChannel,
        volume = Radio.Volume,
        favourite = Radio.favourite,
        recomended = Radio.recomended,
        userData = Radio.userData,
        time = Radio:CalculateTimeToDisplay(),
        street = Radio:getCrossroads(),
        maxChannel = Shared.MaxFrequency,
        locale = Radio.locale,
        channelName = Shared.RadioNames
    })

    updateTime()
end)

RegisterNetEvent('mm_radio:client:remove', function()
    Radio.usingRadio = false
    SetNuiFocus(false, false)
    Radio:toggleRadioAnimation(false)
    Radio:SendSvelteMessage("setRadioHide", nil)
end)

RegisterNetEvent('mm_radio:client:radioListUpdate', function(players, channel)
    if Radio.RadioChannel == channel then
        Radio:SendSvelteMessage("updateRadioList", players)
    end
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