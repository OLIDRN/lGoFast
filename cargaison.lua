---
--- Generated by Luanalysis
--- Created by olivi.
--- DateTime: 16/02/2023 18:35
---

props = false
CargaisonCharger = false

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local dest = vector3(948.9645, -1698.0959, 30.0864)
        local distance = GetDistanceBetweenCoords(coords, dest, true)
        local coordsPed = GetEntityCoords(ped2)
        vehicle = GetVehiclePedIsIn(playerPed, false)
        if distance < 30.0 and autoriseGofast() then
            if props == false then
                obj1 = CreateObject(GetHashKey("prop_table_04"), 945.0061, -1697.7292, 30.0850-0.98, true, true, true)
                headingOBJ1 = 83.5136
                SetEntityHeading(obj1, headingOBJ1)
                FreezeEntityPosition(obj1, true)
                Wait(2000)
                obj2 = CreateObject(GetHashKey("prop_drug_package"), 945.0061, -1697.7292, 30.0850-0.20, true, true, true)
                headingOBJ2 = 83.5136
                SetEntityHeading(obj2, headingOBJ2)
                Wait(1000)
                props = true
            end
            if CargaisonCharger == false then
                DrawMarker(2, dest.x, dest.y-0.50, dest.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 0, 0, 255, true, true, 2, true, false, false, false)
            end
        end
        if distance < 1.0 and autoriseGofast() and CargaisonCharger == false then
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour prendre la cargaison")
            if IsControlJustReleased(1, 51) then
                if IsPedInAnyVehicle(playerPed, false) then
                    FreezeEntityPosition(vehicle, true)
                    local gotocar = vector3(946.3400, -1697.9299, 30.0850)
                    TaskGoToCoordAnyMeans(playerPed, gotocar.x, gotocar.y, gotocar.z, 1.0, 0, 0, 786603, 0xbf800000)
                    SetEntityHeading(playerPed,81.3434)
                    Wait(5000)
                    DrawSub("Votre cargaison est prête, chargez la dans le coffre", 5000)
                    playAnim("anim@heists@box_carry@", "idle", 10000)
                    AttachEntityToEntity(obj2, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                    Wait(5000)
                    SetVehicleDoorOpen(vehicle, 5, 0, 0)
                    local goto2 = vector3(951.9694, -1698.2791, 30.0109)
                    TaskGoToCoordAnyMeans(playerPed, goto2.x, goto2.y, goto2.z, 1.0, 0, 0, 786603, 0xbf800000)
                    SetEntityHeading(playerPed,84.6736)
                    Wait(5000)
                    playAnim("mp_common", "givetake1_a", 3000)
                    Wait(3000)
                    AttachEntityToEntity(obj2, vehicle, GetEntityBoneIndexByName(vehicle, "boot"), 0.0, 0.4, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
                    Wait(1000)
                    DoScreenFadeOut(850)
                    SetVehicleDoorShut(vehicle, 5, 0, 0)
                    Wait(2000)
                    SetPedIntoVehicle(playerPed, vehicle, -1)
                    Wait(1000)
                    DoScreenFadeIn(850)
                    ClearPedTasks(playerPed)
                    FreezeEntityPosition(vehicle, false)
                    newPoint()
                    props = false
                    CargaisonCharger = true
                else
                    DrawSub("Vous devez être dans un véhicule pour prendre la cargaison", 5000)
                end
            end
        end
    end
end)