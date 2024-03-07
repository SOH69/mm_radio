
if Shared.Core == "esx" then
    export, ESX = pcall(function() return exports.es_extended:getSharedObject() end)
    if not export then
        while not ESX do
            TriggerEvent("esx:getSharedObject", function(obj)
                ESX = obj
            end)
            Wait(500)
        end
    end

    function Radio:ESXInit()
        Radio.PlayerJob = ESX.PlayerData.job.name
        Radio.PlayerGang = ESX.PlayerData.job.name
        Radio.PlayerDuty = true
        Radio.userData.name = Radio.userData.name or ESX.PlayerData.firstName .. " " .. ESX.PlayerData.lastName

        local rec = {}
        for k, v in ipairs(Shared.RestrictedChannels) do
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

    RegisterNetEvent('esx:playerLoaded', function(xPlayer)
        ESX.PlayerData = xPlayer
	    ESX.PlayerLoaded = true
        Radio.playerLoaded = true
        Radio:ESXInit()
    end)

    RegisterNetEvent('esx:onPlayerLogout', function()
        Radio.PlayerItems = {}
        Radio.hasRadio = false
        Radio.playerLoaded = false
        Radio:leaveradio()
    end)

    RegisterNetEvent('esx:setJob', function(job)
        ESX.PlayerData.job = job
        Radio.PlayerDuty = true
        Radio:ESXInit()
    end)

    AddEventHandler('esx:onPlayerDeath', function()
        if ESX.IsPlayerLoaded() and Radio.onRadio and Radio.hasRadio and Radio.RadioChannel ~= 0 then
            Radio:leaveradio()
        end
    end)
end
