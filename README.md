# Buster UI
A simple, clean, and modern UI library for Roblox executors.
---
## Table of Contents
- [Installation](#installation)
- [Basic Setup](#basic-setup)
- [Home Tab](#home-tab)
- [UI Elements](#ui-elements)
  - [Toggle](#toggle)
  - [Button](#button)
  - [Slider](#slider)
  - [Keybind](#keybind)
  - [Dropdown](#dropdown)
  - [Label](#label)
- [Configs](#configs)
- [Full Example Script](#full-example-script)
---
## Installation
Load Buster UI directly from GitHub:
```lua
local Buster = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/jujuuufx/buster-UI-v2-modified/refs/heads/main/UI.lua"
))()
```
---
## Basic Setup
```lua
local Buster = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/jujuuufx/buster-UI-v2-modified/refs/heads/main/UI.lua"
))()
local Window = Buster:CreateWindow({
    Name = "Buster UI",
    Subtitle = "Example Script",
    Footer = "The Bronx",
    BrandText = "B",
    Size = { Width = 860, Height = 480 },
    ToggleKey = Enum.KeyCode.RightShift
})
local Tab = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://10734949856"
})
local Panel = Tab:CreatePanel({
    Column = "Left",
    Title = "Main Features"
})
```
---
## Home Tab
```lua
local HomeTab = Buster:CreateHomeTab(Window, {
    Icon = "rbxassetid://11295288868",
    Backdrop = 0,
    DiscordInvite = "yourcode",
    SupportedExecutors = {
        "Synapse X",
        "Wave",
        "Delta",
        "Codex"
    },
    UnsupportedExecutors = {
        "Solara",
        "Swift"
    },
    Changelog = {
        {
            Title = "Version 1.0.0",
            Date = "December 2024",
            Description = "Initial release"
        }
    }
})
```
---
## UI Elements
### Toggle
```lua
Panel:CreateToggle({
    Name = "Toggle Example",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})
```
### Button
```lua
Panel:CreateButton({
    Name = "Button Example",
    Callback = function()
        print("Button clicked")
    end
})
```
### Slider
```lua
Panel:CreateSlider({
    Name = "Slider Example",
    Min = 0,
    Max = 100,
    Default = 50,
    Increment = 1,
    Callback = function(value)
        print("Slider:", value)
    end
})
```
### Keybind
```lua
Panel:CreateKeybind({
    Name = "Keybind Example",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        print("Keybind:", key.Name)
    end
})
```
### Dropdown
```lua
Panel:CreateDropdown({
    Name = "Dropdown Example",
    List = { "Option 1", "Option 2", "Option 3" },
    Default = "Option 1",
    Callback = function(value)
        print("Dropdown:", value)
    end
})
```
### Label
```lua
Panel:CreateLabel({
    Text = "Label Example",
    Size = 11
})
```
---
## Configs
Buster UI supports saving and loading configurations for UI elements like toggles, sliders, keybinds, and dropdowns. Configs are stored as JSON files in the "BusterConfigs/<PlaceId>/" folder.

### Using the Built-in Config UI
The library automatically creates a "Settings" tab with a "Configs" panel on the right. In this panel, you can:

- Enter a config name in the "Config Name" textbox.
- Select from existing configs in the "Existing Configs" dropdown (auto-refreshes).
- Click "Create Config" to add a new empty config file.
- Click "Save Config" to save current UI settings to the named config.
- Click "Load Config" to apply settings from the selected config.
- Click "Delete Config" to remove the selected config file.

Notifications will confirm actions like saving, loading, or deleting.

### Programmatic Usage
You can manage configs directly via window methods:

```lua
-- Save current UI settings to a config file
Window:SaveConfig("myconfig")

-- Load settings from a config file
Window:LoadConfig("myconfig")

-- Delete a config file
Window:DeleteConfig("myconfig")

-- Get a list of existing config names (without .json extension)
local configs = Window:GetConfigs()
print("Configs:", table.concat(configs, ", "))
```

These methods handle file operations and notify the user of success or errors (e.g., if a config doesn't exist).

Note: Configs persist across sessions if your executor supports file I/O. Only supported element types (Toggle, Slider, Keybind, Dropdown) are saved/loaded.

---
## Full Example Script
```lua
-- Load library
local Buster = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/jujuuufx/buster-UI-v2-modified/refs/heads/main/UI.lua"
))()
-- Window
local Window = Buster:CreateWindow({
    Name = "Buster UI",
    Subtitle = "Example Script",
    Footer = "The Bronx",
    BrandText = "B",
    Size = { Width = 860, Height = 480 },
    ToggleKey = Enum.KeyCode.RightShift
})
-- Home tab
Buster:CreateHomeTab(Window, {
    Icon = "rbxassetid://11295288868",
    Backdrop = 0,
    DiscordInvite = "yourcode",
    SupportedExecutors = { "Synapse X", "Wave", "Delta", "Codex" },
    UnsupportedExecutors = { "Solara", "Swift" },
    Changelog = {
        {
            Title = "Version 1.0.0",
            Date = "December 2024",
            Description = "Initial release"
        }
    }
})
-- Main tab
local Tab = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://10734949856"
})
local Panel = Tab:CreatePanel({
    Column = "Left",
    Title = "Main Features"
})
Panel:CreateToggle({
    Name = "Toggle Example",
    Callback = function(v) print("Toggle:", v) end
})
Panel:CreateButton({
    Name = "Button Example",
    Callback = function() print("Button clicked") end
})
Panel:CreateSlider({
    Name = "Slider Example",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(v) print("Slider:", v) end
})
Panel:CreateKeybind({
    Name = "Keybind Example",
    Default = Enum.KeyCode.E,
    Callback = function(k) print("Keybind:", k.Name) end
})
Panel:CreateDropdown({
    Name = "Dropdown Example",
    List = { "Option 1", "Option 2", "Option 3" },
    Callback = function(v) print("Dropdown:", v) end
})
Panel:CreateLabel({
    Text = "Label Example"
})
```
