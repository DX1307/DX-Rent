ESX = exports['es_extended']:getSharedObject()
RegisterNetEvent('rentacar', function(price, plate, model)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
    else
        TriggerClientEvent('ox_lib:notify', xPlayer.source, { type = 'error', position = 'center-right',  title = 'Rent car', description = Strings.donthavemoney })
    end
end)

ESX.RegisterServerCallback('havemoney', function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= price then
        cb(true)
    else
        cb(false)
    end
end)
