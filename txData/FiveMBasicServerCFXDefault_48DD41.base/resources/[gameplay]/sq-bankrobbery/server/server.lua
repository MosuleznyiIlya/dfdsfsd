local lastDrillTimes = {}

lib.callback.register('sq-bankrobbery:server:CheckCooldown', function(source)
    local src = source
    
    local currentTime = GetGameTimer()

    if lastDrillTimes[src] and (currentTime - lastDrillTimes[src]) < Config.DrillCooldown then
        local remainingTime = math.ceil((Config.DrillCooldown - (currentTime - lastDrillTimes[src])) / 1000)
        return false, Locales.cooldown_active
    end

    lastDrillTimes[src] = currentTime
    return true, Locales.allowed_to_drill
end)

function GetSpotByName(name)
    for _, v in pairs(Config.DrillingLocations) do
        if v.name == name then
            return v
        end
    end
end

lib.callback.register('sq-bankrobbery:server:CheckPlasmaDrill', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return false end
    
    local hasItem = Player.Functions.GetItemByName('plasma_drill')
    
    if not hasItem then
        return false, Locales.no_plasma_drill
    end
    
    return true, Locales.plasma_drill_found, hasItem
end)

RegisterNetEvent('sq-bankrobbery:server:PlasmaDrillingResult', function(success, spotName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    if success then
        local spot = GetSpotByName(spotName)
        if spot then
            Player.Functions.AddMoney(Config.RewardAccount, spot.reward, "robbed-bank-vault")
            TriggerClientEvent('ox_lib:notify', src, {
                type = 'success',
                position = 'top',
                description = Locales.success_drill
            })
        end
    else
        TriggerClientEvent('sq-bankrobbery:client:ToxicGasReleased', src)
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            position = 'top',
            description = Locales.fail_drill
        })
    end
end)
