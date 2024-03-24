local QBCore = nil
local ESX = nil

if Config.FrameWork == "QBCore" then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.FrameWork == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()
end

local Loaded = false


if Config.FrameWork == "ESX" then
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded',function()
        lib.print.info("Hud Loaded")
        lib.notify({
            title = 'as-hud',
            description = 'Hud loaded',
            type = 'success'
        })
    Loaded = true
    end)

    RegisterNetEvent('esx:onPlayerLogout', function()
        Loaded = false
    end)

elseif Config.FrameWork == "QBCore" then
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        lib.print.info("Hud Loaded")
        lib.notify({
            title = 'as-hud',
            description = 'Hud loaded',
            type = 'success'
        })
        Loaded = true
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        Loaded = false
    end)
end
RegisterCommand("tst", function()
    print("ok")
if Config.FrameWork == "QBCore" then
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        lib.print.info("Hud Loaded")
        lib.notify({
            title = 'as-hud',
            description = 'Hud loaded',
            type = 'success'
        })
        Loaded = true
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        Loaded = false
    end)
else 
    print("nthng detected")
end
end)
CreateThread(function()
    while true do
        SetRadarBigmapEnabled(false, false)
        Wait(500)
    end
end)


CreateThread(function()
    local minimap = RequestScaleformMovie('minimap')
    if not HasScaleformMovieLoaded(minimap) then
        RequestScaleformMovie(minimap)
        while not HasScaleformMovieLoaded(minimap) do
            Wait(1)
        end
    end
end)

CreateThread(function()
    TriggerEvent('LoadMap')
    DisplayRadar(false)
end)

RegisterNetEvent('LoadMap')
AddEventHandler('LoadMap', function()
    Wait(50)

    local defaultAspectRatio = 1920 / 1080
    local resolutionX, resolutionY = GetActiveScreenResolution()
    local aspectRatio = resolutionX / resolutionY
    local minimapOffset = 0

    if aspectRatio > defaultAspectRatio then
        minimapOffset = ((defaultAspectRatio - aspectRatio) / 3.6) - 0.008
    end

    RequestStreamedTextureDict('squaremap', false)

    if not HasStreamedTextureDictLoaded('squaremap') then
        Wait(150)
    end

    SetMinimapClipType(0)
    AddReplaceTexture('platform:/textures/graphics', 'radarmasksm', 'squaremap', 'radarmasksm')
    AddReplaceTexture('platform:/textures/graphics', 'radarmask1g', 'squaremap', 'radarmasksm')

    SetMinimapComponentPosition('minimap', 'L', 'B', 0.0 + minimapOffset, -0.047, 0.1638, 0.183)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', 0.0 + minimapOffset, 0.0, 0.128, 0.20)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', -0.01 + minimapOffset, 0.025, 0.262, 0.300)
    SetBlipAlpha(GetNorthRadarBlip(), 0)
    SetRadarBigmapEnabled(true, false)
    SetMinimapClipType(0)
    Wait(50)
    SetRadarBigmapEnabled(false, false)
end)


CreateThread(function()
    while true do
        Wait(0)
        if Loaded then
            DisplayRadar(1)
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
           
            if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                local speed = math.floor(GetEntitySpeed(vehicle) * 3.6)
                local  fuel = GetVehicleFuelLevel(vehicle)

                SendNUIMessage({
                    action = 'updateSpeedometer',
                    speed = speed,
                    fuel = fuel
                })
            else 
                SendNUIMessage({
                    action = 'hidespeed'
                })
            end

           
            local playerId = PlayerId()
            local isTalking = NetworkIsPlayerTalking(playerId)

            SendNUIMessage({
                action = 'updateTalkingStatus',
                isTalking = isTalking
            })

            local thirst = nil
            local hunger = nil
            if Config.FrameWork == "ESX" then
                TriggerEvent('esx_status:getStatus', 'thirst', function(status)
                    if status then thirst = status.val / 10000 end
                end)
                TriggerEvent('esx_status:getStatus', 'hunger', function(status)
                    if status then hunger = status.val / 10000 end
                end)
            elseif Config.FrameWork == "QBCore" then
                thirst = QBCore.Functions.GetPlayerData().metadata['thirst']
                hunger = QBCore.Functions.GetPlayerData().metadata['hunger']
            end

            local armor = GetPedArmour(cache.ped)
            local health = GetEntityHealth(cache.ped) - 100
            SendNUIMessage({
                action = 'updateArmor',
                armor = armor
            })
            SendNUIMessage({
                action = "setBoxes",
                thirst = thirst,
                health = health,
                hunger = hunger,
                armor = armor
            })
        end
    end
end)
