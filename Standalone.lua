-- PlantRoot Hub - Standalone (works on Xeno + most executors)
-- No HttpGet needed, paste directly into executor

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Lighting         = game:GetService("Lighting")
local LocalPlayer      = Players.LocalPlayer

-- Use gethui() if available (Xeno/Synapse), fallback to CoreGui, then PlayerGui
local GuiParent = (gethui and gethui())
    or game:GetService("CoreGui")
    or LocalPlayer:WaitForChild("PlayerGui")

-- Destroy old instance if re-running
local old = GuiParent:FindFirstChild("PlantRootHub")
if old then old:Destroy() end

-- ============================================================
-- THEME
-- ============================================================
local C = {
    BG      = Color3.fromRGB(18,  18,  24),
    Surface = Color3.fromRGB(26,  26,  36),
    Alt     = Color3.fromRGB(32,  32,  46),
    Accent  = Color3.fromRGB(99,  102, 241),
    AccOff  = Color3.fromRGB(55,  55,  75),
    Text    = Color3.fromRGB(230, 230, 240),
    Dim     = Color3.fromRGB(130, 130, 155),
    Border  = Color3.fromRGB(50,  50,  70),
    Red     = Color3.fromRGB(239, 68,  68),
    Yellow  = Color3.fromRGB(251, 191, 36),
}

local function tw(obj, props, t)
    return TweenService:Create(obj, TweenInfo.new(t or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
end
local function cr(r, parent)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 6)
    c.Parent = parent
    return c
end
local function pad(parent, t,r,b,l)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, t or 0)
    p.PaddingRight  = UDim.new(0, r or 0)
    p.PaddingBottom = UDim.new(0, b or 0)
    p.PaddingLeft   = UDim.new(0, l or 0)
    p.Parent = parent
end
local function list(parent, spacing, dir)
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, spacing or 6)
    l.FillDirection = dir or Enum.FillDirection.Vertical
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = parent
    return l
end

-- ============================================================
-- SCREEN GUI
-- ============================================================
local sg = Instance.new("ScreenGui")
sg.Name            = "PlantRootHub"
sg.ResetOnSpawn    = false
sg.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
sg.IgnoreGuiInset  = true
sg.Parent          = GuiParent

-- ============================================================
-- MAIN WINDOW
-- ============================================================
local win = Instance.new("Frame")
win.Size             = UDim2.fromOffset(500, 380)
win.AnchorPoint      = Vector2.new(0.5, 0.5)
win.Position         = UDim2.fromScale(0.5, 0.5)
win.BackgroundColor3 = C.BG
win.ClipsDescendants = true
win.Parent           = sg
cr(10, win)
do local s = Instance.new("UIStroke") s.Color = C.Border s.Thickness = 1 s.Parent = win end

-- DRAG
local dragging, dragStart, winStart = false, nil, nil
local titleBar = Instance.new("Frame")
titleBar.Size             = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = C.Surface
titleBar.ZIndex           = 2
titleBar.Parent           = win

local titleLbl = Instance.new("TextLabel")
titleLbl.Size                 = UDim2.new(1, -90, 1, 0)
titleLbl.Position             = UDim2.fromOffset(14, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text                 = "PlantRoot Hub"
titleLbl.Font                 = Enum.Font.GothamBold
titleLbl.TextSize             = 15
titleLbl.TextColor3           = C.Text
titleLbl.TextXAlignment       = Enum.TextXAlignment.Left
titleLbl.ZIndex               = 3
titleLbl.Parent               = titleBar

-- Close
local closeBtn = Instance.new("TextButton")
closeBtn.Size              = UDim2.fromOffset(26, 26)
closeBtn.AnchorPoint       = Vector2.new(1, 0.5)
closeBtn.Position          = UDim2.new(1, -8, 0.5, 0)
closeBtn.BackgroundColor3  = C.Red
closeBtn.Text              = "×"
closeBtn.Font              = Enum.Font.GothamBold
closeBtn.TextSize          = 16
closeBtn.TextColor3        = Color3.new(1,1,1)
closeBtn.ZIndex            = 4
closeBtn.Parent            = titleBar
cr(6, closeBtn)
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Minimize
local minBtn = Instance.new("TextButton")
minBtn.Size             = UDim2.fromOffset(26, 26)
minBtn.AnchorPoint      = Vector2.new(1, 0.5)
minBtn.Position         = UDim2.new(1, -40, 0.5, 0)
minBtn.BackgroundColor3 = C.Yellow
minBtn.Text             = "–"
minBtn.Font             = Enum.Font.GothamBold
minBtn.TextSize         = 16
minBtn.TextColor3       = Color3.new(0,0,0)
minBtn.ZIndex           = 4
minBtn.Parent           = titleBar
cr(6, minBtn)
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tw(win, { Size = minimized and UDim2.fromOffset(500, 42) or UDim2.fromOffset(500, 380) }, 0.2):Play()
end)

-- Drag logic
titleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = i.Position; winStart = win.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - dragStart
        win.Position = UDim2.new(winStart.X.Scale, winStart.X.Offset+d.X, winStart.Y.Scale, winStart.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- TAB BAR
local tabBar = Instance.new("Frame")
tabBar.Size             = UDim2.new(1, 0, 0, 34)
tabBar.Position         = UDim2.fromOffset(0, 42)
tabBar.BackgroundColor3 = C.Alt
tabBar.ZIndex           = 2
tabBar.Parent           = win
list(tabBar, 0, Enum.FillDirection.Horizontal)
pad(tabBar, 4, 8, 4, 8)

local sep = Instance.new("Frame")
sep.Size             = UDim2.new(1, 0, 0, 1)
sep.Position         = UDim2.fromOffset(0, 76)
sep.BackgroundColor3 = C.Border
sep.BorderSizePixel  = 0
sep.ZIndex           = 2
sep.Parent           = win

-- CONTENT AREA
local content = Instance.new("Frame")
content.Size                 = UDim2.new(1, 0, 1, -78)
content.Position             = UDim2.fromOffset(0, 78)
content.BackgroundTransparency = 1
content.ZIndex               = 2
content.Parent               = win

-- ============================================================
-- TAB BUILDER
-- ============================================================
local activePage, activeTabBtn, activeUnderline

local function newTab(name)
    local tab = {}

    local tabBtn = Instance.new("TextButton")
    tabBtn.Size                 = UDim2.fromOffset(0, 26)
    tabBtn.AutomaticSize        = Enum.AutomaticSize.X
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text                 = name
    tabBtn.Font                 = Enum.Font.GothamSemibold
    tabBtn.TextSize             = 13
    tabBtn.TextColor3           = C.Dim
    tabBtn.ZIndex               = 3
    tabBtn.Parent               = tabBar
    pad(tabBtn, 0, 12, 0, 12)
    cr(5, tabBtn)

    local underline = Instance.new("Frame")
    underline.Size             = UDim2.new(0, 0, 0, 2)
    underline.AnchorPoint      = Vector2.new(0.5, 1)
    underline.Position         = UDim2.new(0.5, 0, 1, 0)
    underline.BackgroundColor3 = C.Accent
    underline.BorderSizePixel  = 0
    underline.ZIndex           = 4
    underline.Parent           = tabBtn
    cr(2, underline)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size                  = UDim2.fromScale(1, 1)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel       = 0
    scroll.ScrollBarThickness    = 3
    scroll.ScrollBarImageColor3  = C.Accent
    scroll.CanvasSize            = UDim2.fromOffset(0, 0)
    scroll.Visible               = false
    scroll.ZIndex                = 3
    scroll.Parent                = content
    pad(scroll, 8, 12, 8, 12)

    local layout = list(scroll, 8)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.fromOffset(0, layout.AbsoluteContentSize.Y + 16)
    end)

    local function activate()
        if activePage then activePage.Visible = false end
        if activeTabBtn then
            tw(activeTabBtn, { TextColor3 = C.Dim }, 0.12):Play()
            tw(activeUnderline, { Size = UDim2.new(0, 0, 0, 2) }, 0.12):Play()
        end
        scroll.Visible = true
        activePage     = scroll
        activeTabBtn   = tabBtn
        activeUnderline = underline
        tw(tabBtn, { TextColor3 = C.Text }, 0.12):Play()
        tw(underline, { Size = UDim2.new(1, 0, 0, 2) }, 0.2, Enum.EasingStyle.Back):Play()
    end
    tabBtn.MouseButton1Click:Connect(activate)

    -- ── COMPONENTS ──────────────────────────────────────────

    local function row(h)
        local f = Instance.new("Frame")
        f.Size               = UDim2.new(1, 0, 0, h or 36)
        f.BackgroundTransparency = 1
        f.ZIndex             = 4
        f.Parent             = scroll
        return f
    end

    local function card(parent)
        local f = Instance.new("Frame")
        f.Size             = UDim2.fromScale(1, 1)
        f.BackgroundColor3 = C.Alt
        f.ZIndex           = 5
        f.Parent           = parent
        cr(6, f)
        local s = Instance.new("UIStroke") s.Color = C.Border s.Thickness = 1 s.Parent = f
        return f
    end

    function tab:Section(text)
        local r = row(28)
        local line = Instance.new("Frame")
        line.Size             = UDim2.new(1, 0, 0, 1)
        line.Position         = UDim2.fromOffset(0, 13)
        line.BackgroundColor3 = C.Border
        line.BorderSizePixel  = 0
        line.ZIndex           = 5
        line.Parent           = r
        local lbl = Instance.new("TextLabel")
        lbl.Size              = UDim2.fromOffset(0, 20)
        lbl.AutomaticSize     = Enum.AutomaticSize.X
        lbl.AnchorPoint       = Vector2.new(0, 0.5)
        lbl.Position          = UDim2.fromOffset(0, 13)
        lbl.BackgroundColor3  = C.BG
        lbl.Text              = "  "..text.."  "
        lbl.Font              = Enum.Font.GothamSemibold
        lbl.TextSize          = 11
        lbl.TextColor3        = C.Dim
        lbl.ZIndex            = 6
        lbl.Parent            = r
    end

    function tab:Button(text, cb)
        local r = row(36)
        local c = card(r)
        local btn = Instance.new("TextButton")
        btn.Size              = UDim2.fromScale(1, 1)
        btn.BackgroundTransparency = 1
        btn.Text              = text
        btn.Font              = Enum.Font.GothamSemibold
        btn.TextSize          = 13
        btn.TextColor3        = C.Text
        btn.ZIndex            = 6
        btn.Parent            = c
        btn.MouseEnter:Connect(function() tw(c, {BackgroundColor3=C.Accent}, 0.12):Play() end)
        btn.MouseLeave:Connect(function() tw(c, {BackgroundColor3=C.Alt}, 0.12):Play() end)
        btn.MouseButton1Click:Connect(function()
            tw(c, {BackgroundColor3=C.Alt}, 0.1):Play()
            if cb then cb() end
        end)
    end

    function tab:Toggle(text, default, cb)
        local state = default == true
        local r = row(36)
        local c = card(r)
        local lbl = Instance.new("TextLabel")
        lbl.Size              = UDim2.new(1, -56, 1, 0)
        lbl.Position          = UDim2.fromOffset(10, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text              = text
        lbl.Font              = Enum.Font.GothamSemibold
        lbl.TextSize          = 13
        lbl.TextColor3        = C.Text
        lbl.TextXAlignment    = Enum.TextXAlignment.Left
        lbl.ZIndex            = 6
        lbl.Parent            = c
        local track = Instance.new("Frame")
        track.Size            = UDim2.fromOffset(40, 20)
        track.AnchorPoint     = Vector2.new(1, 0.5)
        track.Position        = UDim2.new(1, -10, 0.5, 0)
        track.BackgroundColor3 = state and C.Accent or C.AccOff
        track.ZIndex          = 6
        track.Parent          = c
        cr(10, track)
        local knob = Instance.new("Frame")
        knob.Size             = UDim2.fromOffset(14, 14)
        knob.AnchorPoint      = Vector2.new(0, 0.5)
        knob.Position         = state and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)
        knob.BackgroundColor3 = Color3.new(1,1,1)
        knob.ZIndex           = 7
        knob.Parent           = track
        cr(7, knob)
        local btn = Instance.new("TextButton")
        btn.Size              = UDim2.fromScale(1,1)
        btn.BackgroundTransparency = 1
        btn.Text              = ""
        btn.ZIndex            = 8
        btn.Parent            = c
        local obj = {}
        local function set(v)
            state = v
            tw(track, {BackgroundColor3 = state and C.Accent or C.AccOff}, 0.16):Play()
            tw(knob, {Position = state and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)}, 0.16):Play()
            if cb then cb(state) end
        end
        btn.MouseButton1Click:Connect(function() set(not state) end)
        function obj:Set(v) state=v tw(track,{BackgroundColor3=state and C.Accent or C.AccOff},0.16):Play() tw(knob,{Position=state and UDim2.new(1,-17,0.5,0) or UDim2.new(0,3,0.5,0)},0.16):Play() end
        function obj:Get() return state end
        return obj
    end

    function tab:Slider(text, min, max, default, cb)
        local val = default or min
        local r = row(50)
        local c = card(r)
        local lbl = Instance.new("TextLabel")
        lbl.Size              = UDim2.new(1,-60,0,20)
        lbl.Position          = UDim2.fromOffset(10,6)
        lbl.BackgroundTransparency = 1
        lbl.Text              = text
        lbl.Font              = Enum.Font.GothamSemibold
        lbl.TextSize          = 13
        lbl.TextColor3        = C.Text
        lbl.TextXAlignment    = Enum.TextXAlignment.Left
        lbl.ZIndex            = 6
        lbl.Parent            = c
        local valLbl = Instance.new("TextLabel")
        valLbl.Size           = UDim2.fromOffset(50,20)
        valLbl.AnchorPoint    = Vector2.new(1,0)
        valLbl.Position       = UDim2.new(1,-8,0,6)
        valLbl.BackgroundTransparency = 1
        valLbl.Text           = tostring(val)
        valLbl.Font           = Enum.Font.GothamMono
        valLbl.TextSize       = 12
        valLbl.TextColor3     = C.Accent
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        valLbl.ZIndex         = 6
        valLbl.Parent         = c
        local track = Instance.new("Frame")
        track.Size            = UDim2.new(1,-20,0,5)
        track.Position        = UDim2.fromOffset(10,32)
        track.BackgroundColor3 = C.AccOff
        track.ZIndex          = 6
        track.Parent          = c
        cr(3, track)
        local fill = Instance.new("Frame")
        fill.Size             = UDim2.new((val-min)/(max-min),0,1,0)
        fill.BackgroundColor3 = C.Accent
        fill.ZIndex           = 7
        fill.Parent           = track
        cr(3, fill)
        local thumb = Instance.new("Frame")
        thumb.Size            = UDim2.fromOffset(13,13)
        thumb.AnchorPoint     = Vector2.new(0.5,0.5)
        thumb.Position        = UDim2.new((val-min)/(max-min),0,0.5,0)
        thumb.BackgroundColor3 = Color3.new(1,1,1)
        thumb.ZIndex          = 8
        thumb.Parent          = track
        cr(7, thumb)
        local draggingSl = false
        local function upd(input)
            local rel = math.clamp((input.Position.X - track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
            val = math.floor(min + rel*(max-min)+0.5)
            valLbl.Text = tostring(val)
            fill.Size   = UDim2.new(rel,0,1,0)
            thumb.Position = UDim2.new(rel,0,0.5,0)
            if cb then cb(val) end
        end
        track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then draggingSl=true upd(i) end end)
        UserInputService.InputChanged:Connect(function(i) if draggingSl and i.UserInputType==Enum.UserInputType.MouseMovement then upd(i) end end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then draggingSl=false end end)
        local obj = {}
        function obj:Get() return val end
        function obj:Set(v) val=math.clamp(v,min,max) local rel=(val-min)/(max-min) valLbl.Text=tostring(val) fill.Size=UDim2.new(rel,0,1,0) thumb.Position=UDim2.new(rel,0,0.5,0) end
        return obj
    end

    function tab:Label(text)
        local r = row(26)
        local lbl = Instance.new("TextLabel")
        lbl.Size              = UDim2.fromScale(1,1)
        lbl.BackgroundTransparency = 1
        lbl.Text              = text
        lbl.Font              = Enum.Font.Gotham
        lbl.TextSize          = 13
        lbl.TextColor3        = C.Dim
        lbl.TextXAlignment    = Enum.TextXAlignment.Left
        lbl.ZIndex            = 5
        lbl.Parent            = r
        local obj = {}
        function obj:Set(t) lbl.Text = t end
        return obj
    end

    -- Auto-activate first tab
    task.defer(function()
        if not activePage then activate() end
    end)

    return tab
end

-- ============================================================
-- BUILD TABS
-- ============================================================

-- MOVEMENT
local Move = newTab("Movement")

Move:Section("Speed & Jump")

Move:Toggle("Speed Hack", false, function(on)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = on and 150 or 16 end
end)

Move:Slider("Walk Speed", 16, 500, 16, function(v)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end)

Move:Slider("Jump Power", 50, 500, 50, function(v)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.JumpPower = v end
end)

Move:Toggle("Infinite Jump", false, function(on)
    _G.RoUI_InfJump = on
end)
UserInputService.JumpRequest:Connect(function()
    if _G.RoUI_InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

Move:Section("Teleport")
Move:Button("Teleport to Spawn", function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local spawn = workspace:FindFirstChild("SpawnLocation")
    if root then
        root.CFrame = spawn and (spawn.CFrame + Vector3.new(0,5,0)) or CFrame.new(0,5,0)
    end
end)

-- PLAYER
local Player = newTab("Player")

Player:Section("Combat")

Player:Toggle("God Mode", false, function(on)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.MaxHealth = on and math.huge or 100; hum.Health = hum.MaxHealth end
end)

Player:Toggle("No Clip", false, function(on)
    _G.RoUI_NoClip = on
end)
RunService.Stepped:Connect(function()
    if _G.RoUI_NoClip and LocalPlayer.Character then
        for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

Player:Toggle("Anti AFK", false, function(on)
    _G.RoUI_AFK = on
end)
task.spawn(function()
    while true do
        task.wait(60)
        if _G.RoUI_AFK then
            LocalPlayer:Move(Vector3.new(0,0,0))
        end
    end
end)

Player:Button("Reset Character", function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
end)

Player:Section("Camera")
Player:Slider("FOV", 30, 120, 70, function(v)
    workspace.CurrentCamera.FieldOfView = v
end)

-- VISUAL
local Visual = newTab("Visual")

Visual:Section("World")

Visual:Toggle("Fullbright", false, function(on)
    Lighting.Ambient    = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,70,70)
    Lighting.Brightness = on and 2 or 1
end)

Visual:Slider("Time of Day", 0, 23, 14, function(v)
    Lighting.TimeOfDay = v..":00:00"
end)

Visual:Toggle("No Fog", false, function(on)
    Lighting.FogEnd = on and 9e9 or 100000
end)

Visual:Section("ESP")
Visual:Toggle("Player ESP", false, function(on)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local existing = p.Character:FindFirstChild("_ESP")
            if on and not existing then
                local box = Instance.new("SelectionBox")
                box.Name          = "_ESP"
                box.Adornee       = p.Character
                box.Color3        = Color3.fromRGB(99,102,241)
                box.LineThickness = 0.04
                box.Parent        = p.Character
            elseif not on and existing then
                existing:Destroy()
            end
        end
    end
end)

-- MISC
local Misc = newTab("Misc")

local statusLbl = Misc:Label("Status: idle")

Misc:Section("Misc")

Misc:Button("Copy Username", function()
    setclipboard(LocalPlayer.Name)
    statusLbl:Set("Status: copied " .. LocalPlayer.Name)
end)

Misc:Button("Rejoin Game", function()
    local TS = game:GetService("TeleportService")
    TS:Teleport(game.PlaceId, LocalPlayer)
end)

Misc:Toggle("Hide GUI", false, function(on)
    win.Visible = not on
end)

-- ANIMATE WINDOW IN
win.BackgroundTransparency = 1
win.Position = UDim2.new(0.5,0,0.5,20)
tw(win, {BackgroundTransparency=0, Position=UDim2.fromScale(0.5,0.5)}, 0.3):Play()
