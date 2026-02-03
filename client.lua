local AdminMenu = {
  isOpen = false,
  permissions = {},
  panels = {},
  cachedPlayers = {}
}

local function sendNui(action, data)
  SendNUIMessage({
    action = action,
    data = data or {}
  })
end

local function setFocus(state)
  SetNuiFocus(state, state)
  SetNuiFocusKeepInput(state)
end

local function requestMenu()
  TriggerServerEvent('ultimate_admin:requestMenu')
end

RegisterNetEvent('ultimate_admin:openMenu', function(payload)
  AdminMenu.permissions = payload.permissions or {}
  AdminMenu.panels = payload.panels or {}
  AdminMenu.cachedPlayers = payload.players or {}
  AdminMenu.isOpen = true
  setFocus(true)
  sendNui('open', payload)
end)

RegisterNetEvent('ultimate_admin:updatePlayers', function(players)
  AdminMenu.cachedPlayers = players
  sendNui('players', players)
end)

RegisterNetEvent('ultimate_admin:fixVehicle', function()
  local ped = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(ped, false)
  if vehicle ~= 0 then
    SetVehicleFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
  end
end)

RegisterNetEvent('ultimate_admin:changePlate', function(plate)
  local ped = PlayerPedId()
  local vehicle = GetVehiclePedIsIn(ped, false)
  if vehicle ~= 0 then
    SetVehicleNumberPlateText(vehicle, plate)
  end
end)

RegisterNetEvent('ultimate_admin:spawnObject', function(model)
  local ped = PlayerPedId()
  local coords = GetEntityCoords(ped)
  local heading = GetEntityHeading(ped)
  local modelHash = GetHashKey(model)
  RequestModel(modelHash)
  while not HasModelLoaded(modelHash) do
    Wait(0)
  end
  local object = CreateObject(modelHash, coords.x, coords.y, coords.z - 1.0, true, true, true)
  SetEntityHeading(object, heading)
  PlaceObjectOnGroundProperly(object)
  SetModelAsNoLongerNeeded(modelHash)
end)

RegisterNetEvent('ultimate_admin:createStash', function(stashId)
  local ped = PlayerPedId()
  local coords = GetEntityCoords(ped)
  TriggerServerEvent('inventory:server:OpenInventory', 'stash', stashId, {
    maxweight = 400000,
    slots = 50
  })
  TriggerEvent('inventory:client:SetCurrentStash', stashId)
  TriggerServerEvent('ultimate_admin:logStash', stashId, coords)
end)

RegisterNetEvent('ultimate_admin:adminChat', function(source, message)
  if not message or message == '' then
    return
  end
  sendNui('toast', { message = ('[Admin] %s: %s'):format(source, message), type = 'info' })
end)

RegisterNetEvent('ultimate_admin:reportUpdate', function(source, message)
  if not message or message == '' then
    return
  end
  sendNui('toast', { message = ('[Report] %s: %s'):format(source, message), type = 'warning' })
end)

RegisterNetEvent('ultimate_admin:notify', function(message, type)
  sendNui('toast', { message = message, type = type or 'info' })
end)

RegisterNUICallback('close', function(_, cb)
  AdminMenu.isOpen = false
  setFocus(false)
  cb('ok')
end)

RegisterNUICallback('action', function(data, cb)
  TriggerServerEvent('ultimate_admin:action', data)
  cb('ok')
end)

RegisterNUICallback('requestPlayers', function(_, cb)
  cb(AdminMenu.cachedPlayers)
end)

RegisterCommand('uamenu', function()
  requestMenu()
end, false)

RegisterKeyMapping('uamenu', 'Open Ultimate Admin Menu', 'keyboard', 'F10')

CreateThread(function()
  while true do
    if AdminMenu.isOpen then
      DisableControlAction(0, 1, true)
      DisableControlAction(0, 2, true)
      DisableControlAction(0, 24, true)
      DisableControlAction(0, 25, true)
      DisableControlAction(0, 200, true)
      Wait(0)
    else
      Wait(500)
    end
  end
end)
