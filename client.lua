ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    Wait(5000)
end)

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
        Wait(10)
    end
    if ESX.IsPlayerLoaded() then

        ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)


count = 1 
RegisterNetEvent("gofast:GoFastCDCount")
AddEventHandler("gofast:GoFastCDCount", function()
    count = _count
end)

function DrawSub(msg, time)
    ClearPrints()
    BeginTextCommandPrint('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandPrint(time, 1)
end

function playAnim(animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do Wait(0) end
    TaskPlayAnim(PlayerPedId(), animDict, animName, 1.0, -1.0, duration, 49, 1, false, false, false)
    RemoveAnimDict(animDict)
end


Citizen.CreateThread(function()
    local dest = vector3(1253.8260, -2557.7439, 42.7145)
    local hashP = GetHashKey("g_m_y_lost_01")
    while not HasModelLoaded(hashP) do
        RequestModel(hashP)
        Wait(20)
    end
    ped = CreatePed("PED_TYPE_CIVMALE", hashP, dest.x, dest.y, dest.z-1.0, 213.3470, true, false)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    TaskStartScenarioInPlace(ped, "CODE_HUMAN_CROSS_ROAD_WAIT", 0, true)
end)

function gofastinterac()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
        ESX.ShowNotification("~r~Vous ne pouvez pas faire de GoFast en tant que policier !")
        -- Ped --
        FreezeEntityPosition(ped, true)
        GiveWeaponToPed(ped, GetHashKey("WEAPON_PISTOL"), 999, false, true)
        TaskCombatPed(ped, PlayerPedId(), 0, 16)
        TaskHandsUp(PlayerPedId(), 2000, ped, -1, true)
        Wait(5000)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityAsMissionEntity(ped, true, true)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STRIP_WATCH_STAND", 0, true)
    else
        local hash = GetHashKey("tailgater2")
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(1)
        end
        veh = CreateVehicle(hash, 1258.5360, -2565.6523, 42.7173, 282.1254, true, false)
        DoScreenFadeOut(1500)
        Wait(1300)
        local Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        ShakeCam(Camera, "HAND_SHAKE", 0.3)
        SetCamCoord(Camera, 1253.8260, -2557.7439, 42.7145)
        RenderScriptCams(true, true, 10, true, true)
        SetCamFov(Camera, 50.0)
        SetCamCoord(Camera, 1249.4546, -2559.8308, 46.8117)
        PointCamAtEntity(Camera, PlayerPedId())
        DoScreenFadeIn(3500)
        DrawSub("~r~L'inconnu~s~: Salut, tu veux faire un ~r~GoFast ?", 5000)
        Wait(5000)
        DrawSub("~b~Vous~s~: Oui, pourquoi pas !", 5000)
        Wait(5000)
        DrawSub("~r~L'inconnu~s~: Allze charger la cargaison !", 5000)
        Wait(5000)
        DrawSub("~b~Vous~s~: Ok !", 5000)
        Wait(5000)
        DoScreenFadeOut(850)
        Wait(2500)
        SetPedIntoVehicle(PlayerPedId(), veh, -1)
        RenderScriptCams(0, 1, 500, 1, 1)
        RenderScriptCams(true, true, 10, true, true)
        DoScreenFadeIn(3500)
        RenderScriptCams(false, true, 2000, true, true)
        DestroyCam(Camera, true)
        ClearPedTasks(PlayerPedId())
        gofastmain()
    end
end


Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)
        local dest = vector3(1254.2120, -2558.6819, 42.7147)
        local distance = GetDistanceBetweenCoords(coords, dest, true)
        if distance < 10.0 then
            sleep = 5
            DrawMarker(23, 1254.2120, -2558.6819, 42.7147-0.98, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 255, 255,170, 0, 1, 2, 0, nil, nil, 0)
        end
        if count > 0 then 
            if distance < 1.0 then
                sleep = 5
                ESX.ShowHelpNotification("Appuyez sur ~b~[E]~s~ pour parler a ~r~l'inconnu")
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent("gofast:GoFastCDAdd")
                    gofastinterac()
                end
            end
        else
            ESX.ShowNotification("~r~Vous devez attendre 1h avant de refaire un GoFast !", 5000, true, 1)
        end
        Citizen.Wait(sleep)
    end
end)


function autoriseGofast()
    local playerPed = PlayerPedId()
    local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

    for i=1, #gofast.autorise, 1 do
        if vehModel == GetHashKey(gofast.autorise[i].model) then
            return true
        end
    end

    return false
end

function gofastmain()

    -- Vérification du job --

    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
        ESX.ShowNotification("Vous ne pouvez pas faire de ~r~GoFast ~w~en tant que ~b~policier")

    else

        -- Véhicule Détails --

        TriggerServerEvent('gofast:police')
        SetEntityAsMissionEntity(veh, true, true)
        local plaque = "GOFAST"..math.random(1,9)
        SetVehicleNumberPlateText(veh, plaque)
        SetVehicleOnGroundProperly(veh)
        SetVehicleFuelLevel(veh, 100.0)
        SetVehicleOilLevel(veh, 100.0)
        SetVehicleEngineOn(veh, true, true)
        -- Blips du véhicule --

        blips = AddBlipForEntity(veh)
        SetBlipSprite(blips, 225)
        SetBlipColour(blips, 1)
        SetBlipScale(blips, 0.8)
        SetBlipAsShortRange(blips, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Go Fast")
        EndTextCommandSetBlipName(blips)

        -- Blips de la position finale --

        PointRandom()

        -- Blips Police 1 min --
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
            blips_police = AddBlipForEntity(veh)
            SetBlipSprite(blips_police, 306)
            SetBlipColour(blips_police, 1)
            SetBlipScale(blips_police, 0.8)
            SetBlipAsShortRange(blips_police, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Individu en ~r~Go Fast, vous avez 1 minute pour le rattraper !")
            EndTextCommandSetBlipName(blips_police)

            timer_cops = true
            minute_cops = 1
            seconde_cops = 0
            while timer_cops == true do
                Wait(1000)
                seconde_cops = seconde_cops - 1
                if seconde_cops == -1 then
                    minute_cops = minute_cops - 1
                    seconde_cops = 59
                end
                if minute_cops == 0 and seconde_cops == 0 then
                    timer_cops = false
                    RemoveBlip(blips_police)
                end
                if minute_cops == 0 and seconde_cops == 30 then
                    ESX.ShowNotification("Il vous reste ~r~30 secondes ~w~pour rattraper le ~r~GoFast")
                end
            end
        end

        -- Fin des blips --

        -- Timer --

        timer = true
        minute = 7
        seconde = 0
        while timer == true do
            Wait(1000)
            seconde = seconde - 1
            if seconde == -1 then
                minute = minute - 1
                seconde = 59
            end
            if minute == 0 and seconde == 0 then
                timer = false
                ESX.ShowNotification("Vous avez ~r~perdu ~w~le ~r~GoFast")
                RemoveBlip(blip)
                RemoveBlip(blips)
                DeleteEntity(veh)
            end
            DrawSub("~r~Temps restant : ~w~"..minute..":"..seconde.. "", 1000)
        end
        -- Fin du GoFast --
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k,v in pairs(gofast.randomPoint) do
            local sleep = 500
            local playerPed = PlayerPedId()
            local coords    = GetEntityCoords(playerPed)
            local dest = vector3(v.x, v.y, v.z)
            local distance = GetDistanceBetweenCoords(coords, dest, true)
            if distance < 10.0 and gofast.jeveuxmarker then
                sleep = 0
                if autoriseGofast() then
                    DrawMarker(2, v.x, v.y-0.50, v.z-0.98, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 255, 0, 0, 255, true, true, 2, true, false, false, false)
                end
            end
            if autoriseGofast() then
                sleep = 5
                if distance <= 3.0 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour terminer le ~r~GoFast")
                    if IsControlJustPressed(1, 51) then
                        FreezeEntityPosition(veh, true)
                        RemoveBlip(blip)
                        RemoveBlip(blips)
                        timer = false
                        timer_cops = false

                        DoScreenFadeOut(1500)
                        Wait(1300)
                        local Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                        ShakeCam(Camera, "HAND_SHAKE", 0.3)
                        SetCamCoord(Camera, 516.7614, 173.6704,101.9216)
                        SetCamRot(Camera, 0.0, 0.0, 0.0)
                        RenderScriptCams(true, false, 0, true, true)
                        PointCamAtEntity(Camera, PlayerPedId())
                        DoScreenFadeIn(3500)
                        SetPedIntoVehicle(PlayerPedId(), veh, 0)
                        local gotoCoffre = vector3(521.4490, 168.1350, 99.3716)
                        TaskGoToCoordAnyMeans(PlayerPedId(), gotoCoffre.x, gotoCoffre.y, gotoCoffre.z, 1.0, 0, 0, 786603, 0xbf800000)
                        Wait(5000)
                        SetVehicleDoorOpen(veh, 5, 0, 0)
                        Wait(1000)
                        SetEntityHeading(PlayerPedId(), 68.1291)
                        playAnim("anim@heists@box_carry@", "idle", 5000)
                        AttachEntityToEntity(obj2, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                        local gotoFinal = vector3(515.0125, 169.6769, 99.3701)
                        TaskGoToCoordAnyMeans(PlayerPedId(), gotoFinal.x, gotoFinal.y, gotoFinal.z, 1.0, 0, 0, 786603, 0xbf800000)
                        Wait(5000)
                        playAnim("mp_common", "givetake1_b", 5000)
                        Wait(2000)
                        DetachEntity(obj, true, true)
                        SetVehicleDoorShut(veh, 5, 0, 0)
                        Wait(2000)
                        DoScreenFadeOut(850)
                        Wait(2000)
                        RenderScriptCams(0, 1, 500, 1, 1)
                        RenderScriptCams(true, true, 10, true, true)
                        RenderScriptCams(false, true, 2000, true, true)
                        DoScreenFadeIn(3500)
                        DestroyCam(Camera, true)
                        DeleteEntity(obj1)
                        DeleteEntity(obj2)
                        DeleteEntity(veh)
                        ESX.ShowNotification("Vous avez ~g~gagné ~w~le ~g~GoFast")
                        Wait(1000)
                        if percent < 50 then
                            TriggerServerEvent('gofast:argent50')
                        else
                            TriggerServerEvent('gofast:argent')
                        end

                    end
                end
            end
            Citizen.Wait(sleep)
        end
    end
end)

function PointRandom()
    blip = AddBlipForCoord(945.9724, -1697.7732, 30.0850)
    SetBlipSprite(blip, 225)
    SetBlipColour(blip, 1)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Chargez le coffre")
    EndTextCommandSetBlipName(blip)
    SetBlipRoute(blip, true)
end

function newPoint()
    blips = AddBlipForCoord(518.1937,169.2233,99.3694)
    SetBlipSprite(blips, 225)
    SetBlipColour(blips, 1)
    SetBlipScale(blips, 0.8)
    SetBlipAsShortRange(blips, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Livrez la marchandise")
    EndTextCommandSetBlipName(blips)
    SetBlipRoute(blips, true)
end

function DrawText3D(x, y, z, scale, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 300
        DrawRect(_x, _y + 0.0120, 0.0 + factor, 0.025, 41, 11, 41, 100)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsPedInAnyVehicle(PlayerPedId(), false) and autoriseGofast() then
            veh = GetVehiclePedIsIn(PlayerPedId(), false)
            health = GetEntityHealth(veh)
            maxHealth = 1000
            percent = math.floor((health / maxHealth) * 100)
            DrawText3D(GetEntityCoords(veh).x, GetEntityCoords(veh).y, GetEntityCoords(veh).z + 1.0, 0.4, "Vie du véhicule : "..percent.."%")
            if percent == 0 then
                ESX.ShowNotification("Votre véhicule est mort")
                FreezeEntityPosition(veh, true)
                DeleteEntity(obj)
                RemoveBlip(blip)
                RemoveBlip(blips)
                timer = false
                timer_cops = false
            end
        end
    end
end)