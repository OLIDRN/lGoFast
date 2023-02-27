ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

count = 1

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(gofast.TimeToCooldown * 60000)
        count = 1
        TriggerClientEvent('gofast:GoFastCDCount', -1, count)
    end
end)

RegisterNetEvent('gofast:GoFastCDAdd')
AddEventHandler('gofast:GoFastCDAdd', function()
    count = 0
    TriggerClientEvent('gofast:GoFastCDCount', -1, count)
end)


RegisterNetEvent('gofast:argent')
AddEventHandler('gofast:argent', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local argent = math.random(25000, 30000)
    xPlayer.addMoney(argent)
    TriggerClientEvent('esx:showAdvancedNotification', _source, "~r~GoFast", "~g~Succès","Vous avez gagné ~r~"..argent.."~w~$ !" ,'CHAR_LESTER_DEATHWISH', 9)
end)

RegisterNetEvent('gofast:argent50')
AddEventHandler('gofast:argent50', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local argent = math.random(15000, 20000)
    xPlayer.addMoney(argent)
    TriggerClientEvent('esx:showAdvancedNotification', _source, "~r~GoFast", "~g~Succès","Vous avez gagné ~r~"..argent.."~w~$ !" ,'CHAR_LESTER_DEATHWISH', 9)
end)

RegisterNetEvent('gofast:police')
AddEventHandler('gofast:police', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    local coords = GetEntityCoords(GetPlayerPed(_source))
    local message = "Un ~r~GoFast ~w~est en cours !"
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "~r~Police", "~r~Signalement",message ,'CHAR_CALL911', 9)
        end
    end
end)