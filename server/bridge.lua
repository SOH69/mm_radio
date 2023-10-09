local QBCore = nil
local ESX = nil


if Shared.Core == "qb" then
    QBCore = exports['qb-core']:GetCoreObject()

    QBCore.Functions.CreateUseableItem("radio", function(source)
        TriggerClientEvent('mm_radio:client:use', source)
    end)
elseif Shared.Core == "esx" then
    ESX = exports['es_extended']:getSharedObject()

    ESX.RegisterUsableItem('radio', function(source)
        TriggerClientEvent('mm_radio:client:use', source)
    end)
end

function GetUserName(source)
    if Shared.Core == "qb" and QBCore then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        end
    elseif Shared.Core == "esx" and ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.getName()
        end
    end
end