local Framework = {}

local function setupFramework()
  if Config.Framework == 'esx' then
    local success, result = pcall(function()
      return exports['es_extended']:getSharedObject()
    end)
    if success then
      Framework.shared = result
      Framework.type = 'esx'
    end
  else
    local success, result = pcall(function()
      return exports['qb-core']:GetCoreObject()
    end)
    if success then
      Framework.shared = result
      Framework.type = 'qb'
    end
  end
end

setupFramework()

local function getPlayer(source)
  if Framework.type == 'esx' then
    return Framework.shared.GetPlayerFromId(source)
  end
  return Framework.shared.Functions.GetPlayer(source)
end

local function getPlayerIdentifiers(source)
  local identifiers = {}
  for i = 0, GetNumPlayerIdentifiers(source) - 1 do
    local identifier = GetPlayerIdentifier(source, i)
    identifiers[#identifiers + 1] = identifier
  end
  return identifiers
end

local function getPlayerNameSafe(source)
  return GetPlayerName(source) or ('Player %s'):format(source)
end

local function logToDiscord(title, description, fields)
  if Config.Discord.Webhook == '' then
    return
  end
  local embed = {
    title = title,
    description = description,
    color = 5793266,
    fields = fields or {},
    footer = { text = os.date('%Y-%m-%d %H:%M:%S') }
  }
  PerformHttpRequest(Config.Discord.Webhook, function() end, 'POST', json.encode({
    username = Config.Discord.Username,
    avatar_url = Config.Discord.Avatar,
    embeds = { embed }
  }), { ['Content-Type'] = 'application/json' })
end

local function getRole(source)
  local player = getPlayer(source)
  if not player then
    return nil
  end
  if Framework.type == 'esx' then
    return player.getGroup()
  end
  return player.PlayerData.permission or player.PlayerData.group or player.PlayerData.job.name
end

local function resolveRole(role)
  if Config.Roles[role] then
    return role
  end
  return 'moderator'
end

local function hasPanelAccess(role, panel)
  role = resolveRole(role)
  local panels = Config.RolePanels[role] or {}
  for _, entry in ipairs(panels) do
    if entry == panel then
      return true
    end
  end
  return false
end

local function hasPermission(role, panel)
  local override = Config.PermissionOverrides[panel]
  if override then
    local overrideRole = resolveRole(override)
    local roleMeta = Config.Roles[resolveRole(role)]
    local overrideMeta = Config.Roles[overrideRole]
    return roleMeta and overrideMeta and roleMeta.priority >= overrideMeta.priority
  end
  return hasPanelAccess(role, panel)
end

local function buildPanels(role)
  local panels = {}
  local allowed = Config.RolePanels[resolveRole(role)] or {}
  for _, panel in ipairs(allowed) do
    local meta = Config.PanelMeta[panel] or { label = panel, category = 'Other' }
    panels[#panels + 1] = {
      id = panel,
      label = meta.label,
      category = meta.category
    }
  end
  return panels
end

local function buildPlayers()
  local players = {}
  for _, playerId in ipairs(GetPlayers()) do
    local player = getPlayer(tonumber(playerId))
    local name = getPlayerNameSafe(playerId)
    local job = 'unknown'
    if player then
      if Framework.type == 'esx' then
        job = player.getJob().name
      else
        job = player.PlayerData.job.name
      end
    end
    players[#players + 1] = {
      id = tonumber(playerId),
      name = name,
      job = job
    }
  end
  return players
end

RegisterNetEvent('ultimate_admin:requestMenu', function()
  local src = source
  local role = resolveRole(getRole(src))
  local payload = {
    role = role,
    permissions = Config.RolePanels[role] or {},
    panels = buildPanels(role),
    players = buildPlayers(),
    integrations = Config.Integrations
  }
  TriggerClientEvent('ultimate_admin:openMenu', src, payload)
end)

local function handleAction(src, data)
  local role = resolveRole(getRole(src))
  if not data or not data.panel then
    return
  end
  if not hasPermission(role, data.panel) then
    TriggerClientEvent('ultimate_admin:notify', src, 'Insufficient permissions', 'error')
    return
  end

  local target = tonumber(data.target)
  local reason = data.reason or 'N/A'
  local fields = {
    { name = 'Staff', value = ('%s (%s)'):format(getPlayerNameSafe(src), src), inline = true },
    { name = 'Action', value = data.panel, inline = true },
    { name = 'Target', value = target and getPlayerNameSafe(target) or 'N/A', inline = true },
    { name = 'Reason', value = reason, inline = false }
  }

  if data.panel == 'kick' and target then
    DropPlayer(target, reason)
  elseif data.panel == 'ban' and target then
    DropPlayer(target, ('Banned: %s'):format(reason))
  elseif data.panel == 'revive' and target then
    if Config.Integrations.WasabiAmbulance then
      TriggerEvent('wasabi_ambulance:revivePlayer', target)
    else
      TriggerClientEvent('hospital:client:Revive', target)
    end
  elseif data.panel == 'heal' and target then
    if Config.Integrations.WasabiAmbulance then
      TriggerEvent('wasabi_ambulance:healPlayer', target)
    else
      TriggerClientEvent('hospital:client:HealInjuries', target)
    end
  elseif data.panel == 'give_money' and target then
    local player = getPlayer(target)
    local amount = tonumber(data.amount) or 0
    if player and amount > 0 then
      if Framework.type == 'esx' then
        player.addAccountMoney('money', amount)
      else
        player.Functions.AddMoney('cash', amount, 'admin-menu')
      end
    end
  elseif data.panel == 'give_item' and target then
    local player = getPlayer(target)
    if player and data.item then
      if Framework.type == 'esx' then
        player.addInventoryItem(data.item, tonumber(data.amount) or 1)
      else
        player.Functions.AddItem(data.item, tonumber(data.amount) or 1)
        TriggerClientEvent('inventory:client:ItemBox', target, Framework.shared.Shared.Items[data.item], 'add')
      end
    end
  elseif data.panel == 'give_vehicle' and target then
    if Config.Integrations.CDGarage then
      TriggerEvent('cd_garage:AddCar', target, data.model or 'adder')
    else
      TriggerClientEvent('ultimate_admin:notify', src, 'CD Garage not enabled', 'error')
    end
  elseif data.panel == 'give_keys' and target then
    TriggerClientEvent('vehiclekeys:client:SetOwner', target, data.plate or 'ADMIN')
  elseif data.panel == 'fix_vehicle' and target then
    TriggerClientEvent('ultimate_admin:fixVehicle', target)
  elseif data.panel == 'change_plate' and target then
    TriggerClientEvent('ultimate_admin:changePlate', target, data.plate or 'ADMIN')
  elseif data.panel == 'spawn_object' then
    TriggerClientEvent('ultimate_admin:spawnObject', -1, data.model or 'prop_cone_float_1')
  elseif data.panel == 'create_stash' then
    TriggerClientEvent('ultimate_admin:createStash', -1, data.stashId or 'admin_stash')
  elseif data.panel == 'admin_chat' then
    TriggerClientEvent('ultimate_admin:adminChat', -1, src, data.message or '')
  elseif data.panel == 'reports' then
    TriggerClientEvent('ultimate_admin:reportUpdate', -1, src, data.message or '')
  end

  logToDiscord('Admin Action', ('%s executed %s'):format(getPlayerNameSafe(src), data.panel), fields)
end

RegisterNetEvent('ultimate_admin:action', function(data)
  handleAction(source, data)
end)

RegisterNetEvent('ultimate_admin:logStash', function(stashId, coords)
  local src = source
  local fields = {
    { name = 'Staff', value = ('%s (%s)'):format(getPlayerNameSafe(src), src), inline = true },
    { name = 'Stash', value = stashId, inline = true },
    { name = 'Coords', value = ('%.2f %.2f %.2f'):format(coords.x, coords.y, coords.z), inline = false }
  }
  logToDiscord('Stash Created', 'Dynamic stash created via admin menu.', fields)
end)

RegisterCommand(Config.ReportSystem.Command, function(source, args)
  local message = table.concat(args, ' ')
  if message == '' then
    return
  end
  handleAction(source, { panel = 'reports', message = message })
end)

RegisterCommand(Config.AdminChat.Command, function(source, args)
  local message = table.concat(args, ' ')
  if message == '' then
    return
  end
  handleAction(source, { panel = 'admin_chat', message = message })
end)
