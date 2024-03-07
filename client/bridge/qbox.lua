if Shared.Core == "qbx" then
    function Radio:QboxInit(data)
        local PlayerData = data or exports.qbx_core:GetPlayer()
        if PlayerData then
            Radio.PlayerJob = PlayerData.job.type
            Radio.PlayerGang = PlayerData.gang.name
            Radio.PlayerDuty = PlayerData.job.onduty
        end
        Radio.userData.name = Radio.userData.name or PlayerData.charinfo.firstname .. " " .. PlayerData.charinfo.lastname

        local rec = {}
        for k, v in pairs(Shared.RestrictedChannels) do
            if v.type == 'job' and lib.table.contains(v.name, Radio.PlayerJob) then
                rec[#rec+1] = k
            elseif v.type == 'gang' and lib.table.contains(v.name, Radio.PlayerGang) then
                rec[#rec+1] = k
            end
        end
        Radio.favourite = rec
        for _, val in ipairs(Radio.userData.favourite) do
            if not lib.table.contains(Radio.favourite, val) then
                Radio.favourite[#Radio.favourite+1] = val
            end
        end
        Radio:doRadioCheck()
    end

    RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
        Radio:QboxInit()
        Radio.playerLoaded = true
    end)

    -- Resets state on logout, in case of character change.
    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        Radio.PlayerItems = {}
        Radio.hasRadio = false
        Radio:leaveradio()
        Radio.playerLoaded = false
    end)

    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
        Radio.PlayerJob = job.type
        Radio:QboxInit()
    end)

    RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
        Radio.PlayerGang = gang.name
        Radio:QboxInit()
    end)

    RegisterNetEvent("QBCore:Client:SetDuty", function(newDuty)
        Radio.PlayerDuty = newDuty
    end)

    AddEventHandler('gameEventTriggered', function(event, data)
        if event ~= "CEventNetworkEntityDamage" then return end
        if not IsEntityAPed(data[1]) then return end
        if data[4] and NetworkGetPlayerIndexFromPed(data[1]) == cache.playerId and IsEntityDead(cache.ped) then
            if LocalPlayer.state.isLoggedIn and Radio.onRadio and Radio.hasRadio and Radio.RadioChannel ~= 0 then
                Radio:leaveradio()
            end
        end
    end)
end