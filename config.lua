Config = {}

Config.Framework = 'qb' -- qb | esx

Config.Discord = {
  Webhook = 'https://discord.com/api/webhooks/CHANGE_ME',
  Username = 'Ultimate Admin Menu',
  Avatar = 'https://i.imgur.com/3z6X6P3.png'
}

Config.Integrations = {
  WasabiAmbulance = true,
  GKSPhone = true,
  CDGarage = true
}

Config.AdminChat = {
  Command = 'adminchat',
  ChannelName = 'Admin Chat'
}

Config.ReportSystem = {
  Command = 'report',
  CooldownSeconds = 30
}

Config.Roles = {
  god = {
    label = 'God',
    priority = 100
  },
  admin = {
    label = 'Admin',
    priority = 50
  },
  moderator = {
    label = 'Moderator',
    priority = 25
  }
}

Config.RolePanels = {
  god = {
    'dashboard',
    'player_list',
    'player_info',
    'noclip',
    'spectate',
    'god_mode',
    'kick',
    'ban',
    'freeze',
    'revive',
    'heal',
    'give_item',
    'give_money',
    'give_vehicle',
    'give_keys',
    'fix_vehicle',
    'change_plate',
    'spawn_object',
    'create_stash',
    'outfits',
    'admin_chat',
    'reports',
    'jobs',
    'gangs',
    'permissions',
    'teleport',
    'bring',
    'goto',
    'clear_area',
    'entity_manager',
    'player_appearance',
    'ban_history',
    'server_settings',
    'inventory_view',
    'economy_dashboard',
    'vehicles',
    'spawn_vehicle',
    'delete_vehicle',
    'plate_lookup',
    'warp_vehicle',
    'wipe_player',
    'revive_all',
    'heal_all',
    'weather',
    'time',
    'dispatch',
    'radio',
    'sound',
    'screenshots',
    'logs',
    'staff_duty',
    'staff_stats',
    'announcements',
    'mass_message',
    'freeze_all',
    'unfreeze_all',
    'inventory_clean',
    'vehicle_ownership',
    'businesses',
    'interiors',
    'routing_buckets',
    'dev_tools',
    'resource_monitor',
    'notes',
    'bookmarks',
    'player_flags',
    'punishment_templates',
    'report_settings',
    'reputation',
    'licenses',
    'fines',
    'debug',
    'client_sync'
  },
  admin = {
    'dashboard',
    'player_list',
    'player_info',
    'noclip',
    'spectate',
    'kick',
    'ban',
    'freeze',
    'revive',
    'heal',
    'give_item',
    'give_money',
    'give_vehicle',
    'give_keys',
    'fix_vehicle',
    'change_plate',
    'spawn_object',
    'create_stash',
    'outfits',
    'admin_chat',
    'reports',
    'jobs',
    'gangs',
    'teleport',
    'bring',
    'goto',
    'clear_area',
    'inventory_view',
    'vehicles',
    'spawn_vehicle',
    'delete_vehicle',
    'warp_vehicle',
    'staff_duty',
    'announcements',
    'mass_message',
    'notes'
  },
  moderator = {
    'dashboard',
    'player_list',
    'player_info',
    'spectate',
    'kick',
    'freeze',
    'revive',
    'heal',
    'admin_chat',
    'reports',
    'teleport',
    'bring',
    'goto',
    'announcements',
    'notes'
  }
}

Config.PermissionOverrides = {
  noclip = 'admin',
  god_mode = 'god',
  ban = 'admin',
  wipe_player = 'god',
  resource_monitor = 'god'
}

Config.PanelMeta = {
  dashboard = { label = 'Dashboard', category = 'Overview' },
  player_list = { label = 'Players', category = 'Players' },
  player_info = { label = 'Player Info', category = 'Players' },
  noclip = { label = 'No-clip', category = 'Player Moderation' },
  spectate = { label = 'Spectate', category = 'Player Moderation' },
  god_mode = { label = 'God Mode', category = 'Player Moderation' },
  kick = { label = 'Kick', category = 'Player Moderation' },
  ban = { label = 'Ban', category = 'Player Moderation' },
  freeze = { label = 'Freeze', category = 'Player Moderation' },
  revive = { label = 'Revive', category = 'Player Moderation' },
  heal = { label = 'Heal', category = 'Player Moderation' },
  give_item = { label = 'Give Items', category = 'Inventory & Economy' },
  give_money = { label = 'Give Money', category = 'Inventory & Economy' },
  outfits = { label = 'Outfits', category = 'Inventory & Economy' },
  inventory_view = { label = 'Inventory Viewer', category = 'Inventory & Economy' },
  economy_dashboard = { label = 'Economy', category = 'Inventory & Economy' },
  spawn_object = { label = 'Spawn Object', category = 'World Tools' },
  create_stash = { label = 'Create Stash', category = 'World Tools' },
  vehicles = { label = 'Vehicle Tools', category = 'World & Vehicle Tools' },
  give_vehicle = { label = 'Give Vehicle', category = 'World & Vehicle Tools' },
  give_keys = { label = 'Give Keys', category = 'World & Vehicle Tools' },
  fix_vehicle = { label = 'Fix Vehicle', category = 'World & Vehicle Tools' },
  change_plate = { label = 'Change Plate', category = 'World & Vehicle Tools' },
  spawn_vehicle = { label = 'Spawn Vehicle', category = 'World & Vehicle Tools' },
  delete_vehicle = { label = 'Delete Vehicle', category = 'World & Vehicle Tools' },
  admin_chat = { label = 'Admin Chat', category = 'Communication' },
  reports = { label = 'Reports', category = 'Communication' }
}
