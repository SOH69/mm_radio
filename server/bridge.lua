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