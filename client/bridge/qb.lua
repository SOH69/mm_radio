if Shared.Core == "qb" then
    function Radio:QBInit(items)
        local PlayerData = QBCore.Functions.GetPlayerData()
        if not PlayerData then return end
        Radio.PlayerJob = PlayerData.job.name
        Radio.PlayerGang = PlayerData.gang.name
        Radio.PlayerItems = items or PlayerData.items

        Radio:doRadioCheck()
        local rec = {}
        for k, v in pairs(Shared.RestrictedChannels) do
            print(k)
            if v.type == 'job' and lib.table.contains(v.name, Radio.PlayerJob) then
                rec[#rec+1] = k
            elseif v.type == 'gang' and lib.table.contains(v.name, Radio.PlayerGang) then
                rec[#rec+1] = k
            end
        end
        Radio.favourite = rec
        for _, val in ipairs(Radio.userfav) do
            if not lib.table.contains(Radio.favourite, val) then
                Radio.favourite[#Radio.favourite+1] = val
            end
        end
    end

    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        Radio:QBInit()
        Radio:setSubmixEffect()
    end)

    -- Resets state on logout, in case of character change.
    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        Radio.PlayerItems = {}
        Radio.hasRadio = false
        Radio:leaveradio()
    end)

    RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
        Radio:QBInit(val.items)
    end)

    RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
        Radio.PlayerJob = job.name
        Radio:QBInit()
    end)

    RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
        Radio.PlayerGang = gang.name
        Radio:QBInit()
    end)
end