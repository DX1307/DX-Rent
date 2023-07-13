ESX = exports['es_extended']:getSharedObject()
CreateThread(function()
    for k, v in pairs(Config.Rent) do
        rent(k,v)
    end
end)

RegisterNetEvent('spawncar', function(data)
    ESX.TriggerServerCallback('havemoney', function(have)
        if have then
            if ESX.Game.IsSpawnPointClear(data.spawncoords, 3.0) then
                DoScreenFadeOut(800)
                while not IsScreenFadedOut() do
                    Wait(100)
                end
                ESX.Game.SpawnVehicle(data.model, data.spawncoords, data.spawnheading, function(vehicle)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    TriggerServerEvent('rentacar', data.price, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
                end)
                DoScreenFadeIn(800)
            else
                lib.notify({
                    title = 'Rent car',
                    description = Strings.movecar,
                    position = 'center-right',
                    type = 'success'
                })
            end
        else
            lib.notify({
                title = 'Rent car',
                description = Strings.donthavemoney,
                position = 'center-right',
                type = 'success'
            })
        end
    end, data.price)
end)

function rent(k, data)
    --BLIP
    blip = AddBlipForCoord(data.pedcoords.x, data.pedcoords.y, data.pedcoords.z)
    SetBlipSprite(blip, data.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, data.scale)
    SetBlipColour(blip, data.color)
    SetBlipAsShortRange(blip, true)
  BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.text)
    EndTextCommandSetBlipName(blip)

    --PED
    RequestModel(GetHashKey(data.ped))
    while not HasModelLoaded(GetHashKey(data.ped)) do
        Wait(1)
    end
    RentPed = CreatePed(4, data.ped, vector3(data.pedcoords.x, data.pedcoords.y, data.pedcoords.z - 1), data.pedheading, false, true)
    FreezeEntityPosition(RentPed, true)
    SetEntityInvincible(RentPed, true)
    SetBlockingOfNonTemporaryEvents(RentPed, true)

    --TARGET AND CONTEXT

    exports.qtarget:AddBoxZone("rent-"..k, vector3(data.pedcoords.x, data.pedcoords.y, data.pedcoords.z - 1), 0.45, 0.35, {
        name="rent-"..k,
        heading=data.pedheading,
        debugPoly=false,
        minZ=data.pedcoords.z - 1,
        maxZ=data.pedcoords.z + 2,
    }, {
        options = {
            {
                action = function ()
                    lib.registerContext({
                        id = 'rent-'..k,
                        title = data.title,
                        options = data.vehicles
                    })

                    lib.showContext('rent-'..k)
                end,
                icon = data.icon,
                label = data.label,
            },
        },
        distance = data.distance
    })

    -- REMOVECAR
    Citizen.CreateThread(function()
        while true do
            sleep = 7
            local PlayerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(PlayerPed)
            local playerPosDelete = GetEntityCoords(PlayerPed)
            local dist = #(playerPosDelete-data.removecoords)
            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                if dist <= 15 then
                    DrawMarker(36,data.removecoords.x,data.removecoords.y,data.removecoords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 0, 0, 100, false, true, 2, true, false, false, false)
                    if dist <= 1.5 then
                        DrawText3Ds(data.removecoords.x,data.removecoords.y,data.removecoords.z, '[~y~E~w~] to ~r~Delete a ~w~Car')
                        if IsControlJustPressed(0, 38) then
                            if IsPedInAnyVehicle(GetPlayerPed(-1)) then
                                TaskLeaveVehicle(PlayerPed, vehicle, 0)
                                Wait(2500)
                                ESX.Game.DeleteVehicle(vehicle)
                                lib.notify({
                                    title = 'RentCar',
                                    description = Strings.removecar,
                                    position = 'center-right',
                                    type = 'error'
                                }) 
                                sleep = 7
                            else
                                lib.notify({
                                    title = 'RentCar',
                                    description = Strings.getinthecar,
                                    position = 'center-right',
                                    type = 'error'
                                }) 
                            end
                        end			
                    end
                end
            end
            Wait(sleep)
        end
    end)
end


function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.32, 0.32)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end