```markdown
# Buster UI - Example

Simple and clean UI library for Roblox executors.

## Table of Contents

- [Installation](#installation)
- [Basic Setup](#basic-setup)
- [Home Page](#home-page)
- [Toggle](#toggle)
- [Button](#button)
- [Slider](#slider)
- [Keybind](#keybind)
- [Dropdown](#dropdown)
- [Label](#label)

## Installation

To use Buster UI, load the library from the raw GitHub URL:

```lua
local Buster = loadstring(game:HttpGet("https://raw.githubusercontent.com/jujuuufx/buster-UI-v2-modified/refs/heads/main/UI.lua"))()
```

## Basic Setup

```
local Buster = loadstring(game:HttpGet("https://raw.githubusercontent.com/jujuuufx/buster-UI-v2-modified/refs/heads/main/UI.lua"))()
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

## Home Page

```lua
local homeTab = Buster:CreateHomeTab(Window, {
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

## Button

```lua
Panel:CreateButton({
    Name = "Button Example",
    Callback = function()
        print("Button clicked")
    end
})
```

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

## Label

```lua
Panel:CreateLabel({
    Text = "Label Example",
    Size = 11
})
```
```

# Example Script

Here's a complete example Lua script that combines all the snippets from the README into a single, runnable script. This demonstrates setting up the window, adding a home tab, and creating a panel with all the example UI elements (toggle, button, slider, keybind, dropdown, and label). Save this as `example.lua` or similar.

```lua
-- Load the Buster UI library
local Buster = loadstring(game:HttpGet("https://raw.githubusercontent.com/jurky2/Buster-Ui-Library-V2/refs/heads/main/UI.lua"))()

-- Create the main window
local Window = Buster:CreateWindow({
    Name = "Buster UI",
    Subtitle = "Example Script",
    Footer = "The Bronx",
    BrandText = "B",
    Size = { Width = 860, Height = 480 },
    ToggleKey = Enum.KeyCode.RightShift
})

-- Create the home tab
local homeTab = Buster:CreateHomeTab(Window, {
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

-- Create a main tab
local Tab = Window:CreateTab({
    Name = "Main",
    Icon = "rbxassetid://10734949856"
})

-- Create a panel in the main tab
local Panel = Tab:CreatePanel({
    Column = "Left",
    Title = "Main Features"
})

-- Add a toggle
Panel:CreateToggle({
    Name = "Toggle Example",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end
})

-- Add a button
Panel:CreateButton({
    Name = "Button Example",
    Callback = function()
        print("Button clicked")
    end
})

-- Add a slider
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

-- Add a keybind
Panel:CreateKeybind({
    Name = "Keybind Example",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        print("Keybind:", key.Name)
    end
})

-- Add a dropdown
Panel:CreateDropdown({
    Name = "Dropdown Example",
    List = {"Option 1", "Option 2", "Option 3"},
    Default = "Option 1",
    Callback = function(value)
        print("Dropdown:", value)
    end
})

-- Add a label
Panel:CreateLabel({
    Text = "Label Example",
    Size = 11
})
```

This script should work out of the box in a Roblox executor that supports HttpGet. Let me know if you need further tweaks!
