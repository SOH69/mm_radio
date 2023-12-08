local QBCore = nil
local ESX = nil


if Shared.Core == "qb" then
    QBCore = exports['qb-core']:GetCoreObject()

    if not Shared.Ready then return end

    QBCore.Functions.CreateUseableItem("radio", function(source)
        TriggerClientEvent('mm_radio:client:use', source)
    end)
elseif Shared.Core == 'qbx' then
    if not Shared.Ready then return end

    exports.qbx_core:CreateUseableItem("radio", function(source, item)
        TriggerClientEvent('mm_radio:client:use', source)
    end)
elseif Shared.Core == "esx" then
    ESX = exports['es_extended']:getSharedObject()

    if not Shared.Ready then return end

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
    elseif Shared.Core == 'qbx' then
        local Player = exports.qbx_core:GetPlayer(source)
        if Player then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        end
    elseif Shared.Core == "esx" and ESX then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.getName()
        end
    else
        return GetPlayerName(source)
    end
end