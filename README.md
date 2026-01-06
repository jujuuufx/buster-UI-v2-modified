# Buster UI – Example

A simple, clean, and modern **Roblox executor UI library** with a **resizable window**, modular layout, and easy-to-use API.

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

## Home Page

Create a built-in home tab with executor info, changelog, and Discord invite.

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
            Title = "Version 1.1.0",
            Date = "January 2026",
            Description = "Added resizable window support"
        },
        {
            Title = "Version 1.0.0",
            Date = "December 2024",
            Description = "Initial release"
        }
    }
})
```

---

## Toggle

```lua
Panel:CreateToggle({
    Name = "Toggle Example",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})
```

---

## Button

```lua
Panel:CreateButton({
    Name = "Button Example",
    Callback = function()
        print("Button clicked")
    end
})
```

---

## Slider

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

---

## Keybind

```lua
Panel:CreateKeybind({
    Name = "Keybind Example",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        print("Keybind:", key.Name)
    end
})
```

---

## Dropdown

```lua
Panel:CreateDropdown({
    Name = "Dropdown Example",
    List = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(value)
        print("Dropdown:", value)
    end
})
```

---

## Label

```lua
Panel:CreateLabel({
    Text = "Label Example",
    Size = 11
})
```

---

## Features

* Clean, modern executor UI
* Resizable window
* Tab + panel layout system
* Home page with changelog & executor support
* Toggles, buttons, sliders, dropdowns, keybinds, labels
* Simple and readable API

---

## Notes

* Designed for **Roblox executors**
* Load the library **before** creating UI elements
* Toggle the UI using the configured `ToggleKey`
