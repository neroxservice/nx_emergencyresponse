QBCore = exports['qb-core']:GetCoreObject()
local currentCall = nil

function SendDispatch(coords)
    local info = {
        job = Config.DispatchJob,
        title = Config.DispatchTitle,
        coords = coords,
        message = Config.DispatchMessage
    }
    TriggerClientEvent("nx_emergency:stopCountdown", -1)
    Wait(500)
    TriggerEvent('emergencydispatch:emergencycall:new', Config.DispatchJob, Config.DispatchMessage, coords, true)
end

function StartEmergencyCall()
    local spawnPoint = Config.SpawnLocations[math.random(#Config.SpawnLocations)]
    local scenario = Config.PossibleScenarios[math.random(#Config.PossibleScenarios)]

    currentCall = {
        coords = spawnPoint,
        scenario = scenario,
        active = true
    }

    SendDispatch(spawnPoint)
    TriggerClientEvent("nx_emergency:spawnNPC", -1, currentCall)
end

RegisterNetEvent("nx_emergency:checkForMedics", function()
    local players = QBCore.Functions.GetPlayers()
    local medicsOnDuty = {}

    for _, playerId in pairs(players) do
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player then
            local job = Player.PlayerData.job
            if (job.name == "ambulance" or job.name == "slk" or job.name == "hrf") and job.onduty then
                table.insert(medicsOnDuty, playerId)
            end
        end
    end

    if #medicsOnDuty > 0 then
        for _, id in ipairs(medicsOnDuty) do
            TriggerClientEvent("nx_emergency:startCountdown", id)
        end
    else
        --TriggerClientEvent("QBCore:Notify", source, "Kein Mediziner im Dienst!", "error")
    end
end)

RegisterNetEvent("nx_emergency:stopCountdownForAll", function()
    Wait(1000)
    TriggerClientEvent("nx_emergency:stopCountdown", -1)
end)




function isAmbulanceOnDuty()
    local players = QBCore.Functions.GetPlayers()
    for _, playerId in pairs(players) do
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player then
            local job = Player.PlayerData.job
            if (job.name == "ambulance" or job.name == "slk" or job.name == "hrf") and job.onduty then
                return true
            end
        end
    end
    return false
end

CreateThread(function()
    while true do
        local randomWait = math.random(1500000, 3200000)
        local waitMinutes = math.floor(randomWait / 60000)

        if waitMinutes >= 60 then
            local hours = math.floor(waitMinutes / 60)
            local minutes = waitMinutes % 60
            print(("^3[nx_EmergencyResponse]^7 Nächster Einsatz wird in ^3%d Minuten^7 (^3%dh %dmin^7) generiert.")
                :format(waitMinutes, hours, minutes))
        else
            print(("^3[nx_EmergencyResponse]^7 Nächster Einsatz wird in ^3%d Minuten^7 generiert."):format(waitMinutes))
        end

        Wait(randomWait)

        if isAmbulanceOnDuty() then
            StartEmergencyCall()
        else
            print("^1[nx_EmergencyResponse]^7 Kein Sanitäter im Dienst, kein Einsatz generiert.")
        end
    end
end)



--[[ CreateThread(function()
    while true do
        Wait(5000)

        if isAmbulanceOnDuty() then
            StartEmergencyCall()
        else
        end
    end
end) ]]


local activeNPCs = {}
local activeNPCs2 = {}

RegisterServerEvent("nx_emergency:setNPCNetId")
AddEventHandler("nx_emergency:setNPCNetId", function(netId)
    activeNPCs[netId] = true
end)

RegisterServerEvent("nx_emergency:setNPCNetId2")
AddEventHandler("nx_emergency:setNPCNetId2", function(pedNetId)
    activeNPCs2[pedNetId] = true
end)



RegisterServerEvent("nx_emergency:removeNPC")
AddEventHandler("nx_emergency:removeNPC", function(netId)
    TriggerClientEvent("nx_emergency:deleteNPC", -1, netId)
    activeNPCs[netId] = nil
end)

RegisterNetEvent("nx_emergency:spawnWitness")
AddEventHandler("nx_emergency:spawnWitness", function(pedNetId)
    TriggerClientEvent("nx_emergency:spawnWitnessClient", -1, pedNetId)
end)


RegisterNetEvent("nx_emergency:removeWitness")
AddEventHandler("nx_emergency:removeWitness", function(pedNetId)
    activeNPCs[pedNetId] = nil
    activeNPCs2[pedNetId] = nil
    TriggerClientEvent("nx_emergency:deleteWitness", -1, pedNetId)
end)

RegisterNetEvent("nx_emergency:npcTimeout", function()
    TriggerClientEvent("nx_emergency:removeNPC", -1, netId)

    local players = QBCore.Functions.GetPlayers()
    for _, playerId in pairs(players) do
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player and (Player.PlayerData.job.name == "ambulance" or Player.PlayerData.job.name == "slk" or Player.PlayerData.job.name == "hrf") and Player.PlayerData.job.onduty then
            TriggerClientEvent("QBCore:Notify", playerId,
                "Einsatz wurde automatisch abgebrochen – Patient nicht versorgt.", "error")
        end
    end
end)

RegisterCommand("TriggerEmergency", function(source, args, rawCommand)
    local src = source
    if src > 0 then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player and Player.PlayerData.job.name == "ambulance" then
            StartEmergencyCall()
            TriggerClientEvent('QBCore:Notify', src, "Testeinsatz ausgelöst", "success")
        else
            TriggerClientEvent('QBCore:Notify', src, "Du bist kein Admin", "error")
        end
    else
        StartEmergencyCall()
        print("Einsatz wurde gestartet durch einen Admin")
    end
end)


RegisterCommand("emtest", function(source, args, rawCommand)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or Player.PlayerData.job.name ~= "admin" then
        TriggerClientEvent('QBCore:Notify', src, "Nur für Teamler vorbestimmt!", "error")
        return
    end

    local arg = args[1]
    if not arg or (arg ~= "bewusstlos" and arg ~= "sitzend" and arg ~= "brandopfer") then
        TriggerClientEvent('QBCore:Notify', src, "Benutzung: /emtest [bewusstlos|sitzend]", "error")
        return
    end

    local scenario = nil
    if arg == "bewusstlos" then
        scenario = {
            anim = "dead",
            blood = true,
            fire = false
        }
    elseif arg == "sitzend" then
        scenario = {
            anim = "sitting",
            blood = true,
            fire = false
        }
    end

    local spawnPoint = Config.SpawnLocations[math.random(#Config.SpawnLocations)]

    local testCall = {
        coords = spawnPoint,
        scenario = scenario,
        active = true
    }
    SendDispatch(spawnPoint)
    TriggerClientEvent("nx_emergency:spawnNPC", -1, testCall)
    TriggerClientEvent('QBCore:Notify', src, "Testeinsatz: " .. arg .. " wurde gestartet.", "success")
end)



local green = "\27[32m"
local blue = "\27[34m"
local yellow = "\27[33m"
local magenta = "\27[35m"
local cyan = "\27[36m"
local red = "\27[31m"
local reset = "\27[0m"

local currentVersion = "v1.4.3"

local githubUser = "neroxservice"
local githubRepo = "nx_emergencyresponse"

local function checkVersion()
    local url = ("https://api.github.com/repos/%s/%s/releases/latest"):format(githubUser, githubRepo)
    PerformHttpRequest(url, function(statusCode, response, headers)
        if statusCode == 200 and response then
            local data = json.decode(response)
            if data and data.tag_name then
                local latestVersion = data.tag_name
                local changelog = data.body or "Kein Changelog vorhanden."

                print(yellow .. "--------------------------------------------------------" .. reset)
                print(magenta .. "[nx_EmergencyResponse]" .. reset)
                print(cyan .. "📦 Aktuelle Version: " .. blue .. currentVersion .. reset)
                print(cyan .. "🔄 Verfügbare Version: " .. blue .. latestVersion .. reset)

                if currentVersion == latestVersion then
                    print(green .. "✅ Du verwendest die neueste Version." .. reset)
                else
                    print("")
                    print(red .. "⚠️ Eine neue Version ist verfügbar!" .. reset)
                    print("🔗 " ..
                        cyan ..
                        "Update hier: " ..
                        blue .. "https://github.com/" .. githubUser .. "/" .. githubRepo .. "/releases/latest" .. reset)
                    print("")
                    print(magenta .. "📋 Änderungen in dieser Version:" .. reset)
                    for line in changelog:gmatch("[^\r\n]+") do
                        print("  " .. cyan .. " " .. line .. reset)
                    end
                end
                print(yellow .. "--------------------------------------------------------" .. reset)
            else
            end
        else
            print(red .. "[Fehler] Konnte keine Verbindung zu GitHub aufbauen (Code: " .. statusCode .. ")." .. reset)
        end
    end, "GET", "", { ["User-Agent"] = "FiveMResourceVersionChecker" })
end

AddEventHandler("onResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        Citizen.SetTimeout(500, function()
            checkVersion()
        end)
    end
end)
