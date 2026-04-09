--[[
    RoUI - Roblox UI Library
    by plantroot234

    Usage:
        local RoUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/plantroot234/RoUI/main/RoUI.lua"))()
        local Window = RoUI:CreateWindow({ Title = "My Script", Key = "mykey123" }) -- Key is optional
        local Tab = Window:AddTab("Main")
        Tab:AddButton({ Text = "Click Me", Callback = function() print("clicked") end })
        Tab:AddToggle({ Text = "God Mode", Default = false, Callback = function(v) print(v) end })
]]

-- ============================================================
--  SERVICES
-- ============================================================
local Players        = game:GetService("Players")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService     = game:GetService("RunService")

local LocalPlayer   = Players.LocalPlayer
local PlayerGui     = LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
--  THEME
-- ============================================================
local Theme = {
    Background   = Color3.fromRGB(18, 18, 24),
    Surface      = Color3.fromRGB(26, 26, 36),
    SurfaceAlt   = Color3.fromRGB(32, 32, 46),
    Accent       = Color3.fromRGB(99, 102, 241),   -- indigo
    AccentHover  = Color3.fromRGB(129, 132, 255),
    AccentOff    = Color3.fromRGB(55, 55, 75),
    Text         = Color3.fromRGB(230, 230, 240),
    TextDim      = Color3.fromRGB(140, 140, 160),
    Border       = Color3.fromRGB(50, 50, 70),
    Success      = Color3.fromRGB(52, 211, 153),
    Danger       = Color3.fromRGB(239, 68, 68),
    Warning      = Color3.fromRGB(251, 191, 36),
}

-- ============================================================
--  UTILITY
-- ============================================================
local function tween(obj, props, t, style, dir)
    style = style or Enum.EasingStyle.Quad
    dir   = dir   or Enum.EasingDirection.Out
    return TweenService:Create(obj, TweenInfo.new(t or 0.18, style, dir), props)
end

local function corner(r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    return c
end

local function stroke(color, thick)
    local s = Instance.new("UIStroke")
    s.Color     = color or Theme.Border
    s.Thickness = thick or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return s
end

local function padding(t, r, b, l)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 0)
    p.PaddingRight  = UDim.new(0, r or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft   = UDim.new(0, l or 0)
    return p
end

local function listLayout(spacing, dir, align)
    local l = Instance.new("UIListLayout")
    l.Padding          = UDim.new(0, spacing or 6)
    l.FillDirection    = dir   or Enum.FillDirection.Vertical
    l.HorizontalAlignment = align or Enum.HorizontalAlignment.Left
    l.SortOrder        = Enum.SortOrder.LayoutOrder
    return l
end

-- ============================================================
--  LIBRARY TABLE
-- ============================================================
local RoUI = {}
RoUI.__index = RoUI

-- ============================================================
--  KEY SYSTEM
-- ============================================================
local function ShowKeySystem(requiredKey, callback)
    local sg = Instance.new("ScreenGui")
    sg.Name             = "RoUI_Key"
    sg.ResetOnSpawn     = false
    sg.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    sg.Parent           = PlayerGui

    -- Overlay
    local overlay = Instance.new("Frame")
    overlay.Size            = UDim2.fromScale(1, 1)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.ZIndex          = 10
    overlay.Parent          = sg

    -- Card
    local card = Instance.new("Frame")
    card.Size               = UDim2.fromOffset(360, 220)
    card.AnchorPoint        = Vector2.new(0.5, 0.5)
    card.Position           = UDim2.fromScale(0.5, 0.5)
    card.BackgroundColor3   = Theme.Background
    card.ZIndex             = 11
    card.Parent             = sg
    corner(10):Parent = card
    stroke(Theme.Accent, 1.5):Parent = card

    -- Title
    local title = Instance.new("TextLabel")
    title.Size              = UDim2.new(1, 0, 0, 40)
    title.Position          = UDim2.fromOffset(0, 16)
    title.BackgroundTransparency = 1
    title.Text              = "Key Required"
    title.Font              = Enum.Font.GothamBold
    title.TextSize          = 18
    title.TextColor3        = Theme.Text
    title.ZIndex            = 12
    title.Parent            = card

    local subtitle = Instance.new("TextLabel")
    subtitle.Size           = UDim2.new(1, -32, 0, 24)
    subtitle.Position       = UDim2.fromOffset(16, 52)
    subtitle.BackgroundTransparency = 1
    subtitle.Text           = "Enter your key to continue"
    subtitle.Font           = Enum.Font.Gotham
    subtitle.TextSize       = 13
    subtitle.TextColor3     = Theme.TextDim
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex         = 12
    subtitle.Parent         = card

    -- Input box
    local inputBox = Instance.new("Frame")
    inputBox.Size           = UDim2.new(1, -32, 0, 38)
    inputBox.Position       = UDim2.fromOffset(16, 88)
    inputBox.BackgroundColor3 = Theme.SurfaceAlt
    inputBox.ZIndex         = 12
    inputBox.Parent         = card
    corner(6):Parent = inputBox
    stroke(Theme.Border):Parent = inputBox

    local input = Instance.new("TextBox")
    input.Size              = UDim2.new(1, -16, 1, 0)
    input.Position          = UDim2.fromOffset(8, 0)
    input.BackgroundTransparency = 1
    input.PlaceholderText   = "Paste your key here..."
    input.PlaceholderColor3 = Theme.TextDim
    input.Text              = ""
    input.Font              = Enum.Font.GothamMono
    input.TextSize          = 13
    input.TextColor3        = Theme.Text
    input.ClearTextOnFocus  = false
    input.ZIndex            = 13
    input.Parent            = inputBox

    -- Status label
    local status = Instance.new("TextLabel")
    status.Size             = UDim2.new(1, -32, 0, 20)
    status.Position         = UDim2.fromOffset(16, 134)
    status.BackgroundTransparency = 1
    status.Text             = ""
    status.Font             = Enum.Font.Gotham
    status.TextSize         = 12
    status.TextColor3       = Theme.Danger
    status.TextXAlignment   = Enum.TextXAlignment.Left
    status.ZIndex           = 12
    status.Parent           = card

    -- Submit button
    local btn = Instance.new("TextButton")
    btn.Size                = UDim2.new(1, -32, 0, 36)
    btn.Position            = UDim2.fromOffset(16, 162)
    btn.BackgroundColor3    = Theme.Accent
    btn.Text                = "Confirm"
    btn.Font                = Enum.Font.GothamBold
    btn.TextSize            = 14
    btn.TextColor3          = Color3.new(1, 1, 1)
    btn.ZIndex              = 12
    btn.Parent              = card
    corner(6):Parent = btn

    btn.MouseButton1Click:Connect(function()
        if input.Text == requiredKey then
            tween(sg.Frame, { BackgroundTransparency = 1 }, 0.3):Play()
            tween(card, { BackgroundTransparency = 1 }, 0.3):Play()
            task.delay(0.3, function()
                sg:Destroy()
                callback(true)
            end)
        else
            status.Text = "Invalid key. Please try again."
            tween(inputBox, { BackgroundColor3 = Color3.fromRGB(60, 20, 20) }, 0.1):Play()
            task.delay(0.5, function()
                tween(inputBox, { BackgroundColor3 = Theme.SurfaceAlt }, 0.2):Play()
            end)
        end
    end)

    -- Animate in
    card.Position = UDim2.new(0.5, 0, 0.5, 40)
    card.BackgroundTransparency = 1
    tween(card, { Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0 }, 0.3, Enum.EasingStyle.Back):Play()
end

-- ============================================================
--  LOADING SCREEN
-- ============================================================
local function ShowLoading(title, callback)
    local sg = Instance.new("ScreenGui")
    sg.Name             = "RoUI_Loading"
    sg.ResetOnSpawn     = false
    sg.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
    sg.Parent           = PlayerGui

    local frame = Instance.new("Frame")
    frame.Size              = UDim2.fromScale(1, 1)
    frame.BackgroundColor3  = Theme.Background
    frame.BackgroundTransparency = 0
    frame.ZIndex            = 20
    frame.Parent            = sg

    -- Logo / title
    local logoLabel = Instance.new("TextLabel")
    logoLabel.Size          = UDim2.new(1, 0, 0, 50)
    logoLabel.AnchorPoint   = Vector2.new(0.5, 0.5)
    logoLabel.Position      = UDim2.fromScale(0.5, 0.42)
    logoLabel.BackgroundTransparency = 1
    logoLabel.Text          = title or "RoUI"
    logoLabel.Font          = Enum.Font.GothamBold
    logoLabel.TextSize      = 36
    logoLabel.TextColor3    = Theme.Text
    logoLabel.ZIndex        = 21
    logoLabel.Parent        = frame

    -- Spinner container
    local spinnerFrame = Instance.new("Frame")
    spinnerFrame.Size       = UDim2.fromOffset(48, 48)
    spinnerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    spinnerFrame.Position   = UDim2.fromScale(0.5, 0.55)
    spinnerFrame.BackgroundTransparency = 1
    spinnerFrame.ZIndex     = 21
    spinnerFrame.Parent     = frame

    -- Spinner arc (fake with rotating image)
    local spinnerOuter = Instance.new("Frame")
    spinnerOuter.Size       = UDim2.fromOffset(48, 48)
    spinnerOuter.BackgroundTransparency = 1
    spinnerOuter.ZIndex     = 22
    spinnerOuter.Parent     = spinnerFrame

    local arc = Instance.new("UIStroke")
    arc.Color               = Theme.Accent
    arc.Thickness           = 4
    arc.ApplyStrokeMode     = Enum.ApplyStrokeMode.Border
    arc.Parent              = spinnerOuter
    corner(24):Parent = spinnerOuter

    local arcBack = Instance.new("Frame")
    arcBack.Size            = UDim2.fromOffset(48, 48)
    arcBack.BackgroundTransparency = 1
    arcBack.ZIndex          = 21
    arcBack.Parent          = spinnerFrame
    local arcBackStroke = Instance.new("UIStroke")
    arcBackStroke.Color     = Theme.Border
    arcBackStroke.Thickness = 4
    arcBackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    arcBackStroke.Parent    = arcBack
    corner(24):Parent = arcBack

    -- Animate spinner by rotating a half-mask
    local mask = Instance.new("Frame")
    mask.Size               = UDim2.fromOffset(48, 24)
    mask.BackgroundColor3   = Theme.Background
    mask.BorderSizePixel    = 0
    mask.ZIndex             = 23
    mask.Parent             = spinnerFrame

    -- Progress bar
    local barBg = Instance.new("Frame")
    barBg.Size              = UDim2.fromOffset(220, 4)
    barBg.AnchorPoint       = Vector2.new(0.5, 0.5)
    barBg.Position          = UDim2.fromScale(0.5, 0.65)
    barBg.BackgroundColor3  = Theme.SurfaceAlt
    barBg.ZIndex            = 21
    barBg.Parent            = frame
    corner(4):Parent = barBg

    local bar = Instance.new("Frame")
    bar.Size                = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3    = Theme.Accent
    bar.ZIndex              = 22
    bar.Parent              = barBg
    corner(4):Parent = bar

    -- Status text
    local loadStatus = Instance.new("TextLabel")
    loadStatus.Size         = UDim2.new(1, 0, 0, 24)
    loadStatus.AnchorPoint  = Vector2.new(0.5, 0.5)
    loadStatus.Position     = UDim2.fromScale(0.5, 0.7)
    loadStatus.BackgroundTransparency = 1
    loadStatus.Text         = "Initializing..."
    loadStatus.Font         = Enum.Font.Gotham
    loadStatus.TextSize     = 13
    loadStatus.TextColor3   = Theme.TextDim
    loadStatus.ZIndex       = 21
    loadStatus.Parent       = frame

    -- Spin animation
    local angle = 0
    local spinConn = RunService.RenderStepped:Connect(function(dt)
        angle = (angle + dt * 200) % 360
        spinnerOuter.Rotation = angle
    end)

    -- Fake load stages
    local stages = {
        { text = "Loading assets...",    pct = 0.25 },
        { text = "Setting up UI...",     pct = 0.55 },
        { text = "Applying theme...",    pct = 0.80 },
        { text = "Ready!",               pct = 1.00 },
    }

    task.spawn(function()
        for _, s in ipairs(stages) do
            task.wait(0.4)
            loadStatus.Text = s.text
            tween(bar, { Size = UDim2.new(s.pct, 0, 1, 0) }, 0.35):Play()
        end
        task.wait(0.3)
        spinConn:Disconnect()

        -- Fade out
        tween(frame, { BackgroundTransparency = 1 }, 0.45):Play()
        tween(logoLabel, { TextTransparency = 1 }, 0.35):Play()
        task.delay(0.5, function()
            sg:Destroy()
            callback()
        end)
    end)
end

-- ============================================================
--  WINDOW
-- ============================================================
function RoUI:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "RoUI"
    local requiredKey = config.Key   -- optional

    local win = {}
    local tabs = {}
    local activeTab = nil

    local function buildWindow()
        -- ScreenGui
        local sg = Instance.new("ScreenGui")
        sg.Name             = "RoUI_" .. windowTitle
        sg.ResetOnSpawn     = false
        sg.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
        sg.IgnoreGuiInset   = true
        sg.Parent           = PlayerGui

        -- Main frame
        local mainFrame = Instance.new("Frame")
        mainFrame.Size              = UDim2.fromOffset(520, 400)
        mainFrame.AnchorPoint       = Vector2.new(0.5, 0.5)
        mainFrame.Position          = UDim2.fromScale(0.5, 0.5)
        mainFrame.BackgroundColor3  = Theme.Background
        mainFrame.ClipsDescendants  = true
        mainFrame.Parent            = sg
        corner(10):Parent = mainFrame
        stroke(Theme.Border):Parent = mainFrame

        -- Animate in
        mainFrame.Position = UDim2.new(0.5, 0, 0.5, 30)
        mainFrame.BackgroundTransparency = 1
        tween(mainFrame, { Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0 }, 0.35, Enum.EasingStyle.Back):Play()

        -- Title bar
        local titleBar = Instance.new("Frame")
        titleBar.Size               = UDim2.new(1, 0, 0, 44)
        titleBar.BackgroundColor3   = Theme.Surface
        titleBar.ZIndex             = 2
        titleBar.Parent             = mainFrame

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size             = UDim2.new(1, -80, 1, 0)
        titleLabel.Position         = UDim2.fromOffset(16, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text             = windowTitle
        titleLabel.Font             = Enum.Font.GothamBold
        titleLabel.TextSize         = 15
        titleLabel.TextColor3       = Theme.Text
        titleLabel.TextXAlignment   = Enum.TextXAlignment.Left
        titleLabel.ZIndex           = 3
        titleLabel.Parent           = titleBar

        -- Close button
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size               = UDim2.fromOffset(28, 28)
        closeBtn.AnchorPoint        = Vector2.new(1, 0.5)
        closeBtn.Position           = UDim2.new(1, -10, 0.5, 0)
        closeBtn.BackgroundColor3   = Theme.Danger
        closeBtn.Text               = "×"
        closeBtn.Font               = Enum.Font.GothamBold
        closeBtn.TextSize           = 16
        closeBtn.TextColor3         = Color3.new(1, 1, 1)
        closeBtn.ZIndex             = 4
        closeBtn.Parent             = titleBar
        corner(6):Parent = closeBtn

        closeBtn.MouseButton1Click:Connect(function()
            tween(mainFrame, { Size = UDim2.fromOffset(520, 0), BackgroundTransparency = 1 }, 0.25, Enum.EasingStyle.Quad):Play()
            task.delay(0.28, function() sg:Destroy() end)
        end)

        -- Minimize button
        local minBtn = Instance.new("TextButton")
        minBtn.Size                 = UDim2.fromOffset(28, 28)
        minBtn.AnchorPoint          = Vector2.new(1, 0.5)
        minBtn.Position             = UDim2.new(1, -44, 0.5, 0)
        minBtn.BackgroundColor3     = Theme.Warning
        minBtn.Text                 = "–"
        minBtn.Font                 = Enum.Font.GothamBold
        minBtn.TextSize             = 16
        minBtn.TextColor3           = Color3.new(0, 0, 0)
        minBtn.ZIndex               = 4
        minBtn.Parent               = titleBar
        corner(6):Parent = minBtn

        local minimized = false
        minBtn.MouseButton1Click:Connect(function()
            minimized = not minimized
            if minimized then
                tween(mainFrame, { Size = UDim2.fromOffset(520, 44) }, 0.22):Play()
            else
                tween(mainFrame, { Size = UDim2.fromOffset(520, 400) }, 0.22):Play()
            end
        end)

        -- Drag
        local dragging, dragStart, startPos = false, nil, nil
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos  = mainFrame.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        -- Tab bar
        local tabBar = Instance.new("Frame")
        tabBar.Size                 = UDim2.new(1, 0, 0, 36)
        tabBar.Position             = UDim2.fromOffset(0, 44)
        tabBar.BackgroundColor3     = Theme.SurfaceAlt
        tabBar.ZIndex               = 2
        tabBar.Parent               = mainFrame
        listLayout(0, Enum.FillDirection.Horizontal):Parent = tabBar
        padding(4, 8, 4, 8):Parent = tabBar

        -- Tab separator line
        local sep = Instance.new("Frame")
        sep.Size                    = UDim2.new(1, 0, 0, 1)
        sep.Position                = UDim2.fromOffset(0, 80)
        sep.BackgroundColor3        = Theme.Border
        sep.BorderSizePixel         = 0
        sep.ZIndex                  = 2
        sep.Parent                  = mainFrame

        -- Content area
        local contentArea = Instance.new("Frame")
        contentArea.Size            = UDim2.new(1, 0, 1, -82)
        contentArea.Position        = UDim2.fromOffset(0, 82)
        contentArea.BackgroundTransparency = 1
        contentArea.ZIndex          = 2
        contentArea.Parent          = mainFrame

        -- --------------------------------------------------------
        --  AddTab
        -- --------------------------------------------------------
        function win:AddTab(name)
            local tab = {}
            local components = {}

            -- Tab button
            local tabBtn = Instance.new("TextButton")
            tabBtn.Size             = UDim2.fromOffset(0, 28)
            tabBtn.AutomaticSize    = Enum.AutomaticSize.X
            tabBtn.BackgroundColor3 = Theme.SurfaceAlt
            tabBtn.BackgroundTransparency = 1
            tabBtn.Text             = name
            tabBtn.Font             = Enum.Font.GothamSemibold
            tabBtn.TextSize         = 13
            tabBtn.TextColor3       = Theme.TextDim
            tabBtn.ZIndex           = 3
            tabBtn.Parent           = tabBar
            padding(0, 14, 0, 14):Parent = tabBtn
            corner(6):Parent = tabBtn

            -- Tab underline
            local underline = Instance.new("Frame")
            underline.Size          = UDim2.new(0, 0, 0, 2)
            underline.AnchorPoint   = Vector2.new(0.5, 1)
            underline.Position      = UDim2.new(0.5, 0, 1, 1)
            underline.BackgroundColor3 = Theme.Accent
            underline.BorderSizePixel = 0
            underline.ZIndex        = 4
            underline.Parent        = tabBtn
            corner(2):Parent = underline

            -- Scroll frame for components
            local scroll = Instance.new("ScrollingFrame")
            scroll.Size             = UDim2.fromScale(1, 1)
            scroll.BackgroundTransparency = 1
            scroll.BorderSizePixel  = 0
            scroll.ScrollBarThickness = 3
            scroll.ScrollBarImageColor3 = Theme.Accent
            scroll.CanvasSize       = UDim2.fromOffset(0, 0)
            scroll.Visible          = false
            scroll.ZIndex           = 3
            scroll.Parent           = contentArea
            padding(8, 12, 8, 12):Parent = scroll

            local layout = listLayout(8)
            layout.Parent = scroll
            layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                scroll.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16)
            end)

            -- Activate tab
            local function activate()
                if activeTab then
                    activeTab.scroll.Visible = false
                    tween(activeTab.tabBtn, { TextColor3 = Theme.TextDim }, 0.15):Play()
                    tween(activeTab.underline, { Size = UDim2.new(0, 0, 0, 2) }, 0.15):Play()
                    activeTab.tabBtn.BackgroundTransparency = 1
                end
                activeTab = { scroll = scroll, tabBtn = tabBtn, underline = underline }
                scroll.Visible = true
                tween(tabBtn, { TextColor3 = Theme.Text }, 0.15):Play()
                tween(underline, { Size = UDim2.new(1, 0, 0, 2) }, 0.2, Enum.EasingStyle.Back):Play()
            end

            tabBtn.MouseButton1Click:Connect(activate)

            if #tabs == 0 then
                task.defer(activate)
            end
            table.insert(tabs, tab)

            -- Helper: add a row container
            local function newRow(height)
                local row = Instance.new("Frame")
                row.Size            = UDim2.new(1, 0, 0, height or 36)
                row.BackgroundTransparency = 1
                row.ZIndex          = 4
                row.Parent          = scroll
                return row
            end

            -- Helper: section label
            local function sectionLabel(text, parent)
                local lbl = Instance.new("TextLabel")
                lbl.Size            = UDim2.new(1, 0, 0, 22)
                lbl.BackgroundTransparency = 1
                lbl.Text            = text
                lbl.Font            = Enum.Font.GothamSemibold
                lbl.TextSize        = 12
                lbl.TextColor3      = Theme.TextDim
                lbl.TextXAlignment  = Enum.TextXAlignment.Left
                lbl.ZIndex          = 5
                lbl.Parent          = parent
                return lbl
            end

            -- ====================================================
            --  SECTION DIVIDER
            -- ====================================================
            function tab:AddSection(text)
                local row = newRow(30)
                local line = Instance.new("Frame")
                line.Size           = UDim2.new(1, 0, 0, 1)
                line.Position       = UDim2.fromOffset(0, 14)
                line.BackgroundColor3 = Theme.Border
                line.BorderSizePixel = 0
                line.ZIndex         = 5
                line.Parent         = row

                local lbl = Instance.new("TextLabel")
                lbl.Size            = UDim2.fromOffset(0, 22)
                lbl.AutomaticSize   = Enum.AutomaticSize.X
                lbl.AnchorPoint     = Vector2.new(0, 0.5)
                lbl.Position        = UDim2.fromOffset(0, 14)
                lbl.BackgroundColor3 = Theme.Background
                lbl.Text            = "  " .. text .. "  "
                lbl.Font            = Enum.Font.GothamSemibold
                lbl.TextSize        = 11
                lbl.TextColor3      = Theme.TextDim
                lbl.ZIndex          = 6
                lbl.Parent          = row
            end

            -- ====================================================
            --  BUTTON
            -- ====================================================
            function tab:AddButton(config)
                config = config or {}
                local row = newRow(38)

                local btn = Instance.new("TextButton")
                btn.Size            = UDim2.fromScale(1, 1)
                btn.BackgroundColor3 = Theme.SurfaceAlt
                btn.Text            = ""
                btn.ZIndex          = 5
                btn.Parent          = row
                corner(6):Parent = btn
                stroke(Theme.Border, 1):Parent = btn

                local label = Instance.new("TextLabel")
                label.Size          = UDim2.fromScale(1, 1)
                label.BackgroundTransparency = 1
                label.Text          = config.Text or "Button"
                label.Font          = Enum.Font.GothamSemibold
                label.TextSize      = 13
                label.TextColor3    = Theme.Text
                label.ZIndex        = 6
                label.Parent        = btn

                btn.MouseEnter:Connect(function()
                    tween(btn, { BackgroundColor3 = Theme.Accent }, 0.15):Play()
                end)
                btn.MouseLeave:Connect(function()
                    tween(btn, { BackgroundColor3 = Theme.SurfaceAlt }, 0.15):Play()
                end)
                btn.MouseButton1Down:Connect(function()
                    tween(btn, { BackgroundColor3 = Theme.AccentHover }, 0.1):Play()
                end)
                btn.MouseButton1Click:Connect(function()
                    tween(btn, { BackgroundColor3 = Theme.SurfaceAlt }, 0.15):Play()
                    if config.Callback then config.Callback() end
                end)

                return btn
            end

            -- ====================================================
            --  TOGGLE
            -- ====================================================
            function tab:AddToggle(config)
                config = config or {}
                local state = config.Default == true

                local row = newRow(38)

                local bg = Instance.new("Frame")
                bg.Size             = UDim2.fromScale(1, 1)
                bg.BackgroundColor3 = Theme.SurfaceAlt
                bg.ZIndex           = 5
                bg.Parent           = row
                corner(6):Parent = bg
                stroke(Theme.Border, 1):Parent = bg

                local label = Instance.new("TextLabel")
                label.Size          = UDim2.new(1, -60, 1, 0)
                label.Position      = UDim2.fromOffset(12, 0)
                label.BackgroundTransparency = 1
                label.Text          = config.Text or "Toggle"
                label.Font          = Enum.Font.GothamSemibold
                label.TextSize      = 13
                label.TextColor3    = Theme.Text
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex        = 6
                label.Parent        = bg

                -- Track
                local track = Instance.new("Frame")
                track.Size          = UDim2.fromOffset(42, 22)
                track.AnchorPoint   = Vector2.new(1, 0.5)
                track.Position      = UDim2.new(1, -12, 0.5, 0)
                track.BackgroundColor3 = state and Theme.Accent or Theme.AccentOff
                track.ZIndex        = 6
                track.Parent        = bg
                corner(11):Parent = track

                -- Knob
                local knob = Instance.new("Frame")
                knob.Size           = UDim2.fromOffset(16, 16)
                knob.AnchorPoint    = Vector2.new(0, 0.5)
                knob.Position       = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
                knob.BackgroundColor3 = Color3.new(1, 1, 1)
                knob.ZIndex         = 7
                knob.Parent         = track
                corner(8):Parent = knob

                local togObj = {}

                local function setToggle(val, silent)
                    state = val
                    tween(track, { BackgroundColor3 = state and Theme.Accent or Theme.AccentOff }, 0.18):Play()
                    tween(knob, { Position = state and UDim2.new(1, -19, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) }, 0.18, Enum.EasingStyle.Back):Play()
                    if not silent and config.Callback then config.Callback(state) end
                end

                local btn = Instance.new("TextButton")
                btn.Size            = UDim2.fromScale(1, 1)
                btn.BackgroundTransparency = 1
                btn.Text            = ""
                btn.ZIndex          = 8
                btn.Parent          = bg
                btn.MouseButton1Click:Connect(function()
                    setToggle(not state)
                end)

                function togObj:Set(val) setToggle(val, true) end
                function togObj:Get() return state end

                return togObj
            end

            -- ====================================================
            --  SLIDER
            -- ====================================================
            function tab:AddSlider(config)
                config = config or {}
                local min    = config.Min     or 0
                local max    = config.Max     or 100
                local def    = config.Default or min
                local value  = def

                local row = newRow(52)

                local bg = Instance.new("Frame")
                bg.Size             = UDim2.fromScale(1, 1)
                bg.BackgroundColor3 = Theme.SurfaceAlt
                bg.ZIndex           = 5
                bg.Parent           = row
                corner(6):Parent = bg
                stroke(Theme.Border, 1):Parent = bg

                local label = Instance.new("TextLabel")
                label.Size          = UDim2.new(1, -70, 0, 22)
                label.Position      = UDim2.fromOffset(12, 6)
                label.BackgroundTransparency = 1
                label.Text          = config.Text or "Slider"
                label.Font          = Enum.Font.GothamSemibold
                label.TextSize      = 13
                label.TextColor3    = Theme.Text
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex        = 6
                label.Parent        = bg

                local valLabel = Instance.new("TextLabel")
                valLabel.Size       = UDim2.fromOffset(60, 22)
                valLabel.AnchorPoint = Vector2.new(1, 0)
                valLabel.Position   = UDim2.new(1, -10, 0, 6)
                valLabel.BackgroundTransparency = 1
                valLabel.Text       = tostring(value)
                valLabel.Font       = Enum.Font.GothamMono
                valLabel.TextSize   = 12
                valLabel.TextColor3 = Theme.Accent
                valLabel.TextXAlignment = Enum.TextXAlignment.Right
                valLabel.ZIndex     = 6
                valLabel.Parent     = bg

                -- Track
                local trackBg = Instance.new("Frame")
                trackBg.Size        = UDim2.new(1, -24, 0, 6)
                trackBg.Position    = UDim2.new(0, 12, 0, 34)
                trackBg.BackgroundColor3 = Theme.AccentOff
                trackBg.ZIndex      = 6
                trackBg.Parent      = bg
                corner(3):Parent = trackBg

                local fill = Instance.new("Frame")
                fill.Size           = UDim2.new((value - min) / (max - min), 0, 1, 0)
                fill.BackgroundColor3 = Theme.Accent
                fill.ZIndex         = 7
                fill.Parent         = trackBg
                corner(3):Parent = fill

                local thumb = Instance.new("Frame")
                thumb.Size          = UDim2.fromOffset(14, 14)
                thumb.AnchorPoint   = Vector2.new(0.5, 0.5)
                thumb.Position      = UDim2.new((value - min) / (max - min), 0, 0.5, 0)
                thumb.BackgroundColor3 = Color3.new(1, 1, 1)
                thumb.ZIndex        = 8
                thumb.Parent        = trackBg
                corner(7):Parent = thumb

                local sliderObj = {}
                local draggingSlider = false

                local function updateSlider(input)
                    local rel = (input.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X
                    rel = math.clamp(rel, 0, 1)
                    value = math.floor(min + rel * (max - min) + 0.5)
                    valLabel.Text = tostring(value)
                    tween(fill,  { Size  = UDim2.new(rel, 0, 1, 0) }, 0.05):Play()
                    tween(thumb, { Position = UDim2.new(rel, 0, 0.5, 0) }, 0.05):Play()
                    if config.Callback then config.Callback(value) end
                end

                trackBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSlider = true
                        updateSlider(input)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input)
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        draggingSlider = false
                    end
                end)

                function sliderObj:Set(v)
                    value = math.clamp(v, min, max)
                    local rel = (value - min) / (max - min)
                    valLabel.Text = tostring(value)
                    fill.Size  = UDim2.new(rel, 0, 1, 0)
                    thumb.Position = UDim2.new(rel, 0, 0.5, 0)
                end
                function sliderObj:Get() return value end
                return sliderObj
            end

            -- ====================================================
            --  DROPDOWN
            -- ====================================================
            function tab:AddDropdown(config)
                config = config or {}
                local options  = config.Options or {}
                local selected = config.Default or options[1] or ""
                local open     = false

                local row = newRow(38)

                local bg = Instance.new("Frame")
                bg.Size             = UDim2.fromScale(1, 1)
                bg.BackgroundColor3 = Theme.SurfaceAlt
                bg.ZIndex           = 5
                bg.ClipsDescendants = false
                bg.Parent           = row
                corner(6):Parent = bg
                stroke(Theme.Border, 1):Parent = bg

                local label = Instance.new("TextLabel")
                label.Size          = UDim2.new(1, -100, 1, 0)
                label.Position      = UDim2.fromOffset(12, 0)
                label.BackgroundTransparency = 1
                label.Text          = config.Text or "Dropdown"
                label.Font          = Enum.Font.GothamSemibold
                label.TextSize      = 13
                label.TextColor3    = Theme.Text
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex        = 6
                label.Parent        = bg

                local selLabel = Instance.new("TextLabel")
                selLabel.Size       = UDim2.fromOffset(90, 30)
                selLabel.AnchorPoint = Vector2.new(1, 0.5)
                selLabel.Position   = UDim2.new(1, -8, 0.5, 0)
                selLabel.BackgroundColor3 = Theme.AccentOff
                selLabel.Text       = selected .. " ▾"
                selLabel.Font       = Enum.Font.Gotham
                selLabel.TextSize   = 12
                selLabel.TextColor3 = Theme.Text
                selLabel.ZIndex     = 6
                selLabel.Parent     = bg
                corner(5):Parent = selLabel
                padding(0, 8, 0, 8):Parent = selLabel

                -- Dropdown list (rendered in contentArea to avoid clipping)
                local listFrame = Instance.new("Frame")
                listFrame.Size      = UDim2.fromOffset(bg.AbsoluteSize.X, 0)
                listFrame.BackgroundColor3 = Theme.SurfaceAlt
                listFrame.Visible   = false
                listFrame.ZIndex    = 20
                listFrame.Parent    = sg  -- parent to ScreenGui for z-ordering
                corner(6):Parent = listFrame
                stroke(Theme.Border):Parent = listFrame
                listLayout(0):Parent = listFrame

                local function closeDropdown()
                    open = false
                    tween(listFrame, { Size = UDim2.fromOffset(listFrame.AbsoluteSize.X, 0) }, 0.15):Play()
                    task.delay(0.15, function() listFrame.Visible = false end)
                end

                local ddObj = {}
                ddObj.Selected = selected

                local function buildOptions()
                    for _, child in ipairs(listFrame:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    for _, opt in ipairs(options) do
                        local optBtn = Instance.new("TextButton")
                        optBtn.Size             = UDim2.new(1, 0, 0, 32)
                        optBtn.BackgroundColor3 = Theme.SurfaceAlt
                        optBtn.BackgroundTransparency = opt == selected and 0 or 1
                        optBtn.Text             = opt
                        optBtn.Font             = Enum.Font.Gotham
                        optBtn.TextSize         = 13
                        optBtn.TextColor3       = opt == selected and Theme.Accent or Theme.Text
                        optBtn.ZIndex           = 21
                        optBtn.Parent           = listFrame
                        optBtn.MouseEnter:Connect(function()
                            tween(optBtn, { BackgroundTransparency = 0, BackgroundColor3 = Theme.Accent }, 0.1):Play()
                        end)
                        optBtn.MouseLeave:Connect(function()
                            tween(optBtn, { BackgroundTransparency = opt == selected and 0 or 1, BackgroundColor3 = Theme.SurfaceAlt }, 0.1):Play()
                        end)
                        optBtn.MouseButton1Click:Connect(function()
                            selected = opt
                            ddObj.Selected = opt
                            selLabel.Text = opt .. " ▾"
                            closeDropdown()
                            buildOptions()
                            if config.Callback then config.Callback(opt) end
                        end)
                    end
                end
                buildOptions()

                local openBtn = Instance.new("TextButton")
                openBtn.Size        = UDim2.fromScale(1, 1)
                openBtn.BackgroundTransparency = 1
                openBtn.Text        = ""
                openBtn.ZIndex      = 7
                openBtn.Parent      = bg

                openBtn.MouseButton1Click:Connect(function()
                    if open then
                        closeDropdown()
                    else
                        open = true
                        -- Position list below the row
                        local abs = bg.AbsolutePosition
                        local sz  = bg.AbsoluteSize
                        listFrame.Position = UDim2.fromOffset(abs.X, abs.Y + sz.Y + 4)
                        listFrame.Size     = UDim2.fromOffset(sz.X, 0)
                        listFrame.Visible  = true
                        local targetH = #options * 32 + 4
                        tween(listFrame, { Size = UDim2.fromOffset(sz.X, targetH) }, 0.18, Enum.EasingStyle.Back):Play()
                    end
                end)

                function ddObj:Set(val)
                    if table.find(options, val) then
                        selected = val
                        selLabel.Text = val .. " ▾"
                        buildOptions()
                    end
                end
                function ddObj:Get() return selected end
                return ddObj
            end

            -- ====================================================
            --  TEXT INPUT
            -- ====================================================
            function tab:AddInput(config)
                config = config or {}

                local row = newRow(52)

                local bg = Instance.new("Frame")
                bg.Size             = UDim2.fromScale(1, 1)
                bg.BackgroundColor3 = Theme.SurfaceAlt
                bg.ZIndex           = 5
                bg.Parent           = row
                corner(6):Parent = bg
                stroke(Theme.Border, 1):Parent = bg

                local label = Instance.new("TextLabel")
                label.Size          = UDim2.new(1, -12, 0, 22)
                label.Position      = UDim2.fromOffset(12, 4)
                label.BackgroundTransparency = 1
                label.Text          = config.Text or "Input"
                label.Font          = Enum.Font.GothamSemibold
                label.TextSize      = 12
                label.TextColor3    = Theme.TextDim
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex        = 6
                label.Parent        = bg

                local inputBox = Instance.new("TextBox")
                inputBox.Size       = UDim2.new(1, -24, 0, 22)
                inputBox.Position   = UDim2.fromOffset(12, 24)
                inputBox.BackgroundTransparency = 1
                inputBox.PlaceholderText = config.Placeholder or "Type here..."
                inputBox.PlaceholderColor3 = Theme.TextDim
                inputBox.Text       = config.Default or ""
                inputBox.Font       = Enum.Font.Gotham
                inputBox.TextSize   = 13
                inputBox.TextColor3 = Theme.Text
                inputBox.TextXAlignment = Enum.TextXAlignment.Left
                inputBox.ClearTextOnFocus = false
                inputBox.ZIndex     = 6
                inputBox.Parent     = bg

                inputBox.Focused:Connect(function()
                    tween(bg, { BackgroundColor3 = Theme.Surface }, 0.15):Play()
                end)
                inputBox.FocusLost:Connect(function(enter)
                    tween(bg, { BackgroundColor3 = Theme.SurfaceAlt }, 0.15):Play()
                    if config.Callback then config.Callback(inputBox.Text, enter) end
                end)

                local inputObj = {}
                function inputObj:Get() return inputBox.Text end
                function inputObj:Set(v) inputBox.Text = v end
                return inputObj
            end

            -- ====================================================
            --  LABEL
            -- ====================================================
            function tab:AddLabel(config)
                config = config or {}
                local row = newRow(28)

                local lbl = Instance.new("TextLabel")
                lbl.Size            = UDim2.fromScale(1, 1)
                lbl.BackgroundTransparency = 1
                lbl.Text            = config.Text or ""
                lbl.Font            = Enum.Font.Gotham
                lbl.TextSize        = config.Size or 13
                lbl.TextColor3      = config.Color or Theme.TextDim
                lbl.TextXAlignment  = Enum.TextXAlignment.Left
                lbl.ZIndex          = 5
                lbl.Parent          = row

                local lObj = {}
                function lObj:Set(t) lbl.Text = t end
                function lObj:Get() return lbl.Text end
                return lObj
            end

            -- ====================================================
            --  COLOR PICKER  (simple hue bar)
            -- ====================================================
            function tab:AddColorPicker(config)
                config = config or {}
                local currentColor = config.Default or Color3.fromRGB(99, 102, 241)
                local row = newRow(52)

                local bg = Instance.new("Frame")
                bg.Size             = UDim2.fromScale(1, 1)
                bg.BackgroundColor3 = Theme.SurfaceAlt
                bg.ZIndex           = 5
                bg.Parent           = row
                corner(6):Parent = bg
                stroke(Theme.Border, 1):Parent = bg

                local lbl = Instance.new("TextLabel")
                lbl.Size            = UDim2.new(1, -60, 0, 22)
                lbl.Position        = UDim2.fromOffset(12, 4)
                lbl.BackgroundTransparency = 1
                lbl.Text            = config.Text or "Color"
                lbl.Font            = Enum.Font.GothamSemibold
                lbl.TextSize        = 13
                lbl.TextColor3      = Theme.Text
                lbl.TextXAlignment  = Enum.TextXAlignment.Left
                lbl.ZIndex          = 6
                lbl.Parent          = bg

                -- Preview swatch
                local swatch = Instance.new("Frame")
                swatch.Size         = UDim2.fromOffset(28, 22)
                swatch.AnchorPoint  = Vector2.new(1, 0)
                swatch.Position     = UDim2.new(1, -10, 0, 4)
                swatch.BackgroundColor3 = currentColor
                swatch.ZIndex       = 6
                swatch.Parent       = bg
                corner(4):Parent = swatch

                -- Hue gradient bar
                local hueBar = Instance.new("Frame")
                hueBar.Size         = UDim2.new(1, -24, 0, 12)
                hueBar.Position     = UDim2.fromOffset(12, 32)
                hueBar.BackgroundColor3 = Color3.new(1, 1, 1)
                hueBar.ZIndex       = 6
                hueBar.Parent       = bg
                corner(4):Parent = hueBar

                local grad = Instance.new("UIGradient")
                grad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,   Color3.fromHSV(0,   1, 1)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
                    ColorSequenceKeypoint.new(0.5,  Color3.fromHSV(0.5,  1, 1)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
                    ColorSequenceKeypoint.new(1,   Color3.fromHSV(1,   1, 1)),
                })
                grad.Parent = hueBar

                local hueBtn = Instance.new("TextButton")
                hueBtn.Size         = UDim2.fromScale(1, 1)
                hueBtn.BackgroundTransparency = 1
                hueBtn.Text         = ""
                hueBtn.ZIndex       = 7
                hueBtn.Parent       = hueBar

                local cpObj = {}
                cpObj.Value = currentColor

                local function pickHue(input)
                    local rel = math.clamp((input.Position.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                    currentColor = Color3.fromHSV(rel, 1, 1)
                    cpObj.Value  = currentColor
                    swatch.BackgroundColor3 = currentColor
                    if config.Callback then config.Callback(currentColor) end
                end

                local draggingHue = false
                hueBtn.MouseButton1Down:Connect(function() draggingHue = true end)
                hueBtn.MouseButton1Up:Connect(function() draggingHue = false end)
                hueBtn.MouseButton1Click:Connect(pickHue)
                UserInputService.InputChanged:Connect(function(input)
                    if draggingHue and input.UserInputType == Enum.UserInputType.MouseMovement then
                        pickHue(input)
                    end
                end)

                function cpObj:Set(c) currentColor = c; cpObj.Value = c; swatch.BackgroundColor3 = c end
                function cpObj:Get() return currentColor end
                return cpObj
            end

            -- ====================================================
            --  KEYBIND
            -- ====================================================
            function tab:AddKeybind(config)
                config = config or {}
                local bound = config.Default or Enum.KeyCode.E
                local listening = false

                local row = newRow(38)

                local bg = Instance.new("Frame")
                bg.Size             = UDim2.fromScale(1, 1)
                bg.BackgroundColor3 = Theme.SurfaceAlt
                bg.ZIndex           = 5
                bg.Parent           = row
                corner(6):Parent = bg
                stroke(Theme.Border, 1):Parent = bg

                local lbl = Instance.new("TextLabel")
                lbl.Size            = UDim2.new(1, -80, 1, 0)
                lbl.Position        = UDim2.fromOffset(12, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text            = config.Text or "Keybind"
                lbl.Font            = Enum.Font.GothamSemibold
                lbl.TextSize        = 13
                lbl.TextColor3      = Theme.Text
                lbl.TextXAlignment  = Enum.TextXAlignment.Left
                lbl.ZIndex          = 6
                lbl.Parent          = bg

                local keyBtn = Instance.new("TextButton")
                keyBtn.Size         = UDim2.fromOffset(70, 26)
                keyBtn.AnchorPoint  = Vector2.new(1, 0.5)
                keyBtn.Position     = UDim2.new(1, -10, 0.5, 0)
                keyBtn.BackgroundColor3 = Theme.AccentOff
                keyBtn.Text         = bound.Name
                keyBtn.Font         = Enum.Font.GothamMono
                keyBtn.TextSize     = 12
                keyBtn.TextColor3   = Theme.Text
                keyBtn.ZIndex       = 6
                keyBtn.Parent       = bg
                corner(5):Parent = keyBtn

                keyBtn.MouseButton1Click:Connect(function()
                    listening = true
                    keyBtn.Text = "..."
                    tween(keyBtn, { BackgroundColor3 = Theme.Accent }, 0.15):Play()
                end)

                UserInputService.InputBegan:Connect(function(input, gpe)
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        listening = false
                        bound = input.KeyCode
                        keyBtn.Text = bound.Name
                        tween(keyBtn, { BackgroundColor3 = Theme.AccentOff }, 0.15):Play()
                        if config.Callback then config.Callback(bound) end
                    end
                end)

                -- Fire callback when key is pressed
                UserInputService.InputBegan:Connect(function(input, gpe)
                    if not listening and not gpe and input.KeyCode == bound then
                        if config.OnPress then config.OnPress() end
                    end
                end)

                local kbObj = {}
                function kbObj:Get() return bound end
                return kbObj
            end

            return tab
        end -- AddTab

        return win
    end -- buildWindow

    -- --------------------------------------------------------
    --  Key + Loading gate
    -- --------------------------------------------------------
    if requiredKey then
        ShowKeySystem(requiredKey, function(ok)
            if ok then
                ShowLoading(windowTitle, function()
                    buildWindow()
                end)
            end
        end)
    else
        ShowLoading(windowTitle, function()
            buildWindow()
        end)
    end

    return win
end

return RoUI
