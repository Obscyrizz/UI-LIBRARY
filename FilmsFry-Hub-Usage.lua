--[[
╔══════════════════════════════════════════════════════════════╗
║           FilmsFry-Hub — Usage & API Reference               ║
║           Complete Examples for All Components               ║
╚══════════════════════════════════════════════════════════════╝
]]

-- ══════════════════════════════════════════
-- 1. LOADSTRING USAGE (Production)
-- ══════════════════════════════════════════
local Hub = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USER/FilmsFry-Hub/main/FilmsFry-Hub.lua"))()

-- ══════════════════════════════════════════
-- 2. CREATE WINDOW
-- ══════════════════════════════════════════
local Window = Hub:CreateWindow({
    Title = "FilmsFry-Hub",  -- Displayed in the title bar
    Theme = "Default",       -- "Default" | "Crimson" | "Emerald" | any registered theme
})

-- ══════════════════════════════════════════
-- 3. CREATE TABS
-- ══════════════════════════════════════════
local MainTab    = Window:CreateTab("Main",    "⚔")
local PlayerTab  = Window:CreateTab("Player",  "🧍")
local VisualTab  = Window:CreateTab("Visuals", "👁")
local MiscTab    = Window:CreateTab("Misc",    "⚙")

-- ══════════════════════════════════════════
-- 4. CREATE SECTIONS
-- ══════════════════════════════════════════
local CombatSection  = MainTab:CreateSection("Combat", false)   -- false = expanded on start
local AimbotSection  = MainTab:CreateSection("Aimbot", true)    -- true  = collapsed on start
local PlayerSection  = PlayerTab:CreateSection("Movement")
local VisualSection  = VisualTab:CreateSection("ESP")
local MiscSection    = MiscTab:CreateSection("Utility")
local ConfigSection  = MiscTab:CreateSection("Config")

-- ══════════════════════════════════════════
-- 5. ALL AVAILABLE ELEMENTS
-- ══════════════════════════════════════════

-- ─── LABEL ─────────────────────────────────
CombatSection:AddLabel("Combat Settings", "Configure your combat options below.")
-- Simple label (no description)
CombatSection:AddLabel("⚠ Use at your own risk")

-- ─── DIVIDER ───────────────────────────────
CombatSection:AddDivider("— Melee —")      -- with center text
CombatSection:AddDivider()                  -- plain line

-- ─── BUTTON ────────────────────────────────
CombatSection:AddButton({
    Name     = "Kill All",
    Desc     = "Eliminates all players in the server",  -- optional subtitle
    Icon     = "💀",  -- optional emoji icon
    Callback = function()
        print("Kill all triggered!")
        -- your code here
        Window:Notify({
            Title    = "Action Triggered",
            Desc     = "Kill All executed successfully.",
            Duration = 3,
            Color    = Color3.fromRGB(255, 71, 87),
        })
    end
})

CombatSection:AddButton({
    Name     = "Teleport to Closest",
    Callback = function()
        print("Teleporting!")
    end
})

-- ─── TOGGLE ────────────────────────────────
local GodToggle = CombatSection:AddToggle({
    Name     = "God Mode",
    Desc     = "Makes you invincible",    -- optional
    Default  = false,
    Key      = "GodMode",                 -- config save/load key (optional)
    Callback = function(value)
        print("God Mode:", value)
    end
})

-- Controlling a toggle externally:
GodToggle:Set(true)   -- force enable
print(GodToggle:Get()) -- read current state

-- ─── SLIDER ────────────────────────────────
local SpeedSlider = PlayerSection:AddSlider({
    Name     = "Walk Speed",
    Min      = 16,
    Max      = 250,
    Default  = 16,
    Step     = 1,           -- increment per notch
    Suffix   = " stud/s",  -- appended to value display
    Key      = "WalkSpeed", -- config key
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- Controlling slider externally:
SpeedSlider:Set(100)
print(SpeedSlider:Get())

-- ─── TEXTBOX ───────────────────────────────
local NameBox = MiscSection:AddTextbox({
    Name         = "Player Name",
    Placeholder  = "Enter player name...",
    Default      = "",
    ClearOnFocus = true,   -- clears when clicked
    Key          = "TargetName",
    Callback     = function(text, enterPressed)
        if enterPressed then
            print("Submitted:", text)
        end
    end
})

-- Controlling textbox externally:
NameBox:Set("Roblox")
print(NameBox:Get())

-- ─── DROPDOWN ──────────────────────────────
local TeamDD = MiscSection:AddDropdown({
    Name     = "Select Team",
    Items    = { "Red", "Blue", "Green", "Yellow" },
    Default  = "Red",
    Key      = "SelectedTeam",
    Callback = function(selected)
        print("Team selected:", selected)
    end
})

-- Multi-select dropdown:
local FeaturesDD = MiscSection:AddDropdown({
    Name     = "Enable Features",
    Items    = { "ESP", "Aimbot", "Speed", "Fly", "NoClip" },
    Default  = {},       -- empty table = nothing selected
    Multi    = true,     -- enables multi-select mode
    Callback = function(selected)
        -- selected = { ESP = true, Speed = true } etc.
        for feature, _ in pairs(selected) do
            print("Enabled:", feature)
        end
    end
})

-- Controlling dropdowns externally:
TeamDD:Set("Blue")
print(TeamDD:Get())

-- Refresh items dynamically:
TeamDD:Refresh({ "Alpha", "Bravo", "Charlie" })

-- ─── KEYBIND ───────────────────────────────
local FlyBind = MiscSection:AddKeybind({
    Name     = "Fly Toggle",
    Default  = Enum.KeyCode.F,  -- default key
    Key      = "FlyKey",        -- config key
    Callback = function()
        -- fires automatically when key is pressed
        print("Fly toggled via keybind!")
    end
})

print(FlyBind:Get()) -- returns current KeyCode

-- ─── COLOR PICKER ──────────────────────────
local ESPColor = VisualSection:AddColorPicker({
    Name     = "ESP Color",
    Default  = Color3.fromRGB(88, 101, 242),
    Key      = "ESPColor",
    Callback = function(color)
        print("Color changed:", color:ToHex())
    end
})

ESPColor:Set(Color3.fromRGB(255, 100, 100))
print(ESPColor:Get())

-- ══════════════════════════════════════════
-- 6. NOTIFICATION SYSTEM
-- ══════════════════════════════════════════
-- From window object:
Window:Notify({
    Title    = "Welcome!",
    Desc     = "FilmsFry-Hub loaded successfully.",
    Duration = 5,
    Color    = Color3.fromRGB(88, 101, 242),  -- accent color for the side bar
})

-- Success notification:
Window:Notify({
    Title    = "Success",
    Desc     = "Script activated.",
    Duration = 3,
    Color    = Color3.fromRGB(46, 213, 115),
})

-- Error notification:
Window:Notify({
    Title    = "Error",
    Desc     = "Could not connect to server.",
    Duration = 4,
    Color    = Color3.fromRGB(255, 71, 87),
})

-- Without a window (static method):
Hub:Notify({
    Title = "Hub Ready",
    Desc  = "Injected successfully.",
    Duration = 4,
})

-- ══════════════════════════════════════════
-- 7. CONFIG SAVE / LOAD
-- ══════════════════════════════════════════
-- Add config buttons to your Config section:
ConfigSection:AddButton({
    Name     = "💾 Save Config",
    Callback = function()
        Window:SaveConfig("default")
        -- saves to: FilmsFryHub_Configs/default.json
    end
})

ConfigSection:AddButton({
    Name     = "📂 Load Config",
    Callback = function()
        Window:LoadConfig("default")
    end
})

-- ══════════════════════════════════════════
-- 8. THEME SYSTEM
-- ══════════════════════════════════════════
-- Built-in themes: "Default", "Crimson", "Emerald"

-- Switch theme at runtime:
Window:SetTheme("Crimson")

-- Register a custom theme:
Hub:RegisterTheme("Ocean", {
    Background      = Color3.fromRGB(8, 14, 22),
    TitleBar        = Color3.fromRGB(10, 20, 35),
    Section         = Color3.fromRGB(12, 22, 38),
    SectionHeader   = Color3.fromRGB(16, 28, 50),
    Element         = Color3.fromRGB(14, 26, 44),
    ElementHover    = Color3.fromRGB(20, 36, 60),
    ElementActive   = Color3.fromRGB(28, 48, 80),
    Accent          = Color3.fromRGB(0, 180, 255),
    AccentSecondary = Color3.fromRGB(0, 120, 220),
    AccentGlow      = Color3.fromRGB(0, 180, 255),
    Text            = Color3.fromRGB(220, 240, 255),
    TextDim         = Color3.fromRGB(150, 190, 230),
    TextMuted       = Color3.fromRGB(90, 130, 170),
    Success         = Color3.fromRGB(46, 213, 115),
    Warning         = Color3.fromRGB(255, 171, 0),
    Error           = Color3.fromRGB(255, 71, 87),
    Info            = Color3.fromRGB(88, 177, 255),
    Stroke          = Color3.fromRGB(30, 70, 120),
    StrokeAccent    = Color3.fromRGB(0, 180, 255),
    Toggle_Off      = Color3.fromRGB(20, 50, 80),
    Toggle_On       = Color3.fromRGB(0, 180, 255),
    Slider_Track    = Color3.fromRGB(18, 44, 72),
    Slider_Fill     = Color3.fromRGB(0, 180, 255),
    Slider_Thumb    = Color3.fromRGB(180, 230, 255),
    Dropdown_Arrow  = Color3.fromRGB(120, 180, 230),
    Scrollbar       = Color3.fromRGB(30, 80, 130),
    Notification_BG = Color3.fromRGB(10, 20, 35),
})

-- List all available themes:
print(Hub:GetThemes()) -- { "Default", "Crimson", "Emerald", "Ocean" }

-- ══════════════════════════════════════════
-- 9. DESTROY WINDOW
-- ══════════════════════════════════════════
-- Clean removal of the entire UI:
-- Window:Destroy()

-- ══════════════════════════════════════════
-- 10. WELCOME NOTIFICATION ON LOAD
-- ══════════════════════════════════════════
task.wait(0.5)
Window:Notify({
    Title    = "FilmsFry-Hub",
    Desc     = "Loaded! Press the toggle button to show/hide UI.",
    Duration = 5,
    Color    = Color3.fromRGB(88, 101, 242),
})
