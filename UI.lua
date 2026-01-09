-- Pulse UI V2 - Improved lightweight Roblox UI library
-- Note: This is UI-only (no game logic). Works with mouse + touch.
-- Improvements: Added hover effects, more themes, fixed config handling with auto-load default, cleaned up code, bug fixes, better visuals with gradients.

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- Executor compatibility shims
local taskSpawn = (task and task.spawn) or function(fn, ...) spawn(function() fn(...) end) end
local taskWait = (task and task.wait) or wait
local taskDelay = (task and task.delay) or function(seconds, fn, ...) spawn(function() wait(seconds or 0) fn(...) end) end

local PulseUI = {}

PulseUI.Themes = {
    Default = {
        bg = Color3.fromRGB(10, 10, 10),
        panel = Color3.fromRGB(16, 16, 16),
        panel2 = Color3.fromRGB(20, 20, 20),
        stroke = Color3.fromRGB(60, 60, 60),
        strokeSoft = Color3.fromRGB(42, 42, 42),
        label = Color3.fromRGB(170, 170, 170),
        muted = Color3.fromRGB(140, 140, 140),
        text = Color3.fromRGB(235, 235, 235),
        value = Color3.fromRGB(215, 215, 215),
        accent = Color3.fromRGB(185, 38, 38),
        accent2 = Color3.fromRGB(140, 28, 28),
    },
    Ocean = {
        bg = Color3.fromRGB(9, 10, 12),
        panel = Color3.fromRGB(15, 17, 20),
        panel2 = Color3.fromRGB(20, 22, 26),
        stroke = Color3.fromRGB(70, 80, 90),
        strokeSoft = Color3.fromRGB(40, 48, 56),
        label = Color3.fromRGB(170, 180, 190),
        muted = Color3.fromRGB(140, 150, 160),
        text = Color3.fromRGB(235, 240, 245),
        value = Color3.fromRGB(215, 225, 235),
        accent = Color3.fromRGB(70, 140, 255),
        accent2 = Color3.fromRGB(40, 90, 170),
    },
    Violet = {
        bg = Color3.fromRGB(10, 9, 12),
        panel = Color3.fromRGB(16, 15, 20),
        panel2 = Color3.fromRGB(20, 18, 26),
        stroke = Color3.fromRGB(80, 70, 95),
        strokeSoft = Color3.fromRGB(44, 40, 56),
        label = Color3.fromRGB(175, 170, 190),
        muted = Color3.fromRGB(145, 140, 160),
        text = Color3.fromRGB(238, 236, 245),
        value = Color3.fromRGB(220, 215, 235),
        accent = Color3.fromRGB(160, 90, 255),
        accent2 = Color3.fromRGB(110, 50, 170),
    },
    Emerald = {
        bg = Color3.fromRGB(9, 11, 10),
        panel = Color3.fromRGB(15, 18, 16),
        panel2 = Color3.fromRGB(19, 23, 20),
        stroke = Color3.fromRGB(75, 90, 80),
        strokeSoft = Color3.fromRGB(40, 54, 46),
        label = Color3.fromRGB(175, 190, 180),
        muted = Color3.fromRGB(140, 160, 150),
        text = Color3.fromRGB(238, 245, 241),
        value = Color3.fromRGB(220, 235, 228),
        accent = Color3.fromRGB(50, 200, 140),
        accent2 = Color3.fromRGB(30, 120, 85),
    },
    Mono = {
        bg = Color3.fromRGB(10, 10, 10),
        panel = Color3.fromRGB(17, 17, 17),
        panel2 = Color3.fromRGB(22, 22, 22),
        stroke = Color3.fromRGB(75, 75, 75),
        strokeSoft = Color3.fromRGB(45, 45, 45),
        label = Color3.fromRGB(185, 185, 185),
        muted = Color3.fromRGB(150, 150, 150),
        text = Color3.fromRGB(240, 240, 240),
        value = Color3.fromRGB(230, 230, 230),
        accent = Color3.fromRGB(200, 200, 200),
        accent2 = Color3.fromRGB(130, 130, 130),
    },
    Light = {
        bg = Color3.fromRGB(240, 240, 240),
        panel = Color3.fromRGB(255, 255, 255),
        panel2 = Color3.fromRGB(250, 250, 250),
        stroke = Color3.fromRGB(200, 200, 200),
        strokeSoft = Color3.fromRGB(220, 220, 220),
        label = Color3.fromRGB(100, 100, 100),
        muted = Color3.fromRGB(140, 140, 140),
        text = Color3.fromRGB(30, 30, 30),
        value = Color3.fromRGB(50, 50, 50),
        accent = Color3.fromRGB(200, 50, 50),
        accent2 = Color3.fromRGB(150, 30, 30),
    },
    Sunset = {
        bg = Color3.fromRGB(20, 10, 15),
        panel = Color3.fromRGB(30, 15, 22),
        panel2 = Color3.fromRGB(35, 18, 26),
        stroke = Color3.fromRGB(90, 60, 80),
        strokeSoft = Color3.fromRGB(50, 30, 45),
        label = Color3.fromRGB(190, 160, 180),
        muted = Color3.fromRGB(150, 120, 140),
        text = Color3.fromRGB(245, 230, 240),
        value = Color3.fromRGB(230, 210, 225),
        accent = Color3.fromRGB(255, 120, 80),
        accent2 = Color3.fromRGB(180, 70, 50),
    },
    Forest = {
        bg = Color3.fromRGB(10, 15, 10),
        panel = Color3.fromRGB(15, 22, 15),
        panel2 = Color3.fromRGB(20, 28, 20),
        stroke = Color3.fromRGB(60, 80, 60),
        strokeSoft = Color3.fromRGB(40, 50, 40),
        label = Color3.fromRGB(160, 190, 160),
        muted = Color3.fromRGB(130, 150, 130),
        text = Color3.fromRGB(230, 245, 230),
        value = Color3.fromRGB(210, 235, 210),
        accent = Color3.fromRGB(100, 200, 50),
        accent2 = Color3.fromRGB(60, 120, 30),
    },
    Neon = {
        bg = Color3.fromRGB(0, 0, 0),
        panel = Color3.fromRGB(10, 10, 10),
        panel2 = Color3.fromRGB(15, 15, 15),
        stroke = Color3.fromRGB(50, 50, 50),
        strokeSoft = Color3.fromRGB(30, 30, 30),
        label = Color3.fromRGB(200, 200, 200),
        muted = Color3.fromRGB(150, 150, 150),
        text = Color3.fromRGB(255, 255, 255),
        value = Color3.fromRGB(220, 220, 220),
        accent = Color3.fromRGB(0, 255, 255),
        accent2 = Color3.fromRGB(0, 180, 180),
    },
    Midnight = {
        bg = Color3.fromRGB(5, 5, 15),
        panel = Color3.fromRGB(10, 10, 25),
        panel2 = Color3.fromRGB(15, 15, 30),
        stroke = Color3.fromRGB(50, 50, 70),
        strokeSoft = Color3.fromRGB(30, 30, 50),
        label = Color3.fromRGB(180, 180, 200),
        muted = Color3.fromRGB(140, 140, 160),
        text = Color3.fromRGB(230, 230, 250),
        value = Color3.fromRGB(210, 210, 230),
        accent = Color3.fromRGB(100, 100, 255),
        accent2 = Color3.fromRGB(70, 70, 180),
    },
}

local THEME = cloneTable(PulseUI.Themes.Default)

local function applyTheme(theme)
    for k, v in pairs(theme) do
        THEME[k] = v
    end
end

local function themeNames()
    local names = {}
    for k in pairs(PulseUI.Themes) do
        table.insert(names, k)
    end
    table.sort(names)
    return names
end

local function create(className, props)
    local inst = Instance.new(className)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

local function addCorner(parent, radius)
    local c = create("UICorner", { CornerRadius = UDim.new(0, radius or 6), Parent = parent })
    return c
end

local function addStroke(parent, thickness, color, transparency)
    local s = create("UIStroke", { ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Thickness = thickness or 1, Color = color or THEME.stroke, Transparency = transparency or 0, Parent = parent })
    return s
end

local function addPadding(parent, pad)
    local p = create("UIPadding", { PaddingTop = UDim.new(0, pad), PaddingBottom = UDim.new(0, pad), PaddingLeft = UDim.new(0, pad), PaddingRight = UDim.new(0, pad), Parent = parent })
    return p
end

local function makeLabel(parent, text, size, color, alignment)
    local lbl = create("TextLabel", { BackgroundTransparency = 1, Text = text or "", Font = Enum.Font.GothamMedium, TextSize = size or 12, TextColor3 = color or THEME.text, TextXAlignment = alignment or Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center, Parent = parent })
    return lbl
end

local function tween(inst, t, props)
    local tw = TweenService:Create(inst, TweenInfo.new(t or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local function safeCall(fn, ...)
    local ok, res = pcall(fn, ...)
    if ok then return true, res end
    return false, res
end

local function encodeValue(v)
    local tv = typeof(v)
    if tv == "Color3" then
        return { __t = "Color3", r = v.R, g = v.G, b = v.B }
    elseif tv == "EnumItem" then
        return { __t = "Enum", enum = v.EnumType.Name, name = v.Name }
    elseif tv == "UDim2" then
        return { __t = "UDim2", x = v.X.Scale, xo = v.X.Offset, y = v.Y.Scale, yo = v.Y.Offset }
    elseif tv == "Vector2" then
        return { __t = "Vector2", x = v.X, y = v.Y }
    elseif type(v) == "table" then
        local out = { __t = "Table" }
        for k, vv in pairs(v) do
            out[tostring(k)] = encodeValue(vv)
        end
        return out
    end
    return v
end

local function decodeValue(v)
    if type(v) ~= "table" or not v.__t then return v end
    if v.__t == "Color3" then
        return Color3.new(v.r or 0, v.g or 0, v.b or 0)
    elseif v.__t == "Enum" then
        local enumType = Enum[v.enum]
        if enumType then return enumType[v.name] end
        return nil
    elseif v.__t == "UDim2" then
        return UDim2.new(v.x or 0, v.xo or 0, v.y or 0, v.yo or 0)
    elseif v.__t == "Vector2" then
        return Vector2.new(v.x or 0, v.y or 0)
    elseif v.__t == "Table" then
        local out = {}
        for k, vv in pairs(v) do
            if k ~= "__t" then out[k] = decodeValue(vv) end
        end
        return out
    end
    return v
end

local TAP_SLOP = 10

local function toV2(pos)
    if typeof(pos) == "Vector2" then return pos end
    if typeof(pos) == "Vector3" then return Vector2.new(pos.X, pos.Y) end
    return Vector2.new(0, 0)
end

local function connectTap(button, onTap)
    local startPos
    local tracking = false
    local inputRef
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            tracking = true
            startPos = toV2(input.Position)
            inputRef = input
        end
    end)
    button.InputEnded:Connect(function(input)
        if not tracking then return end
        if inputRef and input ~= inputRef and input.UserInputType == Enum.UserInputType.Touch then return end
        tracking = false
        local delta = toV2(input.Position) - startPos
        if math.abs(delta.X) <= TAP_SLOP and math.abs(delta.Y) <= TAP_SLOP then
            onTap()
        end
    end)
end

local function cloneTable(t)
    local out = {}
    for k, v in pairs(t or {}) do
        out[k] = v
    end
    return out
end

local function isPhoneViewport(vp)
    return vp.X <= 650
end

local function applyPopupIn(frame)
    local delayTime = 0.06
    frame.Visible = true
    local s = create("UIScale", { Name = "PopupScale", Scale = 1, Parent = frame })
    s.Scale = 0.96
    taskDelay(delayTime, function()
        if s.Parent then
            tween(s, 0.14, { Scale = 1 })
        end
    end)
end

local function clamp01(x)
    return math.clamp(x, 0, 1)
end

local function formatNumber(n)
    if type(n) ~= "number" then return tostring(n) end
    if math.abs(n) >= 100 then return tostring(math.floor(n + 0.5)) end
    local s = string.format("%.2f", n)
    s = s:gsub("0+$", ""):gsub("%.$", "")
    return s
end

local function hsvToColor3(h, s, v)
    return Color3.fromHSV(clamp01(h), clamp01(s), clamp01(v))
end

local function color3ToHsv(c)
    return c:ToHSV()
end

local function makeDraggable(dragHandle, dragTarget)
    local dragging = false
    local dragStart, startPos
    local dragInput
    local function update(input)
        local delta = input.Position - dragStart
        dragTarget.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = dragTarget.Position
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
end

-- Classes
local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Group = {}
Group.__index = Group

local function ensureFolder(path)
    if type(makefolder) == "function" and type(isfolder) == "function" then
        if not isfolder(path) then
            makefolder(path)
        end
    end
end

local function listConfigFiles(path)
    if type(listfiles) ~= "function" then return {} end
    local ok, files = safeCall(listfiles, path)
    if not ok then return {} end
    local out = {}
    for _, f in ipairs(files) do
        local name = tostring(f):match("([^/\\]+)%.json$")
        if name then table.insert(out, name) end
    end
    table.sort(out)
    return out
end

function PulseUI:CreateWindow(opts)
    opts = opts or {}
    local title = opts.Title or "Pulse"
    local footerText = opts.FooterText or "Pulse V2 by Specter"
    local parent = opts.Parent or (type(gethui) == "function" and gethui()) or game:GetService("CoreGui")

    local gui = create("ScreenGui", { Name = "PulseUI_V2", ResetOnSpawn = false, IgnoreGuiInset = true, Parent = parent })

    local root = create("Frame", { Name = "Root", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 820, 0, 430), BackgroundColor3 = THEME.bg, Parent = gui })
    addCorner(root, 4)
    addStroke(root, 1, THEME.stroke, 0)

    local topLine = create("Frame", { Name = "TopLine", BackgroundColor3 = THEME.accent, Size = UDim2.new(1, 0, 0, 2), Parent = root })

    local scale = create("UIScale", { Scale = 1, Parent = root })

    local function updateScale()
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
        local baseX, baseY = 900, 520
        local s = math.min(vp.X / baseX, vp.Y / baseY)
        if isPhoneViewport(vp) then s = math.clamp(s, 0.55, 0.92) else s = math.clamp(s, 0.78, 1.05) end
        scale.Scale = s
    end
    updateScale()
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

    local topBar = create("Frame", { Name = "TopBar", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24), Parent = root })

    local titleLabel = makeLabel(topBar, title, 12, THEME.muted, Enum.TextXAlignment.Left)
    titleLabel.Position = UDim2.new(0, 10, 0, 2)
    titleLabel.Size = UDim2.new(1, -20, 1, -4)
    titleLabel.TextTransparency = 0.6

    local body = create("Frame", { Name = "Body", BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 24), Size = UDim2.new(1, 0, 1, -24), Parent = root })

    local bottomBar = create("Frame", { Name = "BottomBar", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(1, 0, 0, 22), ZIndex = 2, Parent = root })

    local footerLbl = makeLabel(bottomBar, footerText, 11, THEME.muted, Enum.TextXAlignment.Center)
    footerLbl.Position = UDim2.new(0.5, 0, 0, 0)
    footerLbl.AnchorPoint = Vector2.new(0.5, 0)
    footerLbl.Size = UDim2.new(0.7, 0, 1, 0)
    footerLbl.TextTransparency = 0.5
    footerLbl.ZIndex = 3

    local sidebar = create("Frame", { Name = "Sidebar", BackgroundColor3 = THEME.bg, Size = UDim2.new(0, 175, 1, 0), Parent = body })
    addStroke(sidebar, 1, THEME.strokeSoft, 0)

    local sidePad = addPadding(sidebar, 10)
    sidePad.PaddingTop = UDim.new(0, 12)
    sidePad.PaddingBottom = UDim.new(0, 10)

    local playerCard = create("Frame", { Name = "PlayerCard", BackgroundColor3 = THEME.panel, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, -6), Size = UDim2.new(1, 0, 0, 44), Parent = sidebar })
    addCorner(playerCard, 3)
    addPadding(playerCard, 8)
    playerCard.ZIndex = 2

    local avatar = create("ImageLabel", { Name = "Avatar", BackgroundTransparency = 1, Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0, 0, 0.5, -14), Image = "", ZIndex = 3, Parent = playerCard })
    addCorner(avatar, 999)

    local display = makeLabel(playerCard, "Player", 12, THEME.text, Enum.TextXAlignment.Left)
    display.Position = UDim2.new(0, 36, 0, 6)
    display.Size = UDim2.new(1, -36, 0, 14)
    display.ZIndex = 3

    local user = makeLabel(playerCard, "@username", 11, THEME.muted, Enum.TextXAlignment.Left)
    user.Position = UDim2.new(0, 36, 0, 22)
    user.Size = UDim2.new(1, -36, 0, 14)
    user.TextTransparency = 0.3
    user.ZIndex = 3

    local lp = Players.LocalPlayer
    if lp then
        display.Text = lp.DisplayName
        user.Text = "@" .. lp.Name
        local content = Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        avatar.Image = content
    end

    local tabsHolder = create("Frame", { Name = "Tabs", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, -58), Parent = sidebar })

    local sideList = create("UIListLayout", { Padding = UDim.new(0, 8), FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Left, SortOrder = Enum.SortOrder.LayoutOrder, Parent = tabsHolder })

    local content = create("Frame", { Name = "Content", BackgroundTransparency = 1, Position = UDim2.new(0, 175, 0, 0), Size = UDim2.new(1, -175, 1, 0), Parent = body })

    local pages = create("Frame", { Name = "Pages", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = content })
    addPadding(pages, 14)

    local overlay = create("Frame", { Name = "Overlay", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), ZIndex = 50, Parent = gui })

    local openBtn = create("TextButton", { Name = "OpenButton", BackgroundColor3 = THEME.panel, AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 10, 1, -10), Size = UDim2.new(0, 120, 0, 32), AutoButtonColor = false, Text = "Pulse", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = THEME.value, Visible = false, ZIndex = 90, Parent = gui })
    addCorner(openBtn, 6)
    addStroke(openBtn, 1, THEME.stroke, 0.25)

    local circles = create("Frame", { Name = "TopRightButtons", BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 6), Size = UDim2.new(0, 72, 0, 12), ZIndex = 5, Parent = root })

    local function circleButton(order)
        local b = create("TextButton", { BackgroundColor3 = THEME.strokeSoft, Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(1, -(order * 14), 0, 1), AnchorPoint = Vector2.new(1, 0), AutoButtonColor = false, Text = "", ZIndex = 6, Parent = circles })
        addCorner(b, 999)
        return b
    end

    local btnFull = circleButton(3)
    local btnMin = circleButton(2)
    local btnClose = circleButton(1)

    makeDraggable(topBar, root)

    applyPopupIn(root)

    local self = setmetatable({
        Gui = gui,
        Root = root,
        Sidebar = sidebar,
        SidebarList = tabsHolder,
        Pages = pages,
        Overlay = overlay,
        BottomBar = bottomBar,
        FooterLabel = footerLbl,
        PlayerCard = playerCard,
        _Minimized = false,
        _ToggleKey = Enum.KeyCode.RightShift,
        _ThemeName = "Default",
        Flags = {},
        _Registry = {},
        _ConfigMemory = {},
        _Tabs = {},
        _Selected = nil,
        _OpenButton = openBtn,
    }, Window)

    local function setHidden(hidden)
        if not self.Root then return end
        self.Root.Visible = not hidden
        if self._OpenButton then self._OpenButton.Visible = hidden end
        if not hidden then
            self._Minimized = false
            body.Visible = true
            applyPopupIn(self.Root)
        end
    end

    connectTap(openBtn, function()
        setHidden(false)
    end)

    connectTap(btnClose, function()
        self:Destroy()
    end)

    connectTap(btnMin, function()
        self._Minimized = true
        setHidden(true)
    end)

    connectTap(btnFull, function()
        self:SetFullscreen(not self._Fullscreen)
    end)

    UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == self._ToggleKey then
            setHidden(self.Root.Visible)
        end
    end)

    -- Startup loading pulse animation
    self.Root.Visible = false
    local loadBox = create("Frame", { Name = "LoadBox", BackgroundColor3 = THEME.panel, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 280, 0, 170), ZIndex = 95, Parent = gui })
    addCorner(loadBox, 8)
    addStroke(loadBox, 1, THEME.stroke, 0.25)

    local avatarImg = create("ImageLabel", { Name = "LoadAvatar", BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 16), Size = UDim2.new(0, 88, 0, 88), Image = lp and ("rbxthumb://type=AvatarHeadShot&id=" .. lp.UserId .. "&w=180&h=180") or "", ZIndex = 96, Parent = loadBox })
    addCorner(avatarImg, 999)

    local userText = makeLabel(loadBox, lp and ("@" .. lp.Name) or "@Player", 13, THEME.value, Enum.TextXAlignment.Center)
    userText.AnchorPoint = Vector2.new(0.5, 0)
    userText.Position = UDim2.new(0.5, 0, 0, 112)
    userText.Size = UDim2.new(1, -20, 0, 18)
    userText.ZIndex = 96

    local loadText = makeLabel(loadBox, "Loading Pulse...", 12, THEME.muted, Enum.TextXAlignment.Center)
    loadText.AnchorPoint = Vector2.new(0.5, 0)
    loadText.Position = UDim2.new(0.5, 0, 0, 134)
    loadText.Size = UDim2.new(1, -20, 0, 18)
    loadText.ZIndex = 96

    local lbScale = create("UIScale", { Name = "PopupScale", Scale = 1, Parent = loadBox })
    lbScale.Scale = 0.86
    loadBox.Visible = true
    taskSpawn(function()
        for _ = 1, 3 do
            tween(lbScale, 0.14, { Scale = 1.06 })
            taskWait(0.18)
            tween(lbScale, 0.14, { Scale = 0.90 })
            taskWait(0.18)
        end
        taskWait(0.20)
        if loadBox.Parent then loadBox:Destroy() end
        if self.Gui and self.Root then self.Root.Visible = true end
    end)

    -- built-in Settings tab
    local settingsTab = self:CreateTab("settings")
    self.SettingsTab = settingsTab
    settingsTab.Page.Visible = false
    settingsTab.Accent.Visible = false
    settingsTab.Button.BackgroundTransparency = 1
    settingsTab.ButtonText.TextColor3 = THEME.muted
    self._Selected = nil

    local bg = create("ImageLabel", { Name = "SettingsBackground", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Image = "rbxthumb://type=GameIcon&id=" .. game.PlaceId .. "&w=420&h=420", ImageTransparency = 0.92, ScaleType = Enum.ScaleType.Fit, ZIndex = 0, Parent = settingsTab.Page })

    local uiGroup = settingsTab:CreateGroup("UI", "left")
    local cfgGroup = settingsTab:CreateGroup("Config", "right")
    local infoGroup = settingsTab:CreateGroup("Info", "left")

    uiGroup:AddKeybind("Toggle Key", self._ToggleKey, function(kc) self:SetToggleKey(kc) end, "ui.toggleKey")
    uiGroup:AddDropdown("Theme", themeNames(), self._ThemeName, function(name) self:SetTheme(name) end, "ui.theme")

    local cfgName = "default"
    cfgGroup:AddTextBox("Config Name", cfgName, function(txt) cfgName = txt end)

    local cfgList = self:ListConfigs()
    local selectedCfg = cfgList[1] or "default"
    local cfgDropdown = cfgGroup:AddDropdown("Configs", cfgList, selectedCfg, function(v) selectedCfg = v end)

    cfgGroup:AddButton("Save", function()
        local name = (cfgName ~= "" and cfgName) or selectedCfg or "default"
        self:SaveConfig(name)
        cfgDropdown.SetOptions(self:ListConfigs())
    end)

    cfgGroup:AddButton("Load", function()
        self:LoadConfig(selectedCfg)
    end)

    cfgGroup:AddButton("Delete", function()
        self:DeleteConfig(selectedCfg)
        cfgDropdown.SetOptions(self:ListConfigs())
    end)

    local lp2 = Players.LocalPlayer
    infoGroup:AddLabel("User")
    infoGroup:AddLabel(lp2 and (lp2.DisplayName .. " (@" .. lp2.Name .. ")") or "Unknown")
    infoGroup:AddLabel("Game")
    infoGroup:AddLabel("PlaceId: " .. tostring(game.PlaceId))
    infoGroup:AddLabel("JobId: " .. tostring(game.JobId))
    infoGroup:AddButton("Copy Discord", function()
        if type(setclipboard) == "function" then
            setclipboard("discord.gg/example") -- Replace with actual
        end
    end)

    return self
end

function Window:SetToggleKey(keyCode)
    self._ToggleKey = keyCode
end

function Window:SetFullscreen(enabled)
    enabled = enabled and true or false
    self._Fullscreen = enabled
    if not self.Root then return end
    if enabled then
        self._PrevPos = self._PrevPos or self.Root.Position
        self._PrevSize = self._PrevSize or self.Root.Size
        self._PrevAnchor = self._PrevAnchor or self.Root.AnchorPoint
        self.Root.AnchorPoint = Vector2.new(0.5, 0.5)
        self.Root.Position = UDim2.new(0.5, 0, 0.5, 0)
        self.Root.Size = UDim2.new(1, -20, 1, -20)
    else
        if self._PrevAnchor then self.Root.AnchorPoint = self._PrevAnchor end
        if self._PrevPos then self.Root.Position = self._PrevPos end
        if self._PrevSize then self.Root.Size = self._PrevSize end
        self._PrevAnchor, self._PrevPos, self._PrevSize = nil, nil, nil
    end
end

function Window:SetFooterText(text)
    if self.FooterLabel then self.FooterLabel.Text = tostring(text or "") end
end

function Window:Destroy()
    if self.Gui then self.Gui:Destroy() end
end

function Window:SetCopyDiscordHandler(fn)
    self._CopyDiscordHandler = fn
end

function Window:SetFlag(flag, value)
    if type(flag) ~= "string" then return end
    self.Flags[flag] = value
    local reg = self._Registry[flag]
    if reg and reg.Set then reg.Set(value) end
end

function Window:GetFlag(flag)
    return self.Flags[flag]
end

function Window:_registerFlag(flag, api)
    if type(flag) ~= "string" then return end
    self._Registry[flag] = api
    self.Flags[flag] = api.Get and api.Get() or nil
end

function Window:SetTheme(nameOrTheme)
    local theme = type(nameOrTheme) == "string" and PulseUI.Themes[nameOrTheme] or nameOrTheme
    if type(theme) ~= "table" then return end
    self._ThemeName = type(nameOrTheme) == "string" and nameOrTheme or self._ThemeName
    local old = cloneTable(THEME)
    applyTheme(theme)
    local new = cloneTable(THEME)
    local function remapColor(c)
        for k, oldC in pairs(old) do
            if typeof(oldC) == "Color3" and c == oldC then return new[k] or c end
        end
        return c
    end
    if self.Gui then
        for _, inst in ipairs(self.Gui:GetDescendants()) do
            if inst:IsA("Frame") or inst:IsA("TextButton") or inst:IsA("TextBox") or inst:IsA("ImageLabel") or inst:IsA("ImageButton") or inst:IsA("ScrollingFrame") then
                if inst.BackgroundTransparency < 1 then
                    inst.BackgroundColor3 = remapColor(inst.BackgroundColor3)
                end
                if inst:IsA("TextLabel") or inst:IsA("TextButton") or inst:IsA("TextBox") then
                    inst.TextColor3 = remapColor(inst.TextColor3)
                end
                if inst:IsA("ScrollingFrame") then
                    inst.ScrollBarImageColor3 = remapColor(inst.ScrollBarImageColor3)
                end
                if inst:IsA("ImageLabel") or inst:IsA("ImageButton") then
                    inst.ImageColor3 = remapColor(inst.ImageColor3)
                end
            end
            if inst:IsA("UIStroke") then
                inst.Color = remapColor(inst.Color)
            end
        end
    end
end

function Window:_configPath(name)
    name = tostring(name or "")
    if type(isfolder) == "function" then
        return "PulseConfigs/" .. name .. ".json"
    end
    return "PulseConfigs_" .. name .. ".json"
end

function Window:ListConfigs()
    local supportsFolders = type(makefolder) == "function" and type(isfolder) == "function"
    if supportsFolders then
        ensureFolder("PulseConfigs")
        return listConfigFiles("PulseConfigs")
    else
        if type(listfiles) == "function" then
            local _, files = safeCall(listfiles, "")
            local out = {}
            for _, f in ipairs(files or {}) do
                local name = tostring(f):match("PulseConfigs_([^/\\]+)%.json$")
                if name then table.insert(out, name) end
            end
            table.sort(out)
            return out
        end
    end
    return {}
end

function Window:SaveConfig(name)
    name = tostring(name or "")
    if name == "" then return false, "missing name" end
    local supportsFolders = type(makefolder) == "function" and type(isfolder) == "function"
    if supportsFolders then
        ensureFolder("PulseConfigs")
    end
    local flags = {}
    for k, v in pairs(self.Flags or {}) do
        flags[k] = encodeValue(v)
    end
    local data = {
        flags = flags,
        theme = self._ThemeName or "Default",
        toggleKey = self._ToggleKey and self._ToggleKey.Name or "RightShift",
        ui = {
            pos = encodeValue((self._PrevPos) or (self.Root and self.Root.Position) or UDim2.new(0.5, 0, 0.5, 0)),
            size = encodeValue((self._PrevSize) or (self.Root and self.Root.Size) or UDim2.new(0, 820, 0, 430)),
            anchor = encodeValue((self._PrevAnchor) or (self.Root and self.Root.AnchorPoint) or Vector2.new(0.5, 0.5)),
            visible = self.Root and self.Root.Visible or true,
            min = self._Minimized or false,
            full = self._Fullscreen or false,
            selected = self._Selected and self._Selected.Name or "",
        },
    }
    local payload = HttpService:JSONEncode(data)
    if type(writefile) == "function" then
        local ok = safeCall(writefile, self:_configPath(name), payload)
        if ok then return true end
    end
    self._ConfigMemory[name] = payload
    return true
end

function Window:LoadConfig(name)
    name = tostring(name or "")
    if name == "" then return false, "missing name" end
    local payload
    local path = self:_configPath(name)
    if type(readfile) == "function" and type(isfile) == "function" and isfile(path) then
        local _, content = safeCall(readfile, path)
        payload = content
    else
        payload = self._ConfigMemory[name]
    end
    if type(payload) ~= "string" then return false, "not found" end
    local ok, decoded = safeCall(HttpService.JSONDecode, HttpService, payload)
    if not ok or type(decoded) ~= "table" then return false, "bad json" end
    if type(decoded.theme) == "string" then self:SetTheme(decoded.theme) end
    if type(decoded.toggleKey) == "string" then
        local kc = Enum.KeyCode[decoded.toggleKey]
        if kc then self:SetToggleKey(kc) end
    end
    if type(decoded.flags) == "table" then
        for flag, raw in pairs(decoded.flags) do
            local value = decodeValue(raw)
            self.Flags[flag] = value
            local reg = self._Registry[flag]
            if reg and reg.Set then reg.Set(value) end
        end
    end
    if type(decoded.ui) == "table" and self.Root then
        local ui = decoded.ui
        local anchor = decodeValue(ui.anchor)
        if typeof(anchor) == "Vector2" then self.Root.AnchorPoint = anchor end
        local size = decodeValue(ui.size)
        if typeof(size) == "UDim2" then self.Root.Size = size end
        local pos = decodeValue(ui.pos)
        if typeof(pos) == "UDim2" then self.Root.Position = pos end
        if type(ui.visible) == "boolean" then self.Root.Visible = ui.visible end
        if type(ui.min) == "boolean" then
            self._Minimized = ui.min
            if self._Minimized then
                self.Root.Visible = false
                if self._OpenButton then self._OpenButton.Visible = true end
            else
                self.Root.Visible = true
                if self._OpenButton then self._OpenButton.Visible = false end
                local body = self.Root:FindFirstChild("Body")
                if body then body.Visible = true end
            end
        end
        if type(ui.full) == "boolean" then self:SetFullscreen(ui.full) end
        if type(ui.selected) == "string" and ui.selected ~= "" then
            for _, t in ipairs(self._Tabs) do
                if t.Name == ui.selected then self:SelectTab(t) break end
            end
        end
    end
    return true
end

function Window:DeleteConfig(name)
    name = tostring(name or "")
    if name == "" then return false, "missing name" end
    local path = self:_configPath(name)
    if type(delfile) == "function" and type(isfile) == "function" and isfile(path) then
        local ok = safeCall(delfile, path)
        if ok then return true end
    end
    self._ConfigMemory[name] = nil
    return true
end

function Window:SelectTab(tab)
    if self._Selected == tab then return end
    self._Selected = tab
    for _, t in ipairs(self._Tabs) do
        if t == tab then
            t.Page.Visible = true
            t.Accent.Visible = true
            t.Button.BackgroundTransparency = 0
            tween(t.Button, 0.12, { BackgroundColor3 = THEME.panel2 })
            t.ButtonText.TextColor3 = THEME.accent
        else
            t.Page.Visible = false
            t.Accent.Visible = false
            t.Button.BackgroundTransparency = 1
            t.ButtonText.TextColor3 = THEME.muted
        end
    end
end

function Window:CreateTab(name)
    name = name or "Tab"
    local btn = create("TextButton", { Name = "TabButton_" .. name, Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = THEME.panel2, AutoButtonColor = false, Text = "", Parent = self.SidebarList })
    btn.BackgroundTransparency = 1

    local accentBar = create("Frame", { Name = "Accent", BackgroundColor3 = THEME.accent, Size = UDim2.new(0, 2, 1, 0), Visible = false, Parent = btn })
    addCorner(accentBar, 2)

    local text = makeLabel(btn, name, 12, THEME.muted, Enum.TextXAlignment.Left)
    text.Name = "Label"
    text.Position = UDim2.new(0, 10, 0, 0)
    text.Size = UDim2.new(1, -20, 1, 0)

    local page = create("Frame", { Name = "Page_" .. name, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false, Parent = self.Pages })

    local columns = create("Frame", { Name = "Columns", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Parent = page })

    local leftCol = create("Frame", { Name = "Left", BackgroundTransparency = 1, Size = UDim2.new(0.5, -6, 1, 0), Parent = columns })

    local rightCol = create("Frame", { Name = "Right", BackgroundTransparency = 1, Position = UDim2.new(0.5, 6, 0, 0), Size = UDim2.new(0.5, -6, 1, 0), Parent = columns })

    for _, col in ipairs({ leftCol, rightCol }) do
        local scroll = create("ScrollingFrame", { Name = "Scroll", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = THEME.accent2, Parent = col })
        addPadding(scroll, 0)
        local list = create("UIListLayout", { Padding = UDim.new(0, 10), FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Parent = scroll })
    end

    local tab = setmetatable({
        Window = self,
        Name = name,
        Button = btn,
        ButtonText = text,
        Accent = accentBar,
        Page = page,
        Left = leftCol.Scroll,
        Right = rightCol.Scroll,
    }, Tab)

    connectTap(btn, function()
        self:SelectTab(tab)
    end)

    table.insert(self._Tabs, tab)
    if not self._Selected then
        self:SelectTab(tab)
    end
    return tab
end

function Window:GetSettingsTab()
    return self.SettingsTab
end

function Tab:CreateGroup(title, side)
    title = title or "Group"
    side = (side or "left"):lower()
    local parent = (side == "right") and self.Right or self.Left
    local group = create("Frame", { Name = "Group_" .. title, BackgroundColor3 = THEME.panel, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = parent })
    addCorner(group, 3)
    addStroke(group, 1, THEME.strokeSoft, 0)

    local headerText = makeLabel(group, title, 12, THEME.text, Enum.TextXAlignment.Left)
    headerText.Position = UDim2.new(0, 10, 0, 8)
    headerText.Size = UDim2.new(1, -20, 0, 16)

    local sep = create("Frame", { Name = "Separator", BackgroundColor3 = THEME.strokeSoft, Position = UDim2.new(0, 8, 0, 28), Size = UDim2.new(1, -16, 0, 1), Parent = group })

    local body = create("Frame", { Name = "Body", BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 32), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = group })

    local pad = addPadding(body, 10)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 10)

    local list = create("UIListLayout", { Padding = UDim.new(0, 10), FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Parent = body })

    local g = setmetatable({
        Tab = self,
        Frame = group,
        Body = body,
    }, Group)
    return g
end

function Tab:CreateSection(title, side)
    return self:CreateGroup(title, side)
end

local function makeRow(parent)
    local row = create("Frame", { BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), Parent = parent })
    return row
end

local function normalizeCallbackAndFlag(callback, flag)
    if type(callback) == "string" and flag == nil then
        return nil, callback
    end
    return callback, flag
end

local function makeField(parent)
    local field = create("Frame", { BackgroundColor3 = THEME.panel2, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 170, 0, 26), Parent = parent })
    addCorner(field, 6)
    addStroke(field, 1, THEME.stroke, 0.25)
    return field
end

function Group:AddToggle(label, default, callback, flag)
    callback, flag = normalizeCallbackAndFlag(callback, flag)
    local row = makeRow(self.Body)
    local lbl = makeLabel(row, label or "Toggle", 12, THEME.label, Enum.TextXAlignment.Left)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.Size = UDim2.new(1, -190, 1, 0)

    local box = create("TextButton", { BackgroundColor3 = THEME.bg, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 18, 0, 18), AutoButtonColor = false, Text = "", Parent = row })
    addCorner(box, 3)
    addStroke(box, 1, THEME.strokeSoft, 0)

    local mark = create("Frame", { BackgroundColor3 = THEME.accent, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 12, 0, 12), Visible = false, Parent = box })
    addCorner(mark, 3)

    local state = default and true or false

    local function render()
        mark.Visible = state
        box.BackgroundColor3 = THEME.bg
    end
    render()

    connectTap(box, function()
        state = not state
        render()
        if callback then taskSpawn(callback, state) end
    end)

    local api = {
        Get = function() return state end,
        Set = function(v)
            state = v and true or false
            render()
            if callback then taskSpawn(callback, state) end
        end,
    }

    local window = self.Tab and self.Tab.Window
    if window and flag then
        window:_registerFlag(flag, api)
    end
    return api
end

function Group:AddCheckbox(label, default, callback, flag)
    callback, flag = normalizeCallbackAndFlag(callback, flag)
    local row = makeRow(self.Body)
    local lbl = makeLabel(row, label or "Checkbox", 12, THEME.label, Enum.TextXAlignment.Left)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.Size = UDim2.new(1, -190, 1, 0)

    local box = create("TextButton", { BackgroundColor3 = THEME.bg, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 16, 0, 16), AutoButtonColor = false, Text = "", Parent = row })
    addCorner(box, 2)
    addStroke(box, 1, THEME.strokeSoft, 0)

    local mark = create("Frame", { BackgroundColor3 = THEME.accent, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 10, 0, 10), Visible = false, Parent = box })
    addCorner(mark, 2)

    local state = default and true or false

    local function render()
        mark.Visible = state
        box.BackgroundColor3 = THEME.bg
    end
    render()

    connectTap(box, function()
        state = not state
        render()
        if callback then taskSpawn(callback, state) end
    end)

    local api = {
        Get = function() return state end,
        Set = function(v)
            state = v and true or false
            render()
            if callback then taskSpawn(callback, state) end
        end,
    }

    local window = self.Tab and self.Tab.Window
    if window and flag then
        window:_registerFlag(flag, api)
    end
    return api
end

function Group:AddDropdown(label, options, default, callback, flag)
    callback, flag = normalizeCallbackAndFlag(callback, flag)
    options = options or {}
    local row = makeRow(self.Body)
    local lbl = makeLabel(row, label or "Dropdown", 12, THEME.label, Enum.TextXAlignment.Left)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.Size = UDim2.new(1, -190, 1, 0)

    local fieldBtn = create("TextButton", { BackgroundColor3 = THEME.bg, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 170, 0, 26), AutoButtonColor = false, Text = "", Parent = row })
    addCorner(fieldBtn, 6)
    addStroke(fieldBtn, 1, THEME.stroke, 0.25)

    local valueLabel = makeLabel(fieldBtn, "", 12, THEME.value, Enum.TextXAlignment.Left)
    valueLabel.Position = UDim2.new(0, 8, 0, 0)
    valueLabel.Size = UDim2.new(1, -22, 1, 0)

    local arrow = makeLabel(fieldBtn, "▼", 10, THEME.muted, Enum.TextXAlignment.Right)
    arrow.Position = UDim2.new(1, -6, 0, 0)
    arrow.AnchorPoint = Vector2.new(1, 0)
    arrow.Size = UDim2.new(0, 16, 1, 0)

    local selected = default or options[1] or "None"
    valueLabel.Text = tostring(selected)

    local open = false
    local popup, blocker
    local scrollConn

    local function close()
        open = false
        if scrollConn then scrollConn:Disconnect() scrollConn = nil end
        if popup then popup:Destroy() popup = nil end
        if blocker then blocker:Destroy() blocker = nil end
    end

    local function rebuild()
        if not popup then return end
        for _, c in ipairs(popup:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        for _, opt in ipairs(options) do
            local optBtn = create("TextButton", { BackgroundColor3 = THEME.panel2, Size = UDim2.new(1, -4, 0, 22), AutoButtonColor = false, Text = "", ZIndex = 61, Parent = popup })
            addCorner(optBtn, 2)

            local optLbl = makeLabel(optBtn, tostring(opt), 12, THEME.value, Enum.TextXAlignment.Left)
            optLbl.Position = UDim2.new(0, 8, 0, 0)
            optLbl.Size = UDim2.new(1, -16, 1, 0)
            optLbl.ZIndex = 62

            connectTap(optBtn, function()
                selected = opt
                valueLabel.Text = tostring(opt)
                close()
                if callback then taskSpawn(callback, selected) end
            end)
        end
    end

    local function openOverlay()
        local window = self.Tab and self.Tab.Window
        if not window or not window.Overlay then return end
        for _, child in ipairs(window.Overlay:GetChildren()) do
            if child.Name == "DropdownPopup" or child.Name = "DropdownBlocker" then child:Destroy() end
        end
        blocker = create("TextButton", { Name = "DropdownBlocker", BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Size = UDim2.new(1, 0, 1, 0), ZIndex = 58, Parent = window.Overlay })
        connectTap(blocker, close)

        popup = create("ScrollingFrame", { Name = "DropdownPopup", BackgroundColor3 = THEME.bg, Size = UDim2.new(0, fieldBtn.AbsoluteSize.X, 0, 0), ClipsDescendants = true, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, ScrollBarThickness = 3, ScrollBarImageColor3 = THEME.accent2, ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 60, Parent = window.Overlay })
        addCorner(popup, 2)
        addStroke(popup, 1, THEME.strokeSoft, 0)
        addPadding(popup, 6)

        local list = create("UIListLayout", { Padding = UDim.new(0, 6), FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Parent = popup })

        rebuild()

        local abs = fieldBtn.AbsolutePosition
        local size = fieldBtn.AbsoluteSize
        local popupX = abs.X
        local popupY = abs.Y + size.Y + 4
        popup.Position = UDim2.fromOffset(popupX, popupY)

        local desired = (#options * 28) + 12
        local maxHeight = 180
        local overlaySize = window.Overlay.AbsoluteSize
        local availableBelow = math.max(24, overlaySize.Y - popupY - 10)
        local height = math.min(maxHeight, math.min(desired, availableBelow))
        popup.Size = UDim2.new(0, size.X, 0, height)

        applyPopupIn(popup)

        local scroll = fieldBtn:FindFirstAncestorWhichIsA("ScrollingFrame")
        if scroll then
            scrollConn = scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(close)
        end
    end

    connectTap(fieldBtn, function()
        open = not open
        if open then
            openOverlay()
        else
            close()
        end
    end)

    local api = {
        Get = function() return selected end,
        Set = function(v)
            selected = v
            valueLabel.Text = tostring(v)
            if callback then taskSpawn(callback, selected) end
        end,
        SetOptions = function(newOptions)
            options = newOptions or {}
            close()
        end,
        Close = close,
    }

    local window = self.Tab and self.Tab.Window
    if window and flag then
        window:_registerFlag(flag, api)
    end
    return api
end

function Group:AddSlider(label, min, max, default, callback, flag)
    callback, flag = normalizeCallbackAndFlag(callback, flag)
    min = tonumber(min) or 0
    max = tonumber(max) or 100
    local value = tonumber(default) or min
    value = math.clamp(value, min, max)

    local row = makeRow(self.Body)
    row.Size = UDim2.new(1, 0, 0, 36)

    local lbl = makeLabel(row, label or "Slider", 12, THEME.label, Enum.TextXAlignment.Left)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.Size = UDim2.new(1, -190, 0, 16)

    local valLbl = makeLabel(row, "", 12, THEME.value, Enum.TextXAlignment.Right)
    valLbl.Position = UDim2.new(1, 0, 0, 0)
    valLbl.AnchorPoint = Vector2.new(1, 0)
    valLbl.Size = UDim2.new(0, 170, 0, 16)

    local track = create("Frame", { BackgroundColor3 = THEME.strokeSoft, Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 0, 6), Parent = row })
    addCorner(track, 2)

    local fill = create("Frame", { BackgroundColor3 = THEME.accent, Size = UDim2.new(0, 0, 1, 0), Parent = track })
    addCorner(fill, 2)

    local handle = create("Frame", { BackgroundColor3 = THEME.text, AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.new(0, 10, 0, 10), Position = UDim2.new(0, 0, 0.5, 0), Parent = track })
    handle.BackgroundTransparency = 0.25
    addCorner(handle, 999)

    local function setValue(v, fire)
        value = math.clamp(v, min, max)
        local alpha = (value - min) / (max - min)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        handle.Position = UDim2.new(alpha, 0, 0.5, 0)
        valLbl.Text = formatNumber(value) .. "/" .. formatNumber(max)
        if fire and callback then taskSpawn(callback, value) end
    end
    setValue(value, false)

    local dragging = false
    local dragInput
    local function updateFromInput(input)
        local x = input.Position.X
        local absPos = track.AbsolutePosition.X
        local absSize = track.AbsoluteSize.X
        local alpha = (x - absPos) / absSize
        alpha = clamp01(alpha)
        local v = min + (max - min) * alpha
        setValue(v, true)
    end

    track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            updateFromInput(input)
        end
    end)

    track.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end)

    local api = {
        Get = function() return value end,
        Set = function(v) setValue(tonumber(v) or min, true) end,
    }

    local window = self.Tab and self.Tab.Window
    if window and flag then
        window:_registerFlag(flag, api)
    end
    return api
end

function Group:AddColorPicker(label, defaultColor, callback, flag)
    callback, flag = normalizeCallbackAndFlag(callback, flag)
    local row = makeRow(self.Body)
    local lbl = makeLabel(row, label or "Color", 12, THEME.label, Enum.TextXAlignment.Left)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.Size = UDim2.new(1, -190, 1, 0)

    local color = defaultColor or THEME.accent

    local fieldBtn = create("TextButton", { BackgroundColor3 = THEME.bg, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 42, 0, 16), AutoButtonColor = false, Text = "", Parent = row })
    addCorner(fieldBtn, 2)
    addStroke(fieldBtn, 1, THEME.strokeSoft, 0)

    local preview = create("Frame", { BackgroundColor3 = color, Position = UDim2.new(0, 2, 0, 2), Size = UDim2.new(1, -4, 1, -4), Parent = fieldBtn })
    addCorner(preview, 2)

    local function setColor(c, fire)
        color = c
        preview.BackgroundColor3 = color
        if fire and callback then taskSpawn(callback, color) end
    end

    local openPopup
    local closePopup
    local scrollConn

    function openPopup()
        local window = self.Tab and self.Tab.Window
        if not window or not window.Overlay then return end
        local existingPopup = window.Overlay:FindFirstChild("ColorPickerPopup")
        if existingPopup then existingPopup:Destroy() end
        local existingBlocker = window.Overlay:FindFirstChild("Blocker")
        if existingBlocker then existingBlocker:Destroy() end

        local popup = create("Frame", { Name = "ColorPickerPopup", BackgroundColor3 = THEME.panel, Size = UDim2.new(0, 250, 0, 170), ZIndex = 60, Parent = window.Overlay })
        addCorner(popup, 3)
        addStroke(popup, 1, THEME.strokeSoft, 0)

        local abs = fieldBtn.AbsolutePosition
        local size = fieldBtn.AbsoluteSize
        popup.Position = UDim2.fromOffset(abs.X + size.X - 250, abs.Y + size.Y + 6)

        local title = makeLabel(popup, label or "Color", 12, THEME.text, Enum.TextXAlignment.Left)
        title.Position = UDim2.new(0, 10, 0, 8)
        title.Size = UDim2.new(1, -20, 0, 14)
        title.ZIndex = 61

        local sep = create("Frame", { BackgroundColor3 = THEME.strokeSoft, Position = UDim2.new(0, 8, 0, 28), Size = UDim2.new(1, -16, 0, 1), ZIndex = 61, Parent = popup })

        local h, s, v = color3ToHsv(color)

        local sv = create("ImageButton", { Name = "SV", AutoButtonColor = false, BackgroundColor3 = hsvToColor3(h, 1, 1), Position = UDim2.new(0, 10, 0, 38), Size = UDim2.new(0, 150, 0, 110), ZIndex = 61, Parent = popup })
        addCorner(sv, 2)
        addStroke(sv, 1, THEME.strokeSoft, 0)

        local gradWhite = create("Frame", { BackgroundColor3 = Color3.new(1, 1, 1), Size = UDim2.new(1, 0, 1, 0), ZIndex = 62, Parent = sv })
        addCorner(gradWhite, 2)
        create("UIGradient", { Transparency = NumberSequence.new(0, 1), Rotation = 0, Parent = gradWhite })

        local gradBlack = create("Frame", { BackgroundColor3 = Color3.new(0, 0, 0), Size = UDim2.new(1, 0, 1, 0), ZIndex = 63, Parent = sv })
        addCorner(gradBlack, 2)
        create("UIGradient", { Transparency = NumberSequence.new(1, 0), Rotation = 90, Parent = gradBlack })

        local svKnob = create("Frame", { BackgroundColor3 = THEME.text, Size = UDim2.new(0, 10, 0, 10), AnchorPoint = Vector2.new(0.5, 0.5), ZIndex = 64, Parent = sv })
        addCorner(svKnob, 999)
        addStroke(svKnob, 2, THEME.bg, 0)

        local hue = create("ImageButton", { Name = "Hue", AutoButtonColor = false, BackgroundColor3 = THEME.bg, Position = UDim2.new(0, 168, 0, 38), Size = UDim2.new(0, 12, 0, 110), ZIndex = 61, Parent = popup })
        addCorner(hue, 2)
        addStroke(hue, 1, THEME.strokeSoft, 0)
        create("UIGradient", { Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
        }), Rotation = 90, Parent = hue })

        local hueKnob = create("Frame", { BackgroundColor3 = THEME.text, Size = UDim2.new(1, 4, 0, 2), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0, 0), ZIndex = 64, Parent = hue })
        addCorner(hueKnob, 999)

        local outPreview = create("Frame", { BackgroundColor3 = color, Position = UDim2.new(0, 190, 0, 38), Size = UDim2.new(0, 50, 0, 24), ZIndex = 61, Parent = popup })
        addCorner(outPreview, 2)
        addStroke(outPreview, 1, THEME.strokeSoft, 0)

        local rgbLbl = makeLabel(popup, "", 11, THEME.muted, Enum.TextXAlignment.Left)
        rgbLbl.Position = UDim2.new(0, 190, 0, 66)
        rgbLbl.Size = UDim2.new(0, 60, 0, 14)
        rgbLbl.ZIndex = 61
        rgbLbl.TextTransparency = 0.25

        local closeBtn = create("TextButton", { BackgroundColor3 = THEME.bg, Position = UDim2.new(0, 190, 0, 128), Size = UDim2.new(0, 50, 0, 20), AutoButtonColor = false, Text = "OK", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = THEME.value, ZIndex = 61, Parent = popup })
        addCorner(closeBtn, 2)
        addStroke(closeBtn, 1, THEME.strokeSoft, 0)

        local function updateUI(fire)
            sv.BackgroundColor3 = hsvToColor3(h, 1, 1)
            local c = hsvToColor3(h, s, v)
            outPreview.BackgroundColor3 = c
            rgbLbl.Text = string.format("%d,%d,%d", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
            svKnob.Position = UDim2.new(s, 0, 1 - v, 0)
            hueKnob.Position = UDim2.new(0.5, 0, 1 - h, 0)
            setColor(c, fire)
        end
        updateUI(false)

        local draggingSV = false
        local draggingHue = false
        local dragInput

        local function setSVFromPos(pos)
            pos = toV2(pos)
            local rel = pos - sv.AbsolutePosition
            local sx = clamp01(rel.X / sv.AbsoluteSize.X)
            local vy = clamp01(rel.Y / sv.AbsoluteSize.Y)
            s = sx
            v = 1 - vy
            updateUI(true)
        end

        local function setHFromPos(pos)
            pos = toV2(pos)
            local rel = pos - hue.AbsolutePosition
            local hy = clamp01(rel.Y / hue.AbsoluteSize.Y)
            h = 1 - hy
            updateUI(true)
        end

        sv.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingSV = true
                dragInput = input
                setSVFromPos(input.Position)
            end
        end)

        sv.InputEnded:Connect(function(input)
            if input == dragInput then draggingSV = false end
        end)

        hue.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                draggingHue = true
                dragInput = input
                setHFromPos(input.Position)
            end
        end)

        hue.InputEnded:Connect(function(input)
            if input == dragInput then draggingHue = false end
        end)

        UIS.InputChanged:Connect(function(input)
            if (draggingSV or draggingHue) and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                if draggingSV then setSVFromPos(input.Position) elseif draggingHue then setHFromPos(input.Position) end
            end
        end)

        local blocker = create("TextButton", { Name = "Blocker", BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Size = UDim2.new(1, 0, 1, 0), ZIndex = 59, Parent = window.Overlay })
        connectTap(blocker, function()
            popup:Destroy()
            blocker:Destroy()
        end)

        connectTap(closeBtn, function()
            popup:Destroy()
            blocker:Destroy()
        end)

        applyPopupIn(popup)

        local scroll = fieldBtn:FindFirstAncestorWhichIsA("ScrollingFrame")
        if scroll then
            scrollConn = scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
                if popup.Parent then popup:Destroy() end
            end)
        end
    end

    connectTap(fieldBtn, openPopup)

    local api = {
        Get = function() return color end,
        Set = function(c) setColor(c, true) end,
    }

    local window = self.Tab and self.Tab.Window
    if window and flag then
        window:_registerFlag(flag, api)
    end
    return api
end

function Group:AddLabel(text)
    local row = makeRow(self.Body)
    row.Size = UDim2.new(1, 0, 0, 18)

    local lbl = makeLabel(row, tostring(text or ""), 12, THEME.muted, Enum.TextXAlignment.Left)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.Size = UDim2.new(1, 0, 1, 0)

    return {
        Set = function(v)
            lbl.Text = tostring(v or "")
        end,
    }
end

function Group:AddButton(text, callback)
    local row = makeRow(self.Body)
    row.Size = UDim2.new(1, 0, 0, 22)

    local btn = create("TextButton", { BackgroundColor3 = THEME.bg, Size = UDim2.new(1, 0, 1, 0), AutoButtonColor = false, Text = tostring(text or "Button"), Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = THEME.value, Parent = row })
    addCorner(btn, 2)
    addStroke(btn, 1, THEME.strokeSoft, 0)

    connectTap(btn, function()
        if callback then taskSpawn(callback) end
    end)

    btn.MouseEnter:Connect(function()
        tween(btn, 0.1, { BackgroundColor3 = THEME.accent2 })
    end)

    btn.MouseLeave:Connect(function()
        tween(btn, 0.1, { BackgroundColor3 = THEME.bg })
    end)

    return {
        SetText = function(t)
            btn.Text = tostring(t or "")
        end,
    }
end

function Group:AddTextBox(label, defaultText, callback, flag)
    callback, flag = normalizeCallbackAndFlag(callback, flag)
    local row = makeRow(self.Body)
    row.Size = UDim2.new(1, 0, 0, 22)

    local lbl = makeLabel(row, label or "Text", 12, THEME.label, Enum.TextXAlignment.Left)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.Size = UDim2.new(1, -190, 1, 0)

    local box = create("TextBox", { BackgroundColor3 = THEME.bg, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 170, 0, 26), ClearTextOnFocus = false, Text = tostring(defaultText or ""), Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = THEME.value, TextXAlignment = Enum.TextXAlignment.Left, Parent = row })
    addCorner(box, 6)
    addStroke(box, 1, THEME.stroke, 0.25)
    addPadding(box, 6)

    local function fire()
        if callback then taskSpawn(callback, box.Text) end
    end

    box.FocusLost:Connect(fire)

    local api = {
        Get = function() return box.Text end,
        Set = function(v)
            box.Text = tostring(v or "")
            fire()
        end,
    }

    local window = self.Tab and self.Tab.Window
    if window and flag then
        window:_registerFlag(flag, api)
    end
    return api
end

function Group:AddKeybind(label, defaultKeyCode, callback, flag)
    callback, flag = normalizeCallbackAndFlag(callback, flag)
    local row = makeRow(self.Body)
    row.Size = UDim2.new(1, 0, 0, 22)

    local lbl = makeLabel(row, label or "Keybind", 12, THEME.label, Enum.TextXAlignment.Left)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.Size = UDim2.new(1, -190, 1, 0)

    local key = defaultKeyCode or Enum.KeyCode.RightShift

    local btn = create("TextButton", { BackgroundColor3 = THEME.bg, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.new(0, 170, 0, 26), AutoButtonColor = false, Text = key.Name, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = THEME.value, Parent = row })
    addCorner(btn, 6)
    addStroke(btn, 1, THEME.stroke, 0.25)

    local capturing = false

    connectTap(btn, function()
        capturing = true
        btn.Text = "Press a key..."
    end)

    local conn = UIS.InputBegan:Connect(function(input, gp)
        if not capturing or gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            capturing = false
            key = input.KeyCode
            btn.Text = key.Name
            if callback then taskSpawn(callback, key) end
        end
    end)

    local api = {
        Get = function() return key end,
        Set = function(v)
            if typeof(v) == "EnumItem" and v.EnumType == Enum.KeyCode then
                key = v
                btn.Text = key.Name
                if callback then taskSpawn(callback, key) end
            end
        end,
    }

    local window = self.Tab and self.Tab.Window
    if window and flag then
        window:_registerFlag(flag, api)
    end
    return api
end

function PulseUI.LoadLibrary(RAW_URL)
    RAW_URL = tostring(RAW_URL or "")
    if RAW_URL ~= "" and type(loadstring) == "function" and type(game.HttpGet) == "function" then
        local ok, src = pcall(game.HttpGet, game, RAW_URL)
        if ok then
            local ok, lib = pcall(loadstring, src)
            if ok then return lib() end
        end
    end
    if type(loadfile) == "function" then
        local ok, lib = pcall(loadfile, "ui.lua")
        if ok then return lib() end
    end
    error("Could not load PulseUI.")
end

return PulseUI
