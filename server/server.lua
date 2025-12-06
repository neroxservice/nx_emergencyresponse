QBCore = exports['qb-core']:GetCoreObject()
local currentCall = nil
local emergencyEnabled = true

function SendDispatch(coords)
    local info = {
        job = Config.DispatchJob,
        title = Config.DispatchTitle,
        coords = coords,
        message = Config.DispatchMessage
    }
    Wait(500)
    TriggerEvent('emergencydispatch:emergencycall:new', Config.DispatchJob, Config.DispatchMessage, coords, true)
end

function StartEmergencyCall()
    if currentCall and currentCall.active then return end

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

    end
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
        local randomWait = math.random(1500000, 2700000)
        local waitMinutes = math.floor(randomWait / 60000)

        if emergencyEnabled then
            if waitMinutes >= 60 then
                local hours = math.floor(waitMinutes / 60)
                local minutes = waitMinutes % 60
                print(("^3[nx_EmergencyResponse]^7 Nächster Einsatz wird in ^3%d Minuten^7 (^3%dh %dmin^7) generiert.")
                    :format(waitMinutes, hours, minutes))
            else
                print(("^3[nx_EmergencyResponse]^7 Nächster Einsatz wird in ^3%d Minuten^7 generiert."):format(
                    waitMinutes))
            end
        else
            print("^1[nx_EmergencyResponse]^7 Einsatzsystem ist deaktiviert – keine Einsätze werden generiert.")
        end

        Wait(randomWait)

        if emergencyEnabled and isAmbulanceOnDuty() then
            StartEmergencyCall()
        else
            print("^1[nx_EmergencyResponse]^7 Einsatz übersprungen.")
        end
    end
end)

RegisterCommand(Config.CommandStop, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player or Player.PlayerData.job.name ~= "ambulance" then
        TriggerClientEvent('QBCore:Notify', source, "Keine Berechtigung!", "error")
        return
    end

    emergencyEnabled = false
    print("[nx_emergency] Einsatz-System wurde deaktiviert!")
    TriggerClientEvent('QBCore:Notify', source, "Einsatzsystem deaktiviert!", "error")
end)

RegisterCommand(Config.CommandStart, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player or Player.PlayerData.job.name ~= "ambulance" then
        TriggerClientEvent('QBCore:Notify', source, "Keine Berechtigung!", "error")
        return
    end

    emergencyEnabled = true
    print("[nx_emergency] Einsatz-System wurde aktiviert!")
    TriggerClientEvent('QBCore:Notify', source, "Einsatzsystem aktiviert!", "success")
end)



RegisterCommand("EndEmergency", function(src, args, rawCommand)
    EndEmergencyCall()
    TriggerClientEvent('QBCore:Notify', src, "Einsatz wurde beendet.", "success")
end)

function EndEmergencyCall()
    if currentCall and currentCall.active then
        currentCall.active = false
        TriggerClientEvent("nx_emergency:endNPC", -1)
        print("[Emergency] Einsatz beendet.")
    end
end

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

RegisterNetEvent("nx_emergency:npcThreated", function()
    if currentCall then
        currentCall.active = false
        currentCall = nil
        print("[nx_emergency] NPC erfolgreich behandelt – Einsatz zurückgesetzt.")
    end
end)



RegisterNetEvent("nx_emergency:npcTimeout", function()
    TriggerClientEvent("nx_emergency:removeNPC", -1, netId)

    if currentCall and currentCall.active then
        currentCall.active = false
        currentCall = nil
        print("[nx_emergency] NPC Timeout – aktiver Einsatz wurde zurückgesetzt.")
    end

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
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player or Player.PlayerData.job.name ~= "ambulance" then
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

local currentVersion = "v1.7.1"

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
