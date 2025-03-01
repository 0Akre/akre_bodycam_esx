local ESX = exports["es_extended"]:getSharedObject()

local displayBodycam = false
local displayBackground = false

RegisterCommand("bodycam", function()
    local xPlayer = ESX.GetPlayerData()
    local jobName = xPlayer.job.name

    if (jobName == "police" or jobName == "sheriff" or jobName == "sahp") then
        displayBodycam = not displayBodycam
        local playerName = xPlayer.firstName .. " " .. xPlayer.lastName

        SendNUIMessage({
            type = "updateBodycam",
            playerName = playerName,
            display = displayBodycam,
            background = displayBackground
        })
    else
        exports.ox_lib:notify({
            title = "Bodycam",
            description = "You do not have permission to show/hide the bodycam because you are not a state authority or are not on duty!",
            type = "error"
        })
    end
end, false)

RegisterCommand("bodycamb", function()
    if displayBodycam then
        displayBackground = not displayBackground
        SendNUIMessage({
            type = "updateBodycam",
            background = displayBackground
        })
    else
        exports.ox_lib:notify({
            title = "Bodycam",
            description = "The bodycam must be turned on before enabling the background!",
            type = "error"
        })
    end
end, false)

RegisterNetEvent('esx:setJob', function(job)
    if (job.name == "police" or job.name == "sheriff" or job.name == "sahp") then
        displayBodycam = true
        local xPlayer = ESX.GetPlayerData()
        local playerName = xPlayer.firstName .. " " .. xPlayer.lastName

        SendNUIMessage({
            type = "updateBodycam",
            playerName = playerName,
            display = displayBodycam,
            background = displayBackground
        })
    else
        displayBodycam = false
        SendNUIMessage({
            type = "updateBodycam",
            display = false,
            background = false
        })
    end
end)

RegisterNetEvent('esx:onPlayerLogout', function()
    displayBodycam = false
    SendNUIMessage({
        type = "updateBodycam",
        display = false,
        background = false
    })
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    local jobName = xPlayer.job.name

    if (jobName == "police" or jobName == "sheriff" or jobName == "sahp") then
        displayBodycam = true
        local playerName = xPlayer.firstName .. " " .. xPlayer.lastName

        SendNUIMessage({
            type = "updateBodycam",
            playerName = playerName,
            display = displayBodycam,
            background = displayBackground
        })
    else
        displayBodycam = false
        SendNUIMessage({
            type = "updateBodycam",
            display = false,
            background = false
        })
    end
end)

RegisterNetEvent('esx:playerLoaded', function(playerData)
    if not playerData.firstName then
        ESX.TriggerServerCallback('esx_identity:getCharacters', function(characters)
            if characters and characters[1] then
                local character = characters[1]
                local jobName = ESX.GetPlayerData().job.name
                
                if (jobName == "police" or jobName == "sheriff" or jobName == "sahp") then
                    displayBodycam = true
                    local playerName = character.firstname .. " " .. character.lastname

                    SendNUIMessage({
                        type = "updateBodycam",
                        playerName = playerName,
                        display = displayBodycam,
                        background = displayBackground
                    })
                end
            end
        end)
    end
end)

CreateThread(function()
    SendNUIMessage({
        type = "updateBodycam",
        display = false,
        background = false,
        playerName = ""
    })
end)