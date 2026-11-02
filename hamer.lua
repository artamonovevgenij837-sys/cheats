-- hamer client (no key)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
    task.wait(0.1)
    LocalPlayer = Players.LocalPlayer
end
local Camera = Workspace.CurrentCamera
while not Camera do
    task.wait(0.1)
    Camera = Workspace.CurrentCamera
end

local FONT_BLACK = Enum.Font.GothamBlack
local FONT_BOLD = Enum.Font.GothamBold
local FONT_REG = Enum.Font.Gotham

local ACCENTS = {
    Mint = Color3.fromRGB(0, 224, 184),
    Cyan = Color3.fromRGB(0, 229, 255),
    Purple = Color3.fromRGB(186, 120, 255),
    Pink = Color3.fromRGB(255, 120, 200),
    Red = Color3.fromRGB(255, 78, 100),
    Lime = Color3.fromRGB(160, 240, 90),
    Gold = Color3.fromRGB(255, 205, 80),
    Blue = Color3.fromRGB(90, 150, 255),
    Emerald = Color3.fromRGB(70, 235, 155),
    Orange = Color3.fromRGB(255, 150, 70),
    White = Color3.fromRGB(240, 245, 255)
}
local ACCENT_ORDER = {"Mint", "Cyan", "Purple", "Pink", "Red", "Lime", "Gold", "Blue", "Emerald", "Orange", "White"}

local S = {
    Accent = "Mint", MenuOpen = false,
    ESP = false, ESPNames = true, ESPDist = true, ESPColor = Color3.fromRGB(0, 229, 255),
    ESPRole = true, ESPHealth = true, ESPTracer = false, ESPSkeleton = false, ESPHeadDot = false,
    ESPChams = false, ESPChamsThrough = false, ESPMaxDist = 1000, ESPVisCheck = false,
    ESPCorners = true, ESPThickness = 1.5,
    ESPMurdererColor = Color3.fromRGB(255, 64, 64), ESPSheriffColor = Color3.fromRGB(80, 150, 255),
    ESPHeroColor = Color3.fromRGB(255, 210, 60), ESPInnocentColor = Color3.fromRGB(90, 230, 130),
    Fullbright = false, Fog = false, FogDensity = 0.35,
    MotionBlur = false, MotionBlurStrength = 16,
    Aspect = false, AspectValue = 0.8,
    World = false, WorldSaturation = 0, WorldContrast = 0,
    Aimbot = false, AimbotFOV = 160, AimbotSmooth = 0.35, AimbotPart = "Head",
    Speed = false, SpeedValue = 32,
    Jump = false, JumpValue = 80,
    Fly = false, FlySpeed = 60,
    Noclip = false,
    Hitbox = false, HitboxSize = 8,
    InfJump = false,
    AntiAfk = false,
    AutoCollect = false,
    Watermark = true,
    Dong = false, DongSize = 1, DongGlow = false, DongColor = Color3.fromRGB(232, 190, 158),
    DongHeadColor = Color3.fromRGB(200, 60, 60), CosmeticGlow = true,
    Wings = false, Halo = false, ChinaHat = false, Kagune = false, Companion = false, NoAnims = false,
    Korblox = false, GhostLegs = false,
    AvatarScale = 1, ConfigName = "default", DroneActive = false, Mobile = false,
    Transparent = false, Fox = false, FoxSize = 1,
    CoinFarm = false, FarmNoClip = false, FarmUnderMap = false, FarmSpeed = 80,
    SilentAim = false, SilentAimFOV = 180, SilentAimMaxDist = 600, SilentAimPredict = 120, SilentAimWallbang = false,
    KillAll = false,
    Keybinds = {ESP = "F", Aimbot = "G", SilentAim = "V", KillAll = "K"},
    AutoLoadConfig = true,
    Aura = false, Crown = false, Horns = false, CatEars = false, Jetpack = false,
    Tail = false, TopHat = false, Visor = false, Scythe = false
}

S.Mobile = (UIS.TouchEnabled and not UIS.KeyboardEnabled) or false

local Unloaded = false
local toast
local Conns = {}
local function conn(c)
    table.insert(Conns, c)
    return c
end
local function clamp(v, a, b)
    if v < a then return a elseif v > b then return b end
    return v
end
local function FS(n)
    if S.Mobile then return math.floor(n * 1.25 + 0.5) end
    return n
end
local function RH(n)
    if S.Mobile then return math.floor(n * 1.22 + 0.5) end
    return n
end
local function tw(o, t, props, style, dir)
    local t1 = TweenService:Create(o, TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    t1:Play()
    return t1
end
local function accent()
    return ACCENTS[S.Accent] or ACCENTS.Cyan
end

local SoundFolder = Instance.new("Folder")
SoundFolder.Name = "HamerSounds"
SoundFolder.Parent = SoundService
local clickSound = Instance.new("Sound")
clickSound.SoundId = "rbxassetid://6895079853"
clickSound.Volume = 0.25
clickSound.PlaybackSpeed = 2
clickSound.Parent = SoundFolder
local function click()
    pcall(function()
        clickSound:Stop()
        clickSound:Play()
    end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "Hamer"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local blur = Instance.new("BlurEffect")
blur.Name = "HamerBlur"
blur.Size = 0
blur.Parent = Lighting

local dim = Instance.new("Frame")
dim.Size = UDim2.new(1, 0, 1, 0)
dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dim.BackgroundTransparency = 1
dim.BorderSizePixel = 0
dim.Visible = false
dim.ZIndex = 5
dim.Parent = gui

local main = Instance.new("Frame")
main.Name = "Main"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.Size = UDim2.new(0, 760, 0, 520)
main.BackgroundColor3 = Color3.fromRGB(22, 23, 27)
main.BackgroundTransparency = S.Transparent and 0.35 or 0
main.BorderSizePixel = 0
main.Visible = false
main.ZIndex = 10
main.Parent = gui
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = main
local mainStroke = Instance.new("UIStroke")
mainStroke.Color = accent()
mainStroke.Transparency = 0.6
mainStroke.Thickness = 1.2
mainStroke.Parent = main

local uiScale = Instance.new("UIScale")
uiScale.Parent = main

local function computeScale()
    local vp = Camera.ViewportSize
    local sc
    if S.Mobile then
        sc = math.min((vp.X - 16) / 760, (vp.Y - 16) / 520)
        return clamp(sc, 0.7, 2.4)
    end
    sc = math.min((vp.X - 60) / 760, (vp.Y - 60) / 520, 1.15)
    return clamp(sc, 0.6, 1.15)
end
uiScale.Scale = computeScale()
conn(Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    if S.MenuOpen then
        uiScale.Scale = computeScale()
    end
end))

local themeFns = {}
local function bindAccent(fn)
    table.insert(themeFns, fn)
    fn(accent())
end
local function applyAccent()
    local c = accent()
    for _, fn in ipairs(themeFns) do
        pcall(fn, c)
    end
end
bindAccent(function(c)
    mainStroke.Color = c
end)

local UI = {
    bg = Color3.fromRGB(22, 23, 27),
    panel = Color3.fromRGB(27, 29, 34),
    card = Color3.fromRGB(36, 38, 44),
    cardHi = Color3.fromRGB(44, 47, 54),
    field = Color3.fromRGB(33, 35, 41),
    navHi = Color3.fromRGB(52, 55, 63),
    text = Color3.fromRGB(242, 244, 248),
    sub = Color3.fromRGB(138, 143, 153),
    line = Color3.fromRGB(255, 255, 255)
}

local SUBTITLES = {
    ESP = "Role ESP, chams, skeleton, tracers", ESPNames = "Show player names", ESPDist = "Show distance",
    Fullbright = "Maximum brightness", Fog = "Atmospheric fog effect", FogDensity = "Fog thickness",
    MotionBlur = "Blur on movement", MotionBlurStrength = "Blur intensity",
    Aspect = "Stretch screen view", AspectValue = "Screen stretch",
    World = "Saturation & contrast", WorldSaturation = "Color saturation", WorldContrast = "Color contrast",
    Speed = "Movement speed", SpeedValue = "Walk speed", Jump = "Jump power", JumpValue = "Jump height",
    Fly = "Free flight", FlySpeed = "Flight speed", Noclip = "Walk through walls",
    Aimbot = "Auto aim at target", AimbotFOV = "Aim radius", AimbotSmooth = "Aim smoothing",
    Hitbox = "Expand hitbox", HitboxSize = "Hitbox size", InfJump = "Infinite jumping",
    AntiAfk = "Stay active", AutoCollect = "Collect nearby items", Watermark = "On-screen watermark",
    CosmeticGlow = "Neon materials", Dong = "Attach a 3D model", DongGlow = "Neon skin",
    DongSize = "Model size", Korblox = "Replace right leg", GhostLegs = "Transparent legs",
    NoAnims = "Disable animations", Wings = "Neon wings", Halo = "Neon halo",
    ChinaHat = "Neon hat", Kagune = "Neon kagune", Companion = "Floating orb",
    AvatarScale = "Character size", Mobile = "Phone / tablet layout",
    Transparent = "Glass background", Fox = "Mini fox on your shoulder", FoxSize = "Fox size",
    CoinFarm = "Auto collect MM2 coins", FarmNoClip = "Pass through walls",
    FarmUnderMap = "Farm below the map", FarmSpeed = "Movement speed",
    SilentAim = "Route shots onto target", SilentAimFOV = "Target search radius",
    SilentAimMaxDist = "Maximum lock distance", SilentAimPredict = "Velocity prediction",
    SilentAimWallbang = "Shoot through walls", KillAll = "Knife every player",
    AutoLoadConfig = "Load config on inject", Aura = "Orbiting energy rings",
    Crown = "Floating neon crown", Horns = "Demon horns", CatEars = "Neon cat ears",
    Jetpack = "Neon jetpack", Tail = "Animated neon tail", TopHat = "Classic top hat",
    Visor = "Glowing visor", Scythe = "Neon scythe on your back"
}

local PALETTE = {
    Color3.fromRGB(0, 229, 255),
    Color3.fromRGB(255, 120, 200),
    Color3.fromRGB(255, 78, 100),
    Color3.fromRGB(160, 240, 90),
    Color3.fromRGB(186, 120, 255),
    Color3.fromRGB(255, 205, 80),
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(232, 190, 158),
    Color3.fromRGB(150, 100, 70),
    Color3.fromRGB(200, 60, 60)
}

local function corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = inst
    return c
end

local function stroke(inst, color, transparency, thickness)
    local st = Instance.new("UIStroke")
    st.Color = color
    st.Transparency = transparency
    st.Thickness = thickness or 1
    st.Parent = inst
    return st
end

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 58)
header.BackgroundTransparency = 1
header.ZIndex = 11
header.Parent = main

local logo = Instance.new("TextLabel")
logo.Text = "H"
logo.Font = FONT_BLACK
logo.TextSize = FS(24)
logo.TextColor3 = accent()
logo.TextXAlignment = Enum.TextXAlignment.Left
logo.Size = UDim2.new(0, 34, 0, 58)
logo.Position = UDim2.new(0, 22, 0, 0)
logo.BackgroundTransparency = 1
logo.ZIndex = 12
logo.Parent = header
bindAccent(function(c) logo.TextColor3 = c end)

local title = Instance.new("TextLabel")
title.Text = "HAMER"
title.Font = FONT_BLACK
title.TextSize = FS(15)
title.TextColor3 = UI.text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Size = UDim2.new(0, 90, 0, 58)
title.Position = UDim2.new(0, 56, 0, 0)
title.BackgroundTransparency = 1
title.ZIndex = 12
title.Parent = header

local brand = Instance.new("TextLabel")
brand.Text = "CLIENT"
brand.Font = FONT_REG
brand.TextSize = FS(15)
brand.TextColor3 = UI.sub
brand.TextXAlignment = Enum.TextXAlignment.Left
brand.Size = UDim2.new(0, 90, 0, 58)
brand.Position = UDim2.new(0, 124, 0, 0)
brand.BackgroundTransparency = 1
brand.ZIndex = 12
brand.Parent = header

local closeDot
for i = 1, 3 do
    local isClose = i == 3
    local d
    if isClose then
        d = Instance.new("TextButton")
        d.Text = ""
        d.AutoButtonColor = false
    else
        d = Instance.new("Frame")
    end
    d.Size = UDim2.new(0, 12, 0, 12)
    d.Position = UDim2.new(1, -22 - (3 - i) * 22, 0, 23)
    d.BackgroundColor3 = isClose and Color3.fromRGB(240, 242, 246) or Color3.fromRGB(58, 61, 68)
    d.BorderSizePixel = 0
    d.ZIndex = 12
    d.Parent = header
    corner(d, 6)
    if isClose then closeDot = d end
end

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(0, 156, 0, 330)
tabBar.Position = UDim2.new(0, 18, 0, 72)
tabBar.BackgroundTransparency = 1
tabBar.ZIndex = 11
tabBar.Parent = main
local tabList = Instance.new("UIListLayout")
tabList.FillDirection = Enum.FillDirection.Vertical
tabList.Padding = UDim.new(0, 4)
tabList.SortOrder = Enum.SortOrder.LayoutOrder
tabList.Parent = tabBar

local tabDivider = Instance.new("Frame")
tabDivider.Size = UDim2.new(0, 156, 0, 1)
tabDivider.Position = UDim2.new(0, 18, 1, -64)
tabDivider.BackgroundColor3 = UI.line
tabDivider.BackgroundTransparency = 0.92
tabDivider.BorderSizePixel = 0
tabDivider.ZIndex = 11
tabDivider.Parent = main

local playerBtn = Instance.new("TextButton")
playerBtn.Size = UDim2.new(0, 156, 0, 48)
playerBtn.Position = UDim2.new(0, 18, 1, -52)
playerBtn.BackgroundColor3 = UI.card
playerBtn.BackgroundTransparency = S.Transparent and 0.75 or 0.55
playerBtn.BorderSizePixel = 0
playerBtn.Text = ""
playerBtn.AutoButtonColor = false
playerBtn.ZIndex = 12
playerBtn.Parent = main
corner(playerBtn, 10)
local playerStroke = stroke(playerBtn, UI.line, 0.85, 1)
local playerIconBox = Instance.new("Frame")
playerIconBox.Size = UDim2.new(0, 24, 0, 24)
playerIconBox.Position = UDim2.new(0, 12, 0.5, -12)
playerIconBox.BackgroundTransparency = 1
playerIconBox.ZIndex = 13
playerIconBox.Parent = playerBtn
corner(playerIconBox, 6)
stroke(playerIconBox, UI.line, 0.6, 1.2)
local playerIcon = Instance.new("TextLabel")
playerIcon.Text = "?"
playerIcon.Font = FONT_BOLD
playerIcon.TextSize = FS(13)
playerIcon.TextColor3 = UI.sub
playerIcon.Size = UDim2.new(1, 0, 1, 0)
playerIcon.BackgroundTransparency = 1
playerIcon.ZIndex = 14
playerIcon.Parent = playerIconBox
local playerTxt = Instance.new("TextLabel")
playerTxt.Text = "Player"
playerTxt.Font = FONT_REG
playerTxt.TextSize = FS(14)
playerTxt.TextColor3 = UI.sub
playerTxt.TextXAlignment = Enum.TextXAlignment.Left
playerTxt.Size = UDim2.new(1, -54, 1, 0)
playerTxt.Position = UDim2.new(0, 46, 0, 0)
playerTxt.BackgroundTransparency = 1
playerTxt.ZIndex = 13
playerTxt.Parent = playerBtn

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -196, 1, -82)
content.Position = UDim2.new(0, 182, 0, 68)
content.BackgroundColor3 = UI.panel
content.BackgroundTransparency = S.Transparent and 0.5 or 0
content.BorderSizePixel = 0
content.ZIndex = 10
content.Parent = main
corner(content, 16)
stroke(content, UI.line, 0.94, 1)

local contentTitle = Instance.new("TextLabel")
contentTitle.Text = "VISUALS"
contentTitle.Font = FONT_BLACK
contentTitle.TextSize = FS(20)
contentTitle.TextColor3 = UI.text
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Size = UDim2.new(1, -36, 0, 30)
contentTitle.Position = UDim2.new(0, 18, 0, 16)
contentTitle.BackgroundTransparency = 1
contentTitle.ZIndex = 12
contentTitle.Parent = content

local searchFrame = Instance.new("Frame")
searchFrame.Size = UDim2.new(1, -36, 0, 40)
searchFrame.Position = UDim2.new(0, 18, 0, 58)
searchFrame.BackgroundColor3 = UI.card
searchFrame.BackgroundTransparency = S.Transparent and 0.55 or 0
searchFrame.BorderSizePixel = 0
searchFrame.ZIndex = 12
searchFrame.Parent = content
corner(searchFrame, 10)
stroke(searchFrame, UI.line, 0.94, 1)

local mag = Instance.new("Frame")
mag.Size = UDim2.new(0, 20, 0, 20)
mag.Position = UDim2.new(0, 14, 0.5, -10)
mag.BackgroundTransparency = 1
mag.ZIndex = 13
mag.Parent = searchFrame
local lens = Instance.new("Frame")
lens.Size = UDim2.new(0, 11, 0, 11)
lens.Position = UDim2.new(0, 1, 0, 1)
lens.BackgroundTransparency = 1
lens.ZIndex = 13
lens.Parent = mag
corner(lens, 6)
stroke(lens, UI.sub, 0.2, 1.6)
local magHandle = Instance.new("Frame")
magHandle.Size = UDim2.new(0, 2, 0, 6)
magHandle.Position = UDim2.new(0, 11, 0, 12)
magHandle.Rotation = -45
magHandle.BackgroundColor3 = UI.sub
magHandle.BackgroundTransparency = 0.2
magHandle.BorderSizePixel = 0
magHandle.ZIndex = 13
magHandle.Parent = mag
corner(magHandle, 1)

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -52, 1, 0)
searchBox.Position = UDim2.new(0, 40, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.Font = FONT_REG
searchBox.TextSize = FS(13)
searchBox.TextColor3 = UI.text
searchBox.PlaceholderText = "Search features..."
searchBox.PlaceholderColor3 = UI.sub
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus = false
searchBox.Text = ""
searchBox.ZIndex = 13
searchBox.Parent = searchFrame

local grid = Instance.new("ScrollingFrame")
grid.Size = UDim2.new(1, -36, 1, -130)
grid.Position = UDim2.new(0, 18, 0, 112)
grid.BackgroundTransparency = 1
grid.BorderSizePixel = 0
grid.ScrollBarThickness = 3
grid.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
grid.ScrollBarImageTransparency = 0.6
grid.ScrollingDirection = Enum.ScrollingDirection.Y
grid.AutomaticCanvasSize = Enum.AutomaticSize.Y
grid.CanvasSize = UDim2.new(0, 0, 0, 0)
grid.ZIndex = 11
grid.Parent = content
local gridLayout = Instance.new("UIListLayout")
gridLayout.Padding = UDim.new(0, 10)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = grid

local builders = {}
local tabButtons = {}
local currentTab = "combat"
local tabs = {
    {id = "combat", label = "Combat", icon = "⚔️"},
    {id = "cosmetics", label = "Cosmetics", icon = "✨"},
    {id = "visual", label = "Visuals", icon = "👁️"},
    {id = "places", label = "Places", icon = "🌐"},
    {id = "configs", label = "Configs", icon = "💾"},
    {id = "themes", label = "Themes", icon = "🎨"}
}

local ActiveCards = {}
local cardOrder = 0
local settingOrder = 0
local currentPanel = nil
local selectTab

local function nextOrder()
    cardOrder = cardOrder + 1
    return cardOrder
end

local function registerCard(obj, titleText, subText)
    table.insert(ActiveCards, {obj = obj, text = string.lower(titleText .. " " .. (subText or ""))})
end

local function cardBase(titleText, subText, reserveRight)
    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, 0, 0, S.Mobile and 96 or 86)
    card.BackgroundColor3 = UI.card
    card.BackgroundTransparency = S.Transparent and 0.45 or 0
    card.BorderSizePixel = 0
    card.Text = ""
    card.AutoButtonColor = false
    card.LayoutOrder = nextOrder()
    card.ZIndex = 12
    card.Parent = grid
    corner(card, 11)
    local st = stroke(card, UI.line, 0.93, 1)
    local rw = reserveRight or 54
    local tl = Instance.new("TextLabel")
    tl.Text = titleText
    tl.Font = FONT_BOLD
    tl.TextSize = FS(14)
    tl.TextColor3 = UI.text
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.TextYAlignment = Enum.TextYAlignment.Top
    tl.TextWrapped = true
    tl.Size = UDim2.new(1, -(24 + rw), 0, 20)
    tl.Position = UDim2.new(0, 14, 0, subText and 16 or 24)
    tl.BackgroundTransparency = 1
    tl.ZIndex = 13
    tl.Parent = card
    if subText then
        local sb = Instance.new("TextLabel")
        sb.Text = subText
        sb.Font = FONT_REG
        sb.TextSize = FS(11)
        sb.TextColor3 = UI.sub
        sb.TextXAlignment = Enum.TextXAlignment.Left
        sb.TextYAlignment = Enum.TextYAlignment.Top
        sb.TextWrapped = true
        sb.Size = UDim2.new(1, -(24 + rw), 0, 36)
        sb.Position = UDim2.new(0, 14, 0, 40)
        sb.BackgroundTransparency = 1
        sb.ZIndex = 13
        sb.Parent = card
    end
    card.MouseEnter:Connect(function()
        tw(card, 0.12, {BackgroundColor3 = UI.cardHi})
        st.Transparency = 0.86
    end)
    card.MouseLeave:Connect(function()
        tw(card, 0.12, {BackgroundColor3 = UI.card})
        st.Transparency = 0.93
    end)
    registerCard(card, titleText, subText)
    return card, st
end

local function styleBox(box, mark, bst, on)
    local c = accent()
    box.BackgroundColor3 = on and c or UI.field
    bst.Color = on and c or UI.line
    bst.Transparency = on and 0 or 0.75
    if mark then mark.Text = on and "✓" or "" end
end

local function makeBox(parent, x, y, size)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, size, 0, size)
    box.Position = UDim2.new(1, x, 0.5, y)
    box.BackgroundColor3 = UI.field
    box.BorderSizePixel = 0
    box.ZIndex = 20
    box.Parent = parent
    corner(box, math.floor(size * 0.26))
    local bst = stroke(box, UI.line, 0.75, 1.4)
    local mark = Instance.new("TextLabel")
    mark.Text = ""
    mark.Font = FONT_BOLD
    mark.TextSize = FS(math.floor(size * 0.55))
    mark.TextColor3 = Color3.fromRGB(18, 20, 24)
    mark.Size = UDim2.new(1, 0, 1, 0)
    mark.BackgroundTransparency = 1
    mark.ZIndex = 21
    mark.Parent = box
    return box, mark, bst
end

local function sectionRow(_) end

local function panelRow(text, height)
    settingOrder = settingOrder + 1
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, height or 44)
    row.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    row.BackgroundTransparency = 1
    row.BorderSizePixel = 0
    row.Text = ""
    row.AutoButtonColor = false
    row.LayoutOrder = settingOrder
    row.ZIndex = 14
    row.Parent = currentPanel
    corner(row, 8)
    local lbl = Instance.new("TextLabel")
    lbl.Text = text
    lbl.Font = FONT_REG
    lbl.TextSize = FS(13)
    lbl.TextColor3 = UI.text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Size = UDim2.new(1, -120, 1, 0)
    lbl.Position = UDim2.new(0, 6, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.ZIndex = 15
    lbl.Parent = row
    row.MouseEnter:Connect(function() row.BackgroundTransparency = 0.94 end)
    row.MouseLeave:Connect(function() row.BackgroundTransparency = 1 end)
    return row, lbl
end

local function settingToggle(text, key, onChange)
    local row = panelRow(text, 44)
    local box, mark, bst = makeBox(row, -34, -12, 24)
    styleBox(box, mark, bst, S[key])
    row.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        styleBox(box, mark, bst, S[key])
        click()
        if onChange then onChange(S[key]) end
    end)
end

local function settingStep(text, key, minv, maxv, step, suffix, onChange)
    local row = panelRow(text, 46)
    local val = Instance.new("TextLabel")
    val.Font = FONT_BOLD
    val.TextSize = FS(12)
    val.TextColor3 = accent()
    val.Size = UDim2.new(0, 34, 1, 0)
    val.Position = UDim2.new(1, -70, 0, 0)
    val.TextXAlignment = Enum.TextXAlignment.Center
    val.BackgroundTransparency = 1
    val.ZIndex = 15
    val.Parent = row
    bindAccent(function(c) val.TextColor3 = c end)
    local function refresh()
        local v = S[key]
        if type(v) == "number" then
            if v == math.floor(v) then
                val.Text = tostring(math.floor(v)) .. (suffix or "")
            else
                val.Text = string.format("%.2f", v) .. (suffix or "")
            end
        end
    end
    local function mk(txt, x)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 24, 0, 24)
        b.Position = UDim2.new(1, x, 0.5, -12)
        b.BackgroundColor3 = UI.field
        b.Text = txt
        b.Font = FONT_BOLD
        b.TextSize = FS(14)
        b.TextColor3 = UI.text
        b.AutoButtonColor = false
        b.ZIndex = 16
        b.Parent = row
        corner(b, 6)
        stroke(b, UI.line, 0.86, 1)
        return b
    end
    local minus = mk("−", -94)
    local plus = mk("+", -34)
    minus.MouseButton1Click:Connect(function()
        S[key] = clamp(S[key] - step, minv, maxv)
        refresh()
        click()
        if onChange then onChange(S[key]) end
    end)
    plus.MouseButton1Click:Connect(function()
        S[key] = clamp(S[key] + step, minv, maxv)
        refresh()
        click()
        if onChange then onChange(S[key]) end
    end)
    refresh()
end

local function settingColor(text, key, onChange)
    local row = panelRow(text, 44)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 24, 0, 24)
    dot.Position = UDim2.new(1, -34, 0.5, -12)
    dot.BackgroundColor3 = S[key]
    dot.BorderSizePixel = 0
    dot.ZIndex = 15
    dot.Parent = row
    corner(dot, 12)
    stroke(dot, UI.line, 0.5, 2)
    row.MouseButton1Click:Connect(function()
        local idx = 1
        for i, c in ipairs(PALETTE) do
            if c == S[key] then idx = i; break end
        end
        S[key] = PALETTE[(idx % #PALETTE) + 1]
        dot.BackgroundColor3 = S[key]
        click()
        if onChange then onChange(S[key]) end
    end)
end

local function settingText(text, key, placeholder)
    local row = panelRow(text, 48)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 120, 0, 32)
    box.Position = UDim2.new(1, -130, 0.5, -16)
    box.BackgroundColor3 = UI.field
    box.BorderSizePixel = 0
    box.Font = FONT_REG
    box.TextSize = FS(12)
    box.TextColor3 = UI.text
    box.PlaceholderText = placeholder or ""
    box.PlaceholderColor3 = UI.sub
    box.Text = tostring(S[key] or "")
    box.ClearTextOnFocus = false
    box.ZIndex = 16
    box.Parent = row
    corner(box, 7)
    stroke(box, UI.line, 0.86, 1)
    box:GetPropertyChangedSignal("Text"):Connect(function()
        S[key] = box.Text
    end)
end

local function settingAction(text, sub, callback)
    local row = panelRow(text, 46)
    if sub then
        local lbl = row:FindFirstChildOfClass("TextLabel")
        if lbl then
            lbl.Size = UDim2.new(1, -150, 1, 0)
            local sb = Instance.new("TextLabel")
            sb.Text = sub
            sb.Font = FONT_REG
            sb.TextSize = FS(10)
            sb.TextColor3 = UI.sub
            sb.TextXAlignment = Enum.TextXAlignment.Left
            sb.Size = UDim2.new(1, -150, 0, 14)
            sb.Position = UDim2.new(0, 6, 0, 26)
            sb.BackgroundTransparency = 1
            sb.ZIndex = 15
            sb.Parent = row
        end
    end
    local arrow = Instance.new("TextLabel")
    arrow.Text = "›"
    arrow.Font = FONT_BOLD
    arrow.TextSize = FS(18)
    arrow.TextColor3 = UI.sub
    arrow.Size = UDim2.new(0, 22, 1, 0)
    arrow.Position = UDim2.new(1, -32, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.ZIndex = 15
    arrow.Parent = row
    row.MouseButton1Click:Connect(function()
        click()
        if callback then callback() end
    end)
end

local function moduleRow(text, key, settingsFn, onChange)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, 0, 0, 0)
    holder.AutomaticSize = Enum.AutomaticSize.Y
    holder.BackgroundColor3 = UI.card
    holder.BackgroundTransparency = S.Transparent and 0.45 or 0
    holder.ClipsDescendants = true
    holder.LayoutOrder = nextOrder()
    holder.ZIndex = 12
    holder.Parent = grid
    corner(holder, 11)
    local hst = stroke(holder, UI.line, 0.93, 1)

    local hlist = Instance.new("UIListLayout")
    hlist.SortOrder = Enum.SortOrder.LayoutOrder
    hlist.Parent = holder

    local headH = S.Mobile and 86 or 76
    local head = Instance.new("Frame")
    head.Size = UDim2.new(1, 0, 0, headH)
    head.BackgroundTransparency = 1
    head.LayoutOrder = 1
    head.ZIndex = 12
    head.Parent = holder

    local headBtn = Instance.new("TextButton")
    headBtn.Size = UDim2.new(1, 0, 1, 0)
    headBtn.BackgroundTransparency = 1
    headBtn.Text = ""
    headBtn.AutoButtonColor = false
    headBtn.ZIndex = 12
    headBtn.Parent = head

    local arrowW = settingsFn and 34 or 0
    local boxW = key and 46 or 0
    local reserve = arrowW + boxW + 14
    local subText = SUBTITLES[key] or (settingsFn and "Tap to open settings" or "Toggle feature")

    local tl = Instance.new("TextLabel")
    tl.Text = text
    tl.Font = FONT_BOLD
    tl.TextSize = FS(14)
    tl.TextColor3 = UI.text
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.TextYAlignment = Enum.TextYAlignment.Top
    tl.TextWrapped = true
    tl.Size = UDim2.new(1, -(28 + reserve), 0, 20)
    tl.Position = UDim2.new(0, 16, 0, 15)
    tl.BackgroundTransparency = 1
    tl.ZIndex = 13
    tl.Parent = head

    local sb = Instance.new("TextLabel")
    sb.Text = subText
    sb.Font = FONT_REG
    sb.TextSize = FS(11)
    sb.TextColor3 = UI.sub
    sb.TextXAlignment = Enum.TextXAlignment.Left
    sb.TextYAlignment = Enum.TextYAlignment.Top
    sb.TextWrapped = true
    sb.Size = UDim2.new(1, -(28 + reserve), 0, 34)
    sb.Position = UDim2.new(0, 16, 0, 39)
    sb.BackgroundTransparency = 1
    sb.ZIndex = 13
    sb.Parent = head

    local arrow
    if settingsFn then
        arrow = Instance.new("TextLabel")
        arrow.Text = "▾"
        arrow.Font = FONT_BOLD
        arrow.TextSize = FS(16)
        arrow.TextColor3 = UI.sub
        arrow.Size = UDim2.new(0, 22, 0, 22)
        arrow.Position = UDim2.new(1, key and -82 or -38, 0.5, -11)
        arrow.BackgroundTransparency = 1
        arrow.ZIndex = 13
        arrow.Parent = head
    end

    local box, mark, bst
    if key then
        box, mark, bst = makeBox(head, -46, -15, 30)
        box.BackgroundColor3 = UI.field
        styleBox(box, mark, bst, S[key])
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 22
        btn.Parent = box
        btn.MouseButton1Click:Connect(function()
            S[key] = not S[key]
            styleBox(box, mark, bst, S[key])
            click()
            if onChange then onChange(S[key]) end
        end)
    end

    local panel = Instance.new("Frame")
    panel.Size = UDim2.new(1, 0, 0, 0)
    panel.Name = "SettingsPanel"
    panel.BackgroundColor3 = Color3.fromRGB(30, 32, 38)
    panel.BackgroundTransparency = S.Transparent and 0.6 or 0
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.LayoutOrder = 2
    panel.Visible = false
    panel.ZIndex = 12
    panel.Parent = holder
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 4)
    pad.PaddingBottom = UDim.new(0, 10)
    pad.Parent = panel
    local plist = Instance.new("UIListLayout")
    plist.Padding = UDim.new(0, 2)
    plist.SortOrder = Enum.SortOrder.LayoutOrder
    plist.Parent = panel

    local built, expanded, target = false, false, 0

    headBtn.MouseEnter:Connect(function()
        tw(holder, 0.12, {BackgroundColor3 = UI.cardHi})
        hst.Transparency = 0.86
    end)
    headBtn.MouseLeave:Connect(function()
        tw(holder, 0.12, {BackgroundColor3 = UI.card})
        hst.Transparency = 0.93
    end)

    headBtn.MouseButton1Click:Connect(function()
        if not settingsFn then
            if key then
                S[key] = not S[key]
                styleBox(box, mark, bst, S[key])
            end
            click()
            if key and onChange then onChange(S[key]) end
            return
        end
        expanded = not expanded
        if expanded then
            if not built then
                built = true
                panel.Visible = true
                panel.Size = UDim2.new(1, 0, 0, 0)
                settingOrder = 0
                currentPanel = panel
                local ok, err = pcall(settingsFn)
                currentPanel = nil
                if not ok then warn("hamer settings error: " .. tostring(err)) end
                task.defer(function()
                    target = plist.AbsoluteContentSize.Y + 18
                    if target <= 18 then
                        task.delay(0.03, function()
                            target = plist.AbsoluteContentSize.Y + 18
                            if expanded then
                                tw(panel, 0.28, {Size = UDim2.new(1, 0, 0, target)}, Enum.EasingStyle.Quart)
                            end
                        end)
                        return
                    end
                    if expanded then
                        tw(panel, 0.28, {Size = UDim2.new(1, 0, 0, target)}, Enum.EasingStyle.Quart)
                    end
                end)
            else
                panel.Visible = true
                tw(panel, 0.28, {Size = UDim2.new(1, 0, 0, target)}, Enum.EasingStyle.Quart)
            end
        else
            tw(panel, 0.22, {Size = UDim2.new(1, 0, 0, 0)}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
            task.delay(0.24, function()
                if not expanded then panel.Visible = false end
            end)
        end
        if arrow then
            tw(arrow, 0.24, {Rotation = expanded and 180 or 0})
        end
        click()
    end)

    registerCard(holder, text, subText)
    return holder
end

local function toggleRow(text, key, onChange)
    if currentPanel then
        return settingToggle(text, key, onChange)
    end
    return moduleRow(text, key, nil, onChange)
end

local function settingStepTop(text, key, minv, maxv, step, suffix, onChange)
    local card = cardBase(text, SUBTITLES[key] or "Adjust value", 112)
    local val = Instance.new("TextLabel")
    val.Font = FONT_BOLD
    val.TextSize = FS(12)
    val.TextColor3 = accent()
    val.Size = UDim2.new(0, 40, 0, 20)
    val.Position = UDim2.new(1, -82, 0.5, -10)
    val.TextXAlignment = Enum.TextXAlignment.Right
    val.BackgroundTransparency = 1
    val.ZIndex = 14
    val.Parent = card
    bindAccent(function(c) val.TextColor3 = c end)
    local function refresh()
        local v = S[key]
        if type(v) == "number" then
            if v == math.floor(v) then
                val.Text = tostring(math.floor(v)) .. (suffix or "")
            else
                val.Text = string.format("%.2f", v) .. (suffix or "")
            end
        end
    end
    local function mk(txt, x)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 26, 0, 26)
        b.Position = UDim2.new(1, x, 0.5, -13)
        b.BackgroundColor3 = UI.field
        b.Text = txt
        b.Font = FONT_BOLD
        b.TextSize = FS(15)
        b.TextColor3 = UI.text
        b.AutoButtonColor = false
        b.ZIndex = 14
        b.Parent = card
        corner(b, 7)
        stroke(b, UI.line, 0.86, 1)
        return b
    end
    local minus = mk("−", -108)
    local plus = mk("+", -40)
    minus.MouseButton1Click:Connect(function()
        S[key] = clamp(S[key] - step, minv, maxv)
        refresh()
        click()
        if onChange then onChange(S[key]) end
    end)
    plus.MouseButton1Click:Connect(function()
        S[key] = clamp(S[key] + step, minv, maxv)
        refresh()
        click()
        if onChange then onChange(S[key]) end
    end)
    refresh()
    return card
end

local function stepRow(text, key, minv, maxv, step, suffix, onChange)
    if currentPanel then
        return settingStep(text, key, minv, maxv, step, suffix, onChange)
    end
    return settingStepTop(text, key, minv, maxv, step, suffix, onChange)
end

local function actionRow(text, sub, callback)
    if currentPanel then
        return settingAction(text, sub, callback)
    end
    local card = cardBase(text, sub or "Run action", 40)
    local arrow = Instance.new("TextLabel")
    arrow.Text = "›"
    arrow.Font = FONT_BOLD
    arrow.TextSize = FS(20)
    arrow.TextColor3 = UI.sub
    arrow.Size = UDim2.new(0, 24, 0, 28)
    arrow.Position = UDim2.new(1, -34, 0.5, -14)
    arrow.BackgroundTransparency = 1
    arrow.ZIndex = 13
    arrow.Parent = card
    card.MouseButton1Click:Connect(function()
        click()
        if callback then callback() end
    end)
end

local function colorRow(text, key, onChange)
    if currentPanel then
        return settingColor(text, key, onChange)
    end
    local card = cardBase(text, SUBTITLES[key] or "Tap to change color")
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 28, 0, 28)
    dot.Position = UDim2.new(1, -42, 0.5, -14)
    dot.BackgroundColor3 = S[key]
    dot.BorderSizePixel = 0
    dot.ZIndex = 14
    dot.Parent = card
    corner(dot, 14)
    stroke(dot, UI.line, 0.5, 2)
    card.MouseButton1Click:Connect(function()
        local idx = 1
        for i, c in ipairs(PALETTE) do
            if c == S[key] then idx = i; break end
        end
        S[key] = PALETTE[(idx % #PALETTE) + 1]
        dot.BackgroundColor3 = S[key]
        click()
        if onChange then onChange(S[key]) end
    end)
end

local function textRow(labelText, key, placeholder)
    if currentPanel then
        return settingText(labelText, key, placeholder)
    end
    local card = cardBase(labelText, "Type a value", 140)
    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 110, 0, 34)
    box.Position = UDim2.new(1, -124, 0.5, -17)
    box.BackgroundColor3 = UI.field
    box.BorderSizePixel = 0
    box.Font = FONT_REG
    box.TextSize = FS(12)
    box.TextColor3 = UI.text
    box.PlaceholderText = placeholder or ""
    box.PlaceholderColor3 = UI.sub
    box.Text = tostring(S[key] or "")
    box.ClearTextOnFocus = false
    box.ZIndex = 14
    box.Parent = card
    corner(box, 8)
    stroke(box, UI.line, 0.86, 1)
    box:GetPropertyChangedSignal("Text"):Connect(function()
        S[key] = box.Text
    end)
end

UI.activeBind = nil
UI.KEYBIND_LIST = {
    {"ESP", "ESP"}, {"Aimbot", "Aimbot"}, {"Silent Aim", "SilentAim"}, {"Kill All", "KillAll"},
    {"Fly", "Fly"}, {"Noclip", "Noclip"}, {"Speed", "Speed"}, {"Coin Farm", "CoinFarm"},
    {"Fullbright", "Fullbright"}, {"Mini Fox", "Fox"}, {"Wings", "Wings"}, {"Aura", "Aura"}
}

UI.keybindRow = function(text, action)
    local row = panelRow(text, 46)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 86, 0, 28)
    btn.Position = UDim2.new(1, -94, 0.5, -14)
    btn.BackgroundColor3 = UI.field
    btn.BorderSizePixel = 0
    btn.Font = FONT_BOLD
    btn.TextSize = FS(12)
    btn.TextColor3 = UI.text
    btn.AutoButtonColor = false
    btn.ZIndex = 16
    btn.Parent = row
    corner(btn, 7)
    stroke(btn, UI.line, 0.86, 1)
    local function refresh()
        btn.Text = S.Keybinds[action] or "None"
        btn.TextColor3 = S.Keybinds[action] and accent() or UI.sub
    end
    btn.MouseButton1Click:Connect(function()
        if UI.activeBind and UI.activeBind.refresh then UI.activeBind.refresh() end
        UI.activeBind = {action = action, refresh = refresh}
        btn.Text = "Press key..."
        btn.TextColor3 = accent()
        click()
    end)
    refresh()
end

local function themeCard(name)
    local col = ACCENTS[name]
    local card, cst = cardBase(name, "Accent theme")
    if S.Accent == name then
        cst.Color = accent()
        cst.Transparency = 0.35
    end
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 28, 0, 28)
    dot.Position = UDim2.new(1, -42, 0.5, -14)
    dot.BackgroundColor3 = col
    dot.BorderSizePixel = 0
    dot.ZIndex = 14
    dot.Parent = card
    corner(dot, 14)
    stroke(dot, UI.line, 0.5, 1.4)
    if S.Accent == name then
        local m = Instance.new("TextLabel")
        m.Text = "✓"
        m.Font = FONT_BOLD
        m.TextSize = FS(15)
        m.TextColor3 = Color3.fromRGB(18, 20, 24)
        m.Size = UDim2.new(1, 0, 1, 0)
        m.BackgroundTransparency = 1
        m.ZIndex = 15
        m.Parent = dot
    end
    card.MouseButton1Click:Connect(function()
        S.Accent = name
        applyAccent()
        click()
        task.defer(function()
            if not Unloaded and S.MenuOpen then selectTab(currentTab) end
        end)
    end)
end

local function themeRow() end

local function clearContent()
    ActiveCards = {}
    cardOrder = 0
    currentPanel = nil
    for _, ch in ipairs(grid:GetChildren()) do
        if ch:IsA("GuiObject") then
            ch:Destroy()
        end
    end
end

local function filterCards()
    local q = string.lower(searchBox.Text or "")
    for _, c in ipairs(ActiveCards) do
        c.obj.Visible = (q == "" or string.find(c.text, q, 1, true) ~= nil)
    end
end

selectTab = function(id)
    currentTab = id
    for tid, b in pairs(tabButtons) do
        local on = tid == id
        if tid == "player" then
            b.btn.BackgroundColor3 = UI.card
            b.btn.BackgroundTransparency = on and (S.Transparent and 0.4 or 0.15) or (S.Transparent and 0.75 or 0.55)
            b.stroke.Color = on and accent() or UI.line
            b.stroke.Transparency = on and 0.4 or 0.85
        else
            b.btn.BackgroundColor3 = UI.navHi
            b.btn.BackgroundTransparency = on and (S.Transparent and 0.55 or 0) or 1
            b.stroke.Color = on and accent() or UI.line
            b.stroke.Transparency = on and 0.55 or 1
        end
        b.txt.TextColor3 = on and UI.text or UI.sub
        b.txt.Font = on and FONT_BOLD or FONT_REG
        if b.icon then b.icon.TextColor3 = on and accent() or UI.sub end
        if b.bar then
            b.bar.Visible = on
            b.bar.BackgroundColor3 = accent()
        end
    end
    for _, t in ipairs(tabs) do
        if t.id == id then contentTitle.Text = string.upper(t.label) end
    end
    clearContent()
    if searchBox.Text ~= "" then searchBox.Text = "" end
    if id == "player" then contentTitle.Text = "PLAYER" end
    if builders[id] then
        local ok, err = pcall(builders[id])
        if not ok then
            warn("hamer ui error: " .. tostring(err))
            local card = cardBase("UI error", tostring(err))
            card.BackgroundColor3 = Color3.fromRGB(70, 24, 30)
        end
    end
    grid.CanvasPosition = Vector2.new(0, 0)
    filterCards()
end

for i, t in ipairs(tabs) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, S.Mobile and 52 or 46)
    b.BackgroundColor3 = UI.navHi
    b.BackgroundTransparency = 1
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.LayoutOrder = i
    b.ZIndex = 12
    b.Parent = tabBar
    corner(b, 10)
    local bst = stroke(b, UI.line, 1, 1)
    local ic = Instance.new("TextLabel")
    ic.Text = t.icon
    ic.Font = FONT_REG
    ic.TextSize = FS(15)
    ic.TextColor3 = UI.sub
    ic.Size = UDim2.new(0, 26, 1, 0)
    ic.Position = UDim2.new(0, 14, 0, 0)
    ic.BackgroundTransparency = 1
    ic.ZIndex = 13
    ic.Parent = b
    local tx = Instance.new("TextLabel")
    tx.Text = t.label
    tx.Font = FONT_REG
    tx.TextSize = FS(14)
    tx.TextColor3 = UI.sub
    tx.TextXAlignment = Enum.TextXAlignment.Left
    tx.Size = UDim2.new(1, -52, 1, 0)
    tx.Position = UDim2.new(0, 46, 0, 0)
    tx.BackgroundTransparency = 1
    tx.ZIndex = 13
    tx.Parent = b
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 0, 20)
    bar.Position = UDim2.new(0, 5, 0.5, -10)
    bar.BackgroundColor3 = accent()
    bar.BorderSizePixel = 0
    bar.Visible = false
    bar.ZIndex = 14
    bar.Parent = b
    corner(bar, 2)
    tabButtons[t.id] = {btn = b, stroke = bst, txt = tx, icon = ic, bar = bar}
    b.MouseEnter:Connect(function()
        if currentTab ~= t.id then b.BackgroundTransparency = 0.85 end
    end)
    b.MouseLeave:Connect(function()
        if currentTab ~= t.id then b.BackgroundTransparency = 1 end
    end)
    b.MouseButton1Click:Connect(function()
        selectTab(t.id)
        click()
    end)
end

tabButtons.player = {btn = playerBtn, stroke = playerStroke, txt = playerTxt, icon = playerIcon}
playerBtn.MouseEnter:Connect(function()
    if currentTab ~= "player" then playerBtn.BackgroundTransparency = 0.35 end
end)
playerBtn.MouseLeave:Connect(function()
    if currentTab ~= "player" then playerBtn.BackgroundTransparency = S.Transparent and 0.75 or 0.55 end
end)
playerBtn.MouseButton1Click:Connect(function()
    selectTab("player")
    click()
end)

searchBox:GetPropertyChangedSignal("Text"):Connect(filterCards)

local toggler = Instance.new("TextButton")
toggler.Size = UDim2.new(0, S.Mobile and 58 or 46, 0, S.Mobile and 58 or 46)
toggler.Position = UDim2.new(1, S.Mobile and -74 or -62, 0, S.Mobile and 72 or 60)
toggler.Text = "H"
toggler.Font = FONT_BLACK
toggler.TextSize = FS(20)
toggler.TextColor3 = accent()
toggler.BackgroundColor3 = UI.bg
toggler.BackgroundTransparency = 0.12
toggler.BorderSizePixel = 0
toggler.AutoButtonColor = false
toggler.ZIndex = 30
toggler.Parent = gui
local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0, 13)
tc.Parent = toggler
local ts = Instance.new("UIStroke")
ts.Color = accent()
ts.Transparency = 0.4
ts.Thickness = 1.2
ts.Parent = toggler
bindAccent(function(c)
    toggler.TextColor3 = c
    ts.Color = c
end)

local function applyUITransparency()
    main.BackgroundTransparency = S.Transparent and 0.35 or 0
    content.BackgroundTransparency = S.Transparent and 0.5 or 0
    searchFrame.BackgroundTransparency = S.Transparent and 0.55 or 0
end

local function setMenu(open)
    S.MenuOpen = open
    toggler.Visible = not open
    if open then
        main.Visible = true
        uiScale.Scale = computeScale() * 0.9
        tw(uiScale, 0.24, {Scale = computeScale()}, Enum.EasingStyle.Back)
        tw(blur, 0.3, {Size = 16})
        dim.Visible = true
        dim.BackgroundTransparency = 1
        tw(dim, 0.3, {BackgroundTransparency = 0.55})
    else
        tw(blur, 0.24, {Size = 0})
        tw(dim, 0.24, {BackgroundTransparency = 1})
        uiScale.Scale = computeScale()
        tw(uiScale, 0.18, {Scale = computeScale() * 0.9}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.delay(0.2, function()
            if not S.MenuOpen then
                main.Visible = false
                dim.Visible = false
                uiScale.Scale = computeScale()
            end
        end)
    end
end

closeDot.MouseButton1Click:Connect(function()
    setMenu(false)
    click()
end)
toggler.MouseButton1Click:Connect(function()
    setMenu(true)
    click()
end)

conn(UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        setMenu(not S.MenuOpen)
    end
end))

local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
conn(UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end))
conn(UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end))
local espGui = Instance.new("ScreenGui")
espGui.Name = "HamerESP"
espGui.ResetOnSpawn = false
espGui.IgnoreGuiInset = true
espGui.DisplayOrder = 998
espGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
espGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local ESP_BOXES = {}

local function espFrame(parent)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    f.BorderSizePixel = 0
    f.Visible = false
    f.ZIndex = 3
    f.Parent = parent
    return f
end

local function espLabel(parent, size)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Font = FONT_BOLD
    t.TextSize = size or 12
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.TextStrokeTransparency = 0.35
    t.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    t.TextXAlignment = Enum.TextXAlignment.Center
    t.ZIndex = 4
    t.Visible = false
    t.Parent = parent
    return t
end

local function makeESPBox(plr)
    local folder = Instance.new("Folder")
    folder.Name = "ESP_" .. plr.Name
    folder.Parent = espGui
    local b = {plr = plr, folder = folder, corners = {}, bones = {}}
    b.box = espFrame(folder)
    b.box.BackgroundTransparency = 1
    b.stroke = Instance.new("UIStroke")
    b.stroke.Thickness = 1.5
    b.stroke.Parent = b.box
    b.corner = Instance.new("UICorner")
    b.corner.CornerRadius = UDim.new(0, 6)
    b.corner.Parent = b.box
    for i = 1, 8 do b.corners[i] = espFrame(folder) end
    b.hpBg = espFrame(folder)
    b.hpFill = espFrame(folder)
    b.name = espLabel(folder, 13)
    b.dist = espLabel(folder, 11)
    b.head = espFrame(folder)
    local hc = Instance.new("UICorner")
    hc.CornerRadius = UDim.new(1, 0)
    hc.Parent = b.head
    b.tracer = espFrame(folder)
    b.tracer.AnchorPoint = Vector2.new(0.5, 0.5)
    return b
end

local function hideESPBox(b)
    b.box.Visible = false
    b.hpBg.Visible = false
    b.hpFill.Visible = false
    b.name.Visible = false
    b.dist.Visible = false
    b.head.Visible = false
    b.tracer.Visible = false
    for _, c in ipairs(b.corners) do c.Visible = false end
    for _, l in ipairs(b.bones) do l.Visible = false end
end

local function destroyESPBox(b)
    if b.folder then b.folder:Destroy() end
end

local function ensureBones(b, count)
    while #b.bones < count do
        local line = espFrame(b.folder)
        line.AnchorPoint = Vector2.new(0.5, 0.5)
        table.insert(b.bones, line)
    end
end

local function setLine(line, x1, y1, x2, y2, color, thickness, transparency)
    local dx, dy = x2 - x1, y2 - y1
    local len = math.sqrt(dx * dx + dy * dy)
    if len < 1 then
        line.Visible = false
        return
    end
    line.Visible = true
    line.Position = UDim2.new(0, (x1 + x2) / 2, 0, (y1 + y2) / 2)
    line.Size = UDim2.new(0, len, 0, math.max(thickness or 1, 1))
    line.Rotation = math.deg(math.atan2(dy, dx))
    line.BackgroundColor3 = color
    line.BackgroundTransparency = transparency or 0.2
end

local function espRoleColor(role)
    if S.ESPRole then
        if role == "Murderer" then return S.ESPMurdererColor end
        if role == "Sheriff" then return S.ESPSheriffColor end
        if role == "Hero" then return S.ESPHeroColor end
        if role == "Innocent" then return S.ESPInnocentColor end
    end
    return S.ESPColor
end

local ROLE_MAP = {
    Zombie = "Murderer", Vampire = "Murderer", Freezer = "Murderer",
    Survivor = "Innocent", Hunter = "Innocent", Villager = "Innocent", Runner = "Innocent"
}

local roleSource = nil
local roleLoading = false
local roleTryAt = 0
local function loadRoleSource()
    if roleSource or roleLoading then return end
    local now = os.clock()
    if now < roleTryAt then return end
    roleTryAt = now + 5
    roleLoading = true
    task.spawn(function()
        local ok, rs = pcall(function() return game:GetService("ReplicatedStorage") end)
        if ok and rs then
            local candidates = {}
            local modules = rs:FindFirstChild("Modules")
            if modules then
                local client = modules:FindFirstChild("Client")
                if client then
                    local m = client:FindFirstChild("CurrentRoundClient")
                    if m then table.insert(candidates, m) end
                end
                local m2 = modules:FindFirstChild("CurrentRoundClient")
                if m2 then table.insert(candidates, m2) end
            end
            local client = rs:FindFirstChild("Client")
            if client then
                local m = client:FindFirstChild("CurrentRoundClient")
                if m then table.insert(candidates, m) end
            end
            local m3 = rs:FindFirstChild("CurrentRoundClient")
            if m3 then table.insert(candidates, m3) end
            for _, m in ipairs(candidates) do
                local ok2, src = pcall(require, m)
                if ok2 and type(src) == "table" and type(src.GetLatestPlayerData) == "function" then
                    roleSource = src
                    break
                end
            end
        end
        roleLoading = false
    end)
end

local function hasTool(plr, name)
    local ch, bp = plr.Character, plr:FindFirstChild("Backpack")
    for _, cont in ipairs({ch, bp}) do
        if cont then
            for _, tool in ipairs(cont:GetChildren()) do
                if tool:IsA("Tool") and string.find(string.lower(tool.Name), name, 1, true) then
                    return true
                end
            end
        end
    end
    return false
end

local function toolRole(plr)
    if hasTool(plr, "knife") then return "Murderer" end
    if hasTool(plr, "gun") then return "Sheriff" end
end

local roleCache = {}
local roleData = nil
local roleRefreshing = false
local roleNext = 0
local function refreshRoleData()
    if roleRefreshing or not roleSource then return end
    local now = os.clock()
    if now < roleNext then return end
    roleNext = now + 0.3
    roleRefreshing = true
    task.spawn(function()
        local ok, d = pcall(function() return roleSource.GetLatestPlayerData() end)
        if ok and type(d) == "table" then roleData = d end
        roleRefreshing = false
    end)
end
local function refreshRoles()
    refreshRoleData()
    for _, plr in ipairs(Players:GetPlayers()) do
        local role
        if roleData then
            local d = roleData[plr.Name]
            if d and not d.Dead and not d.Killed then role = d.Role end
        end
        if role then
            role = tostring(role)
            role = role:sub(1, 1):upper() .. role:sub(2):lower()
            role = ROLE_MAP[role] or role
        end
        if not role then role = toolRole(plr) end
        if role == "Innocent" and hasTool(plr, "gun") then role = "Hero" end
        if role ~= "Murderer" and role ~= "Sheriff" and role ~= "Hero" and role ~= "Innocent" then role = nil end
        roleCache[plr] = role
    end
end

local visCache = {}
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true
local function visibilityCheck(plr, char)
    local now = os.clock()
    local cached = visCache[plr]
    if cached and now - cached.at < 0.2 then return cached.v end
    local part = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
    if not part then return true end
    local filter = {}
    if LocalPlayer.Character then table.insert(filter, LocalPlayer.Character) end
    rayParams.FilterDescendantsInstances = filter
    local origin = Camera.CFrame.Position
    local result = Workspace:Raycast(origin, part.Position - origin, rayParams)
    local visible = (result == nil) or (result.Instance and result.Instance:IsDescendantOf(char))
    visCache[plr] = {at = now, v = visible}
    return visible
end

local R6_BONES = {
    {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
    {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
}
local R15_BONES = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
    {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
    {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
    {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
    {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
}
local function bonesFor(char)
    if char:FindFirstChild("UpperTorso") then return R15_BONES end
    return R6_BONES
end

local function updateESP()
    if not S.ESP then
        for _, b in pairs(ESP_BOXES) do
            hideESPBox(b)
            local char = b.plr.Character
            local hl = char and char:FindFirstChild("HamerChams")
            if hl then hl.Enabled = false end
        end
        return
    end
    loadRoleSource()
    refreshRoles()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local vp = Camera.ViewportSize
    local centerX, bottomY = vp.X / 2, vp.Y
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local b = ESP_BOXES[plr]
            if not b then
                b = makeESPBox(plr)
                ESP_BOXES[plr] = b
            end
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local charRoot = char and char:FindFirstChild("HumanoidRootPart")
            local role = roleCache[plr]
            local color = espRoleColor(role)
            local hl = char and char:FindFirstChild("HamerChams")
            if char and charRoot and hum and hum.Health > 0 then
                local cf, size = char:GetBoundingBox()
                local dist = myRoot and (myRoot.Position - cf.Position).Magnitude or 0
                local headPos = cf.Position + Vector3.new(0, size.Y / 2, 0)
                local feetPos = cf.Position - Vector3.new(0, size.Y / 2, 0)
                local hw, hOn = Camera:WorldToViewportPoint(headPos)
                local fw, fOn = Camera:WorldToViewportPoint(feetPos)
                if dist <= S.ESPMaxDist and hw.Z > 0 and fw.Z > 0 and (hOn or fOn) then
                    local top = math.min(hw.Y, fw.Y)
                    local bottom = math.max(hw.Y, fw.Y)
                    local h = math.max(bottom - top, 12)
                    local w = clamp(h * 0.55, 20, 400)
                    local cx = (hw.X + fw.X) / 2
                    local left, right = cx - w / 2, cx + w / 2
                    local hidden = S.ESPVisCheck and not visibilityCheck(plr, char)
                    local alpha = hidden and 0.7 or 0
                    local th = S.ESPThickness
                    local cs = math.clamp(w * 0.22, 8, 30)

                    b.box.Visible = not S.ESPCorners
                    if b.box.Visible then
                        b.box.Position = UDim2.new(0, left, 0, top)
                        b.box.Size = UDim2.new(0, w, 0, h)
                        b.stroke.Color = color
                        b.stroke.Thickness = th
                        b.stroke.Transparency = 0.05 + alpha
                    end
                    for _, c in ipairs(b.corners) do
                        c.Visible = S.ESPCorners
                        c.BackgroundColor3 = color
                        c.BackgroundTransparency = 0.05 + alpha
                    end
                    if S.ESPCorners then
                        local c1, c2 = b.corners[1], b.corners[2]
                        local c3, c4 = b.corners[3], b.corners[4]
                        local c5, c6 = b.corners[5], b.corners[6]
                        local c7, c8 = b.corners[7], b.corners[8]
                        c1.Position = UDim2.new(0, left, 0, top)
                        c1.Size = UDim2.new(0, cs, 0, th)
                        c2.Position = UDim2.new(0, left, 0, top)
                        c2.Size = UDim2.new(0, th, 0, cs)
                        c3.Position = UDim2.new(0, right - cs, 0, top)
                        c3.Size = UDim2.new(0, cs, 0, th)
                        c4.Position = UDim2.new(0, right - th, 0, top)
                        c4.Size = UDim2.new(0, th, 0, cs)
                        c5.Position = UDim2.new(0, left, 0, bottom - th)
                        c5.Size = UDim2.new(0, cs, 0, th)
                        c6.Position = UDim2.new(0, left, 0, bottom - cs)
                        c6.Size = UDim2.new(0, th, 0, cs)
                        c7.Position = UDim2.new(0, right - cs, 0, bottom - th)
                        c7.Size = UDim2.new(0, cs, 0, th)
                        c8.Position = UDim2.new(0, right - th, 0, bottom - cs)
                        c8.Size = UDim2.new(0, th, 0, cs)
                    end

                    if S.ESPHealth and hum.MaxHealth > 0 then
                        local ratio = clamp(hum.Health / hum.MaxHealth, 0, 1)
                        local hx = left - 6
                        b.hpBg.Visible = true
                        b.hpBg.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
                        b.hpBg.BackgroundTransparency = 0.35
                        b.hpBg.Position = UDim2.new(0, hx, 0, top)
                        b.hpBg.Size = UDim2.new(0, 3, 0, h)
                        b.hpFill.Visible = true
                        b.hpFill.BackgroundColor3 = Color3.fromRGB(235, 60, 60):Lerp(Color3.fromRGB(90, 225, 120), ratio)
                        b.hpFill.BackgroundTransparency = 0.05 + alpha
                        b.hpFill.Position = UDim2.new(0, hx, 0, top + h * (1 - ratio))
                        b.hpFill.Size = UDim2.new(0, 3, 0, math.max(h * ratio, 1))
                    else
                        b.hpBg.Visible = false
                        b.hpFill.Visible = false
                    end

                    b.name.Visible = S.ESPNames
                    if S.ESPNames then
                        local label = plr.DisplayName
                        if role then label = role .. " | " .. label end
                        b.name.Text = label
                        b.name.TextColor3 = role and color or Color3.fromRGB(245, 245, 245)
                        b.name.TextTransparency = alpha
                        b.name.TextStrokeTransparency = 0.35 + alpha
                        b.name.Size = UDim2.new(0, 260, 0, 16)
                        b.name.Position = UDim2.new(0, cx - 130, 0, top - 20)
                    end
                    b.dist.Visible = S.ESPDist
                    if S.ESPDist then
                        b.dist.Text = math.floor(dist) .. "m"
                        b.dist.TextColor3 = color
                        b.dist.TextTransparency = alpha
                        b.dist.TextStrokeTransparency = 0.35 + alpha
                        b.dist.Size = UDim2.new(0, 160, 0, 14)
                        b.dist.Position = UDim2.new(0, cx - 80, 0, bottom + 2)
                    end

                    b.head.Visible = S.ESPHeadDot
                    if S.ESPHeadDot then
                        local hd = clamp(w * 0.18, 5, 14)
                        b.head.BackgroundColor3 = color
                        b.head.BackgroundTransparency = 0.15 + alpha
                        b.head.Position = UDim2.new(0, hw.X - hd / 2, 0, hw.Y - hd / 2)
                        b.head.Size = UDim2.new(0, hd, 0, hd)
                    end

                    if S.ESPTracer then
                        setLine(b.tracer, centerX, bottomY, cx, top + h / 2, color, 1.2, 0.5 + alpha)
                    else
                        b.tracer.Visible = false
                    end

                    if S.ESPSkeleton then
                        local list = bonesFor(char)
                        ensureBones(b, #list)
                        local idx = 1
                        for _, pair in ipairs(list) do
                            local line = b.bones[idx]
                            idx = idx + 1
                            local pa = char:FindFirstChild(pair[1])
                            local pb = char:FindFirstChild(pair[2])
                            if pa and pb then
                                local wa, onA = Camera:WorldToViewportPoint(pa.Position)
                                local wb, onB = Camera:WorldToViewportPoint(pb.Position)
                                if wa.Z > 0 and wb.Z > 0 and (onA or onB) then
                                    setLine(line, wa.X, wa.Y, wb.X, wb.Y, color, 1.2, 0.35 + alpha)
                                else
                                    line.Visible = false
                                end
                            else
                                line.Visible = false
                            end
                        end
                        for i = idx, #b.bones do b.bones[i].Visible = false end
                    else
                        for _, line in ipairs(b.bones) do line.Visible = false end
                    end

                    if S.ESPChams then
                        if not hl then
                            hl = Instance.new("Highlight")
                            hl.Name = "HamerChams"
                            hl.Parent = char
                        end
                        hl.Enabled = true
                        hl.FillColor = color
                        hl.OutlineColor = color
                        hl.FillTransparency = 0.55
                        hl.OutlineTransparency = 0.15
                        hl.DepthMode = S.ESPChamsThrough and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
                    elseif hl then
                        hl.Enabled = false
                    end
                else
                    hideESPBox(b)
                    if hl then hl.Enabled = false end
                end
            else
                hideESPBox(b)
                if hl then hl.Enabled = false end
            end
        end
    end
end

local function cleanupESP()
    for plr, b in pairs(ESP_BOXES) do
        destroyESPBox(b)
        ESP_BOXES[plr] = nil
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        local hl = char and char:FindFirstChild("HamerChams")
        if hl then hl:Destroy() end
    end
    if LocalPlayer.Character then
        local hl = LocalPlayer.Character:FindFirstChild("HamerChams")
        if hl then hl:Destroy() end
    end
end

conn(Players.PlayerRemoving:Connect(function(plr)
    local b = ESP_BOXES[plr]
    if b then
        destroyESPBox(b)
        ESP_BOXES[plr] = nil
    end
    roleCache[plr] = nil
    visCache[plr] = nil
end))
conn(RunService.RenderStepped:Connect(function()
    if not Unloaded then updateESP() end
end))

UI.lightBase = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    GlobalShadows = Lighting.GlobalShadows
}

local function applyFullbright()
    if S.Fullbright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    else
        Lighting.Ambient = UI.lightBase.Ambient
        Lighting.OutdoorAmbient = UI.lightBase.OutdoorAmbient
        Lighting.Brightness = UI.lightBase.Brightness
        Lighting.ClockTime = UI.lightBase.ClockTime
        Lighting.GlobalShadows = UI.lightBase.GlobalShadows
    end
end

local function applyFog()
    local old = Lighting:FindFirstChild("HamerFog")
    if old then old:Destroy() end
    if not S.Fog then return end
    local a = Instance.new("Atmosphere")
    a.Name = "HamerFog"
    a.Density = clamp(S.FogDensity, 0, 1)
    a.Offset = 0.25
    a.Color = Color3.fromRGB(200, 205, 220)
    a.Decay = Color3.fromRGB(95, 105, 135)
    a.Haze = 1.5
    a.Glare = 0
    a.Parent = Lighting
end

local function applyWorld()
    local old = Lighting:FindFirstChild("HamerWorld")
    if old then old:Destroy() end
    if not S.World then return end
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "HamerWorld"
    cc.Saturation = S.WorldSaturation
    cc.Contrast = S.WorldContrast
    cc.Brightness = 0
    cc.TintColor = Color3.fromRGB(255, 255, 255)
    cc.Parent = Lighting
end

UI.mbEffect = Instance.new("BlurEffect")
UI.mbEffect.Name = "HamerMotionBlur"
UI.mbEffect.Size = 0
UI.mbEffect.Parent = Lighting
UI.mbLast = nil
UI.mbAmount = 0
conn(RunService.RenderStepped:Connect(function(dt)
    if Unloaded then return end
    if not S.MotionBlur then
        UI.mbAmount = 0
        UI.mbEffect.Size = 0
        UI.mbLast = nil
        return
    end
    local look = Camera.CFrame.LookVector
    local speed = 0
    if UI.mbLast then
        local dot = clamp(look:Dot(UI.mbLast), -1, 1)
        speed = math.acos(dot) / math.max(dt, 0.001)
    end
    UI.mbLast = look
    local target = clamp(speed * 2, 0, S.MotionBlurStrength)
    UI.mbAmount = UI.mbAmount + (target - UI.mbAmount) * math.min(dt * 10, 1)
    UI.mbEffect.Size = UI.mbAmount
end))

UI.aspectBase, UI.aspectLast = nil, nil
conn(RunService.RenderStepped:Connect(function()
    if Unloaded then return end
    if S.Aspect then
        local cur = Camera.CFrame
        if not UI.aspectBase or (UI.aspectLast and (cur.Position - UI.aspectLast.Position).Magnitude > 0.001) then
            UI.aspectBase = cur
        end
        UI.aspectLast = cur
        Camera.CFrame = UI.aspectBase * CFrame.new(0, 0, 0, 1, 0, 0, 0, S.AspectValue, 0, 0, 0, 1)
    else
        UI.aspectBase = nil
        UI.aspectLast = nil
    end
end))

UI.fovCircle = Instance.new("Frame")
UI.fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
UI.fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
UI.fovCircle.BackgroundTransparency = 1
UI.fovCircle.BorderSizePixel = 0
UI.fovCircle.Visible = false
UI.fovCircle.ZIndex = 6
UI.fovCircle.Parent = gui
UI.fovCorner = Instance.new("UICorner")
UI.fovCorner.CornerRadius = UDim.new(1, 0)
UI.fovCorner.Parent = UI.fovCircle
UI.fovStroke = Instance.new("UIStroke")
UI.fovStroke.Color = accent()
UI.fovStroke.Thickness = 1.4
UI.fovStroke.Transparency = 0.35
UI.fovStroke.Parent = UI.fovCircle
bindAccent(function(c) UI.fovStroke.Color = c end)

UI.flyBV, UI.flyBG = nil, nil
local Farm = {bv = nil, bg = nil, wasOn = false}
local noclipSaved = {}
local hitboxSaved = {}
local hitboxAcc = 0
local autoAcc = 0
UI.speedWasOn = false
UI.jumpWasOn = false

local function updateFly(char, hum, root)
    if S.Fly and char and hum and root then
        if not UI.flyBV then
            UI.flyBV = Instance.new("BodyVelocity")
            UI.flyBV.Name = "HamerFly"
            UI.flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            UI.flyBV.Velocity = Vector3.zero
            UI.flyBV.Parent = root
        end
        if not UI.flyBG then
            UI.flyBG = Instance.new("BodyGyro")
            UI.flyBG.Name = "HamerGyro"
            UI.flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
            UI.flyBG.P = 1500
            UI.flyBG.D = 60
            UI.flyBG.Parent = root
        end
        hum.PlatformStand = true
        local move = Vector3.zero
        local cf = Camera.CFrame
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
        if move.Magnitude > 0 then
            UI.flyBV.Velocity = move.Unit * S.FlySpeed
        else
            UI.flyBV.Velocity = Vector3.zero
        end
        UI.flyBG.CFrame = cf
    else
        if UI.flyBV then UI.flyBV:Destroy(); UI.flyBV = nil end
        if UI.flyBG then UI.flyBG:Destroy(); UI.flyBG = nil end
        if hum then hum.PlatformStand = false end
    end
end

local Coin = (function()
local farmTarget = nil
local farmScanAcc = 0

local function isCoinPart(obj, char)
    if not obj.Parent or obj:IsDescendantOf(char) then return false end
    if obj.Transparency >= 1 then return false end
    local n = string.lower(obj.Name)
    if string.find(n, "coin", 1, true) then return true end
    local p = obj.Parent
    if p and string.find(string.lower(p.Name), "coin", 1, true) then return true end
    if p and p.Parent and string.find(string.lower(p.Parent.Name), "coin", 1, true) then return true end
    return false
end

local function findCoin(char, root)
    local best, bestDist = nil, math.huge
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and isCoinPart(obj, char) then
            local d = (obj.Position - root.Position).Magnitude
            if d < bestDist then
                best, bestDist = obj, d
            end
        end
    end
    return best
end

local function stopCoinFarm()
    if Farm.farmBV then Farm.farmBV:Destroy(); Farm.farmBV = nil end
    if Farm.farmBG then Farm.farmBG:Destroy(); Farm.farmBG = nil end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
end

local function updateCoinFarm(dt, char, hum, root)
    if not (char and hum and root) then return end
    if hum.Health <= 0 then return end
    if UI.flyBV then UI.flyBV:Destroy(); UI.flyBV = nil end
    if UI.flyBG then UI.flyBG:Destroy(); UI.flyBG = nil end
    if not Farm.farmBV or not Farm.farmBV.Parent then
        Farm.farmBV = Instance.new("BodyVelocity")
        Farm.farmBV.Name = "HamerFarm"
        Farm.farmBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        Farm.farmBV.Velocity = Vector3.zero
        Farm.farmBV.Parent = root
    end
    if not Farm.farmBG or not Farm.farmBG.Parent then
        Farm.farmBG = Instance.new("BodyGyro")
        Farm.farmBG.Name = "HamerFarmGyro"
        Farm.farmBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        Farm.farmBG.P = 1500
        Farm.farmBG.D = 60
        Farm.farmBG.Parent = root
    end
    hum.PlatformStand = true
    farmScanAcc = farmScanAcc + dt
    if farmScanAcc >= 0.35 or not (farmTarget and farmTarget.Parent) then
        farmScanAcc = 0
        farmTarget = findCoin(char, root)
    end
    if not (farmTarget and farmTarget.Parent) then
        Farm.farmBV.Velocity = Vector3.zero
        return
    end
    local target = farmTarget.Position
    if S.FarmUnderMap then
        target = target - Vector3.new(0, 2, 0)
    end
    local delta = target - root.Position
    local dist = delta.Magnitude
    local speed = math.clamp(S.FarmSpeed or 80, 10, 300)
    if dist > 0.1 then
        local v = speed
        if dist < 12 then v = math.clamp(dist * 5, 3, speed) end
        Farm.farmBV.Velocity = delta.Unit * v
        local flat = Vector3.new(delta.X, 0, delta.Z)
        if flat.Magnitude > 0.1 then
            Farm.farmBG.CFrame = CFrame.lookAt(root.Position, root.Position + flat.Unit)
        end
    else
        Farm.farmBV.Velocity = Vector3.zero
    end
end

return {farm = Farm, update = updateCoinFarm, stop = stopCoinFarm}
end)()

conn(RunService.Heartbeat:Connect(function(dt)
    if Unloaded then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if hum then
        if S.Speed then
            hum.WalkSpeed = S.SpeedValue
            UI.speedWasOn = true
        elseif UI.speedWasOn then
            hum.WalkSpeed = 16
            UI.speedWasOn = false
        end
        if S.Jump then
            hum.UseJumpPower = true
            hum.JumpPower = S.JumpValue
            UI.jumpWasOn = true
        elseif UI.jumpWasOn then
            hum.JumpPower = 50
            UI.jumpWasOn = false
        end
    end

    if S.CoinFarm then
        Coin.farm.farmWasOn = true
        Coin.update(dt, char, hum, root)
    else
        if Coin.farm.farmWasOn then
            Coin.farm.farmWasOn = false
            Coin.stop()
        end
        updateFly(char, hum, root)
    end

    if char then
        if S.Noclip or (S.CoinFarm and (S.FarmNoClip or S.FarmUnderMap)) then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and noclipSaved[p] == nil then
                    noclipSaved[p] = p.CanCollide
                    p.CanCollide = false
                end
            end
        else
            for p, v in pairs(noclipSaved) do
                if p.Parent then p.CanCollide = v end
            end
            noclipSaved = {}
        end
    end

    hitboxAcc = hitboxAcc + dt
    if hitboxAcc >= 0.3 then
        hitboxAcc = 0
        if S.Hitbox then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    local r = plr.Character:FindFirstChild("HumanoidRootPart")
                    if r then
                        if hitboxSaved[r] == nil then hitboxSaved[r] = r.Size end
                        r.Size = Vector3.new(S.HitboxSize, S.HitboxSize, S.HitboxSize)
                    end
                end
            end
        else
            for p, v in pairs(hitboxSaved) do
                if p.Parent then p.Size = v end
            end
            hitboxSaved = {}
        end
    end

    if S.AutoCollect and char and root then
        autoAcc = autoAcc + dt
        if autoAcc >= 0.6 then
            autoAcc = 0
            local best, bestD = nil, 60
            for _, d in ipairs(Workspace:GetDescendants()) do
                if d:IsA("BasePart") and not d:IsDescendantOf(char) then
                    local n = string.lower(d.Name)
                    if string.find(n, "coin") or string.find(n, "cash") or string.find(n, "gem") or string.find(n, "money") or string.find(n, "diamond") then
                        local dist = (d.Position - root.Position).Magnitude
                        if dist < bestD then
                            bestD = dist
                            best = d
                        end
                    end
                end
            end
            if best then
                root.CFrame = CFrame.new(best.Position + Vector3.new(0, 3, 0))
            end
        end
    end
end))

conn(UIS.JumpRequest:Connect(function()
    if not S.InfJump then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end))

local afkConn = nil
local function setAntiAfk(on)
    S.AntiAfk = on
    if on and not afkConn then
        afkConn = LocalPlayer.Idled:Connect(function()
            local vu = game:GetService("VirtualUser")
            pcall(function()
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end)
    elseif not on and afkConn then
        afkConn:Disconnect()
        afkConn = nil
    end
end

conn(RunService.RenderStepped:Connect(function()
    if Unloaded then return end
    UI.fovCircle.Visible = S.Aimbot
    if not S.Aimbot then return end
    UI.fovCircle.Size = UDim2.new(0, S.AimbotFOV * 2, 0, S.AimbotFOV * 2)
    local vp = Camera.ViewportSize
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    local best, bestD = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local part = char and (char:FindFirstChild(S.AimbotPart) or char:FindFirstChild("HumanoidRootPart"))
            if hum and hum.Health > 0 and part then
                local sp, on = Camera:WorldToViewportPoint(part.Position)
                if on then
                    local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                    if d <= S.AimbotFOV and d < bestD then
                        bestD = d
                        best = part
                    end
                end
            end
        end
    end
    if best then
        local goal = CFrame.new(Camera.CFrame.Position, best.Position)
        Camera.CFrame = Camera.CFrame:Lerp(goal, clamp(1 - S.AimbotSmooth, 0.03, 1))
    end
end))

local Drone = {model = nil, conn = nil, active = false, t = 0}

local function mkDronePart(model, name, shape, size, cf, material, color)
    local p = Instance.new("Part")
    p.Name = name
    p.Shape = shape
    p.Size = size
    p.CFrame = cf
    p.Anchored = true
    p.CanCollide = false
    p.CanQuery = false
    p.CanTouch = false
    p.CastShadow = false
    p.Material = material
    p.Color = color
    p.Parent = model
    return p
end

local function createDroneModel()
    local model = Instance.new("Model")
    model.Name = "HamerDrone"
    local body = mkDronePart(model, "Fuselage", Enum.PartType.Block, Vector3.new(0.9, 0.7, 3.2), CFrame.new(0, 0, 0), Enum.Material.Metal, Color3.fromRGB(205, 210, 220))
    local wingL = mkDronePart(model, "WingL", Enum.PartType.Block, Vector3.new(3.2, 0.1, 1.1), CFrame.new(-1.4, 0, 0.4), Enum.Material.Metal, Color3.fromRGB(190, 195, 205))
    local wingR = mkDronePart(model, "WingR", Enum.PartType.Block, Vector3.new(3.2, 0.1, 1.1), CFrame.new(1.4, 0, 0.4), Enum.Material.Metal, Color3.fromRGB(190, 195, 205))
    local prop = mkDronePart(model, "Propeller", Enum.PartType.Block, Vector3.new(0.12, 1.5, 0.12), CFrame.new(0, 0, 1.9), Enum.Material.Wood, Color3.fromRGB(190, 150, 100))
    local nose = mkDronePart(model, "Nose", Enum.PartType.Ball, Vector3.new(0.6, 0.6, 0.9), CFrame.new(0, 0, -1.7), Enum.Material.Metal, Color3.fromRGB(60, 65, 75))
    model.PrimaryPart = body
    return model, prop
end

local function stopDrone()
    Drone.active = false
    S.DroneActive = false
    if Drone.conn then Drone.conn:Disconnect(); Drone.conn = nil end
    if Drone.model and Drone.model.Parent then Drone.model:Destroy() end
    Drone.model = nil
end

local function startDrone()
    if Drone.active then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local model, prop = createDroneModel()
    model:PivotTo(CFrame.new(root.Position + root.CFrame.LookVector * 4 + Vector3.new(0, 4, 0)))
    model.Parent = Workspace
    Drone.model = model
    Drone.active = true
    S.DroneActive = true
    Drone.t = 0
    local target, bestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            if r then
                local d = (r.Position - root.Position).Magnitude
                if d < bestDist then
                    bestDist = d
                    target = p
                end
            end
        end
    end
    Drone.conn = RunService.Heartbeat:Connect(function(dt)
        if not Drone.active or not model.Parent then return end
        Drone.t = Drone.t + dt
        local fus = model:FindFirstChild("Fuselage")
        if not fus then return end
        local targetPos
        if target and target.Character then
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if tr then targetPos = tr.Position end
        end
        if not targetPos then
            targetPos = fus.Position + fus.CFrame.LookVector * 10
        end
        local dir = targetPos - fus.Position
        if dir.Magnitude > 0.1 then
            model:PivotTo(CFrame.lookAt(fus.Position + dir.Unit * 45 * dt, targetPos))
        end
        if prop and prop.Parent then
            prop.CFrame = fus.CFrame * CFrame.new(0, 0, 1.9) * CFrame.Angles(0, 0, Drone.t * 35)
        end
        if target and target.Character then
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if tr and (tr.Position - fus.Position).Magnitude < 3 then
                local hum = target.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.Health = 0 end
                stopDrone()
            end
        end
        if Drone.t > 30 then stopDrone() end
    end)
end

local CE = (function()
local setSilentAim, setKillAll
local silentHookReady, silentHookTried = false, false
local silentRay = RaycastParams.new()
silentRay.FilterType = Enum.RaycastFilterType.Exclude
silentRay.IgnoreWater = true

local function silentVisible(targetChar, part)
    local myChar = LocalPlayer.Character
    local filter = {}
    if myChar then table.insert(filter, myChar) end
    table.insert(filter, targetChar)
    silentRay.FilterDescendantsInstances = filter
    local origin = Camera.CFrame.Position
    local ok, result = pcall(function() return Workspace:Raycast(origin, part.Position - origin, silentRay) end)
    return (not ok) or result == nil
end

local function findSilentTarget()
    local vp = Camera.ViewportSize
    local center = Vector2.new(vp.X / 2, vp.Y / 2)
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local best, bestD = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local part = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and part and root then
                local dist = myRoot and (myRoot.Position - part.Position).Magnitude or 0
                if dist <= S.SilentAimMaxDist then
                    local pos = part.Position
                    local predict = (S.SilentAimPredict or 0) / 1000
                    if predict > 0 then pos = pos + root.AssemblyLinearVelocity * predict end
                    local sp, on = Camera:WorldToViewportPoint(pos)
                    if on and sp.Z > 0 then
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if d <= S.SilentAimFOV and d < bestD and (S.SilentAimWallbang or silentVisible(char, part)) then
                            bestD = d
                            best = {part = part, char = char, pos = pos}
                        end
                    end
                end
            end
        end
    end
    return best
end

local function installSilentAimHook()
    if silentHookReady then return true end
    if silentHookTried then return false end
    silentHookTried = true
    if type(hookmetamethod) ~= "function" or type(getnamecallmethod) ~= "function" or type(newcclosure) ~= "function" then
        return false
    end
    local ok = pcall(function()
        local original
        original = hookmetamethod(game, "__namecall", newcclosure(function(remote, ...)
            local methodOk, method = pcall(getnamecallmethod)
            if not methodOk or method ~= "FireServer" or not S.SilentAim then
                return original(remote, ...)
            end
            if type(checkcaller) == "function" then
                local callerOk, caller = pcall(checkcaller)
                if callerOk and caller then return original(remote, ...) end
            end
            local nameOk, name = pcall(function() return remote.Name end)
            if not nameOk or type(name) ~= "string" or not string.find(string.lower(name), "shoot", 1, true) then
                return original(remote, ...)
            end
            local parentOk, parent = pcall(function() return remote.Parent end)
            if not parentOk or not parent or not string.find(string.lower(parent.Name), "gun", 1, true) then
                return original(remote, ...)
            end
            local target = findSilentTarget()
            if not target then return original(remote, ...) end
            local char = LocalPlayer.Character
            local gun = char and char:FindFirstChild("Gun")
            local handle = gun and (gun:FindFirstChild("Handle") or gun:FindFirstChildWhichIsA("BasePart"))
            local myRoot = char and char:FindFirstChild("HumanoidRootPart")
            local origin = handle and handle.Position or (myRoot and (myRoot.Position + Vector3.new(0, 1.2, 0)))
            if not origin or (target.pos - origin).Magnitude < 0.2 then
                return original(remote, ...)
            end
            return original(remote, CFrame.new(origin, target.pos), CFrame.new(target.pos))
        end))
    end)
    silentHookReady = ok
    return ok
end

local KNIFE_TARGET_PARTS = {"HumanoidRootPart", "UpperTorso", "Torso", "LowerTorso", "Head"}
local KillAll = {conn = nil, nextAt = 0}

local function findKnife(container)
    if not container then return nil end
    local knife = container:FindFirstChild("Knife")
    if knife and knife:IsA("Tool") then return knife end
    for _, tool in ipairs(container:GetChildren()) do
        if tool:IsA("Tool") and string.find(string.lower(tool.Name), "knife", 1, true) then return tool end
    end
end

local function knifeTouch(root)
    local char = LocalPlayer.Character
    if not char then return end
    local knife = findKnife(char)
    if not knife then
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        knife = findKnife(backpack)
        if knife then pcall(function() knife.Parent = char end) end
    end
    if not knife then return end
    local handle = knife:FindFirstChild("Handle") or knife:FindFirstChildWhichIsA("BasePart")
    if handle and type(firetouchinterest) == "function" then
        for _, name in ipairs(KNIFE_TARGET_PARTS) do
            local part = root.Parent and root.Parent:FindFirstChild(name)
            if part then
                pcall(firetouchinterest, handle, part, 0)
                pcall(firetouchinterest, handle, part, 1)
                pcall(firetouchinterest, part, handle, 0)
                pcall(firetouchinterest, part, handle, 1)
            end
        end
    end
    pcall(function() knife:Activate() end)
end

local function killAllStep()
    if not S.KillAll or Unloaded then return end
    local now = os.clock()
    if now < KillAll.nextAt then return end
    KillAll.nextAt = now + 0.12
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not findKnife(char) and not findKnife(backpack) then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local tchar = plr.Character
            local thum = tchar and tchar:FindFirstChildOfClass("Humanoid")
            local root = tchar and tchar:FindFirstChild("HumanoidRootPart")
            if thum and thum.Health > 0 and root then knifeTouch(root) end
        end
    end
end

setSilentAim = function(on)
    if on and not installSilentAimHook() then
        S.SilentAim = false
        toast("Silent Aim: executor has no hooks")
        return false
    end
    S.SilentAim = not not on
    return true
end

setKillAll = function(on)
    S.KillAll = not not on
    if S.KillAll then
        if not KillAll.conn then
            KillAll.conn = RunService.Heartbeat:Connect(killAllStep)
        end
        local char = LocalPlayer.Character
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
        if not findKnife(char) and not findKnife(backpack) then
            toast("Kill All: knife not found")
        end
    elseif KillAll.conn then
        KillAll.conn:Disconnect()
        KillAll.conn = nil
    end
end

return {setSilentAim = setSilentAim, setKillAll = setKillAll, KillAll = KillAll}
end)()

builders.combat = function()
    moduleRow("Speed", "Speed", function()
        stepRow("Walk speed", "SpeedValue", 16, 200, 4, "")
    end)
    moduleRow("Jump power", "Jump", function()
        stepRow("Jump value", "JumpValue", 50, 300, 10, "")
    end)
    moduleRow("Infinite jump", "InfJump")
    moduleRow("Fly", "Fly", function()
        stepRow("Fly speed", "FlySpeed", 10, 200, 5, "")
    end)
    moduleRow("Noclip", "Noclip")
    moduleRow("Aimbot", "Aimbot", function()
        stepRow("FOV", "AimbotFOV", 40, 400, 10, " px")
        stepRow("Smooth", "AimbotSmooth", 0, 0.9, 0.05, "")
    end)
    moduleRow("Silent Aim", "SilentAim", function()
        stepRow("FOV", "SilentAimFOV", 20, 600, 10, " px")
        stepRow("Max distance", "SilentAimMaxDist", 50, 2000, 50, " st")
        stepRow("Prediction", "SilentAimPredict", 0, 500, 10, " ms")
        toggleRow("Wallbang", "SilentAimWallbang")
    end, CE.setSilentAim)
    moduleRow("Hitbox expander", "Hitbox", function()
        stepRow("Hitbox size", "HitboxSize", 2, 30, 1, "")
    end)
    moduleRow("Auto collect", "AutoCollect")
    moduleRow("Coin Farm (MM2)", "CoinFarm", function()
        toggleRow("Noclip", "FarmNoClip")
        toggleRow("Under map", "FarmUnderMap")
        stepRow("Speed", "FarmSpeed", 10, 300, 10, "")
    end)
    moduleRow("Kill All (MM2)", "KillAll", nil, CE.setKillAll)
    moduleRow("Anti AFK", "AntiAfk", nil, setAntiAfk)
    actionRow("Kamikaze Drone", "Fly to nearest player and explode.", function()
        if Drone.active then stopDrone() else startDrone() end
    end)
end

builders.visual = function()
    moduleRow("Fog", "Fog", function()
        stepRow("Fog density", "FogDensity", 0, 1, 0.05, "", applyFog)
    end, applyFog)
    moduleRow("Fullbright", "Fullbright", nil, applyFullbright)
    moduleRow("Motion Blur", "MotionBlur", function()
        stepRow("Blur strength", "MotionBlurStrength", 0, 56, 2, "")
    end)
    moduleRow("World Color", "World", function()
        stepRow("Saturation", "WorldSaturation", -1, 1, 0.1, "", applyWorld)
        stepRow("Contrast", "WorldContrast", -1, 1, 0.1, "", applyWorld)
    end, applyWorld)
    moduleRow("Aspect Ratio", "Aspect", function()
        stepRow("Aspect value", "AspectValue", 0.5, 1.5, 0.05, "")
    end)
    moduleRow("ESP 2D", "ESP", function()
        toggleRow("Show names", "ESPNames")
        toggleRow("Show distance", "ESPDist")
        toggleRow("Role colors", "ESPRole")
        toggleRow("Corner box", "ESPCorners")
        toggleRow("Health bar", "ESPHealth")
        toggleRow("Head circle", "ESPHeadDot")
        toggleRow("Skeleton", "ESPSkeleton")
        toggleRow("Tracer", "ESPTracer")
        toggleRow("Chams", "ESPChams")
        toggleRow("Chams through walls", "ESPChamsThrough")
        toggleRow("Visibility check", "ESPVisCheck")
        stepRow("Max distance", "ESPMaxDist", 50, 2000, 50, " st")
        stepRow("Box thickness", "ESPThickness", 0.5, 5, 0.5, "")
        colorRow("Custom color", "ESPColor")
        colorRow("Murderer color", "ESPMurdererColor")
        colorRow("Sheriff color", "ESPSheriffColor")
        colorRow("Hero color", "ESPHeroColor")
        colorRow("Innocent color", "ESPInnocentColor")
    end)
end
local function neonPart(parent, shape, size, color, glow)
    local p = Instance.new("Part")
    p.Shape = shape
    p.Size = size
    p.Anchored = true
    p.CanCollide = false
    p.CanQuery = false
    p.CanTouch = false
    p.CastShadow = false
    p.Massless = true
    if glow and S.CosmeticGlow ~= false then
        p.Material = Enum.Material.Neon
    else
        p.Material = Enum.Material.SmoothPlastic
    end
    p.Color = color
    p.Parent = parent
    return p
end

local Dong = {model = nil, conn = nil}
local function applyDong()
    if Dong.conn then Dong.conn:Disconnect(); Dong.conn = nil end
    if Dong.model then Dong.model:Destroy(); Dong.model = nil end
    if not S.Dong then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local s = S.DongSize
    local model = Instance.new("Model")
    model.Name = "HamerDong"
    model.Parent = Workspace
    Dong.model = model
    local ballL = neonPart(model, Enum.PartType.Ball, Vector3.new(0.56 * s, 0.56 * s, 0.56 * s), S.DongColor, S.DongGlow)
    local ballR = neonPart(model, Enum.PartType.Ball, Vector3.new(0.56 * s, 0.56 * s, 0.56 * s), S.DongColor, S.DongGlow)
    local len = 1.25 * s
    local shaft = neonPart(model, Enum.PartType.Cylinder, Vector3.new(len, 0.5 * s, 0.5 * s), S.DongColor, S.DongGlow)
    local head = neonPart(model, Enum.PartType.Ball, Vector3.new(0.62 * s, 0.62 * s, 0.62 * s), S.DongHeadColor, S.DongGlow)
    local t = 0
    Dong.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Dong or not model.Parent then return end
        local c = LocalPlayer.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then return end
        t = t + dt
        local sway = math.sin(t * 2.2) * 0.08
        local bob = math.sin(t * 3.0) * 0.03
        local cf = r.CFrame * CFrame.new(0, bob, 0)
        local off = CFrame.new(0, -0.62 * s, -0.5 * s)
        ballL.CFrame = cf * off * CFrame.new(-0.28 * s, 0, 0)
        ballR.CFrame = cf * off * CFrame.new(0.28 * s, 0, 0)
        shaft.CFrame = cf * off * CFrame.new(0, 0, -len / 2) * CFrame.Angles(0, math.rad(90), 0) * CFrame.Angles(0, 0, sway)
        head.CFrame = cf * off * CFrame.new(0, 0, -len) * CFrame.Angles(0, 0, sway)
    end)
end

local Fox = {model = nil, conn = nil}
local function applyFox()
    if Fox.conn then Fox.conn:Disconnect(); Fox.conn = nil end
    if Fox.model then Fox.model:Destroy(); Fox.model = nil end
    if not S.Fox then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local sc = S.FoxSize or 1
    local orange = Color3.fromRGB(232, 122, 46)
    local white = Color3.fromRGB(246, 241, 234)
    local dark = Color3.fromRGB(38, 30, 26)
    local model = Instance.new("Model")
    model.Name = "HamerFox"
    model.Parent = Workspace
    Fox.model = model
    local parts = {}
    local function add(shape, size, color, pos, rot)
        local p = neonPart(model, shape, Vector3.new(size.X * sc, size.Y * sc, size.Z * sc), color, false)
        local off = CFrame.new(pos.X * sc, pos.Y * sc, pos.Z * sc)
        if rot then off = off * rot end
        table.insert(parts, {p = p, off = off})
    end
    add(Enum.PartType.Block, Vector3.new(0.46, 0.4, 0.8), orange, Vector3.new(0, 0, 0))
    add(Enum.PartType.Block, Vector3.new(0.32, 0.26, 0.16), white, Vector3.new(0, -0.03, -0.36))
    add(Enum.PartType.Ball, Vector3.new(0.44, 0.42, 0.44), orange, Vector3.new(0, 0.27, -0.36))
    add(Enum.PartType.Block, Vector3.new(0.22, 0.15, 0.24), white, Vector3.new(0, 0.18, -0.59))
    add(Enum.PartType.Ball, Vector3.new(0.09, 0.08, 0.09), dark, Vector3.new(0, 0.2, -0.71))
    add(Enum.PartType.Ball, Vector3.new(0.07, 0.08, 0.07), dark, Vector3.new(-0.11, 0.34, -0.55))
    add(Enum.PartType.Ball, Vector3.new(0.07, 0.08, 0.07), dark, Vector3.new(0.11, 0.34, -0.55))
    add(Enum.PartType.Block, Vector3.new(0.15, 0.24, 0.07), orange, Vector3.new(-0.14, 0.5, -0.33), CFrame.Angles(0, 0, math.rad(16)))
    add(Enum.PartType.Block, Vector3.new(0.15, 0.24, 0.07), orange, Vector3.new(0.14, 0.5, -0.33), CFrame.Angles(0, 0, math.rad(-16)))
    add(Enum.PartType.Block, Vector3.new(0.13, 0.16, 0.3), orange, Vector3.new(-0.16, -0.27, -0.2))
    add(Enum.PartType.Block, Vector3.new(0.13, 0.16, 0.3), orange, Vector3.new(0.16, -0.27, -0.2))
    add(Enum.PartType.Block, Vector3.new(0.18, 0.18, 0.52), orange, Vector3.new(0, 0.08, 0.53), CFrame.Angles(math.rad(32), 0, 0))
    add(Enum.PartType.Ball, Vector3.new(0.17, 0.17, 0.17), white, Vector3.new(0, 0.23, 0.78))
    local t = 0
    Fox.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Fox or not model.Parent then return end
        local c = LocalPlayer.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then return end
        t = t + dt
        local bob = math.sin(t * 2.6) * 0.025
        local sway = math.sin(t * 1.8) * math.rad(2)
        local base = r.CFrame * CFrame.new(0.9, 1.02 + bob, -0.02) * CFrame.Angles(0, math.rad(-8), sway)
        for _, e in ipairs(parts) do
            e.p.CFrame = base * e.off
        end
    end)
end

local Wings = {model = nil, conn = nil}
local function applyWings()
    if Wings.conn then Wings.conn:Disconnect(); Wings.conn = nil end
    if Wings.model then Wings.model:Destroy(); Wings.model = nil end
    if not S.Wings then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local c = accent()
    local model = Instance.new("Model")
    model.Name = "HamerWings"
    model.Parent = Workspace
    Wings.model = model
    for sign = -1, 1, 2 do
        for i = 1, 9 do
            local p = neonPart(model, Enum.PartType.Block, Vector3.new(0.9, 0.2, 0.12), c, true)
            p:SetAttribute("sign", sign)
            p:SetAttribute("t", (i - 1) / 8)
        end
    end
    local t = 0
    Wings.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Wings or not model.Parent then return end
        local ch = LocalPlayer.Character
        local r = ch and ch:FindFirstChild("HumanoidRootPart")
        if not r then return end
        t = t + dt
        local flap = math.sin(t * 3.5) * math.rad(14)
        for _, p in ipairs(model:GetChildren()) do
            if p:IsA("BasePart") then
                local sign = p:GetAttribute("sign")
                local ft = p:GetAttribute("t")
                local x = sign * (0.7 + ft * 2.6)
                local y = 1.5 - ft * 0.9 + math.sin(ft * math.pi) * 0.3
                local z = 0.5 - ft * 0.2
                p.CFrame = r.CFrame * CFrame.new(x, y, z) * CFrame.Angles(0, 0, math.rad(sign * (20 + ft * 25)) + flap * sign)
            end
        end
    end)
end

local Halo = {model = nil, conn = nil}
local function applyHalo()
    if Halo.conn then Halo.conn:Disconnect(); Halo.conn = nil end
    if Halo.model then Halo.model:Destroy(); Halo.model = nil end
    if not S.Halo then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Head") then return end
    local c = accent()
    local model = Instance.new("Model")
    model.Name = "HamerHalo"
    model.Parent = Workspace
    Halo.model = model
    local balls = {}
    for i = 1, 16 do
        local p = neonPart(model, Enum.PartType.Ball, Vector3.new(0.16, 0.16, 0.16), c, true)
        table.insert(balls, {p = p, a = (i - 1) / 16 * math.pi * 2})
    end
    local t = 0
    Halo.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Halo or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        t = t + dt
        for _, e in ipairs(balls) do
            local a = e.a + t * 1.5
            e.p.CFrame = h.CFrame * CFrame.new(math.cos(a) * 0.95, 1.15, math.sin(a) * 0.95)
        end
    end)
end

local ChinaHat = {model = nil, conn = nil}
local function applyChinaHat()
    if ChinaHat.conn then ChinaHat.conn:Disconnect(); ChinaHat.conn = nil end
    if ChinaHat.model then ChinaHat.model:Destroy(); ChinaHat.model = nil end
    if not S.ChinaHat then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Head") then return end
    local c = accent()
    local model = Instance.new("Model")
    model.Name = "HamerChinaHat"
    model.Parent = Workspace
    ChinaHat.model = model
    local brim = neonPart(model, Enum.PartType.Cylinder, Vector3.new(0.1, 3.0, 3.0), c, true)
    local rings = {}
    for i = 1, 12 do
        local t = i / 12
        local d = 2.6 * (1 - t) + 0.08 * t
        local p = neonPart(model, Enum.PartType.Cylinder, Vector3.new(0.08, d, d), c, true)
        table.insert(rings, {p = p, y = 0.2 + t * 1.2})
    end
    ChinaHat.conn = RunService.RenderStepped:Connect(function()
        if not S.ChinaHat or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        brim.CFrame = h.CFrame * CFrame.new(0, 0.6, 0) * CFrame.Angles(0, 0, math.rad(90))
        for _, e in ipairs(rings) do
            e.p.CFrame = h.CFrame * CFrame.new(0, e.y, 0) * CFrame.Angles(0, 0, math.rad(90))
        end
    end)
end

local KG = {model = nil, conn = nil, t = 0, blend = 0}
local function applyKagune()
    if KG.conn then KG.conn:Disconnect(); KG.conn = nil end
    if KG.model then KG.model:Destroy(); KG.model = nil end
    if not S.Kagune then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local color = Color3.fromRGB(220, 30, 40)
    local model = Instance.new("Model")
    model.Name = "HamerKagune"
    model.Parent = Workspace
    KG.model = model
    local parts = {}
    for sx = -1, 1, 2 do
        for sy = -1, 1, 2 do
            for i = 1, 14 do
                local t = (i - 1) / 13
                local p = neonPart(model, Enum.PartType.Block, Vector3.new(0.5, 0.5, 0.5), color, true)
                p:SetAttribute("x", (0.5 + t * 2.0) * sx)
                p:SetAttribute("y", (0.3 + t * 1.6) * sy)
                p:SetAttribute("z", 0.5 - math.max(0, (t - 0.5) / 0.5) * 1.5)
                p:SetAttribute("t", t)
                p:SetAttribute("si", i)
                p:SetAttribute("us", sy)
                table.insert(parts, p)
            end
        end
    end
    KG.t = 0
    KG.blend = 0
    KG.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Kagune or not model.Parent then return end
        local c = LocalPlayer.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        KG.t = KG.t + dt
        local walking = hum and hum.MoveDirection.Magnitude > 0.1
        KG.blend = KG.blend + ((walking and 1 or 0) - KG.blend) * math.min(dt * 4, 1)
        local idle = math.sin(KG.t * 2.0) * 0.15
        local walk = math.sin(KG.t * 5) * 0.2
        for _, p in ipairs(parts) do
            if p.Parent then
                local t = p:GetAttribute("t")
                local us = p:GetAttribute("us")
                local wd = math.sin(KG.t * 5 - p:GetAttribute("si") * 0.3) * 0.15
                local fo = idle * (1 - KG.blend) + (walk + wd) * KG.blend
                local off = Vector3.new(p:GetAttribute("x") + fo * 0.5 * t, p:GetAttribute("y") + fo * us * t, p:GetAttribute("z"))
                p.CFrame = r.CFrame * CFrame.new(off) * CFrame.Angles(0, 0, math.rad(us * 45) + fo * us * 0.25) * CFrame.Angles(t * 1.2, 0, 0)
            end
        end
    end)
end

local CMP = {model = nil, conn = nil, t = 0}
local function applyCompanion()
    if CMP.conn then CMP.conn:Disconnect(); CMP.conn = nil end
    if CMP.model then CMP.model:Destroy(); CMP.model = nil end
    if not S.Companion then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local color = accent()
    local model = Instance.new("Model")
    model.Name = "HamerCompanion"
    model.Parent = Workspace
    CMP.model = model
    local box = neonPart(model, Enum.PartType.Block, Vector3.new(0.7, 0.7, 0.7), color, true)
    local core = neonPart(model, Enum.PartType.Ball, Vector3.new(0.28, 0.28, 0.28), Color3.fromRGB(255, 255, 255), true)
    core.Transparency = 0.15
    CMP.t = 0
    CMP.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Companion or not model.Parent then return end
        local c = LocalPlayer.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then return end
        CMP.t = CMP.t + dt
        local t = CMP.t
        local bob = math.sin(t * 2.5) * 0.15
        local sway = math.sin(t * 1.8) * 0.2
        local target = r.Position + r.CFrame.LookVector * (2.5 + sway) + r.CFrame.RightVector * 2.0 + r.CFrame.UpVector * (1.2 + bob)
        local pos = box.Position:Lerp(target, math.min(dt * 8, 1))
        box.CFrame = CFrame.new(pos) * CFrame.Angles(math.sin(t * 2) * 0.3, t * 3, math.sin(t * 2) * 0.15)
        local cs = 0.28 + math.sin(t * 4) * 0.05
        core.Size = Vector3.new(cs, cs, cs)
        core.CFrame = box.CFrame
        core.Transparency = 0.15 + math.sin(t * 4) * 0.08
    end)
end

local Cos = (function()
local function cosmeticModel(name)
    local model = Instance.new("Model")
    model.Name = name
    model.Parent = Workspace
    return model
end

local Aura = {model = nil, conn = nil}
local function applyAura()
    if Aura.conn then Aura.conn:Disconnect(); Aura.conn = nil end
    if Aura.model then Aura.model:Destroy(); Aura.model = nil end
    if not S.Aura then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local c = accent()
    local model = cosmeticModel("HamerAura")
    Aura.model = model
    local rings = {}
    for i = 1, 2 do
        local p = neonPart(model, Enum.PartType.Cylinder, Vector3.new(0.06, 3.6 - i * 0.55, 3.6 - i * 0.55), c, true)
        p.Transparency = 0.2 + i * 0.14
        rings[i] = p
    end
    local orbs = {}
    for i = 1, 3 do
        orbs[i] = neonPart(model, Enum.PartType.Ball, Vector3.new(0.26, 0.26, 0.26), c, true)
    end
    local t = 0
    Aura.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Aura or not model.Parent then return end
        local ch = LocalPlayer.Character
        local r = ch and ch:FindFirstChild("HumanoidRootPart")
        if not r then return end
        t = t + dt
        for i, p in ipairs(rings) do
            p.CFrame = r.CFrame * CFrame.new(0, 0.35 + i * 0.32, 0) * CFrame.Angles(0, t * (1.1 + i * 0.35), 0) * CFrame.Angles(0, 0, math.rad(90))
        end
        for i, p in ipairs(orbs) do
            local a = t * (1.3 + i * 0.22) + i * 2.09
            p.CFrame = r.CFrame * CFrame.new(math.cos(a) * 2.15, 0.85 + math.sin(t * 2 + i) * 0.32, math.sin(a) * 2.15)
        end
    end)
end

local Crown = {model = nil, conn = nil}
local function applyCrown()
    if Crown.conn then Crown.conn:Disconnect(); Crown.conn = nil end
    if Crown.model then Crown.model:Destroy(); Crown.model = nil end
    if not S.Crown then return end
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    local gold = Color3.fromRGB(255, 205, 70)
    local model = cosmeticModel("HamerCrown")
    Crown.model = model
    local band = neonPart(model, Enum.PartType.Cylinder, Vector3.new(0.2, 1.02, 1.02), gold, true)
    local spikes = {}
    for i = 1, 6 do
        spikes[i] = neonPart(model, Enum.PartType.Block, Vector3.new(0.16, 0.34, 0.16), gold, true)
    end
    local gem = neonPart(model, Enum.PartType.Ball, Vector3.new(0.2, 0.2, 0.2), accent(), true)
    Crown.conn = RunService.RenderStepped:Connect(function()
        if not S.Crown or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        band.CFrame = h.CFrame * CFrame.new(0, 0.92, 0) * CFrame.Angles(0, 0, math.rad(90))
        for i, p in ipairs(spikes) do
            local a = (i - 1) / 6 * math.pi * 2
            p.CFrame = h.CFrame * CFrame.new(math.cos(a) * 0.5, 1.16, math.sin(a) * 0.5) * CFrame.Angles(0, -a, 0)
        end
        gem.CFrame = h.CFrame * CFrame.new(0, 0.92, -0.54)
    end)
end

local Horns = {model = nil, conn = nil}
local function applyHorns()
    if Horns.conn then Horns.conn:Disconnect(); Horns.conn = nil end
    if Horns.model then Horns.model:Destroy(); Horns.model = nil end
    if not S.Horns then return end
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    local red = Color3.fromRGB(215, 40, 52)
    local model = cosmeticModel("HamerHorns")
    Horns.model = model
    local parts = {}
    for sign = -1, 1, 2 do
        for i = 1, 3 do
            local p = neonPart(model, Enum.PartType.Block, Vector3.new(0.17 - (i - 1) * 0.035, 0.3, 0.17 - (i - 1) * 0.035), red, true)
            p:SetAttribute("sign", sign)
            p:SetAttribute("i", i)
            table.insert(parts, p)
        end
    end
    Horns.conn = RunService.RenderStepped:Connect(function()
        if not S.Horns or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        for _, p in ipairs(parts) do
            local sign = p:GetAttribute("sign")
            local i = p:GetAttribute("i")
            local off = Vector3.new(sign * (0.3 + i * 0.08), 0.62 + i * 0.2, -0.04)
            p.CFrame = h.CFrame * CFrame.new(off) * CFrame.Angles(math.rad(-12), 0, math.rad(sign * (12 + i * 9)))
        end
    end)
end

local CatEars = {model = nil, conn = nil}
local function applyCatEars()
    if CatEars.conn then CatEars.conn:Disconnect(); CatEars.conn = nil end
    if CatEars.model then CatEars.model:Destroy(); CatEars.model = nil end
    if not S.CatEars then return end
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    local model = cosmeticModel("HamerCatEars")
    CatEars.model = model
    local outer = {}
    local inner = {}
    for sign = -1, 1, 2 do
        local a = neonPart(model, Enum.PartType.Block, Vector3.new(0.32, 0.42, 0.1), accent(), true)
        local b = neonPart(model, Enum.PartType.Block, Vector3.new(0.17, 0.25, 0.12), Color3.fromRGB(255, 175, 205), true)
        table.insert(outer, {p = a, sign = sign})
        table.insert(inner, {p = b, sign = sign})
    end
    CatEars.conn = RunService.RenderStepped:Connect(function()
        if not S.CatEars or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        for _, e in ipairs(outer) do
            local sign = e.sign
            e.p.CFrame = h.CFrame * CFrame.new(sign * 0.34, 0.72, -0.02) * CFrame.Angles(0, 0, math.rad(sign * 18))
        end
        for _, e in ipairs(inner) do
            local sign = e.sign
            e.p.CFrame = h.CFrame * CFrame.new(sign * 0.34, 0.72, -0.075) * CFrame.Angles(0, 0, math.rad(sign * 18))
        end
    end)
end

local Jetpack = {model = nil, conn = nil}
local function applyJetpack()
    if Jetpack.conn then Jetpack.conn:Disconnect(); Jetpack.conn = nil end
    if Jetpack.model then Jetpack.model:Destroy(); Jetpack.model = nil end
    if not S.Jetpack then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local model = cosmeticModel("HamerJetpack")
    Jetpack.model = model
    local body = neonPart(model, Enum.PartType.Block, Vector3.new(0.86, 1.0, 0.34), Color3.fromRGB(48, 52, 62), false)
    local tanks = {}
    for sign = -1, 1, 2 do
        local tank = neonPart(model, Enum.PartType.Cylinder, Vector3.new(0.68, 0.26, 0.26), accent(), true)
        table.insert(tanks, {p = tank, sign = sign})
    end
    local flames = {}
    for sign = -1, 1, 2 do
        local f = neonPart(model, Enum.PartType.Ball, Vector3.new(0.24, 0.58, 0.24), Color3.fromRGB(255, 145, 45), true)
        f.Transparency = 0.35
        table.insert(flames, {p = f, sign = sign})
    end
    local t = 0
    Jetpack.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Jetpack or not model.Parent then return end
        local ch = LocalPlayer.Character
        local r = ch and ch:FindFirstChild("HumanoidRootPart")
        if not r then return end
        t = t + dt
        local base = r.CFrame * CFrame.new(0, 0.78, 0.56)
        body.CFrame = base
        for _, e in ipairs(tanks) do
            e.p.CFrame = base * CFrame.new(e.sign * 0.34, 0, 0.02) * CFrame.Angles(0, 0, math.rad(90))
        end
        for _, e in ipairs(flames) do
            local s = 0.75 + math.sin(t * 18 + e.sign) * 0.25
            e.p.Size = Vector3.new(0.24 * s, 0.58 * s, 0.24 * s)
            e.p.CFrame = base * CFrame.new(e.sign * 0.34, -0.72, 0.02)
            e.p.Transparency = 0.3 + math.sin(t * 14 + e.sign) * 0.12
        end
    end)
end

local Tail = {model = nil, conn = nil}
local function applyTail()
    if Tail.conn then Tail.conn:Disconnect(); Tail.conn = nil end
    if Tail.model then Tail.model:Destroy(); Tail.model = nil end
    if not S.Tail then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local model = cosmeticModel("HamerTail")
    Tail.model = model
    local parts = {}
    for i = 1, 10 do
        local f = (i - 1) / 9
        local p = neonPart(model, Enum.PartType.Block, Vector3.new(0.22 - f * 0.11, 0.18 - f * 0.07, 0.24 - f * 0.1), accent():Lerp(Color3.fromRGB(255, 255, 255), f * 0.7), true)
        table.insert(parts, p)
    end
    local t = 0
    Tail.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Tail or not model.Parent then return end
        local ch = LocalPlayer.Character
        local r = ch and ch:FindFirstChild("HumanoidRootPart")
        if not r then return end
        t = t + dt
        for i, p in ipairs(parts) do
            local f = (i - 1) / 9
            local off = CFrame.new(math.sin(t * 3 - i * 0.45) * (0.08 + f * 0.3), 0.85 - f * 0.85 + math.sin(t * 4 - i * 0.5) * 0.07, 0.52 + f * 1.65)
            p.CFrame = r.CFrame * off * CFrame.Angles(math.sin(t * 3 - i * 0.4) * 0.25, 0, math.sin(t * 3 - i * 0.5) * 0.2)
        end
    end)
end

local TopHat = {model = nil, conn = nil}
local function applyTopHat()
    if TopHat.conn then TopHat.conn:Disconnect(); TopHat.conn = nil end
    if TopHat.model then TopHat.model:Destroy(); TopHat.model = nil end
    if not S.TopHat then return end
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    local dark = Color3.fromRGB(22, 23, 28)
    local model = cosmeticModel("HamerTopHat")
    TopHat.model = model
    local brim = neonPart(model, Enum.PartType.Cylinder, Vector3.new(0.08, 1.7, 1.7), dark, false)
    local top = neonPart(model, Enum.PartType.Cylinder, Vector3.new(0.95, 1.0, 1.0), dark, false)
    local band = neonPart(model, Enum.PartType.Cylinder, Vector3.new(0.24, 1.03, 1.03), accent(), true)
    TopHat.conn = RunService.RenderStepped:Connect(function()
        if not S.TopHat or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        brim.CFrame = h.CFrame * CFrame.new(0, 0.7, 0) * CFrame.Angles(0, 0, math.rad(90))
        band.CFrame = h.CFrame * CFrame.new(0, 0.93, 0) * CFrame.Angles(0, 0, math.rad(90))
        top.CFrame = h.CFrame * CFrame.new(0, 1.3, 0) * CFrame.Angles(0, 0, math.rad(90))
    end)
end

local Visor = {model = nil, conn = nil}
local function applyVisor()
    if Visor.conn then Visor.conn:Disconnect(); Visor.conn = nil end
    if Visor.model then Visor.model:Destroy(); Visor.model = nil end
    if not S.Visor then return end
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    local model = cosmeticModel("HamerVisor")
    Visor.model = model
    local bar = neonPart(model, Enum.PartType.Block, Vector3.new(0.74, 0.14, 0.08), accent(), true)
    local lens = neonPart(model, Enum.PartType.Block, Vector3.new(0.56, 0.08, 0.04), Color3.fromRGB(255, 255, 255), true)
    lens.Transparency = 0.25
    local t = 0
    Visor.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Visor or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        t = t + dt
        bar.CFrame = h.CFrame * CFrame.new(0, 0.06, -0.57)
        lens.CFrame = bar.CFrame * CFrame.new(0, 0, -0.045)
        bar.Transparency = 0.05 + math.sin(t * 4) * 0.08
        lens.Transparency = 0.2 + math.sin(t * 4 + 1) * 0.1
    end)
end

local Scythe = {model = nil, conn = nil}
local function applyScythe()
    if Scythe.conn then Scythe.conn:Disconnect(); Scythe.conn = nil end
    if Scythe.model then Scythe.model:Destroy(); Scythe.model = nil end
    if not S.Scythe then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local model = cosmeticModel("HamerScythe")
    Scythe.model = model
    local shaft = neonPart(model, Enum.PartType.Cylinder, Vector3.new(5.2, 0.11, 0.11), Color3.fromRGB(42, 44, 54), false)
    local blade = {}
    local specs = {
        {Vector3.new(0.9, 0.17, 0.1), CFrame.new(2.85, 0.1, 0) * CFrame.Angles(0, 0, math.rad(-8))},
        {Vector3.new(0.62, 0.15, 0.1), CFrame.new(3.3, 0.42, 0) * CFrame.Angles(0, 0, math.rad(-38))},
        {Vector3.new(0.4, 0.13, 0.1), CFrame.new(3.58, 0.72, 0) * CFrame.Angles(0, 0, math.rad(-62))}
    }
    for i, e in ipairs(specs) do
        local p = neonPart(model, Enum.PartType.Block, e[1], accent(), true)
        blade[i] = {p = p, off = e[2]}
    end
    local grip = neonPart(model, Enum.PartType.Ball, Vector3.new(0.26, 0.26, 0.26), accent(), true)
    Scythe.conn = RunService.RenderStepped:Connect(function()
        if not S.Scythe or not model.Parent then return end
        local ch = LocalPlayer.Character
        local r = ch and ch:FindFirstChild("HumanoidRootPart")
        if not r then return end
        local base = r.CFrame * CFrame.new(0, 1.05, 0.7) * CFrame.Angles(0, 0, math.rad(-32))
        shaft.CFrame = base
        grip.CFrame = base * CFrame.new(-2.4, 0, 0)
        for _, e in ipairs(blade) do
            e.p.CFrame = base * e.off
        end
    end)
end

local function refreshCosmetics()
    if S.Dong then applyDong() end
    if S.Wings then applyWings() end
    if S.Halo then applyHalo() end
    if S.ChinaHat then applyChinaHat() end
    if S.Kagune then applyKagune() end
    if S.Companion then applyCompanion() end
    if S.Aura then applyAura() end
    if S.Crown then applyCrown() end
    if S.Horns then applyHorns() end
    if S.CatEars then applyCatEars() end
    if S.Jetpack then applyJetpack() end
    if S.Tail then applyTail() end
    if S.TopHat then applyTopHat() end
    if S.Visor then applyVisor() end
    if S.Scythe then applyScythe() end
end

return {
    applyAura = applyAura, applyCrown = applyCrown, applyHorns = applyHorns,
    applyCatEars = applyCatEars, applyJetpack = applyJetpack, applyTail = applyTail,
    applyTopHat = applyTopHat, applyVisor = applyVisor, applyScythe = applyScythe,
    refresh = refreshCosmetics, cosmeticModel = cosmeticModel
}
end)()

local function applyNoAnims(on)
    S.NoAnims = on
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    if on then
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop() end)
        end
    end
end

local function applyKorblox(on)
    S.Korblox = on
    local char = LocalPlayer.Character
    if not char then return end
    for _, n in ipairs({"Right Leg", "RightUpperLeg", "RightLowerLeg"}) do
        local p = char:FindFirstChild(n)
        if p then
            p.Transparency = on and 1 or 0
        end
    end
end

local function applyGhostLegs(on)
    S.GhostLegs = on
    local char = LocalPlayer.Character
    if not char then return end
    for _, n in ipairs({"Left Leg", "Right Leg", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg"}) do
        local p = char:FindFirstChild(n)
        if p then
            p.Transparency = on and 1 or 0
        end
    end
end

local function setAvatarScale(v)
    S.AvatarScale = v
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _, n in ipairs({"BodyHeightScale", "BodyWidthScale", "BodyDepthScale", "HeadScale"}) do
        local nv = hum:FindFirstChild(n)
        if nv then nv.Value = v end
    end
end

local Wm = (function()
local wmGui = Instance.new("ScreenGui")
wmGui.Name = "HamerWatermark"
wmGui.ResetOnSpawn = false
wmGui.IgnoreGuiInset = true
wmGui.DisplayOrder = 997
wmGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
wmGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local wm = Instance.new("Frame")
wm.Size = UDim2.new(0, 210, 0, 26)
wm.Position = UDim2.new(0, 12, 0, 60)
wm.BackgroundColor3 = Color3.fromRGB(14, 18, 28)
wm.BackgroundTransparency = 0.12
wm.BorderSizePixel = 0
wm.ZIndex = 1
wm.Parent = wmGui
local wmc = Instance.new("UICorner")
wmc.CornerRadius = UDim.new(0, 8)
wmc.Parent = wm
local wms = Instance.new("UIStroke")
wms.Color = accent()
wms.Transparency = 0.5
wms.Thickness = 1
wms.Parent = wm
bindAccent(function(c) wms.Color = c end)
local wmText = Instance.new("TextLabel")
wmText.Text = "hamer"
wmText.Font = FONT_BOLD
wmText.TextSize = 11
wmText.TextColor3 = Color3.fromRGB(255, 255, 255)
wmText.TextTransparency = 0.15
wmText.TextXAlignment = Enum.TextXAlignment.Left
wmText.BackgroundTransparency = 1
wmText.Size = UDim2.new(1, -16, 1, 0)
wmText.Position = UDim2.new(0, 8, 0, 0)
wmText.ZIndex = 2
wmText.Parent = wm

local fpsCount, fpsAcc, fpsValue = 0, 0, 0
conn(RunService.RenderStepped:Connect(function(dt)
    if Unloaded then return end
    wmGui.Enabled = S.Watermark
    fpsAcc = fpsAcc + dt
    fpsCount = fpsCount + 1
    if fpsAcc >= 0.5 then
        fpsValue = math.floor(fpsCount / fpsAcc + 0.5)
        fpsAcc = 0
        fpsCount = 0
    end
    local ping = 0
    pcall(function()
        ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    end)
    wmText.Text = string.format("hamer  |  %d fps  |  %d ms", fpsValue, ping)
end))

local EmoteMenu = {gui = nil, track = nil}
local EMOTES = {
    {name = "Dance", id = "507771019"},
    {name = "Cheer", id = "507770677"},
    {name = "Hello", id = "507770239"},
    {name = "Point", id = "507770453"},
    {name = "Laugh", id = "507770818"},
    {name = "Sit", id = "2506281703"}
}

local function playEmote(id, looped)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end
    if EmoteMenu.track then pcall(function() EmoteMenu.track:Stop() end) end
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. id
    local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
    if ok and track then
        track.Priority = Enum.AnimationPriority.Action4
        track.Looped = looped == true
        track:Play()
        EmoteMenu.track = track
    end
end

local function toggleEmoteMenu()
    if EmoteMenu.gui and EmoteMenu.gui.Parent then
        EmoteMenu.gui:Destroy()
        EmoteMenu.gui = nil
        return
    end
    local eg = Instance.new("ScreenGui")
    eg.Name = "HamerEmotes"
    eg.ResetOnSpawn = false
    eg.IgnoreGuiInset = true
    eg.DisplayOrder = 998
    eg.ZIndexBehavior = Enum.ZIndexBehavior.Global
    eg.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 170, 0, 258)
    frame.Position = UDim2.new(1, -190, 0.5, -129)
    frame.BackgroundColor3 = Color3.fromRGB(14, 18, 28)
    frame.BackgroundTransparency = 0.06
    frame.BorderSizePixel = 0
    frame.ZIndex = 10
    frame.Parent = eg
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 16)
    fc.Parent = frame
    local fs = Instance.new("UIStroke")
    fs.Color = accent()
    fs.Transparency = 0.45
    fs.Thickness = 1.2
    fs.Parent = frame

    local tl = Instance.new("TextLabel")
    tl.Text = "EMOTES"
    tl.Font = FONT_BLACK
    tl.TextSize = 13
    tl.TextColor3 = Color3.fromRGB(255, 255, 255)
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.BackgroundTransparency = 1
    tl.Size = UDim2.new(1, -24, 0, 26)
    tl.Position = UDim2.new(0, 12, 0, 10)
    tl.ZIndex = 11
    tl.Parent = frame

    for i, e in ipairs(EMOTES) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -24, 0, 30)
        b.Position = UDim2.new(0, 12, 0, 40 + (i - 1) * 34)
        b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        b.BackgroundTransparency = 0.93
        b.BorderSizePixel = 0
        b.Text = e.name
        b.Font = FONT_REG
        b.TextSize = 12
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.AutoButtonColor = false
        b.ZIndex = 11
        b.Parent = frame
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 8)
        bc.Parent = b
        local bs = Instance.new("UIStroke")
        bs.Color = Color3.fromRGB(255, 255, 255)
        bs.Transparency = 0.9
        bs.Parent = b
        b.MouseButton1Click:Connect(function()
            playEmote(e.id, e.name == "Sit")
            click()
        end)
    end
    EmoteMenu.gui = eg
end

return {
    toggle = toggleEmoteMenu,
    cleanup = function()
        if EmoteMenu.gui and EmoteMenu.gui.Parent then EmoteMenu.gui:Destroy() end
        EmoteMenu.gui = nil
        if EmoteMenu.track then pcall(function() EmoteMenu.track:Stop() end) end
        if wmGui then wmGui:Destroy() end
    end
}
end)()

toast = function(text)
    local t = Instance.new("TextLabel")
    t.Text = text
    t.Font = FONT_BOLD
    t.TextSize = 12
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.BackgroundColor3 = Color3.fromRGB(14, 18, 28)
    t.BackgroundTransparency = 0.08
    t.Size = UDim2.new(0, 280, 0, 32)
    t.Position = UDim2.new(0.5, -140, 1, -104)
    t.ZIndex = 40
    t.Parent = gui
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 9)
    c.Parent = t
    local s = Instance.new("UIStroke")
    s.Color = accent()
    s.Transparency = 0.4
    s.Parent = t
    task.delay(2, function()
        if t and t.Parent then t:Destroy() end
    end)
end

local Cfg = (function()
local CONFIG_DIR = "hamer_configs"

local function hasFileAPI()
    return type(writefile) == "function" and type(readfile) == "function"
end

local function safeName(n)
    n = tostring(n or "default")
    n = string.gsub(n, "[^%w_%- ]", "")
    if n == "" then n = "default" end
    return n
end

local function serialize()
    local t = {}
    for k, v in pairs(S) do
        if (type(v) == "boolean" or type(v) == "number" or type(v) == "string") and k ~= "MenuOpen" and k ~= "DroneActive" then
            t[k] = v
        end
    end
    t.ESPColor = {math.floor(S.ESPColor.R * 255), math.floor(S.ESPColor.G * 255), math.floor(S.ESPColor.B * 255)}
    t.ESPMurdererColor = {math.floor(S.ESPMurdererColor.R * 255), math.floor(S.ESPMurdererColor.G * 255), math.floor(S.ESPMurdererColor.B * 255)}
    t.ESPSheriffColor = {math.floor(S.ESPSheriffColor.R * 255), math.floor(S.ESPSheriffColor.G * 255), math.floor(S.ESPSheriffColor.B * 255)}
    t.ESPHeroColor = {math.floor(S.ESPHeroColor.R * 255), math.floor(S.ESPHeroColor.G * 255), math.floor(S.ESPHeroColor.B * 255)}
    t.ESPInnocentColor = {math.floor(S.ESPInnocentColor.R * 255), math.floor(S.ESPInnocentColor.G * 255), math.floor(S.ESPInnocentColor.B * 255)}
    t.DongColor = {math.floor(S.DongColor.R * 255), math.floor(S.DongColor.G * 255), math.floor(S.DongColor.B * 255)}
    t.DongHeadColor = {math.floor(S.DongHeadColor.R * 255), math.floor(S.DongHeadColor.G * 255), math.floor(S.DongHeadColor.B * 255)}
    t.Keybinds = S.Keybinds
    return HttpService:JSONEncode(t)
end

local function reapplyAll()
    applyFullbright()
    applyFog()
    applyWorld()
    applyDong()
    applyFox()
    applyWings()
    applyHalo()
    applyChinaHat()
    applyKagune()
    applyCompanion()
    Cos.applyAura()
    Cos.applyCrown()
    Cos.applyHorns()
    Cos.applyCatEars()
    Cos.applyJetpack()
    Cos.applyTail()
    Cos.applyTopHat()
    Cos.applyVisor()
    Cos.applyScythe()
    applyKorblox(S.Korblox)
    applyGhostLegs(S.GhostLegs)
    applyNoAnims(S.NoAnims)
    setAvatarScale(S.AvatarScale)
    applyAccent()
    applyUITransparency()
    uiScale.Scale = computeScale()
    task.defer(function()
        if not Unloaded and S.MenuOpen then selectTab(currentTab) end
    end)
end

local function saveConfig()
    if not hasFileAPI() then toast("file api unavailable"); return end
    local name = safeName(S.ConfigName)
    local ok, err = pcall(function()
        if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder(CONFIG_DIR) then
            makefolder(CONFIG_DIR)
        end
        writefile(CONFIG_DIR .. "/" .. name .. ".json", serialize())
    end)
    toast(ok and ("saved: " .. name) or ("save failed: " .. tostring(err)))
end

local function loadConfig()
    if not hasFileAPI() then toast("file api unavailable"); return end
    local name = safeName(S.ConfigName)
    local path = CONFIG_DIR .. "/" .. name .. ".json"
    local ok, data = pcall(function() return readfile(path) end)
    if not ok or not data then toast("config not found: " .. name); return end
    local decOk, decoded = pcall(function() return HttpService:JSONDecode(data) end)
    if not decOk or type(decoded) ~= "table" then toast("broken config"); return end
    for k, v in pairs(decoded) do
        if S[k] ~= nil and typeof(S[k]) ~= "Color3" then
            if type(S[k]) == type(v) then S[k] = v end
        end
    end
    if type(decoded.ESPColor) == "table" then
        S.ESPColor = Color3.fromRGB(decoded.ESPColor[1] or 0, decoded.ESPColor[2] or 229, decoded.ESPColor[3] or 255)
    end
    if type(decoded.ESPMurdererColor) == "table" then
        S.ESPMurdererColor = Color3.fromRGB(decoded.ESPMurdererColor[1] or 255, decoded.ESPMurdererColor[2] or 64, decoded.ESPMurdererColor[3] or 64)
    end
    if type(decoded.ESPSheriffColor) == "table" then
        S.ESPSheriffColor = Color3.fromRGB(decoded.ESPSheriffColor[1] or 80, decoded.ESPSheriffColor[2] or 150, decoded.ESPSheriffColor[3] or 255)
    end
    if type(decoded.ESPHeroColor) == "table" then
        S.ESPHeroColor = Color3.fromRGB(decoded.ESPHeroColor[1] or 255, decoded.ESPHeroColor[2] or 210, decoded.ESPHeroColor[3] or 60)
    end
    if type(decoded.ESPInnocentColor) == "table" then
        S.ESPInnocentColor = Color3.fromRGB(decoded.ESPInnocentColor[1] or 90, decoded.ESPInnocentColor[2] or 230, decoded.ESPInnocentColor[3] or 130)
    end
    if type(decoded.DongColor) == "table" then
        S.DongColor = Color3.fromRGB(decoded.DongColor[1] or 232, decoded.DongColor[2] or 190, decoded.DongColor[3] or 158)
    end
    if type(decoded.DongHeadColor) == "table" then
        S.DongHeadColor = Color3.fromRGB(decoded.DongHeadColor[1] or 200, decoded.DongHeadColor[2] or 60, decoded.DongHeadColor[3] or 60)
    end
    if type(decoded.Keybinds) == "table" then
        local binds = {}
        for action, key in pairs(decoded.Keybinds) do
            if type(action) == "string" and type(key) == "string" then binds[action] = key end
        end
        S.Keybinds = binds
    end
    reapplyAll()
    CE.setSilentAim(S.SilentAim)
    CE.setKillAll(S.KillAll)
    toast("loaded: " .. name)
end

local function deleteConfig()
    if not hasFileAPI() then toast("file api unavailable"); return end
    local name = safeName(S.ConfigName)
    local ok = pcall(function()
        if type(delfile) == "function" then
            delfile(CONFIG_DIR .. "/" .. name .. ".json")
        end
    end)
    toast(ok and ("deleted: " .. name) or "delete failed")
end

return {
    dir = CONFIG_DIR, hasFileAPI = hasFileAPI, safeName = safeName,
    save = saveConfig, load = loadConfig, delete = deleteConfig, reapply = reapplyAll
}
end)()

local function unload()
    Unloaded = true
    for _, c in ipairs(Conns) do
        pcall(function() c:Disconnect() end)
    end
    Conns = {}
    stopDrone()
    S.Dong, S.Wings, S.Halo, S.ChinaHat = false, false, false, false
    S.Kagune, S.Companion, S.NoAnims = false, false, false
    S.Fox, S.CoinFarm, S.FarmNoClip, S.FarmUnderMap = false, false, false, false
    S.ESP, S.ESPChams, S.ESPChamsThrough = false, false, false
    S.Aura, S.Crown, S.Horns, S.CatEars, S.Jetpack = false, false, false, false, false
    S.Tail, S.TopHat, S.Visor, S.Scythe = false, false, false, false
    S.KillAll, S.SilentAim = false, false
    if CE.KillAll.conn then CE.KillAll.conn:Disconnect(); CE.KillAll.conn = nil end
    cleanupESP()
    applyDong()
    applyFox()
    applyWings()
    applyHalo()
    applyChinaHat()
    applyKagune()
    applyCompanion()
    Cos.applyAura()
    Cos.applyCrown()
    Cos.applyHorns()
    Cos.applyCatEars()
    Cos.applyJetpack()
    Cos.applyTail()
    Cos.applyTopHat()
    Cos.applyVisor()
    Cos.applyScythe()
    for p, v in pairs(noclipSaved) do
        if p.Parent then p.CanCollide = v end
    end
    noclipSaved = {}
    if UI.flyBV then UI.flyBV:Destroy() end
    if UI.flyBG then UI.flyBG:Destroy() end
    Coin.stop()
    S.Fullbright = false
    applyFullbright()
    S.Fog = false
    applyFog()
    S.World = false
    applyWorld()
    S.MotionBlur = false
    if UI.mbEffect then UI.mbEffect:Destroy() end
    Wm.cleanup()
    if blur then blur:Destroy() end
    if gui then gui:Destroy() end
    if espGui then espGui:Destroy() end
end

builders.cosmetics = function()
    moduleRow("Glow all cosmetics", "CosmeticGlow", nil, Cos.refresh)
    moduleRow("3D Dick", "Dong", function()
        stepRow("Size", "DongSize", 0.4, 3, 0.1, "", function()
            if S.Dong then applyDong() end
        end)
        toggleRow("Glow", "DongGlow", function()
            if S.Dong then applyDong() end
        end)
        colorRow("Skin color", "DongColor", function()
            if S.Dong then applyDong() end
        end)
        colorRow("Head color", "DongHeadColor", function()
            if S.Dong then applyDong() end
        end)
    end, applyDong)
    moduleRow("Korblox leg", "Korblox", nil, applyKorblox)
    moduleRow("Ghost legs", "GhostLegs", nil, applyGhostLegs)
    moduleRow("No animations", "NoAnims", nil, applyNoAnims)
    moduleRow("Mini Fox", "Fox", function()
        stepRow("Size", "FoxSize", 0.5, 2, 0.1, "", applyFox)
    end, applyFox)
    moduleRow("Wings", "Wings", nil, applyWings)
    moduleRow("Halo", "Halo", nil, applyHalo)
    moduleRow("China hat", "ChinaHat", nil, applyChinaHat)
    moduleRow("Kagune", "Kagune", nil, applyKagune)
    moduleRow("Companion", "Companion", nil, applyCompanion)
    moduleRow("Neon Aura", "Aura", nil, Cos.applyAura)
    moduleRow("Crown", "Crown", nil, Cos.applyCrown)
    moduleRow("Demon horns", "Horns", nil, Cos.applyHorns)
    moduleRow("Cat ears", "CatEars", nil, Cos.applyCatEars)
    moduleRow("Jetpack", "Jetpack", nil, Cos.applyJetpack)
    moduleRow("Neon tail", "Tail", nil, Cos.applyTail)
    moduleRow("Top hat", "TopHat", nil, Cos.applyTopHat)
    moduleRow("Neon visor", "Visor", nil, Cos.applyVisor)
    moduleRow("Scythe", "Scythe", nil, Cos.applyScythe)
end

builders.themes = function()
    moduleRow("Transparent UI", "Transparent", nil, function()
        applyUITransparency()
        task.defer(function()
            if not Unloaded and S.MenuOpen then selectTab(currentTab) end
        end)
    end)
    for _, name in ipairs(ACCENT_ORDER) do
        themeCard(name)
    end
end

builders.places = function()
    actionRow("Rejoin server", "Reconnect to this place.", function()
        pcall(function()
            TeleportService:Teleport(game.PlaceId, LocalPlayer)
        end)
    end)
    actionRow("Reset character", "Respawn your avatar.", function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = 0 end
    end)
    actionRow("Copy Job ID", "Copy the server id.", function()
        if setclipboard then
            pcall(function() setclipboard(tostring(game.JobId)) end)
        end
    end)
end

builders.configs = function()
    textRow("Config name", "ConfigName", "default")
    toggleRow("Auto load on start", "AutoLoadConfig")
    actionRow("Save config", "Write current settings to file.", Cfg.save)
    actionRow("Load config", "Apply saved settings.", Cfg.load)
    actionRow("Delete config", "Remove saved config.", Cfg.delete)
    moduleRow("Hotkey manager", nil, function()
        for _, entry in ipairs(UI.KEYBIND_LIST) do
            UI.keybindRow(entry[1], entry[2])
        end
        actionRow("Clear all keybinds", "Remove every hotkey", function()
            S.Keybinds = {}
            toast("keybinds cleared")
        end)
    end)
end

builders.player = function()
    moduleRow("Phone mode", "Mobile", nil, function()
        uiScale.Scale = computeScale()
        task.defer(function()
            if not Unloaded and S.MenuOpen then selectTab(currentTab) end
        end)
    end)
    moduleRow("Watermark", "Watermark")
    stepRow("Avatar scale", "AvatarScale", 0.3, 2, 0.1, "", setAvatarScale)
    actionRow("Emote menu", "Quick dance / cheer / sit.", Wm.toggle)
    actionRow("Destroy GUI", "Unload hamer.", unload)
end

CE.KEY_ACTIONS = {
    ESP = function()
        S.ESP = not S.ESP
        toast("ESP " .. (S.ESP and "on" or "off"))
    end,
    Aimbot = function()
        S.Aimbot = not S.Aimbot
        toast("Aimbot " .. (S.Aimbot and "on" or "off"))
    end,
    SilentAim = function()
        if CE.setSilentAim(not S.SilentAim) then toast("Silent Aim " .. (S.SilentAim and "on" or "off")) end
    end,
    KillAll = function()
        CE.setKillAll(not S.KillAll)
        toast("Kill All " .. (S.KillAll and "on" or "off"))
    end,
    Fly = function()
        S.Fly = not S.Fly
        toast("Fly " .. (S.Fly and "on" or "off"))
    end,
    Noclip = function()
        S.Noclip = not S.Noclip
        toast("Noclip " .. (S.Noclip and "on" or "off"))
    end,
    Speed = function()
        S.Speed = not S.Speed
        toast("Speed " .. (S.Speed and "on" or "off"))
    end,
    CoinFarm = function()
        S.CoinFarm = not S.CoinFarm
        toast("Coin Farm " .. (S.CoinFarm and "on" or "off"))
    end,
    Fullbright = function()
        S.Fullbright = not S.Fullbright
        applyFullbright()
        toast("Fullbright " .. (S.Fullbright and "on" or "off"))
    end,
    Fox = function()
        S.Fox = not S.Fox
        applyFox()
        toast("Mini Fox " .. (S.Fox and "on" or "off"))
    end,
    Wings = function()
        S.Wings = not S.Wings
        applyWings()
        toast("Wings " .. (S.Wings and "on" or "off"))
    end,
    Aura = function()
        S.Aura = not S.Aura
        Cos.applyAura()
        toast("Aura " .. (S.Aura and "on" or "off"))
    end
}

conn(UIS.InputBegan:Connect(function(input, gp)
    if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if UIS:GetFocusedTextBox() then return end
    if UI.activeBind then
        local action = UI.activeBind.action
        local key = input.KeyCode
        if key == Enum.KeyCode.Escape or key == Enum.KeyCode.Backspace or key == Enum.KeyCode.Delete then
            S.Keybinds[action] = nil
        elseif key ~= Enum.KeyCode.Unknown then
            for other, value in pairs(S.Keybinds) do
                if other ~= action and value == key.Name then S.Keybinds[other] = nil end
            end
            S.Keybinds[action] = key.Name
        end
        if UI.activeBind.refresh then UI.activeBind.refresh() end
        toast("keybind: " .. (S.Keybinds[action] or "none"))
        UI.activeBind = nil
        return
    end
    local pressed = input.KeyCode.Name
    for action, key in pairs(S.Keybinds) do
        if key == pressed and CE.KEY_ACTIONS[action] then
            CE.KEY_ACTIONS[action]()
            break
        end
    end
end))

conn(LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    if Unloaded then return end
    if S.Dong then applyDong() end
    if S.Fox then applyFox() end
    if S.Wings then applyWings() end
    if S.Halo then applyHalo() end
    if S.ChinaHat then applyChinaHat() end
    if S.Kagune then applyKagune() end
    if S.Companion then applyCompanion() end
    if S.Aura then Cos.applyAura() end
    if S.Crown then Cos.applyCrown() end
    if S.Horns then Cos.applyHorns() end
    if S.CatEars then Cos.applyCatEars() end
    if S.Jetpack then Cos.applyJetpack() end
    if S.Tail then Cos.applyTail() end
    if S.TopHat then Cos.applyTopHat() end
    if S.Visor then Cos.applyVisor() end
    if S.Scythe then Cos.applyScythe() end
    applyKorblox(S.Korblox)
    applyGhostLegs(S.GhostLegs)
    applyNoAnims(S.NoAnims)
    setAvatarScale(S.AvatarScale)
end))

if S.AutoLoadConfig and Cfg.hasFileAPI() then
    local exists = true
    local path = Cfg.dir .. "/" .. Cfg.safeName(S.ConfigName) .. ".json"
    if type(isfile) == "function" then exists = isfile(path) end
    if exists then pcall(Cfg.load) end
end
if S.KillAll then CE.setKillAll(true) end
if S.SilentAim then CE.setSilentAim(true) end

selectTab("visual")
setMenu(true)

print("hamer loaded (no key)")
