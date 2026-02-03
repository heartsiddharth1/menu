# Ultimate Admin Menu

Production-ready FiveM admin menu built for QBCore with modular ESX compatibility, featuring a Svelte-based NUI, granular role permissions, and Discord logging.

## Features

- **Player Moderation**: No-clip, Spectate, God Mode, Kick, Ban, Freeze, Revive, Heal.
- **Inventory & Economy**: Give Items, Give Money, Outfits/Clothing access, Inventory viewer.
- **World & Vehicle Tools**: Synced object spawning, dynamic stash creation, give vehicle/keys, fix vehicles, change plates.
- **Communication Hub**: Report system (player tickets) + admin-only chat.
- **Role Management**: Role-based panels with priority overrides (God/Admin/Moderator).
- **Integrations**: Wasabi Ambulance, GKS Phone, CD Garage.
- **Logging**: Discord webhook logs for all actions.

## Installation

1. Place the resource in your server’s `resources` folder, e.g.:
   ```
   resources/[admin]/ultimate_admin_menu
   ```
2. Ensure the resource in `server.cfg`:
   ```
   ensure ultimate_admin_menu
   ```
3. Configure `config.lua` (see below).

## Configuration

### Framework

Set which framework is active:

```lua
Config.Framework = 'qb' -- qb | esx
```

### Discord Logging

Set your webhook and branding:

```lua
Config.Discord = {
  Webhook = 'https://discord.com/api/webhooks/CHANGE_ME',
  Username = 'Ultimate Admin Menu',
  Avatar = 'https://i.imgur.com/3z6X6P3.png'
}
```

### Integrations

Toggle support for common scripts:

```lua
Config.Integrations = {
  WasabiAmbulance = true,
  GKSPhone = true,
  CDGarage = true
}
```

### Role & Panel Access

Roles are defined with priority; higher priority inherits lower-level capabilities. Panels are whitelisted per role and can be locked with overrides.

```lua
Config.Roles = {
  god = { label = 'God', priority = 100 },
  admin = { label = 'Admin', priority = 50 },
  moderator = { label = 'Moderator', priority = 25 }
}

Config.RolePanels = {
  god = { 'dashboard', 'player_list', 'noclip', 'ban', 'give_vehicle' },
  admin = { 'dashboard', 'player_list', 'kick', 'give_money' },
  moderator = { 'dashboard', 'player_list', 'kick' }
}

Config.PermissionOverrides = {
  noclip = 'admin',
  god_mode = 'god'
}
```

> Tip: Add any custom panel IDs in `Config.PanelMeta` to label and categorize them in the UI.

## Commands & Keybinds

- **F10**: Opens the menu (`uamenu`).
- **/report**: Sends a player report to admins.
- **/adminchat**: Sends an admin-only chat message.

Commands are defined in `Config.ReportSystem.Command` and `Config.AdminChat.Command`.

## How It Works

### NUI Flow

1. Client opens menu with `uamenu`.
2. Server builds the allowed panel list based on role and sends payload to NUI.
3. NUI renders categories + quick actions and posts actions to the server.
4. Server validates permissions, performs action, and logs to Discord.

### Panels

The UI is driven by `Config.PanelMeta` and `Config.RolePanels`. This allows you to create 60+ panels without changing the UI layout—just add IDs to roles and metadata to label them.

### Moderation Actions

Actions such as kick, ban, revive, heal, and vehicle tools are validated server-side before running and logged to Discord with staff/target context.

## Extending Panels

Add a new panel:

1. Add the panel ID to `Config.PanelMeta` with a label and category.
2. Add the panel ID to the appropriate role in `Config.RolePanels`.
3. Add handling in `server.lua` inside `handleAction`:
   ```lua
   elseif data.panel == 'my_custom_action' then
     -- server logic here
   end
   ```
4. Add client event handling if needed (e.g., vehicle or UI behavior).

## Performance Notes

- The client script only runs a light control-disabler loop while the menu is open.
- Svelte NUI is optimized for fast rendering and supports large panel lists.
- Server logic is centralized in `handleAction` to reduce event overhead.

## Troubleshooting

- **Menu doesn’t open**: Ensure `ensure ultimate_admin_menu` is in `server.cfg`.
- **No Discord logs**: Check `Config.Discord.Webhook`.
- **Vehicle tools fail**: Ensure CD Garage and vehicle key resources are running if enabled.
- **Revive/Heal not working**: Confirm Wasabi Ambulance/QBCore hospital events are available.

## File Structure

```
ultimate_admin_menu/
├─ fxmanifest.lua
├─ config.lua
├─ client.lua
├─ server.lua
└─ web/
   ├─ index.html
   └─ src/
      ├─ main.js
      └─ App.svelte
```
