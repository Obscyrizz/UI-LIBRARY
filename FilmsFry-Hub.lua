--[[
    ███████╗██╗██╗     ███╗   ███╗███████╗███████╗██████╗ ██╗   ██╗      ██╗  ██╗██╗   ██╗██████╗
    ██╔════╝██║██║     ████╗ ████║██╔════╝██╔════╝██╔══██╗╚██╗ ██╔╝      ██║  ██║██║   ██║██╔══██╗
    █████╗  ██║██║     ██╔████╔██║███████╗█████╗  ██████╔╝ ╚████╔╝ █████╗███████║██║   ██║██████╔╝
    ██╔══╝  ██║██║     ██║╚██╔╝██║╚════██║██╔══╝  ██╔══██╗  ╚██╔╝  ╚════╝██╔══██║██║   ██║██╔══██╗
    ██║     ██║███████╗██║ ╚═╝ ██║███████║██║     ██║  ██║   ██║         ██║  ██║╚██████╔╝██████╔╝
    ╚═╝     ╚═╝╚══════╝╚═╝     ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝   ╚═╝         ╚═╝  ╚═╝ ╚═════╝ ╚═════╝

    FilmsFry-Hub UI Library v1.0.0
    Premium Futuristic Hub Interface for Roblox
    Designed for PC & Mobile | Blue-Purple Neon Theme
    
    Usage:
        local Hub = loadstring(game:HttpGet("YOUR_RAW_URL"))()
        local Window = Hub:CreateWindow({ Title = "My Script", Theme = "Default" })
        local Section = Window:CreateSection("Combat")
        Section:AddToggle({ Name = "God Mode", Default = false, Callback = function(v) end })
--]]

-- ============================================================
--  SERVICES & CORE
-- ============================================================
local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local CoreGui         = game:GetService("CoreGui")
local HttpService     = game:GetService("HttpService")
local TextService     = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()
local Camera      = workspace.CurrentCamera

-- ============================================================
--  UTILITY HELPERS
-- ============================================================
local function Tween(obj, props, t, style, dir)
    local info = TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

local function Create(class, props, children)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            pcall(function() obj[k] = v end)
        end
    end
    for _, child in pairs(children or {}) do
        child.Parent = obj
    end
    if props and props.Parent then
        obj.Parent = props.Parent
    end
    return obj
end

local function MakeGradient(parent, rotation, colors)
    local grad = Create("UIGradient", {
        Rotation = rotation or 90,
        Color = ColorSequence.new(colors),
        Parent = parent
    })
    return grad
end

local function MakeStroke(parent, color, thickness, transparency)
    return Create("UIStroke", {
        Color = color or Color3.fromRGB(100, 100, 180),
        Thickness = thickness or 1.5,
        Transparency = transparency or 0.4,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function MakeShadow(parent, size, color, transparency)
    local shadow = Create("ImageLabel", {
        Name = "_Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 4),
        Size = UDim2.new(1, size or 20, 1, size or 20),
        ZIndex = parent.ZIndex - 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = color or Color3.fromRGB(0, 0, 0),
        ImageTransparency = transparency or 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Parent = parent
    })
    return shadow
end

local function GetTextSize(text, fontSize, font, frameSize)
    return TextService:GetTextSize(text, fontSize, font, frameSize)
end

local function Round(frame, radius)
    return Create("UICorner", { CornerRadius = UDim.new(0, radius or 8), Parent = frame })
end

local function Pad(frame, top, bottom, left, right)
    return Create("UIPadding", {
        PaddingTop    = UDim.new(0, top or 6),
        PaddingBottom = UDim.new(0, bottom or 6),
        PaddingLeft   = UDim.new(0, left or 8),
        PaddingRight  = UDim.new(0, right or 8),
        Parent        = frame
    })
end

local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- ============================================================
--  THEME SYSTEM
-- ============================================================
local Themes = {
    Default = {
        Background      = Color3.fromRGB(12, 12, 20),
        TitleBar        = Color3.fromRGB(18, 18, 32),
        Section         = Color3.fromRGB(20, 20, 36),
        SectionHeader   = Color3.fromRGB(26, 26, 46),
        Element         = Color3.fromRGB(24, 24, 42),
        ElementHover    = Color3.fromRGB(32, 32, 56),
        ElementActive   = Color3.fromRGB(40, 40, 68),
        Accent          = Color3.fromRGB(88, 101, 242),
        AccentSecondary = Color3.fromRGB(155, 89, 255),
        AccentGlow      = Color3.fromRGB(88, 101, 242),
        Text            = Color3.fromRGB(240, 240, 255),
        TextDim         = Color3.fromRGB(160, 160, 200),
        TextMuted       = Color3.fromRGB(100, 100, 140),
        Success         = Color3.fromRGB(46, 213, 115),
        Warning         = Color3.fromRGB(255, 171, 0),
        Error           = Color3.fromRGB(255, 71, 87),
        Info            = Color3.fromRGB(88, 177, 255),
        Stroke          = Color3.fromRGB(70, 70, 120),
        StrokeAccent    = Color3.fromRGB(88, 101, 242),
        Toggle_Off      = Color3.fromRGB(50, 50, 80),
        Toggle_On       = Color3.fromRGB(88, 101, 242),
        Slider_Track    = Color3.fromRGB(35, 35, 60),
        Slider_Fill     = Color3.fromRGB(88, 101, 242),
        Slider_Thumb    = Color3.fromRGB(200, 200, 255),
        Dropdown_Arrow  = Color3.fromRGB(160, 160, 210),
        Scrollbar       = Color3.fromRGB(60, 60, 100),
        Notification_BG = Color3.fromRGB(18, 18, 32),
    },
    Crimson = {
        Background      = Color3.fromRGB(14, 10, 10),
        TitleBar        = Color3.fromRGB(24, 14, 14),
        Section         = Color3.fromRGB(26, 16, 16),
        SectionHeader   = Color3.fromRGB(36, 20, 20),
        Element         = Color3.fromRGB(30, 18, 18),
        ElementHover    = Color3.fromRGB(42, 24, 24),
        ElementActive   = Color3.fromRGB(56, 32, 32),
        Accent          = Color3.fromRGB(220, 50, 70),
        AccentSecondary = Color3.fromRGB(255, 100, 60),
        AccentGlow      = Color3.fromRGB(220, 50, 70),
        Text            = Color3.fromRGB(255, 235, 235),
        TextDim         = Color3.fromRGB(200, 160, 160),
        TextMuted       = Color3.fromRGB(140, 100, 100),
        Success         = Color3.fromRGB(46, 213, 115),
        Warning         = Color3.fromRGB(255, 171, 0),
        Error           = Color3.fromRGB(255, 71, 87),
        Info            = Color3.fromRGB(88, 177, 255),
        Stroke          = Color3.fromRGB(120, 60, 60),
        StrokeAccent    = Color3.fromRGB(220, 50, 70),
        Toggle_Off      = Color3.fromRGB(70, 40, 40),
        Toggle_On       = Color3.fromRGB(220, 50, 70),
        Slider_Track    = Color3.fromRGB(50, 28, 28),
        Slider_Fill     = Color3.fromRGB(220, 50, 70),
        Slider_Thumb    = Color3.fromRGB(255, 200, 200),
        Dropdown_Arrow  = Color3.fromRGB(200, 150, 150),
        Scrollbar       = Color3.fromRGB(100, 55, 55),
        Notification_BG = Color3.fromRGB(24, 14, 14),
    },
    Emerald = {
        Background      = Color3.fromRGB(8, 14, 12),
        TitleBar        = Color3.fromRGB(14, 24, 20),
        Section         = Color3.fromRGB(16, 26, 22),
        SectionHeader   = Color3.fromRGB(20, 36, 30),
        Element         = Color3.fromRGB(18, 30, 26),
        ElementHover    = Color3.fromRGB(24, 42, 36),
        ElementActive   = Color3.fromRGB(32, 56, 46),
        Accent          = Color3.fromRGB(46, 213, 115),
        AccentSecondary = Color3.fromRGB(0, 200, 180),
        AccentGlow      = Color3.fromRGB(46, 213, 115),
        Text            = Color3.fromRGB(230, 255, 245),
        TextDim         = Color3.fromRGB(160, 210, 185),
        TextMuted       = Color3.fromRGB(100, 150, 130),
        Success         = Color3.fromRGB(46, 213, 115),
        Warning         = Color3.fromRGB(255, 171, 0),
        Error           = Color3.fromRGB(255, 71, 87),
        Info            = Color3.fromRGB(88, 177, 255),
        Stroke          = Color3.fromRGB(50, 110, 85),
        StrokeAccent    = Color3.fromRGB(46, 213, 115),
        Toggle_Off      = Color3.fromRGB(30, 60, 50),
        Toggle_On       = Color3.fromRGB(46, 213, 115),
        Slider_Track    = Color3.fromRGB(22, 50, 40),
        Slider_Fill     = Color3.fromRGB(46, 213, 115),
        Slider_Thumb    = Color3.fromRGB(200, 255, 230),
        Dropdown_Arrow  = Color3.fromRGB(160, 220, 190),
        Scrollbar       = Color3.fromRGB(40, 100, 76),
        Notification_BG = Color3.fromRGB(14, 24, 20),
    },
}

-- ============================================================
--  CONFIG SAVE / LOAD
-- ============================================================
local ConfigSystem = {}
ConfigSystem.__index = ConfigSystem

function ConfigSystem.new(hubName)
    local self = setmetatable({}, ConfigSystem)
    self.HubName = hubName
    self.Folder  = "FilmsFryHub_Configs"
    self.Data    = {}
    self:_EnsureFolder()
    return self
end

function ConfigSystem:_EnsureFolder()
    pcall(function()
        if not isfolder then return end
        if not isfolder(self.Folder) then
            makefolder(self.Folder)
        end
    end)
end

function ConfigSystem:Save(name)
    pcall(function()
        if not writefile then return end
        local path = self.Folder .. "/" .. (name or "default") .. ".json"
        writefile(path, HttpService:JSONEncode(self.Data))
    end)
end

function ConfigSystem:Load(name)
    pcall(function()
        if not readfile or not isfile then return end
        local path = self.Folder .. "/" .. (name or "default") .. ".json"
        if isfile(path) then
            local ok, data = pcall(function()
                return HttpService:JSONDecode(readfile(path))
            end)
            if ok and data then
                self.Data = data
            end
        end
    end)
end

function ConfigSystem:Set(key, value)
    self.Data[key] = value
end

function ConfigSystem:Get(key, default)
    return self.Data[key] ~= nil and self.Data[key] or default
end

-- ============================================================
--  DRAGGABLE SYSTEM
-- ============================================================
local function MakeDraggable(frame, handle, onDragStart, onDragEnd)
    local dragging    = false
    local dragStart   = nil
    local startPos    = nil
    local connection1 = nil
    local connection2 = nil

    local function Update(input)
        local delta  = input.Position - dragStart
        local target = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        -- Clamp to screen
        local absSize = frame.AbsoluteSize
        local screenSize = Camera.ViewportSize
        local newX = math.clamp(target.X.Offset, 0, screenSize.X - absSize.X)
        local newY = math.clamp(target.Y.Offset, 0, screenSize.Y - absSize.Y)
        frame.Position = UDim2.new(0, newX, 0, newY)
    end

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            if onDragStart then onDragStart() end

            connection1 = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if connection1 then connection1:Disconnect() end
                    if connection2 then connection2:Disconnect() end
                    if onDragEnd then onDragEnd() end
                end
            end)

            connection2 = UserInputService.InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement or
                   inp.UserInputType == Enum.UserInputType.Touch then
                    if dragging then Update(inp) end
                end
            end)
        end
    end)
end

-- ============================================================
--  NOTIFICATION SYSTEM
-- ============================================================
local NotifHolder = nil
local function EnsureNotifHolder()
    if NotifHolder and NotifHolder.Parent then return end
    local gui = Instance.new("ScreenGui")
    gui.Name              = "FFHub_Notifs"
    gui.ResetOnSpawn      = false
    gui.ZIndexBehavior    = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder      = 999
    pcall(function() gui.Parent = CoreGui end)
    if not gui.Parent then gui.Parent = LocalPlayer.PlayerGui end

    NotifHolder = Create("Frame", {
        Name              = "NotifHolder",
        BackgroundTransparency = 1,
        Position          = UDim2.new(1, -20, 1, -20),
        AnchorPoint       = Vector2.new(1, 1),
        Size              = UDim2.new(0, 320, 1, -20),
        Parent            = gui
    })
    Create("UIListLayout", {
        FillDirection       = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment   = Enum.VerticalAlignment.Bottom,
        Padding             = UDim.new(0, 8),
        SortOrder           = Enum.SortOrder.LayoutOrder,
        Parent              = NotifHolder
    })
end

local function SendNotification(options, theme)
    EnsureNotifHolder()
    local T = theme or Themes.Default
    local title    = options.Title    or "Notification"
    local desc     = options.Desc     or options.Description or ""
    local duration = options.Duration or 4
    local nColor   = options.Color    or T.Accent
    local icon     = options.Icon     or nil

    local notif = Create("Frame", {
        Name              = "Notif",
        BackgroundColor3  = T.Notification_BG,
        BackgroundTransparency = 0.05,
        Size              = UDim2.new(1, 0, 0, 0),
        AutomaticSize     = Enum.AutomaticSize.Y,
        ClipsDescendants  = true,
        Parent            = NotifHolder
    })
    Round(notif, 10)
    MakeStroke(notif, nColor, 1.5, 0.3)

    -- Accent left bar
    local bar = Create("Frame", {
        Name             = "AccentBar",
        BackgroundColor3 = nColor,
        Size             = UDim2.new(0, 3, 1, 0),
        Position         = UDim2.new(0, 0, 0, 0),
        Parent           = notif
    })
    Round(bar, 3)

    local inner = Create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size     = UDim2.new(1, -16, 1, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent   = notif
    })
    Pad(inner, 10, 10, 2, 4)

    local layout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = inner
    })

    Create("TextLabel", {
        Name             = "Title",
        BackgroundTransparency = 1,
        Text             = title,
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        TextColor3       = T.Text,
        TextXAlignment   = Enum.TextXAlignment.Left,
        AutomaticSize    = Enum.AutomaticSize.XY,
        LayoutOrder      = 1,
        Parent           = inner
    })

    if desc ~= "" then
        Create("TextLabel", {
            Name             = "Desc",
            BackgroundTransparency = 1,
            Text             = desc,
            Font             = Enum.Font.Gotham,
            TextSize         = 12,
            TextColor3       = T.TextDim,
            TextXAlignment   = Enum.TextXAlignment.Left,
            AutomaticSize    = Enum.AutomaticSize.XY,
            TextWrapped      = true,
            Size             = UDim2.new(1, 0, 0, 0),
            LayoutOrder      = 2,
            Parent           = inner
        })
    end

    -- Progress bar
    local progBG = Create("Frame", {
        BackgroundColor3 = T.Stroke,
        Size             = UDim2.new(1, 0, 0, 2),
        LayoutOrder      = 3,
        Parent           = inner
    })
    Round(progBG, 2)
    local prog = Create("Frame", {
        BackgroundColor3 = nColor,
        Size             = UDim2.new(1, 0, 1, 0),
        Parent           = progBG
    })
    Round(prog, 2)

    -- Slide in
    notif.Position = UDim2.new(1, 10, 0, 0)
    notif.BackgroundTransparency = 1
    Tween(notif, { Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.05 }, 0.35)

    -- Progress shrink
    task.delay(0.1, function()
        Tween(prog, { Size = UDim2.new(0, 0, 1, 0) }, duration - 0.1, Enum.EasingStyle.Linear)
    end)

    -- Dismiss
    task.delay(duration, function()
        Tween(notif, { Position = UDim2.new(1, 10, 0, 0), BackgroundTransparency = 1 }, 0.3)
        task.delay(0.32, function()
            pcall(function() notif:Destroy() end)
        end)
    end)

    -- Click to dismiss
    notif.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or
           inp.UserInputType == Enum.UserInputType.Touch then
            Tween(notif, { Position = UDim2.new(1, 10, 0, 0), BackgroundTransparency = 1 }, 0.2)
            task.delay(0.22, function()
                pcall(function() notif:Destroy() end)
            end)
        end
    end)
end

-- ============================================================
--  KEYBIND LISTENER
-- ============================================================
local KeybindRegistry = {}
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    for _, entry in pairs(KeybindRegistry) do
        if entry.Key == input.KeyCode then
            pcall(entry.Callback)
        end
    end
end)

-- ============================================================
--  MAIN LIBRARY
-- ============================================================
local FilmsFryHub = {}
FilmsFryHub.__index = FilmsFryHub

function FilmsFryHub:CreateWindow(options)
    options = options or {}
    local title    = options.Title  or "FilmsFry-Hub"
    local themeName = options.Theme or "Default"
    local T = Themes[themeName] or Themes.Default

    local Config = ConfigSystem.new(title)

    -- Screen GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name           = "FilmsFryHub_" .. title:gsub("%s", "")
    ScreenGui.ResetOnSpawn   = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder   = 100
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

    -- =====================
    -- MAIN WINDOW FRAME
    -- =====================
    local WindowWidth  = IsMobile() and math.min(Camera.ViewportSize.X - 20, 400) or 500
    local WindowHeight = 560

    local MainFrame = Create("Frame", {
        Name             = "MainWindow",
        BackgroundColor3 = T.Background,
        Size             = UDim2.new(0, WindowWidth, 0, WindowHeight),
        Position         = UDim2.new(0.5, -WindowWidth/2, 0.5, -WindowHeight/2),
        ClipsDescendants = false,
        Parent           = ScreenGui
    })
    Round(MainFrame, 14)
    MakeStroke(MainFrame, T.Stroke, 1.5, 0.2)
    MakeShadow(MainFrame, 30, Color3.fromRGB(0,0,0), 0.4)

    -- Background gradient
    MakeGradient(MainFrame, 135, {
        ColorSequenceKeypoint.new(0, T.Background),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(
            math.clamp(T.Background.R*255 + 6, 0, 255)/255,
            math.clamp(T.Background.G*255 + 4, 0, 255)/255,
            math.clamp(T.Background.B*255 + 18, 0, 255)/255
        ))
    })

    -- =====================
    -- TITLE BAR
    -- =====================
    local TitleBar = Create("Frame", {
        Name             = "TitleBar",
        BackgroundColor3 = T.TitleBar,
        Size             = UDim2.new(1, 0, 0, 48),
        Position         = UDim2.new(0, 0, 0, 0),
        ZIndex           = 10,
        Parent           = MainFrame
    })
    Create("UICorner", { CornerRadius = UDim.new(0, 14), Parent = TitleBar })
    -- Bottom sharp corners
    Create("Frame", {
        BackgroundColor3 = T.TitleBar,
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BorderSizePixel = 0,
        Parent = TitleBar
    })
    MakeGradient(TitleBar, 90, {
        ColorSequenceKeypoint.new(0, Color3.fromRGB(
            math.clamp(T.Accent.R*255, 0, 255)/255,
            math.clamp(T.Accent.G*255, 0, 255)/255,
            math.clamp(T.Accent.B*255, 0, 255)/255
        ):Lerp(T.TitleBar, 0.75)),
        ColorSequenceKeypoint.new(0.5, T.TitleBar),
        ColorSequenceKeypoint.new(1, T.AccentSecondary:Lerp(T.TitleBar, 0.75))
    })

    -- Title logo dots
    local logoDot1 = Create("Frame", {
        BackgroundColor3 = T.Accent,
        Size = UDim2.new(0, 8, 0, 8),
        Position = UDim2.new(0, 14, 0.5, -4),
        ZIndex = 11,
        Parent = TitleBar
    })
    Round(logoDot1, 4)

    local logoDot2 = Create("Frame", {
        BackgroundColor3 = T.AccentSecondary,
        Size = UDim2.new(0, 5, 0, 5),
        Position = UDim2.new(0, 26, 0.5, 2),
        ZIndex = 11,
        Parent = TitleBar
    })
    Round(logoDot2, 3)

    local TitleLabel = Create("TextLabel", {
        Name             = "TitleLabel",
        BackgroundTransparency = 1,
        Position         = UDim2.new(0, 40, 0, 0),
        Size             = UDim2.new(1, -130, 1, 0),
        Text             = title,
        Font             = Enum.Font.GothamBold,
        TextSize         = 16,
        TextColor3       = T.Text,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 11,
        Parent           = TitleBar
    })

    -- Version label
    Create("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 40, 0, 0),
        Size     = UDim2.new(1, -130, 1, 0),
        Text     = "v1.0.0",
        Font     = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = T.TextMuted,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom,
        ZIndex = 11,
        Parent = TitleBar
    })

    -- Title bar separator
    Create("Frame", {
        BackgroundColor3 = T.Stroke,
        BackgroundTransparency = 0.4,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        ZIndex = 11,
        Parent = TitleBar
    })

    -- Minimize button
    local MinBtn = Create("TextButton", {
        Name             = "MinimizeBtn",
        BackgroundColor3 = T.Element,
        Size             = UDim2.new(0, 30, 0, 30),
        Position         = UDim2.new(1, -72, 0.5, -15),
        Text             = "—",
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        TextColor3       = T.TextDim,
        ZIndex           = 12,
        Parent           = TitleBar
    })
    Round(MinBtn, 8)
    MakeStroke(MinBtn, T.Stroke, 1, 0.5)

    -- Close button
    local CloseBtn = Create("TextButton", {
        Name             = "CloseBtn",
        BackgroundColor3 = Color3.fromRGB(220, 60, 70),
        Size             = UDim2.new(0, 30, 0, 30),
        Position         = UDim2.new(1, -38, 0.5, -15),
        Text             = "✕",
        Font             = Enum.Font.GothamBold,
        TextSize         = 14,
        TextColor3       = Color3.fromRGB(255, 255, 255),
        ZIndex           = 12,
        Parent           = TitleBar
    })
    Round(CloseBtn, 8)

    -- =====================
    -- TAB BAR
    -- =====================
    local TabBarFrame = Create("Frame", {
        Name             = "TabBar",
        BackgroundColor3 = T.TitleBar,
        BackgroundTransparency = 0.3,
        Size             = UDim2.new(1, 0, 0, 36),
        Position         = UDim2.new(0, 0, 0, 48),
        Parent           = MainFrame
    })
    local TabScroll = Create("ScrollingFrame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        Parent = TabBarFrame
    })
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = TabScroll
    })

    -- =====================
    -- CONTENT AREA
    -- =====================
    local ContentArea = Create("Frame", {
        Name             = "ContentArea",
        BackgroundTransparency = 1,
        Size             = UDim2.new(1, 0, 1, -84),
        Position         = UDim2.new(0, 0, 0, 84),
        ClipsDescendants = true,
        Parent           = MainFrame
    })

    -- =====================
    -- TOGGLE BUTTON (minimized)
    -- =====================
    local ToggleBtn = Create("TextButton", {
        Name             = "ToggleButton",
        BackgroundColor3 = T.TitleBar,
        Size             = UDim2.new(0, 120, 0, 36),
        Position         = UDim2.new(0.5, -60, 0.5, -18),
        Text             = "⚡ Toggle UI",
        Font             = Enum.Font.GothamBold,
        TextSize         = 13,
        TextColor3       = T.Text,
        Visible          = false,
        ZIndex           = 50,
        Parent           = ScreenGui
    })
    Round(ToggleBtn, 10)
    MakeStroke(ToggleBtn, T.Accent, 1.5, 0.2)
    MakeShadow(ToggleBtn, 16, Color3.fromRGB(0,0,0), 0.5)
    MakeGradient(ToggleBtn, 90, {
        ColorSequenceKeypoint.new(0, T.Accent:Lerp(T.TitleBar, 0.7)),
        ColorSequenceKeypoint.new(1, T.AccentSecondary:Lerp(T.TitleBar, 0.7))
    })

    MakeDraggable(ToggleBtn, ToggleBtn)

    -- =====================
    -- DRAGGABLE WINDOW
    -- =====================
    MakeDraggable(MainFrame, TitleBar)

    -- =====================
    -- BUTTON HOVER FX
    -- =====================
    MinBtn.MouseEnter:Connect(function()
        Tween(MinBtn, { BackgroundColor3 = T.ElementHover }, 0.15)
    end)
    MinBtn.MouseLeave:Connect(function()
        Tween(MinBtn, { BackgroundColor3 = T.Element }, 0.15)
    end)
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, { BackgroundColor3 = Color3.fromRGB(255, 80, 90) }, 0.15)
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, { BackgroundColor3 = Color3.fromRGB(220, 60, 70) }, 0.15)
    end)

    -- =====================
    -- OPEN ANIMATION
    -- =====================
    MainFrame.Size = UDim2.new(0, WindowWidth, 0, 0)
    MainFrame.BackgroundTransparency = 1
    Tween(MainFrame, { Size = UDim2.new(0, WindowWidth, 0, WindowHeight), BackgroundTransparency = 0 }, 0.4, Enum.EasingStyle.Back)

    -- =====================
    -- WINDOW OBJECT
    -- =====================
    local Window = {}
    Window.Theme   = T
    Window.Tabs    = {}
    Window.Config  = Config
    Window.Gui     = ScreenGui
    Window.Frame   = MainFrame
    Window._destroyed = false

    local ActiveTab = nil

    -- =====================
    -- MINIMIZE / RESTORE
    -- =====================
    local minimized = false

    MinBtn.MouseButton1Click:Connect(function()
        if minimized then return end
        minimized = true
        Tween(MainFrame, { Size = UDim2.new(0, WindowWidth, 0, 0), BackgroundTransparency = 1 }, 0.3, Enum.EasingStyle.Quart)
        task.delay(0.32, function()
            MainFrame.Visible = false
            ToggleBtn.Visible = true
            Tween(ToggleBtn, { BackgroundTransparency = 0 }, 0.2)
        end)
    end)

    ToggleBtn.MouseButton1Click:Connect(function()
        if not minimized then return end
        minimized = false
        ToggleBtn.Visible = false
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, WindowWidth, 0, 0)
        MainFrame.BackgroundTransparency = 1
        Tween(MainFrame, { Size = UDim2.new(0, WindowWidth, 0, WindowHeight), BackgroundTransparency = 0 }, 0.35, Enum.EasingStyle.Back)
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        Tween(MainFrame, { Size = UDim2.new(0, WindowWidth, 0, 0), BackgroundTransparency = 1 }, 0.3, Enum.EasingStyle.Quart)
        task.delay(0.32, function()
            pcall(function() ScreenGui:Destroy() end)
        end)
    end)

    -- =====================
    -- CREATE TAB
    -- =====================
    function Window:CreateTab(tabName, icon)
        local tabBtn = Create("TextButton", {
            Name             = "Tab_" .. tabName,
            BackgroundColor3 = T.Element,
            BackgroundTransparency = 0.5,
            Size             = UDim2.new(0, 0, 0, 26),
            AutomaticSize    = Enum.AutomaticSize.X,
            Text             = (icon and icon .. " " or "") .. tabName,
            Font             = Enum.Font.GothamBold,
            TextSize         = 12,
            TextColor3       = T.TextDim,
            Parent           = TabScroll
        })
        Round(tabBtn, 7)
        Pad(tabBtn, 0, 0, 12, 12)

        -- Tab content page
        local tabPage = Create("ScrollingFrame", {
            Name                  = "Page_" .. tabName,
            BackgroundTransparency = 1,
            Size                  = UDim2.new(1, 0, 1, 0),
            CanvasSize            = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize   = Enum.AutomaticSize.Y,
            ScrollBarThickness    = 4,
            ScrollBarImageColor3  = T.Scrollbar,
            ScrollingDirection    = Enum.ScrollingDirection.Y,
            Visible               = false,
            Parent                = ContentArea
        })
        Pad(tabPage, 8, 8, 8, 8)
        Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabPage
        })

        local function Activate()
            -- Deactivate all
            for _, t in pairs(self.Tabs) do
                Tween(t.Btn, { BackgroundColor3 = T.Element, BackgroundTransparency = 0.5, TextColor3 = T.TextDim }, 0.15)
                t.Page.Visible = false
                if t.Indicator then t.Indicator.Visible = false end
            end
            -- Activate this
            Tween(tabBtn, { BackgroundColor3 = T.Accent, BackgroundTransparency = 0, TextColor3 = T.Text }, 0.15)
            tabPage.Visible = true
            ActiveTab = tabName
        end

        -- Active indicator line
        local indicator = Create("Frame", {
            Name             = "Indicator",
            BackgroundColor3 = T.Accent,
            Size             = UDim2.new(1, -8, 0, 2),
            Position         = UDim2.new(0, 4, 1, -2),
            Visible          = false,
            ZIndex           = 13,
            Parent           = tabBtn
        })
        Round(indicator, 2)

        tabBtn.MouseButton1Click:Connect(Activate)
        tabBtn.MouseEnter:Connect(function()
            if ActiveTab ~= tabName then
                Tween(tabBtn, { BackgroundTransparency = 0.3 }, 0.1)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if ActiveTab ~= tabName then
                Tween(tabBtn, { BackgroundTransparency = 0.5 }, 0.1)
            end
        end)

        local Tab = {}
        Tab.Name = tabName
        Tab.Btn  = tabBtn
        Tab.Page = tabPage
        Tab.Indicator = indicator
        Tab._sections = {}

        -- Activate first tab by default
        if #self.Tabs == 0 then
            Activate()
            indicator.Visible = true
        end
        table.insert(self.Tabs, Tab)

        -- =====================
        -- CREATE SECTION
        -- =====================
        function Tab:CreateSection(sectionName, collapsed)
            local sectionFrame = Create("Frame", {
                Name             = "Section_" .. sectionName,
                BackgroundColor3 = T.Section,
                BackgroundTransparency = 0.1,
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                ClipsDescendants = false,
                Parent           = tabPage
            })
            Round(sectionFrame, 10)
            MakeStroke(sectionFrame, T.Stroke, 1, 0.5)

            -- Section header
            local sectionHeader = Create("TextButton", {
                Name             = "Header",
                BackgroundColor3 = T.SectionHeader,
                BackgroundTransparency = 0.1,
                Size             = UDim2.new(1, 0, 0, 36),
                Text             = "",
                AutoButtonColor  = false,
                ZIndex           = 2,
                Parent           = sectionFrame
            })
            Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = sectionHeader })
            -- Bottom sharp corners (when expanded)
            local headerBottomBlock = Create("Frame", {
                BackgroundColor3 = T.SectionHeader,
                BackgroundTransparency = 0.1,
                Size = UDim2.new(1, 0, 0, 10),
                Position = UDim2.new(0, 0, 1, -10),
                BorderSizePixel = 0,
                ZIndex = 2,
                Visible = true,
                Parent = sectionHeader
            })

            -- Section name
            local sNameLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 12, 0, 0),
                Size     = UDim2.new(1, -60, 1, 0),
                Text     = sectionName,
                Font     = Enum.Font.GothamBold,
                TextSize = 13,
                TextColor3 = T.Text,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex   = 3,
                Parent   = sectionHeader
            })

            -- Section accent dot
            local accentDot = Create("Frame", {
                BackgroundColor3 = T.Accent,
                Size     = UDim2.new(0, 4, 0, 18),
                Position = UDim2.new(0, 4, 0.5, -9),
                ZIndex   = 3,
                Parent   = sectionHeader
            })
            Round(accentDot, 2)

            -- Collapse arrow
            local arrow = Create("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -32, 0, 0),
                Size     = UDim2.new(0, 24, 1, 0),
                Text     = "▾",
                Font     = Enum.Font.GothamBold,
                TextSize = 14,
                TextColor3 = T.TextDim,
                ZIndex   = 3,
                Parent   = sectionHeader
            })

            -- Element container
            local elemContainer = Create("Frame", {
                Name             = "Elements",
                BackgroundTransparency = 1,
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                Position         = UDim2.new(0, 0, 0, 36),
                ClipsDescendants = true,
                Parent           = sectionFrame
            })
            Pad(elemContainer, 4, 6, 8, 8)
            Create("UIListLayout", {
                FillDirection = Enum.FillDirection.Vertical,
                Padding = UDim.new(0, 4),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = elemContainer
            })

            local isCollapsed = collapsed or false

            local function UpdateCollapse(animate)
                if isCollapsed then
                    arrow.Text = "▸"
                    Tween(elemContainer, { Size = UDim2.new(1, 0, 0, 0) }, animate and 0.22 or 0)
                    headerBottomBlock.Visible = false
                else
                    arrow.Text = "▾"
                    elemContainer.AutomaticSize = Enum.AutomaticSize.Y
                    if animate then
                        Tween(elemContainer, {}, 0.22)
                    end
                    headerBottomBlock.Visible = true
                end
            end
            UpdateCollapse(false)

            sectionHeader.MouseButton1Click:Connect(function()
                isCollapsed = not isCollapsed
                UpdateCollapse(true)
                Tween(sectionHeader, { BackgroundTransparency = isCollapsed and 0 or 0.1 }, 0.15)
            end)

            sectionHeader.MouseEnter:Connect(function()
                Tween(sectionHeader, { BackgroundColor3 = Color3.fromRGB(
                    T.SectionHeader.R*255 + 8, T.SectionHeader.G*255 + 8, T.SectionHeader.B*255 + 12
                ) / 255 }, 0.1)
            end)
            sectionHeader.MouseLeave:Connect(function()
                Tween(sectionHeader, { BackgroundColor3 = T.SectionHeader }, 0.1)
            end)

            local Section = {}
            Section._container = elemContainer
            Section._order = 0

            local function NextOrder()
                Section._order = Section._order + 1
                return Section._order
            end

            -- ==============================
            -- LABEL
            -- ==============================
            function Section:AddLabel(text, desc)
                local frame = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size  = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    LayoutOrder = NextOrder(),
                    Parent = elemContainer
                })

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Size  = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Text  = text,
                    Font  = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextColor3 = T.TextDim,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    Parent = frame
                })

                if desc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Size  = UDim2.new(1, 0, 0, 0),
                        AutomaticSize = Enum.AutomaticSize.Y,
                        Text  = desc,
                        Font  = Enum.Font.Gotham,
                        TextSize = 11,
                        TextColor3 = T.TextMuted,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        TextWrapped = true,
                        Parent = frame
                    })
                    Create("UIListLayout", {
                        FillDirection = Enum.FillDirection.Vertical,
                        Padding = UDim.new(0, 2),
                        Parent = frame
                    })
                end
                return frame
            end

            -- ==============================
            -- DIVIDER
            -- ==============================
            function Section:AddDivider(labelText)
                local divFrame = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    LayoutOrder = NextOrder(),
                    Parent = elemContainer
                })
                local line = Create("Frame", {
                    BackgroundColor3 = T.Stroke,
                    BackgroundTransparency = 0.3,
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Parent = divFrame
                })
                if labelText then
                    local lblSize = GetTextSize(labelText, 11, Enum.Font.GothamBold, Vector2.new(500, 30))
                    local lbl = Create("TextLabel", {
                        BackgroundColor3 = T.Section,
                        BackgroundTransparency = 0.1,
                        Size = UDim2.new(0, lblSize.X + 16, 0, 18),
                        Position = UDim2.new(0.5, -(lblSize.X + 16)/2, 0.5, -9),
                        Text = labelText,
                        Font = Enum.Font.GothamBold,
                        TextSize = 11,
                        TextColor3 = T.TextMuted,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        Parent = divFrame
                    })
                    Round(lbl, 4)
                end
                return divFrame
            end

            -- ==============================
            -- BUTTON
            -- ==============================
            function Section:AddButton(options)
                options = options or {}
                local name     = options.Name     or "Button"
                local desc     = options.Desc     or nil
                local callback = options.Callback or function() end
                local icon     = options.Icon     or nil

                local btnHeight = desc and 52 or 36

                local btnFrame = Create("TextButton", {
                    Name             = "Btn_" .. name,
                    BackgroundColor3 = T.Element,
                    Size             = UDim2.new(1, 0, 0, btnHeight),
                    Text             = "",
                    AutoButtonColor  = false,
                    LayoutOrder      = NextOrder(),
                    Parent           = elemContainer
                })
                Round(btnFrame, 8)
                MakeStroke(btnFrame, T.Stroke, 1, 0.6)

                local btnLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, icon and 36 or 12, 0, 0),
                    Size     = UDim2.new(1, -(icon and 52 or 28), desc and 0.5 or 1, 0),
                    Text     = name,
                    Font     = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextColor3 = T.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = btnFrame
                })

                if desc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0.5, 0),
                        Size     = UDim2.new(1, -24, 0.5, 0),
                        Text     = desc,
                        Font     = Enum.Font.Gotham,
                        TextSize = 11,
                        TextColor3 = T.TextMuted,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = btnFrame
                    })
                end

                if icon then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size     = UDim2.new(0, 24, 1, 0),
                        Text     = icon,
                        Font     = Enum.Font.GothamBold,
                        TextSize = 16,
                        TextColor3 = T.Accent,
                        TextXAlignment = Enum.TextXAlignment.Center,
                        Parent = btnFrame
                    })
                end

                -- Ripple / press effect
                local pressing = false
                btnFrame.MouseButton1Down:Connect(function()
                    pressing = true
                    Tween(btnFrame, { BackgroundColor3 = T.ElementActive }, 0.1)
                    Tween(btnLabel, { TextColor3 = T.Accent }, 0.1)
                end)
                btnFrame.MouseButton1Up:Connect(function()
                    if pressing then
                        Tween(btnFrame, { BackgroundColor3 = T.ElementHover }, 0.1)
                        Tween(btnLabel, { TextColor3 = T.Text }, 0.15)
                        pressing = false
                        task.spawn(callback)
                    end
                end)
                btnFrame.MouseEnter:Connect(function()
                    if not pressing then
                        Tween(btnFrame, { BackgroundColor3 = T.ElementHover }, 0.12)
                    end
                end)
                btnFrame.MouseLeave:Connect(function()
                    pressing = false
                    Tween(btnFrame, { BackgroundColor3 = T.Element }, 0.12)
                    Tween(btnLabel, { TextColor3 = T.Text }, 0.12)
                end)

                return { Frame = btnFrame, SetText = function(txt) btnLabel.Text = txt end }
            end

            -- ==============================
            -- TOGGLE
            -- ==============================
            function Section:AddToggle(options)
                options = options or {}
                local name      = options.Name     or "Toggle"
                local desc      = options.Desc     or nil
                local default   = options.Default  ~= nil and options.Default or false
                local callback  = options.Callback or function() end
                local configKey = options.Key      or nil

                if configKey then
                    default = Config:Get(configKey, default)
                end

                local state = default

                local toggleFrame = Create("Frame", {
                    BackgroundColor3 = T.Element,
                    Size = UDim2.new(1, 0, 0, desc and 50 or 36),
                    LayoutOrder = NextOrder(),
                    Parent = elemContainer
                })
                Round(toggleFrame, 8)
                MakeStroke(toggleFrame, T.Stroke, 1, 0.6)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size     = UDim2.new(1, -64, desc and 0.55 or 1, 0),
                    Text     = name,
                    Font     = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextColor3 = T.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = toggleFrame
                })

                if desc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0, 12, 0.55, 0),
                        Size     = UDim2.new(1, -64, 0.45, 0),
                        Text     = desc,
                        Font     = Enum.Font.Gotham,
                        TextSize = 11,
                        TextColor3 = T.TextMuted,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = toggleFrame
                    })
                end

                -- Toggle pill
                local pill = Create("Frame", {
                    BackgroundColor3 = state and T.Toggle_On or T.Toggle_Off,
                    Size = UDim2.new(0, 42, 0, 22),
                    Position = UDim2.new(1, -54, 0.5, -11),
                    Parent = toggleFrame
                })
                Round(pill, 11)
                MakeStroke(pill, state and T.Accent or T.Stroke, 1.5, 0.3)

                local thumb = Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(240, 240, 255),
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
                    Parent = pill
                })
                Round(thumb, 8)

                local function UpdateToggle(anim)
                    local t = anim and 0.2 or 0
                    if state then
                        Tween(pill,  { BackgroundColor3 = T.Toggle_On  }, t)
                        Tween(thumb, { Position = UDim2.new(1, -19, 0.5, -8) }, t, Enum.EasingStyle.Back)
                    else
                        Tween(pill,  { BackgroundColor3 = T.Toggle_Off }, t)
                        Tween(thumb, { Position = UDim2.new(0, 3, 0.5, -8) }, t, Enum.EasingStyle.Back)
                    end
                end

                local btn = Create("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    Text = "",
                    ZIndex = 5,
                    Parent = toggleFrame
                })

                btn.MouseButton1Click:Connect(function()
                    state = not state
                    UpdateToggle(true)
                    if configKey then Config:Set(configKey, state) end
                    task.spawn(callback, state)
                end)

                btn.MouseEnter:Connect(function()
                    Tween(toggleFrame, { BackgroundColor3 = T.ElementHover }, 0.1)
                end)
                btn.MouseLeave:Connect(function()
                    Tween(toggleFrame, { BackgroundColor3 = T.Element }, 0.1)
                end)

                local Toggle = {}
                function Toggle:Set(val)
                    state = val
                    UpdateToggle(true)
                    if configKey then Config:Set(configKey, state) end
                    task.spawn(callback, state)
                end
                function Toggle:Get() return state end

                return Toggle
            end

            -- ==============================
            -- SLIDER
            -- ==============================
            function Section:AddSlider(options)
                options = options or {}
                local name      = options.Name     or "Slider"
                local min       = options.Min      or 0
                local max       = options.Max      or 100
                local default   = options.Default  or min
                local suffix    = options.Suffix   or ""
                local callback  = options.Callback or function() end
                local configKey = options.Key      or nil
                local step      = options.Step     or 1

                if configKey then default = Config:Get(configKey, default) end
                local value = math.clamp(default, min, max)

                local sliderFrame = Create("Frame", {
                    BackgroundColor3 = T.Element,
                    Size = UDim2.new(1, 0, 0, 56),
                    LayoutOrder = NextOrder(),
                    Parent = elemContainer
                })
                Round(sliderFrame, 8)
                MakeStroke(sliderFrame, T.Stroke, 1, 0.6)

                local nameLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 6),
                    Size     = UDim2.new(1, -80, 0, 20),
                    Text     = name,
                    Font     = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextColor3 = T.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sliderFrame
                })

                local valLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -70, 0, 6),
                    Size     = UDim2.new(0, 62, 0, 20),
                    Text     = tostring(value) .. suffix,
                    Font     = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextColor3 = T.Accent,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = sliderFrame
                })

                -- Track
                local track = Create("Frame", {
                    BackgroundColor3 = T.Slider_Track,
                    Size = UDim2.new(1, -24, 0, 6),
                    Position = UDim2.new(0, 12, 0, 36),
                    Parent = sliderFrame
                })
                Round(track, 3)

                local fill = Create("Frame", {
                    BackgroundColor3 = T.Slider_Fill,
                    Size = UDim2.new((value - min) / (max - min), 0, 1, 0),
                    Parent = track
                })
                Round(fill, 3)
                MakeGradient(fill, 0, {
                    ColorSequenceKeypoint.new(0, T.Accent),
                    ColorSequenceKeypoint.new(1, T.AccentSecondary)
                })

                local thumbBtn = Create("Frame", {
                    BackgroundColor3 = T.Slider_Thumb,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new((value - min) / (max - min), -8, 0.5, -8),
                    ZIndex = 3,
                    Parent = track
                })
                Round(thumbBtn, 8)
                MakeStroke(thumbBtn, T.Accent, 2, 0.1)

                local draggingSlider = false

                local function SetValue(pct)
                    local rawVal = min + (max - min) * pct
                    local stepped = math.round(rawVal / step) * step
                    value = math.clamp(stepped, min, max)
                    local actualPct = (value - min) / (max - min)
                    Tween(fill,     { Size = UDim2.new(actualPct, 0, 1, 0) }, 0.05)
                    Tween(thumbBtn, { Position = UDim2.new(actualPct, -8, 0.5, -8) }, 0.05)
                    valLabel.Text = tostring(value) .. suffix
                    if configKey then Config:Set(configKey, value) end
                    task.spawn(callback, value)
                end

                local function GetPct(inputPos)
                    local trackAbs = track.AbsolutePosition
                    local trackSize = track.AbsoluteSize
                    return math.clamp((inputPos.X - trackAbs.X) / trackSize.X, 0, 1)
                end

                track.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or
                       inp.UserInputType == Enum.UserInputType.Touch then
                        draggingSlider = true
                        SetValue(GetPct(inp.Position))
                    end
                end)

                thumbBtn.InputBegan:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or
                       inp.UserInputType == Enum.UserInputType.Touch then
                        draggingSlider = true
                    end
                end)

                UserInputService.InputChanged:Connect(function(inp)
                    if draggingSlider then
                        if inp.UserInputType == Enum.UserInputType.MouseMovement or
                           inp.UserInputType == Enum.UserInputType.Touch then
                            SetValue(GetPct(inp.Position))
                        end
                    end
                end)

                UserInputService.InputEnded:Connect(function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or
                       inp.UserInputType == Enum.UserInputType.Touch then
                        draggingSlider = false
                    end
                end)

                -- Hover
                sliderFrame.MouseEnter:Connect(function()
                    Tween(sliderFrame, { BackgroundColor3 = T.ElementHover }, 0.1)
                end)
                sliderFrame.MouseLeave:Connect(function()
                    Tween(sliderFrame, { BackgroundColor3 = T.Element }, 0.1)
                end)

                local Slider = {}
                function Slider:Set(val)
                    value = math.clamp(val, min, max)
                    SetValue((value - min) / (max - min))
                end
                function Slider:Get() return value end
                return Slider
            end

            -- ==============================
            -- TEXTBOX
            -- ==============================
            function Section:AddTextbox(options)
                options = options or {}
                local name      = options.Name        or "Input"
                local placeholder = options.Placeholder or "Type here..."
                local default   = options.Default     or ""
                local callback  = options.Callback    or function() end
                local configKey = options.Key         or nil
                local clearOnFocus = options.ClearOnFocus ~= nil and options.ClearOnFocus or false

                if configKey then default = Config:Get(configKey, default) end

                local boxFrame = Create("Frame", {
                    BackgroundColor3 = T.Element,
                    Size = UDim2.new(1, 0, 0, 56),
                    LayoutOrder = NextOrder(),
                    Parent = elemContainer
                })
                Round(boxFrame, 8)
                MakeStroke(boxFrame, T.Stroke, 1, 0.6)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 6),
                    Size     = UDim2.new(1, -24, 0, 20),
                    Text     = name,
                    Font     = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextColor3 = T.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = boxFrame
                })

                local inputBG = Create("Frame", {
                    BackgroundColor3 = T.Background,
                    BackgroundTransparency = 0.3,
                    Size = UDim2.new(1, -24, 0, 24),
                    Position = UDim2.new(0, 12, 0, 26),
                    Parent = boxFrame
                })
                Round(inputBG, 6)
                MakeStroke(inputBG, T.Stroke, 1, 0.4)

                local textBox = Create("TextBox", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -16, 1, 0),
                    Position = UDim2.new(0, 8, 0, 0),
                    Text     = default,
                    PlaceholderText = placeholder,
                    Font     = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = T.Text,
                    PlaceholderColor3 = T.TextMuted,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ClearTextOnFocus = clearOnFocus,
                    Parent = inputBG
                })

                textBox.Focused:Connect(function()
                    Tween(inputBG._stroke or inputBG, {}, 0.15)
                    MakeStroke(inputBG, T.Accent, 1.5, 0.2)
                end)
                textBox.FocusLost:Connect(function(enterPressed)
                    MakeStroke(inputBG, T.Stroke, 1, 0.4)
                    if configKey then Config:Set(configKey, textBox.Text) end
                    task.spawn(callback, textBox.Text, enterPressed)
                end)

                local Textbox = {}
                function Textbox:Set(txt) textBox.Text = txt end
                function Textbox:Get() return textBox.Text end
                return Textbox
            end

            -- ==============================
            -- DROPDOWN
            -- ==============================
            function Section:AddDropdown(options)
                options = options or {}
                local name      = options.Name     or "Dropdown"
                local items     = options.Items    or {}
                local default   = options.Default  or (items[1] or "Select...")
                local callback  = options.Callback or function() end
                local configKey = options.Key      or nil
                local multi     = options.Multi    or false

                if configKey then default = Config:Get(configKey, default) end

                local selected  = multi and {} or default
                if multi and type(default) == "table" then selected = default end

                local ddFrame = Create("Frame", {
                    BackgroundColor3 = T.Element,
                    Size = UDim2.new(1, 0, 0, 56),
                    ClipsDescendants = false,
                    LayoutOrder = NextOrder(),
                    ZIndex = 4,
                    Parent = elemContainer
                })
                Round(ddFrame, 8)
                MakeStroke(ddFrame, T.Stroke, 1, 0.6)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 6),
                    Size     = UDim2.new(1, -24, 0, 20),
                    Text     = name,
                    Font     = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextColor3 = T.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                    Parent = ddFrame
                })

                local selectedBG = Create("TextButton", {
                    BackgroundColor3 = T.Background,
                    BackgroundTransparency = 0.3,
                    Size = UDim2.new(1, -24, 0, 24),
                    Position = UDim2.new(0, 12, 0, 26),
                    Text = "",
                    ZIndex = 5,
                    Parent = ddFrame
                })
                Round(selectedBG, 6)
                MakeStroke(selectedBG, T.Stroke, 1, 0.4)

                local selectedLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 8, 0, 0),
                    Size     = UDim2.new(1, -30, 1, 0),
                    Text     = multi and "Select options..." or tostring(selected),
                    Font     = Enum.Font.Gotham,
                    TextSize = 12,
                    TextColor3 = T.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6,
                    Parent = selectedBG
                })

                local arrowLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -24, 0, 0),
                    Size     = UDim2.new(0, 20, 1, 0),
                    Text     = "▾",
                    Font     = Enum.Font.GothamBold,
                    TextSize = 12,
                    TextColor3 = T.Dropdown_Arrow,
                    ZIndex = 6,
                    Parent = selectedBG
                })

                -- Dropdown popup
                local popup = Create("Frame", {
                    BackgroundColor3 = T.Section,
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 1, 4),
                    ClipsDescendants = true,
                    ZIndex = 20,
                    Visible = false,
                    Parent = ddFrame
                })
                Round(popup, 8)
                MakeStroke(popup, T.Stroke, 1.5, 0.2)
                MakeShadow(popup, 12, Color3.fromRGB(0,0,0), 0.5)

                local popupScroll = Create("ScrollingFrame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = T.Scrollbar,
                    ZIndex = 21,
                    Parent = popup
                })
                Pad(popupScroll, 4, 4, 4, 4)
                Create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Vertical,
                    Padding = UDim.new(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = popupScroll
                })

                local isOpen = false
                local maxVisible = math.min(#items, 5)

                local function UpdateSelectedDisplay()
                    if multi then
                        local sel = {}
                        for k, _ in pairs(selected) do table.insert(sel, k) end
                        selectedLabel.Text = #sel == 0 and "Select options..." or table.concat(sel, ", ")
                    else
                        selectedLabel.Text = tostring(selected)
                    end
                end

                local function BuildItems()
                    for _, child in pairs(popupScroll:GetChildren()) do
                        if child:IsA("Frame") then child:Destroy() end
                    end

                    for i, item in ipairs(items) do
                        local isSelected = multi and selected[item] or (not multi and selected == item)
                        local itemBtn = Create("TextButton", {
                            BackgroundColor3 = isSelected and T.Accent or T.Element,
                            BackgroundTransparency = isSelected and 0 or 0.3,
                            Size = UDim2.new(1, 0, 0, 28),
                            Text = "",
                            LayoutOrder = i,
                            ZIndex = 22,
                            Parent = popupScroll
                        })
                        Round(itemBtn, 6)

                        if isSelected then
                            Create("TextLabel", {
                                BackgroundTransparency = 1,
                                Position = UDim2.new(1, -24, 0, 0),
                                Size = UDim2.new(0, 20, 1, 0),
                                Text = "✓",
                                Font = Enum.Font.GothamBold,
                                TextSize = 12,
                                TextColor3 = Color3.fromRGB(255,255,255),
                                ZIndex = 23,
                                Parent = itemBtn
                            })
                        end

                        Create("TextLabel", {
                            BackgroundTransparency = 1,
                            Position = UDim2.new(0, 10, 0, 0),
                            Size = UDim2.new(1, -30, 1, 0),
                            Text = tostring(item),
                            Font = Enum.Font.Gotham,
                            TextSize = 12,
                            TextColor3 = isSelected and Color3.fromRGB(255,255,255) or T.Text,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 23,
                            Parent = itemBtn
                        })

                        itemBtn.MouseButton1Click:Connect(function()
                            if multi then
                                if selected[item] then selected[item] = nil
                                else selected[item] = true end
                                UpdateSelectedDisplay()
                                BuildItems()
                                task.spawn(callback, selected)
                                if configKey then Config:Set(configKey, selected) end
                            else
                                selected = item
                                UpdateSelectedDisplay()
                                BuildItems()
                                isOpen = false
                                Tween(popup, { Size = UDim2.new(1, 0, 0, 0) }, 0.2)
                                Tween(arrowLabel, { Rotation = 0 }, 0.2)
                                popup.Visible = false
                                task.spawn(callback, selected)
                                if configKey then Config:Set(configKey, selected) end
                            end
                        end)

                        itemBtn.MouseEnter:Connect(function()
                            if not (not multi and selected == item) then
                                Tween(itemBtn, { BackgroundColor3 = T.ElementHover, BackgroundTransparency = 0 }, 0.1)
                            end
                        end)
                        itemBtn.MouseLeave:Connect(function()
                            local sel2 = multi and selected[item] or (not multi and selected == item)
                            Tween(itemBtn, { BackgroundColor3 = sel2 and T.Accent or T.Element, BackgroundTransparency = sel2 and 0 or 0.3 }, 0.1)
                        end)
                    end
                end
                BuildItems()

                selectedBG.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        popup.Visible = true
                        local targetH = math.min(#items * 30 + 8, maxVisible * 30 + 8)
                        Tween(popup, { Size = UDim2.new(1, 0, 0, targetH) }, 0.22, Enum.EasingStyle.Back)
                        Tween(arrowLabel, { Rotation = 180 }, 0.2)
                    else
                        Tween(popup, { Size = UDim2.new(1, 0, 0, 0) }, 0.18)
                        Tween(arrowLabel, { Rotation = 0 }, 0.2)
                        task.delay(0.2, function() popup.Visible = false end)
                    end
                end)

                local Dropdown = {}
                function Dropdown:Set(val)
                    if multi then selected = val
                    else selected = val end
                    UpdateSelectedDisplay()
                    BuildItems()
                end
                function Dropdown:Get() return selected end
                function Dropdown:Refresh(newItems)
                    items = newItems
                    BuildItems()
                end
                return Dropdown
            end

            -- ==============================
            -- KEYBIND
            -- ==============================
            function Section:AddKeybind(options)
                options = options or {}
                local name      = options.Name     or "Keybind"
                local default   = options.Default  or Enum.KeyCode.Unknown
                local callback  = options.Callback or function() end
                local configKey = options.Key      or nil

                if configKey then
                    local saved = Config:Get(configKey)
                    if saved then
                        pcall(function() default = Enum.KeyCode[saved] or default end)
                    end
                end

                local boundKey  = default
                local listening = false

                local kbFrame = Create("Frame", {
                    BackgroundColor3 = T.Element,
                    Size = UDim2.new(1, 0, 0, 36),
                    LayoutOrder = NextOrder(),
                    Parent = elemContainer
                })
                Round(kbFrame, 8)
                MakeStroke(kbFrame, T.Stroke, 1, 0.6)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size     = UDim2.new(1, -110, 1, 0),
                    Text     = name,
                    Font     = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextColor3 = T.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = kbFrame
                })

                local keyBadge = Create("TextButton", {
                    BackgroundColor3 = T.Background,
                    BackgroundTransparency = 0.2,
                    Size = UDim2.new(0, 90, 0, 24),
                    Position = UDim2.new(1, -100, 0.5, -12),
                    Text = boundKey == Enum.KeyCode.Unknown and "None" or boundKey.Name,
                    Font = Enum.Font.GothamBold,
                    TextSize = 11,
                    TextColor3 = T.Accent,
                    ZIndex = 3,
                    Parent = kbFrame
                })
                Round(keyBadge, 6)
                MakeStroke(keyBadge, T.Accent, 1.5, 0.4)

                keyBadge.MouseButton1Click:Connect(function()
                    listening = true
                    keyBadge.Text = "Press key..."
                    keyBadge.TextColor3 = T.Warning
                    Tween(keyBadge, { BackgroundColor3 = T.Warning:Lerp(T.Background, 0.8) }, 0.1)
                end)

                UserInputService.InputBegan:Connect(function(inp, gp)
                    if not listening then return end
                    if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end

                    listening = false
                    boundKey = inp.KeyCode

                    -- Update registry
                    for i, entry in pairs(KeybindRegistry) do
                        if entry.Id == tostring(kbFrame) then
                            table.remove(KeybindRegistry, i)
                            break
                        end
                    end
                    table.insert(KeybindRegistry, {
                        Key      = boundKey,
                        Callback = callback,
                        Id       = tostring(kbFrame)
                    })

                    keyBadge.Text = boundKey.Name
                    keyBadge.TextColor3 = T.Accent
                    Tween(keyBadge, { BackgroundColor3 = T.Background }, 0.1)

                    if configKey then Config:Set(configKey, boundKey.Name) end
                end)

                -- Register default
                if boundKey ~= Enum.KeyCode.Unknown then
                    table.insert(KeybindRegistry, {
                        Key      = boundKey,
                        Callback = callback,
                        Id       = tostring(kbFrame)
                    })
                end

                kbFrame.MouseEnter:Connect(function()
                    Tween(kbFrame, { BackgroundColor3 = T.ElementHover }, 0.1)
                end)
                kbFrame.MouseLeave:Connect(function()
                    Tween(kbFrame, { BackgroundColor3 = T.Element }, 0.1)
                end)

                local Keybind = {}
                function Keybind:Get() return boundKey end
                return Keybind
            end

            -- ==============================
            -- COLOR PICKER (Simple Hex)
            -- ==============================
            function Section:AddColorPicker(options)
                options = options or {}
                local name      = options.Name     or "Color"
                local default   = options.Default  or Color3.fromRGB(88, 101, 242)
                local callback  = options.Callback or function() end
                local configKey = options.Key      or nil

                if configKey then
                    local saved = Config:Get(configKey)
                    if saved then
                        pcall(function()
                            default = Color3.fromHex(saved)
                        end)
                    end
                end

                local color = default

                local cpFrame = Create("Frame", {
                    BackgroundColor3 = T.Element,
                    Size = UDim2.new(1, 0, 0, 36),
                    LayoutOrder = NextOrder(),
                    Parent = elemContainer
                })
                Round(cpFrame, 8)
                MakeStroke(cpFrame, T.Stroke, 1, 0.6)

                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size     = UDim2.new(1, -100, 1, 0),
                    Text     = name,
                    Font     = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextColor3 = T.Text,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = cpFrame
                })

                local colorPreview = Create("Frame", {
                    BackgroundColor3 = color,
                    Size = UDim2.new(0, 60, 0, 22),
                    Position = UDim2.new(1, -74, 0.5, -11),
                    Parent = cpFrame
                })
                Round(colorPreview, 6)
                MakeStroke(colorPreview, T.Stroke, 1.5, 0.3)

                local hexBox = Create("TextBox", {
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 6, 0, 0),
                    Size = UDim2.new(1, -12, 1, 0),
                    Text = color:ToHex():upper(),
                    Font = Enum.Font.GothamBold,
                    TextSize = 11,
                    TextColor3 = T.Text,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Parent = colorPreview
                })

                hexBox.FocusLost:Connect(function()
                    local ok, c = pcall(function() return Color3.fromHex(hexBox.Text) end)
                    if ok then
                        color = c
                        colorPreview.BackgroundColor3 = color
                        hexBox.Text = color:ToHex():upper()
                        if configKey then Config:Set(configKey, color:ToHex()) end
                        task.spawn(callback, color)
                    else
                        hexBox.Text = color:ToHex():upper()
                    end
                end)

                cpFrame.MouseEnter:Connect(function()
                    Tween(cpFrame, { BackgroundColor3 = T.ElementHover }, 0.1)
                end)
                cpFrame.MouseLeave:Connect(function()
                    Tween(cpFrame, { BackgroundColor3 = T.Element }, 0.1)
                end)

                local CP = {}
                function CP:Set(c)
                    color = c
                    colorPreview.BackgroundColor3 = c
                    hexBox.Text = c:ToHex():upper()
                end
                function CP:Get() return color end
                return CP
            end

            return Section
        end -- CreateSection

        return Tab
    end -- CreateTab

    -- =====================
    -- NOTIFY (Window-level)
    -- =====================
    function Window:Notify(options)
        SendNotification(options, T)
    end

    -- =====================
    -- CHANGE THEME
    -- =====================
    function Window:SetTheme(name)
        -- Rebuild would be complex; this patches the T reference
        -- For full rebuild, destroy and recreate window
        local newTheme = Themes[name]
        if newTheme then
            for k, v in pairs(newTheme) do T[k] = v end
        end
    end

    -- =====================
    -- SAVE / LOAD CONFIG
    -- =====================
    function Window:SaveConfig(name)
        Config:Save(name)
        self:Notify({ Title = "Config Saved", Desc = "Saved as: " .. (name or "default"), Duration = 3, Color = T.Success })
    end

    function Window:LoadConfig(name)
        Config:Load(name)
        self:Notify({ Title = "Config Loaded", Desc = "Loaded: " .. (name or "default"), Duration = 3, Color = T.Info })
    end

    -- =====================
    -- DESTROY
    -- =====================
    function Window:Destroy()
        pcall(function() ScreenGui:Destroy() end)
        self._destroyed = true
    end

    return Window
end

-- ============================================================
--  STATIC NOTIFY (no window needed)
-- ============================================================
function FilmsFryHub:Notify(options)
    SendNotification(options, Themes.Default)
end

-- ============================================================
--  THEME REGISTRATION
-- ============================================================
function FilmsFryHub:RegisterTheme(name, themeTable)
    Themes[name] = themeTable
end

function FilmsFryHub:GetThemes()
    local names = {}
    for k, _ in pairs(Themes) do table.insert(names, k) end
    return names
end

-- ============================================================
--  RETURN LIBRARY
-- ============================================================
return FilmsFryHub
