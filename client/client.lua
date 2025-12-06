local QBCore = exports['qb-core']:GetCoreObject()

local npcModels = {
    "a_m_y_ktown_01",
    "a_m_m_business_01",
    "a_f_y_indian_01",
    "a_m_y_soucent_01",
}

local npcManager = {}
local countdownActive = false
local countdownTime = 0

function CreateEmergencyNPC(data)
    local modelHash = GetHashKey(npcModels[math.random(#npcModels)])
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do Wait(0) end

    local ped = CreatePed(0, modelHash, data.coords.x, data.coords.y, data.coords.z - 1, 0.0, false, true)

    while not DoesEntityExist(ped) do Wait(50) end

    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    TriggerServerEvent("nx_emergency:checkForMedics")

    if data.scenario.anim == "dead" then
        RequestAnimDict("dead")
        while not HasAnimDictLoaded("dead") do Wait(0) end
        TaskPlayAnim(ped, "dead", "dead_a", 8.0, -8, -1, 1, 0, false, false, false)
    elseif data.scenario.anim == "sitting" or data.scenario.anim == "brandopfer" then
        RequestAnimDict("amb@world_human_picnic@male@idle_a")
        while not HasAnimDictLoaded("amb@world_human_picnic@male@idle_a") do Wait(0) end
        TaskPlayAnim(ped, "amb@world_human_picnic@male@idle_a", "idle_a", 8.0, -8, -1, 1, 0, false, false, false)
    end

    if data.scenario.blood or data.scenario.fire then
        local coords = GetEntityCoords(ped)
        UseParticleFxAssetNextCall("core")
        StartParticleFxNonLoopedAtCoord("blood_stab", coords.x, coords.y, coords.z - 1.0, 0.0, 0.0, 0.0, 1.0, false,
            false, false)
        ApplyPedDamagePack(ped, "BigHitByVehicle", 0.0, 9.0)
    end

    local netId = NetworkGetNetworkIdFromEntity(ped)
    npcManager[netId] = ped
    TriggerServerEvent("nx_emergency:setNPCNetId", netId)

    SetTimeout(1800000, function()
        if DoesEntityExist(ped) then
            DeletePed(ped)
            npcManager[netId] = nil
            TriggerServerEvent("nx_emergency:npcTimeout", netId)
        end
    end)

    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                icon = "fas fa-heart",
                label = "Behandeln",
                action = function()
                    TreatNPC(netId)
                end
            },
            {
                icon = "fas fa-heart",
                label = "Reanimation starten",
                action = function()
                    TreatNPC(netId)
                end
            }
        },
        distance = 2.0
    })
end

RegisterNetEvent("nx_emergency:spawnNPC", function(data)
    CreateEmergencyNPC(data)
end)


function TreatNPC(netId)
    local ped = npcManager[netId]
    if not ped or not DoesEntityExist(ped) then return end
    local playerPed = PlayerPedId()
    local dict = "mini@cpr@char_a@cpr_str"
    local anim = "cpr_pumpchest"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end

    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)

    QBCore.Functions.Progressbar("treat_npc", "Behandle Patient...", 15000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, function()
        ClearPedTasks(playerPed)
        TriggerServerEvent("nx_emergency:npcThreated")
    end, function()
        ClearPedTasks(playerPed)

        FreezeEntityPosition(ped, false)
        ClearPedTasks(ped)
        TaskWanderStandard(ped, 10.0, 10)

        SetTimeout(1500000, function()
            if DoesEntityExist(ped) then
                DeletePed(ped)
                npcManager[netId] = nil
                TriggerServerEvent("nx_emergency:removeNPC", netId)
                TriggerServerEvent("nx_emergency:npcThreated")
            end
        end)
        Wait(500)

        QBCore.Functions.Notify("Bahdandlung abgeschlossen", "success")
    end)
end

RegisterNetEvent("nx_emergency:deleteNPC", function(netId)
    local ped = npcManager[netId]
    if ped and DoesEntityExist(ped) then
        DeletePed(ped)
        npcManager[netId] = nil
    end
end)

RegisterNetEvent("nx_emergency:removeNPC", function(netId)
    local ped = NetworkGetEntityFromNetworkId(netId)
    if ped and DoesEntityExist(ped) then
        DeletePed(ped)
    end
end)


CreateThread(function()
    while true do
        Wait(0)
        if countdownActive and countdownTime > 0 then
            local minutes = math.floor(countdownTime / 60)
            local seconds = countdownTime % 60
            local text = string.format("⏱️ Einsatz läuft ab in: %02d:%02d", minutes, seconds)

            SetTextFont(0)
            SetTextProportional(1)
            SetTextScale(0.35, 0.35)
            SetTextColour(200, 50, 50, 220)
            SetTextOutline()
            SetTextEntry("STRING")
            AddTextComponentString(text)
            DrawText(0.015, 0.015)
        end
    end
end)



function CarryToStretcher()
    ---- stretcher Function einfügen----

    Notify("Patient auf die Trage gelegt...")
end
