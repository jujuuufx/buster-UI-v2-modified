-- Roblox UI Library for Executors
-- Created by Grok AI
-- Version 1.0
-- This is a simple, modern UI library inspired by clean designs like Material UI.
-- It provides windows, tabs, sections, buttons, toggles, sliders, textboxes, and more.
-- Usage: Paste this into your executor and run it. Then use the API to create UIs.

local Library = {}
Library.__index = Library

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Colors (Modern dark theme with accents)
local Colors = {
    Background = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(0, 122, 255),
    Text = Color3.fromRGB(255, 255, 255),
    Secondary = Color3.fromRGB(50, 50, 50),
    Border = Color3.fromRGB(60, 60, 60),
    Hover = Color3.fromRGB(40, 40, 40),
    Active = Color3.fromRGB(0, 100, 200)
}

-- Utility Functions
local function CreateInstance(class, properties)
    local instance = Instance.new(class)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

local function Tween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(duration or 0.2, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Main Library Function
function Library:New(options)
    options = options or {}
    local self = setmetatable({}, Library)
    
    -- Main ScreenGui
    self.ScreenGui = CreateInstance("ScreenGui", {
        Name = options.Name or "ExecutorUI",
        Parent = game.CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Notification System (optional, can be expanded)
    self.Notifications = {}
    
    -- Windows Table
    self.Windows = {}
    
    return self
end

-- Create Window
function Library:CreateWindow(title, size, position)
    local window = {}
    
    -- Main Frame
    window.Frame = CreateInstance("Frame", {
        Name = title,
        Size = size or UDim2.new(0, 400, 0, 300),
        Position = position or UDim2.new(0.5, -200, 0.5, -150),
        BackgroundColor3 = Colors.Background,
        BorderColor3 = Colors.Border,
        BorderSizePixel = 1,
        Active = true,
        Draggable = true,
        Parent = self.ScreenGui
    })
    
    -- Title Bar
    window.TitleBar = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = window.Frame
    })
    
    window.TitleLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = title or "Window",
        TextColor3 = Colors.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = window.TitleBar
    })
    
    -- Close Button
    window.CloseButton = CreateInstance("TextButton", {
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = Colors.Text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        Parent = window.TitleBar
    })
    
    window.CloseButton.MouseButton1Click:Connect(function()
        window.Frame:Destroy()
    end)
    
    -- Content Frame (for tabs or sections)
    window.Content = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = window.Frame
    })
    
    -- UI Corner for rounded edges
    local corner = CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, 5),
        Parent = window.Frame
    })
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 5), Parent = window.TitleBar})
    
    -- Shadow Effect
    local shadow = CreateInstance("UIStroke", {
        Color = Color3.fromRGB(0, 0, 0),
        Transparency = 0.5,
        Thickness = 2,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = window.Frame
    })
    
    table.insert(self.Windows, window)
    return window
end

-- Create Tab System in Window
function Library:CreateTabSystem(window, tabs)
    local tabButtons = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = window.Content
    })
    
    local tabContent = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, -30),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = window.Content
    })
    
    local currentTab = nil
    local tabFrames = {}
    
    for i, tabName in ipairs(tabs) do
        local button = CreateInstance("TextButton", {
            Size = UDim2.new(1/#tabs, 0, 1, 0),
            Position = UDim2.new((i-1)/#tabs, 0, 0, 0),
            BackgroundColor3 = Colors.Secondary,
            Text = tabName,
            TextColor3 = Colors.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            Parent = tabButtons
        })
        
        local tabFrame = CreateInstance("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 4,
            Visible = false,
            Parent = tabContent
        })
        
        -- Layout for sections
        local layout = CreateInstance("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5),
            Parent = tabFrame
        })
        
        tabFrames[tabName] = tabFrame
        
        button.MouseButton1Click:Connect(function()
            if currentTab then
                tabFrames[currentTab].Visible = false
            end
            tabFrame.Visible = true
            currentTab = tabName
            Tween(button, {BackgroundColor3 = Colors.Accent}, 0.2)
            for _, btn in ipairs(tabButtons:GetChildren()) do
                if btn:IsA("TextButton") and btn ~= button then
                    Tween(btn, {BackgroundColor3 = Colors.Secondary}, 0.2)
                end
            end
        end)
        
        if i == 1 then
            button:FireEvent("MouseButton1Click")
        end
    end
    
    return tabFrames
end

-- Create Section in Tab
function Library:CreateSection(tabFrame, title)
    local section = CreateInstance("Frame", {
        Size = UDim2.new(1, -10, 0, 0), -- Auto height
        BackgroundColor3 = Colors.Secondary,
        BorderSizePixel = 0,
        Parent = tabFrame
    })
    
    local sectionTitle = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Colors.Text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section
    })
    
    local content = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, -25),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundTransparency = 1,
        Parent = section
    })
    
    local layout = CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
        Parent = content
    })
    
    layout.Changed:Connect(function(prop)
        if prop == "AbsoluteContentSize" then
            section.Size = UDim2.new(1, -10, 0, layout.AbsoluteContentSize.Y + 30)
            tabFrame.CanvasSize = UDim2.new(0, 0, 0, tabFrame.UIListLayout.AbsoluteContentSize.Y + 20)
        end
    end)
    
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = section})
    
    return content
end

-- Create Button
function Library:CreateButton(section, text, callback)
    local button = CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Colors.Accent,
        Text = text,
        TextColor3 = Colors.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        AutoButtonColor = false,
        Parent = section
    })
    
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = button})
    
    button.MouseEnter:Connect(function()
        Tween(button, {BackgroundColor3 = Colors.Active}, 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        Tween(button, {BackgroundColor3 = Colors.Accent}, 0.2)
    end)
    
    button.MouseButton1Click:Connect(callback or function() end)
    
    return button
end

-- Create Toggle
function Library:CreateToggle(section, text, default, callback)
    local toggle = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = section
    })
    
    local label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Colors.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toggle
    })
    
    local toggleButton = CreateInstance("Frame", {
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -40, 0.5, -10),
        BackgroundColor3 = Colors.Secondary,
        Parent = toggle
    })
    
    local circle = CreateInstance("Frame", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, 1, 0.5, -9),
        BackgroundColor3 = Colors.Background,
        Parent = toggleButton
    })
    
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 10), Parent = toggleButton})
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 9), Parent = circle})
    
    local enabled = default or false
    local function updateToggle()
        if enabled then
            Tween(circle, {Position = UDim2.new(1, -19, 0.5, -9), BackgroundColor3 = Colors.Accent}, 0.2)
        else
            Tween(circle, {Position = UDim2.new(0, 1, 0.5, -9), BackgroundColor3 = Colors.Background}, 0.2)
        end
        callback(enabled)
    end
    
    toggleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            enabled = not enabled
            updateToggle()
        end
    end)
    
    if default then updateToggle() end
    
    return toggle
end

-- Create Slider
function Library:CreateSlider(section, text, min, max, default, callback)
    local slider = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = section
    })
    
    local label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Colors.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = slider
    })
    
    local sliderBar = CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 5),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = Colors.Secondary,
        Parent = slider
    })
    
    local fill = CreateInstance("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Colors.Accent,
        Parent = sliderBar
    })
    
    local valueLabel = CreateInstance("TextLabel", {
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -50, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextColor3 = Colors.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = slider
    })
    
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 3), Parent = sliderBar})
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 3), Parent = fill})
    
    local value = default or min
    local dragging = false
    
    local function updateValue(pos)
        local percent = math.clamp((pos - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        value = min + (max - min) * percent
        value = math.round(value)
        fill.Size = UDim2.new(percent, 0, 1, 0)
        valueLabel.Text = tostring(value)
        callback(value)
    end
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateValue(input.Position.X)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateValue(input.Position.X)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    updateValue(sliderBar.AbsolutePosition.X + (sliderBar.AbsoluteSize.X * ((default - min) / (max - min))))
    
    return slider
end

-- Create Textbox
function Library:CreateTextbox(section, placeholder, callback)
    local textbox = CreateInstance("TextBox", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Colors.Secondary,
        Text = "",
        PlaceholderText = placeholder,
        PlaceholderColor3 = Colors.Border,
        TextColor3 = Colors.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        ClearTextOnFocus = false,
        Parent = section
    })
    
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 4), Parent = textbox})
    
    textbox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            callback(textbox.Text)
        end
    end)
    
    return textbox
end

-- Notification Function
function Library:Notify(text, duration)
    local notify = CreateInstance("Frame", {
        Size = UDim2.new(0, 200, 0, 50),
        Position = UDim2.new(1, -210, 1, -60 - (#self.Notifications * 55)),
        BackgroundColor3 = Colors.Background,
        BorderColor3 = Colors.Border,
        Parent = self.ScreenGui
    })
    
    local label = CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Colors.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextWrapped = true,
        Parent = notify
    })
    
    CreateInstance("UICorner", {CornerRadius = UDim.new(0, 5), Parent = notify})
    
    table.insert(self.Notifications, notify)
    
    Tween(notify, {Position = UDim2.new(1, -210, 1, -60 - (#self.Notifications * 55))}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    wait(duration or 3)
    
    Tween(notify, {Position = UDim2.new(1, 0, notify.Position.Y.Scale, notify.Position.Y.Offset)}, 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    wait(0.3)
    notify:Destroy()
    table.remove(self.Notifications, table.find(self.Notifications, notify))
end

-- Example Usage (Comment out or remove in actual use)
--[[
local UI = Library:New({Name = "MyExecutorUI"})

local win = UI:CreateWindow("Executor Panel", UDim2.new(0, 500, 0, 400))

local tabs = UI:CreateTabSystem(win, {"Scripts", "Settings", "Info"})

local scriptSection = UI:CreateSection(tabs["Scripts"], "Script Executor")

UI:CreateTextbox(scriptSection, "Enter Lua Script Here", function(script)
    -- Execute script here, e.g., loadstring(script)()
    UI:Notify("Script Executed!")
end)

UI:CreateButton(scriptSection, "Execute", function()
    -- Get textbox text and execute
end)

local settingsSection = UI:CreateSection(tabs["Settings"], "UI Settings")

UI:CreateToggle(settingsSection, "Dark Mode", true, function(state)
    print("Dark Mode:", state)
end)

UI:CreateSlider(settingsSection, "Speed", 1, 100, 50, function(value)
    print("Speed Set To:", value)
end)
--]]

return Library
