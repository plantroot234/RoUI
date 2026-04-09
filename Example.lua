--[[
    RoUI Example Script
    Put this in a LocalScript inside StarterPlayerScripts

    HOW TO LOAD:
        local RoUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/plantroot234/RoUI/main/RoUI.lua"))()

    WITHOUT key system:
        local Window = RoUI:CreateWindow({ Title = "My Script" })

    WITH key system:
        local Window = RoUI:CreateWindow({ Title = "My Script", Key = "secretkey123" })
]]

-- Load the library
local RoUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/plantroot234/RoUI/main/RoUI.lua"))()

-- Create the window (remove Key = "..." to disable the key system)
local Window = RoUI:CreateWindow({
    Title = "My Roblox Script",
    Key   = "roui2024",       -- <-- players must type this to open the UI
})

-- ============================================================
--  TAB 1: Combat
-- ============================================================
local CombatTab = Window:AddTab("Combat")

CombatTab:AddSection("Player")

local godToggle = CombatTab:AddToggle({
    Text     = "God Mode",
    Default  = false,
    Callback = function(enabled)
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.MaxHealth = enabled and math.huge or 100
                hum.Health    = hum.MaxHealth
            end
        end
    end,
})

CombatTab:AddSlider({
    Text     = "Walk Speed",
    Min      = 16,
    Max      = 200,
    Default  = 16,
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v end
        end
    end,
})

CombatTab:AddSlider({
    Text     = "Jump Power",
    Min      = 50,
    Max      = 500,
    Default  = 50,
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.JumpPower = v end
        end
    end,
})

CombatTab:AddSection("Tools")

CombatTab:AddButton({
    Text     = "Reset Character",
    Callback = function()
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
    end,
})

-- ============================================================
--  TAB 2: Visual
-- ============================================================
local VisualTab = Window:AddTab("Visual")

VisualTab:AddSection("Rendering")

local espToggle = VisualTab:AddToggle({
    Text     = "ESP / Highlights",
    Default  = false,
    Callback = function(enabled)
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= game.Players.LocalPlayer and plr.Character then
                local hl = plr.Character:FindFirstChild("RoUI_HL")
                if enabled then
                    if not hl then
                        hl = Instance.new("SelectionBox")
                        hl.Name      = "RoUI_HL"
                        hl.Adornee   = plr.Character
                        hl.LineThickness = 0.05
                        hl.Color3    = Color3.fromRGB(99, 102, 241)
                        hl.Parent    = plr.Character
                    end
                else
                    if hl then hl:Destroy() end
                end
            end
        end
    end,
})

VisualTab:AddColorPicker({
    Text    = "ESP Color",
    Default = Color3.fromRGB(99, 102, 241),
    Callback = function(color)
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr.Character then
                local hl = plr.Character:FindFirstChild("RoUI_HL")
                if hl then hl.Color3 = color end
            end
        end
    end,
})

VisualTab:AddSection("Misc")

local fovLabel = VisualTab:AddLabel({ Text = "FOV: 70" })

VisualTab:AddSlider({
    Text     = "Field of View",
    Min      = 30,
    Max      = 120,
    Default  = 70,
    Callback = function(v)
        workspace.CurrentCamera.FieldOfView = v
        fovLabel:Set("FOV: " .. v)
    end,
})

-- ============================================================
--  TAB 3: Settings
-- ============================================================
local SettingsTab = Window:AddTab("Settings")

SettingsTab:AddSection("Keybinds")

SettingsTab:AddKeybind({
    Text    = "Toggle UI",
    Default = Enum.KeyCode.RightShift,
    -- OnPress is called when the key is pressed in-game
    OnPress = function()
        print("UI toggle key pressed!")
    end,
    Callback = function(key)
        print("Keybind changed to:", key.Name)
    end,
})

SettingsTab:AddSection("Account")

local nameInput = SettingsTab:AddInput({
    Text        = "Discord Username",
    Placeholder = "yourname#0000",
    Callback = function(text, pressedEnter)
        if pressedEnter then
            print("Username saved:", text)
        end
    end,
})

SettingsTab:AddDropdown({
    Text    = "Theme",
    Options = { "Indigo (Default)", "Red", "Green", "Orange" },
    Default = "Indigo (Default)",
    Callback = function(choice)
        print("Theme selected:", choice)
    end,
})

SettingsTab:AddButton({
    Text     = "Save Settings",
    Callback = function()
        print("Settings saved!")
        print("Username:", nameInput:Get())
    end,
})
