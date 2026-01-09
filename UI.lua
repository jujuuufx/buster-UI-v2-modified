-- Shadow UI Library
-- Sleek and Modular UI for Roblox Executors
-- Version 1.0.0

local Shadow = {}
Shadow.__index = Shadow

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Theme Definitions
local Themes = {
    DarkSleek = {
        Background = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(0, 122, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Secondary = Color3.fromRGB(50, 50, 50),
        Border = Color3.fromRGB(60, 60, 60),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    LightMinimal = {
        Background = Color3.fromRGB(240, 240, 240),
        Accent = Color3.fromRGB(0, 122, 255),
        Text = Color3.fromRGB(0, 0, 0),
        Secondary = Color3.fromRGB(220, 220, 220),
        Border = Color3.fromRGB(200, 200, 200),
        Shadow = Color3.fromRGB(150, 150, 150),
    }
}

-- Utility Functions
local function CreateInstance(class, props)
    local inst = Instance.new(class)
    for prop, value in pairs(props or {}) do
        inst[prop] = value
    end
    return inst
end

local function Tween(instance, props, info)
    TweenService:Create(instance, TweenInfo.new(info.Time or 0.2, info.Style or Enum.EasingStyle.Quad, info.Direction or Enum.EasingDirection.Out), props):Play()
end

-- Module System (Modular Design)
local Modules = {}
function Shadow:RegisterModule(name, factory)
    Modules[name] = factory()
    return Modules[name]
end

-- Window Creation
function Shadow:CreateWindow(options)
    local self = setmetatable({}, { __index = Shadow })
    self.Theme = Themes[options.Theme or "DarkSleek"]
    self.Tabs = {}
    self.Modules = Modules
    
    -- ScreenGui
    self.ScreenGui = CreateInstance("ScreenGui", {
        Parent = game.CoreGui,
        Name = options.Title or "ShadowUI",
        IgnoreGuiInset = true
    })
    
    -- Main Frame
    self.MainFrame = CreateInstance("Frame", {
        Parent = self.ScreenGui,
        Size = UDim2.new(0, options.Dimensions.Width, 0, options.Dimensions.Height),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0
    })
    CreateInstance("UICorner", { Parent = self.MainFrame, CornerRadius = UDim.new(0, 8) })
    CreateInstance("UIStroke", { Parent = self.MainFrame, Color = self.Theme.Border, Transparency = 0.5 })
    
    -- Title Bar
    self.TitleBar = CreateInstance("Frame", {
        Parent = self.MainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0
    })
    CreateInstance("UICorner", { Parent = self.TitleBar, CornerRadius = UDim.new(0, 8) })
    
    local TitleLabel = CreateInstance("TextLabel", {
        Parent = self.TitleBar,
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 40, 0, 0),
        BackgroundTransparency = 1,
        Text = options.Title .. " - " .. (options.Subtitle or ""),
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14
    })
    
    -- Brand Icon
    if options.BrandIcon then
        CreateInstance("TextLabel", {
            Parent = self.TitleBar,
            Size = UDim2.new(0, 40, 1, 0),
            BackgroundTransparency = 1,
            Text = options.BrandIcon,
            TextColor3 = self.Theme.Accent,
            Font = Enum.Font.GothamBlack,
            TextSize = 20
        })
    end
    
    -- Close Button
    local CloseButton = CreateInstance("TextButton", {
        Parent = self.TitleBar,
        Size = UDim2.new(0, 40, 1, 0),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 14
    })
    CloseButton.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    -- Tab Container
    self.TabButtons = CreateInstance("Frame", {
        Parent = self.MainFrame,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0
    })
    CreateInstance("UIListLayout", { Parent = self.TabButtons, FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 5) })
    
    self.TabContent = CreateInstance("Frame", {
        Parent = self.MainFrame,
        Size = UDim2.new(1, 0, 1, -80),
        Position = UDim2.new(0, 0, 0, 80),
        BackgroundTransparency = 1
    })
    
    -- Footer
    self.Footer = CreateInstance("TextLabel", {
        Parent = self.MainFrame,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -20),
        BackgroundColor3 = self.Theme.Secondary,
        Text = options.Footer or "",
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 10
    })
    
    -- Draggable
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    -- Toggle Key
    if options.ToggleBind then
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == options.ToggleBind and not UserInputService:GetFocusedTextBox() then
                self.ScreenGui.Enabled = not self.ScreenGui.Enabled
            end
        end)
    end
    
    return self
end

-- Tab Creation
function Shadow:CreateTab(options)
    local tab = {}
    tab.Name = options.Name
    tab.Icon = options.Icon
    
    -- Tab Button
    tab.Button = CreateInstance("TextButton", {
        Parent = self.TabButtons,
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundColor3 = self.Theme.Background,
        Text = options.Name,
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 12
    })
    CreateInstance("UICorner", { Parent = tab.Button, CornerRadius = UDim.new(0, 4) })
    
    if options.Icon then
        CreateInstance("ImageLabel", {
            Parent = tab.Button,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 5, 0.5, -10),
            BackgroundTransparency = 1,
            Image = options.Icon
        })
        tab.Button.TextXAlignment = Enum.TextXAlignment.Right
    end
    
    -- Tab Frame
    tab.Frame = CreateInstance("ScrollingFrame", {
        Parent = self.TabContent,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    })
    CreateInstance("UIListLayout", { Parent = tab.Frame, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })
    
    -- Tab Switching
    tab.Button.MouseButton1Click:Connect(function()
        for _, t in pairs(self.Tabs) do
            t.Frame.Visible = false
            Tween(t.Button, { BackgroundColor3 = self.Theme.Background }, { Time = 0.1 })
        end
        tab.Frame.Visible = true
        Tween(tab.Button, { BackgroundColor3 = self.Theme.Secondary }, { Time = 0.1 })
    end)
    
    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        tab.Button:FireEvent("MouseButton1Click")
    end
    
    return tab
end

-- Section Creation
function Shadow:CreateSection(tab, options)
    local section = CreateInstance("Frame", {
        Parent = tab.Frame,
        Size = UDim2.new(0.5, -10, 0, 0),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y
    })
    if options.Side == "Right" then
        section.Position = UDim2.new(0.5, 5, 0, 0)
    else
        section.Position = UDim2.new(0, 5, 0, 0)
    end
    CreateInstance("UICorner", { Parent = section, CornerRadius = UDim.new(0, 6) })
    CreateInstance("UIListLayout", { Parent = section, Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })
    
    local header = CreateInstance("TextLabel", {
        Parent = section,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = options.Header,
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamSemibold,
        TextSize = 13
    })
    
    if options.Collapsible then
        local collapseButton = CreateInstance("TextButton", {
            Parent = header,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -25, 0.5, -10),
            BackgroundTransparency = 1,
            Text = "-",
            TextColor3 = self.Theme.Accent
        })
        collapseButton.MouseButton1Click:Connect(function()
            section.Visible = not section.Visible
            collapseButton.Text = section.Visible and "-" or "+"
        end)
    end
    
    -- Element Methods
    function section:CreateToggle(opts)
        local toggle = CreateInstance("Frame", {
            Parent = section,
            Size = UDim2.new(1, -10, 0, 30),
            BackgroundTransparency = 1
        })
        
        local label = CreateInstance("TextLabel", {
            Parent = toggle,
            Size = UDim2.new(1, -50, 1, 0),
            BackgroundTransparency = 1,
            Text = opts.Label,
            TextColor3 = self.Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local toggleButton = CreateInstance("Frame", {
            Parent = toggle,
            Size = UDim2.new(0, 40, 0, 20),
            Position = UDim2.new(1, -40, 0.5, -10),
            BackgroundColor3 = self.Theme.Background,
            BorderSizePixel = 0
        })
        CreateInstance("UICorner", { Parent = toggleButton, CornerRadius = UDim.new(1, 0) })
        
        local indicator = CreateInstance("Frame", {
            Parent = toggleButton,
            Size = UDim2.new(0.5, 0, 1, 0),
            BackgroundColor3 = opts.EnabledByDefault and self.Theme.Accent or self.Theme.Secondary
        })
        CreateInstance("UICorner", { Parent = indicator, CornerRadius = UDim.new(1, 0) })
        
        local enabled = opts.EnabledByDefault or false
        toggleButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                enabled = not enabled
                Tween(indicator, { Position = UDim2.new(enabled and 0.5 or 0, 0, 0, 0), BackgroundColor3 = enabled and self.Theme.Accent or self.Theme.Secondary }, { Time = 0.2 })
                if opts.OnChange then opts.OnChange(enabled) end
            end
        end)
        
        return toggle
    end
    
    function section:CreateButton(opts)
        local button = CreateInstance("TextButton", {
            Parent = section,
            Size = UDim2.new(1, -10, 0, 30),
            BackgroundColor3 = self.Theme[opts.Style or "Primary"] == "Primary" and self.Theme.Accent or (opts.Style == "Danger" and Color3.fromRGB(255, 0, 0) or self.Theme.Secondary),
            Text = opts.Label,
            TextColor3 = self.Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12
        })
        CreateInstance("UICorner", { Parent = button, CornerRadius = UDim.new(0, 4) })
        
        if opts.Icon then
            CreateInstance("ImageLabel", {
                Parent = button,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 5, 0.5, -10),
                BackgroundTransparency = 1,
                Image = opts.Icon
            })
            button.TextXAlignment = Enum.TextXAlignment.Right
        end
        
        button.MouseButton1Click:Connect(opts.OnClick or function() end)
        return button
    end
    
    function section:CreateSlider(opts)
        local slider = CreateInstance("Frame", {
            Parent = section,
            Size = UDim2.new(1, -10, 0, 40),
            BackgroundTransparency = 1
        })
        
        local label = CreateInstance("TextLabel", {
            Parent = slider,
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = opts.Label,
            TextColor3 = self.Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12
        })
        
        local sliderBar = CreateInstance("Frame", {
            Parent = slider,
            Size = UDim2.new(1, 0, 0, 10),
            Position = UDim2.new(0, 0, 0, 25),
            BackgroundColor3 = self.Theme.Secondary
        })
        CreateInstance("UICorner", { Parent = sliderBar, CornerRadius = UDim.new(1, 0) })
        
        local fill = CreateInstance("Frame", {
            Parent = sliderBar,
            Size = UDim2.new(0.5, 0, 1, 0),
            BackgroundColor3 = self.Theme.Accent
        })
        CreateInstance("UICorner", { Parent = fill, CornerRadius = UDim.new(1, 0) })
        
        local valueLabel = CreateInstance("TextLabel", {
            Parent = sliderBar,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            TextColor3 = self.Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 10
        })
        
        local min, max, step = opts.Range.Min, opts.Range.Max, opts.Step or 1
        local value = opts.StartValue or min
        local function updateValue(newValue)
            value = math.clamp(math.floor(newValue / step) * step, min, max)
            fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            valueLabel.Text = tostring(value) .. (opts.Unit or "")
            if opts.OnValueChange then opts.OnValueChange(value) end
        end
        updateValue(value)
        
        local dragging = false
        sliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
            end
        end)
        sliderBar.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        RunService.RenderStepped:Connect(function()
            if dragging then
                local mousePos = UserInputService:GetMouseLocation()
                local relPos = math.clamp((mousePos.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                updateValue(min + relPos * (max - min))
            end
        end)
        
        return slider
    end
    
    function section:CreateKeybind(opts)
        local keybind = CreateInstance("Frame", {
            Parent = section,
            Size = UDim2.new(1, -10, 0, 30),
            BackgroundTransparency = 1
        })
        
        local label = CreateInstance("TextLabel", {
            Parent = keybind,
            Size = UDim2.new(1, -100, 1, 0),
            BackgroundTransparency = 1,
            Text = opts.Label,
            TextColor3 = self.Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local bindButton = CreateInstance("TextButton", {
            Parent = keybind,
            Size = UDim2.new(0, 80, 1, 0),
            Position = UDim2.new(1, -80, 0, 0),
            BackgroundColor3 = self.Theme.Background,
            Text = opts.DefaultKey.Name,
            TextColor3 = self.Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12
        })
        CreateInstance("UICorner", { Parent = bindButton, CornerRadius = UDim.new(0, 4) })
        
        local currentKey = opts.DefaultKey
        local listening = false
        bindButton.MouseButton1Click:Connect(function()
            listening = true
            bindButton.Text = "..."
        end)
        UserInputService.InputBegan:Connect(function(input)
            if listening and input.KeyCode ~= Enum.KeyCode.Unknown then
                currentKey = input.KeyCode
                bindButton.Text = currentKey.Name
                listening = false
                if opts.OnBind then opts.OnBind(currentKey) end
            end
        end)
        
        -- Mode (Hold/Toggle/AlwaysOn)
        local mode = opts.Mode or "Hold"
        if mode == "Hold" then
            UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == currentKey then
                    if opts.OnBind then opts.OnBind(true) end
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.KeyCode == currentKey then
                    if opts.OnBind then opts.OnBind(false) end
                end
            end)
        elseif mode == "Toggle" then
            local toggled = false
            UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode == currentKey then
                    toggled = not toggled
                    if opts.OnBind then opts.OnBind(toggled) end
                end
            end)
        elseif mode == "AlwaysOn" then
            if opts.OnBind then opts.OnBind(true) end
        end
        
        return keybind
    end
    
    function section:CreateDropdown(opts)
        local dropdown = CreateInstance("Frame", {
            Parent = section,
            Size = UDim2.new(1, -10, 0, 30),
            BackgroundTransparency = 1
        })
        
        local label = CreateInstance("TextLabel", {
            Parent = dropdown,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = opts.Label,
            TextColor3 = self.Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left
        })
        
        local selected = CreateInstance("TextButton", {
            Parent = dropdown,
            Size = UDim2.new(0, 150, 1, 0),
            Position = UDim2.new(1, -150, 0, 0),
            BackgroundColor3 = self.Theme.Background,
            Text = opts.DefaultSelection,
            TextColor3 = self.Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12
        })
        CreateInstance("UICorner", { Parent = selected, CornerRadius = UDim.new(0, 4) })
        
        local listFrame = CreateInstance("ScrollingFrame", {
            Parent = dropdown,
            Size = UDim2.new(1, 0, 0, 100),
            Position = UDim2.new(0, 0, 1, 5),
            BackgroundColor3 = self.Theme.Secondary,
            Visible = false,
            ScrollBarThickness = 4,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y
        })
        CreateInstance("UICorner", { Parent = listFrame, CornerRadius = UDim.new(0, 4) })
        CreateInstance("UIListLayout", { Parent = listFrame, Padding = UDim.new(0, 2) })
        
        selected.MouseButton1Click:Connect(function()
            listFrame.Visible = not listFrame.Visible
        end)
        
        local selections = opts.MultiSelect and {} or nil
        for _, option in pairs(opts.Options) do
            local optButton = CreateInstance("TextButton", {
                Parent = listFrame,
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundColor3 = self.Theme.Background,
                Text = option,
                TextColor3 = self.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 12
            })
            CreateInstance("UICorner", { Parent = optButton, CornerRadius = UDim.new(0, 4) })
            
            optButton.MouseButton1Click:Connect(function()
                if opts.MultiSelect then
                    if table.find(selections, option) then
                        table.remove(selections, table.find(selections, option))
                    else
                        table.insert(selections, option)
                    end
                    selected.Text = table.concat(selections, ", ") or "None"
                else
                    selected.Text = option
                    listFrame.Visible = false
                end
                if opts.OnSelect then opts.OnSelect(opts.MultiSelect and selections or option) end
            end)
        end
        
        return dropdown
    end
    
    function section:CreateLabel(opts)
        local label = CreateInstance("TextLabel", {
            Parent = section,
            Size = UDim2.new(1, -10, 0, opts.FontSize + 10),
            BackgroundTransparency = 1,
            Text = opts.Content,
            TextColor3 = opts.Color or self.Theme.Text,
            Font = Enum.Font.Gotham,
            TextSize = opts.FontSize or 12,
            TextXAlignment = Enum.TextXAlignment[opts.Alignment or "Left"]
        })
        return label
    end
    
    return section
end

-- Home Tab (Special Tab)
function Shadow:CreateHomeTab(window, options)
    local homeTab = window:CreateTab({ Name = "Home", Icon = options.Icon })
    local leftSection = homeTab:CreateSection({ Side = "Left", Header = "Welcome" })
    local rightSection = homeTab:CreateSection({ Side = "Right", Header = "Info" })
    
    -- Backdrop
    if options.BackgroundImage then
        CreateInstance("ImageLabel", {
            Parent = homeTab.Frame,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = options.BackgroundImage,
            ScaleType = Enum.ScaleType.Crop,
            ZIndex = -1
        })
    end
    
    -- Discord Invite
    if options.DiscordLink then
        leftSection:CreateButton({
            Label = "Join Discord",
            OnClick = function()
                -- Roblox doesn't support direct links, perhaps print or setclipboard
                setclipboard("https://discord.gg/" .. options.DiscordLink)
                print("Discord invite copied to clipboard")
            end
        })
    end
    
    -- Supported Executors
    leftSection:CreateLabel({ Content = "Supported Executors:", FontSize = 12 })
    for _, exec in pairs(options.SupportedPlatforms or {}) do
        leftSection:CreateLabel({ Content = "- " .. exec, FontSize = 11 })
    end
    
    -- Unsupported
    leftSection:CreateLabel({ Content = "Unsupported Executors:", FontSize = 12 })
    for _, exec in pairs(options.UnsupportedPlatforms or {}) do
        leftSection:CreateLabel({ Content = "- " .. exec, FontSize = 11 })
    end
    
    -- Changelog
    rightSection:CreateLabel({ Content = "Changelog:", FontSize = 12 })
    for _, log in pairs(options.UpdateLog or {}) do
        rightSection:CreateLabel({ Content = log.Version .. " (" .. log.ReleaseDate .. "): " .. log.Changes, FontSize = 11 })
    end
    
    -- Load Modules
    for _, mod in pairs(options.Modules or {}) do
        if Modules[mod] then
            -- Assume modules have an Init function or something
            -- For example purposes, skip detailed init
        end
    end
    
    return homeTab
end

return Shadow
