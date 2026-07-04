local QBCore = exports["qb-core"]:GetCoreObject()

RegisterNetEvent("sq-bankrobbery:client:StartPlasmaDrilling", function(data)
	local spotName = data and data.spotName

	lib.callback("sq-bankrobbery:server:CheckPlasmaDrill", false, function(hasItem, message, itemData)
		if not hasItem then
			TriggerEvent("ox_lib:notify", {
				type = "error",
				position = "top",
				description = message,
			})
			return
		end

		lib.callback("sq-bankrobbery:server:CheckCooldown", false, function(canDrill, cooldownMessage)
			if not canDrill then
				TriggerEvent("ox_lib:notify", {
					type = "error",
					position = "top",
					description = cooldownMessage,
				})
				return
			end

			local success = exports["glitch-minigames"]:StartPlasmaDrilling(Config.MinigameDifficulty)
			TriggerServerEvent("sq-bankrobbery:server:PlasmaDrillingResult", success, spotName)
		end)
	end)
end)

RegisterNetEvent("sq-bankrobbery:client:ToxicGasReleased", function()
	SetFlash(0, 0, 500, 7000, 500)
	ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", 0.16)
end)

Citizen.CreateThread(function()
	for _, spot in pairs(Config.DrillingLocations) do
		exports.ox_target:addBoxZone({
			name = spot.name,
			coords = spot.coords.xyz,
			size = vec3(2.0, 2.0, 2.0),
			rotation = spot.coords.w,
			debug = false,
			options = {
				{
					icon = "fas fa-bolt",
					label = "Start Plasma Drilling",
					onSelect = function()
						TriggerEvent("sq-bankrobbery:client:StartPlasmaDrilling", { spotName = spot.name })
					end,
					distance = 2.5,
				},
			},
		})
	end
end)
