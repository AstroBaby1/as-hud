local QBCore = exports['qb-core']:GetCoreObject()
local Loaded = false

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    print("Hud Loaded")
    QBCore.Functions.Notify("Hud loaded", "success")
    Loaded = true
end)
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    print("Hud Loaded")
    Loaded = true
end)
RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    Loaded = false
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
                local fuel = exports['LegacyFuel']:GetFuel(vehicle)

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

            local player = PlayerPedId()
            local armor = GetPedArmour(player)
            local thirst = QBCore.Functions.GetPlayerData().metadata['thirst']
            local health = GetEntityHealth(player) - 100
            local hunger = QBCore.Functions.GetPlayerData().metadata['hunger']
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
