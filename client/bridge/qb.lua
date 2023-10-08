function Radio:QBInit(items)
    Radio.PlayerData = QBCore.Functions.GetPlayerData()
    Radio.PlayerItems = items or Radio.PlayerData.items
    Radio:doRadioCheck()
    local rec = {}
    for k, v in ipairs(Shared.RestrictedChannels) do
        if v.type == 'job' and lib.table.contains(v.name, Radio.PlayerData.job.name) then
            rec[#rec+1] = k
        elseif v.type == 'gang' and lib.table.contains(v.name, Radio.PlayerData.gang.name) then
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

RegisterNetEvent('QBCore:Client:OnJobUpdate', function()
    Radio:QBInit()
end)