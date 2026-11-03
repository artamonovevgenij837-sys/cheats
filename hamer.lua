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
    Shader = "off", ShaderIntensity = 1, CosFolder = "all",
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
    AvatarScale = 1, ConfigName = "default", DroneActive = false, DroneView = 1, DroneManual = false, DroneSpeed = 45, Mobile = false, Optimize = 2,
    Transparent = false, Fox = false, FoxSize = 1,
    CoinFarm = false, FarmNoClip = false, FarmUnderMap = false, FarmSpeed = 80,
    SilentAim = false, SilentAimFOV = 180, SilentAimMaxDist = 600, SilentAimPredict = 120, SilentAimWallbang = false,
    KillAll = false,
    Keybinds = {ESP = "F", Aimbot = "G", SilentAim = "V", KillAll = "K"},
    AutoLoadConfig = true,
    Aura = false, Crown = false, Horns = false, CatEars = false, Jetpack = false,
    Tail = false, TopHat = false, Visor = false, Scythe = false,
    OniMask = false, GasMask = false, NeonMask = false, Cap = false,
    CyberPack = false, AngelPack = false,
    MM2AutoEquip = false, MM2AutoGun = false, MM2KnifeAura = false, MM2AuraRange = 12,
    Rainbow = false, GlowTrail = false, Invisible = false, ClickTP = false
}

S.Mobile = (UIS.TouchEnabled and not UIS.KeyboardEnabled) or false

local Unloaded = false
local toast
local Conns = {}
local function conn(c)
    table.insert(Conns, c)
    return c
end
local FrameTick = 0
conn(RunService.RenderStepped:Connect(function()
    FrameTick = FrameTick + 1
    if FrameTick > 100000 then FrameTick = 0 end
end))
local function optSkip()
    local step = S.Optimize >= 3 and 4 or (S.Optimize == 2 and 3 or 2)
    return FrameTick % step ~= 0
end
local function applyOptimization()
    if S.Optimize >= 3 then
        S.MotionBlur = false
        local mb = Lighting:FindFirstChild("HamerMotionBlur")
        if mb then mb.Size = 0 end
    end
    local label = S.Optimize >= 3 and "max" or (S.Optimize == 2 and "medium" or "weak")
    toast("optimization: " .. label)
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
    Shader = "Post-processing preset", ShaderIntensity = "Shader strength",
    Speed = "Movement speed", SpeedValue = "Walk speed", Jump = "Jump power", JumpValue = "Jump height",
    Fly = "Free flight", FlySpeed = "Flight speed", Noclip = "Walk through walls",
    Aimbot = "Auto aim at target", AimbotFOV = "Aim radius", AimbotSmooth = "Aim smoothing",
    Hitbox = "Expand hitbox", HitboxSize = "Hitbox size", InfJump = "Infinite jumping",
    AntiAfk = "Stay active", AutoCollect = "Collect nearby items", Watermark = "On-screen watermark",
    CosmeticGlow = "Neon materials", Dong = "Attach a 3D model", DongGlow = "Neon skin",
    DongSize = "Model size", Korblox = "Replace right leg", GhostLegs = "Transparent legs",
    NoAnims = "Disable animations", Wings = "Layered feather wings", Halo = "Neon halo",
    ChinaHat = "Neon hat", Kagune = "Neon kagune", Companion = "Floating orb",
    AvatarScale = "Character size", Mobile = "Phone / tablet layout",
    Transparent = "Glass background", Fox = "Mini fox on your shoulder", FoxSize = "Fox size",
    CoinFarm = "Auto collect MM2 coins", FarmNoClip = "Pass through walls",
    FarmUnderMap = "Farm below the map", FarmSpeed = "Movement speed",
    SilentAim = "Route shots onto target", SilentAimFOV = "Target search radius",
    SilentAimMaxDist = "Maximum lock distance", SilentAimPredict = "Velocity prediction",
    SilentAimWallbang = "Shoot through walls", KillAll = "Knife every player",
    AutoLoadConfig = "Load config on inject", Optimize = "1 weak, 2 medium, 3 max",
    Aura = "Swirling particle aura",
    DroneView = "1 third person, 2 first person", DroneManual = "Pilot the drone manually", DroneSpeed = "Manual flight speed",
    Crown = "Floating neon crown", Horns = "Demon horns", CatEars = "Neon cat ears",
    Jetpack = "Neon jetpack", Tail = "Animated neon tail", TopHat = "Classic top hat",
    Visor = "Glowing visor", Scythe = "Neon scythe on your back",
    OniMask = "Crimson demon mask", GasMask = "Tactical gas mask", NeonMask = "Cyber face mask",
    Cap = "Neon baseball cap", CyberPack = "Glowing tech backpack", AngelPack = "Winged holy backpack",
    MM2AutoEquip = "Equip knife automatically", MM2AutoGun = "Equip gun automatically", MM2KnifeAura = "Hit players near you",
    MM2AuraRange = "Knife aura radius", Rainbow = "Cycle avatar colors",
    GlowTrail = "Neon trail while moving", Invisible = "Hide your character locally",
    ClickTP = "Teleport where you click or tap"
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
tabBar.Size = UDim2.new(0, 156, 0, S.Mobile and 384 or 352)
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
    {id = "mm2", label = "MM2", icon = "🔪"},
    {id = "fun", label = "Fun", icon = "🎮"},
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
    b.Size = UDim2.new(1, 0, 0, S.Mobile and 44 or 40)
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
    if Unloaded or optSkip() then return end
    updateESP()
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

local Shaders = (function()
    local names = {"HamerShaderColor", "HamerShaderBloom", "HamerShaderBlur", "HamerShaderSun", "HamerShaderDoF", "HamerShaderAtmos"}
    local function clear()
        for _, name in ipairs(names) do
            local fx = Lighting:FindFirstChild(name)
            if fx then fx:Destroy() end
        end
    end
    local function make(class, name)
        local fx = Instance.new(class)
        fx.Name = name
        fx.Parent = Lighting
        return fx
    end
    local function apply(name)
        clear()
        name = name or "off"
        S.Shader = name
        if name == "off" then return end
        local k = clamp(tonumber(S.ShaderIntensity) or 1, 0, 2)
        local cc = make("ColorCorrectionEffect", "HamerShaderColor")
        local bloom = make("BloomEffect", "HamerShaderBloom")
        if name == "neon" then
            cc.Saturation = 0.45
            cc.Contrast = 0.18
            cc.Brightness = 0.02
            cc.TintColor = Color3.fromRGB(205, 245, 255)
            bloom.Intensity = 1.15 * k
            bloom.Size = 32
            bloom.Threshold = 0.82
        elseif name == "cinematic" then
            cc.Saturation = -0.12
            cc.Contrast = 0.3
            cc.Brightness = -0.01
            cc.TintColor = Color3.fromRGB(255, 236, 212)
            bloom.Intensity = 0.32 * k
            bloom.Size = 24
            bloom.Threshold = 1.25
            local sun = make("SunRaysEffect", "HamerShaderSun")
            sun.Intensity = 0.045 * k
            sun.Spread = 0.65
            local dof = make("DepthOfFieldEffect", "HamerShaderDoF")
            dof.FocusDistance = 48
            dof.InFocusRadius = 55
            dof.FarIntensity = 0.16 * k
            dof.NearIntensity = 0.08 * k
        elseif name == "horror" then
            cc.Saturation = -0.78
            cc.Contrast = 0.48
            cc.Brightness = -0.13
            cc.TintColor = Color3.fromRGB(255, 190, 190)
            bloom.Intensity = 0.55 * k
            bloom.Size = 40
            bloom.Threshold = 0.55
            local blurFx = make("BlurEffect", "HamerShaderBlur")
            blurFx.Size = 1.8 * k
            local atm = make("Atmosphere", "HamerShaderAtmos")
            atm.Density = 0.38
            atm.Offset = 0.15
            atm.Color = Color3.fromRGB(38, 34, 40)
            atm.Decay = Color3.fromRGB(70, 25, 30)
            atm.Haze = 2.4
            atm.Glare = 0
        elseif name == "anime" then
            cc.Saturation = 0.52
            cc.Contrast = 0.14
            cc.Brightness = 0.05
            cc.TintColor = Color3.fromRGB(255, 246, 255)
            bloom.Intensity = 0.85 * k
            bloom.Size = 24
            bloom.Threshold = 0.95
            local sun = make("SunRaysEffect", "HamerShaderSun")
            sun.Intensity = 0.03 * k
            sun.Spread = 0.45
        elseif name == "vaporwave" then
            cc.Saturation = 0.58
            cc.Contrast = 0.22
            cc.Brightness = 0.02
            cc.TintColor = Color3.fromRGB(255, 180, 255)
            bloom.Intensity = 1.05 * k
            bloom.Size = 36
            bloom.Threshold = 0.78
            local blurFx = make("BlurEffect", "HamerShaderBlur")
            blurFx.Size = 0.9 * k
            local atm = make("Atmosphere", "HamerShaderAtmos")
            atm.Density = 0.22
            atm.Offset = 0.2
            atm.Color = Color3.fromRGB(255, 190, 235)
            atm.Decay = Color3.fromRGB(85, 55, 140)
            atm.Haze = 1.6
            atm.Glare = 0
        elseif name == "retro" then
            cc.Saturation = -0.32
            cc.Contrast = 0.26
            cc.Brightness = -0.02
            cc.TintColor = Color3.fromRGB(255, 238, 185)
            bloom.Intensity = 0.38 * k
            bloom.Size = 20
            bloom.Threshold = 1.1
            local blurFx = make("BlurEffect", "HamerShaderBlur")
            blurFx.Size = 1.2 * k
        end
    end
    return {apply = apply, clear = clear}
end)()

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
    local scanRate = S.Optimize >= 3 and 0.8 or (S.Optimize == 2 and 0.5 or 0.3)
    if farmScanAcc >= scanRate or not (farmTarget and farmTarget.Parent) then
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

local Drone = {model = nil, conn = nil, active = false, t = 0, prevType = nil, prevSubject = nil, gui = nil, hold = {f = false, b = false, l = false, r = false, u = false, d = false}, pads = {}, yaw = 0, pitch = 0, lookTouch = nil, touchPos = nil}

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
    local c = accent()
    local body = mkDronePart(model, "Fuselage", Enum.PartType.Block, Vector3.new(0.9, 0.7, 3.2), CFrame.new(0, 0, 0), Enum.Material.Metal, Color3.fromRGB(205, 210, 220))
    local wingL = mkDronePart(model, "WingL", Enum.PartType.Block, Vector3.new(3.2, 0.1, 1.1), CFrame.new(-1.4, 0, 0.4), Enum.Material.Metal, Color3.fromRGB(190, 195, 205))
    local wingR = mkDronePart(model, "WingR", Enum.PartType.Block, Vector3.new(3.2, 0.1, 1.1), CFrame.new(1.4, 0, 0.4), Enum.Material.Metal, Color3.fromRGB(190, 195, 205))
    mkDronePart(model, "StripL", Enum.PartType.Block, Vector3.new(0.12, 0.13, 1.0), CFrame.new(-2.92, 0, 0.4), Enum.Material.Neon, c)
    mkDronePart(model, "StripR", Enum.PartType.Block, Vector3.new(0.12, 0.13, 1.0), CFrame.new(2.92, 0, 0.4), Enum.Material.Neon, c)
    mkDronePart(model, "TopStrip", Enum.PartType.Block, Vector3.new(0.34, 0.07, 2.0), CFrame.new(0, 0.37, -0.1), Enum.Material.Neon, c)
    mkDronePart(model, "Core", Enum.PartType.Ball, Vector3.new(0.34, 0.34, 0.34), CFrame.new(0, 0.1, 0.2), Enum.Material.Neon, c)
    local prop = mkDronePart(model, "Propeller", Enum.PartType.Block, Vector3.new(0.12, 1.5, 0.12), CFrame.new(0, 0, 1.9), Enum.Material.Metal, Color3.fromRGB(120, 126, 138))
    local nose = mkDronePart(model, "Nose", Enum.PartType.Ball, Vector3.new(0.6, 0.6, 0.9), CFrame.new(0, 0, -1.7), Enum.Material.Metal, Color3.fromRGB(60, 65, 75))
    local light = Instance.new("PointLight")
    light.Color = c
    light.Range = 8
    light.Brightness = 2
    light.Parent = nose
    model.PrimaryPart = body
    return model, prop
end

local function droneExplode(pos)
    local boom = Instance.new("Explosion")
    boom.Position = pos
    boom.BlastRadius = 9
    boom.BlastPressure = 0
    boom.DestroyJointRadiusPercent = 0
    boom.Parent = Workspace
    local ball = Instance.new("Part")
    ball.Shape = Enum.PartType.Ball
    ball.Material = Enum.Material.Neon
    ball.Color = Color3.fromRGB(255, 150, 45)
    ball.Size = Vector3.new(2, 2, 2)
    ball.Transparency = 0.15
    ball.Anchored = true
    ball.CanCollide = false
    ball.CanQuery = false
    ball.CanTouch = false
    ball.CastShadow = false
    ball.Position = pos
    ball.Parent = Workspace
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 170, 70)
    light.Range = 18
    light.Brightness = 8
    light.Parent = ball
    TweenService:Create(ball, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(14, 14, 14),
        Transparency = 1
    }):Play()
    task.delay(0.55, function()
        if ball.Parent then ball:Destroy() end
    end)
end

local function droneLookFromCamera()
    local look = Camera and Camera.CFrame.LookVector or Vector3.new(0, 0, -1)
    Drone.pitch = math.asin(clamp(look.Y, -1, 1))
    Drone.yaw = math.atan2(-look.X, -look.Z)
end

local function destroyDroneControls()
    if Drone.gui then Drone.gui:Destroy(); Drone.gui = nil end
    for k in pairs(Drone.hold) do Drone.hold[k] = false end
    Drone.lookTouch, Drone.touchPos = nil, nil
    Drone.pads = {}
end

local function createDroneControls()
    destroyDroneControls()
    local sg = Instance.new("ScreenGui")
    sg.Name = "HamerDroneControls"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 998
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    Drone.gui = sg
    local function pad(text, x, y, key)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 50, 0, 50)
        b.Position = UDim2.new(0.5, x, 1, y)
        b.AnchorPoint = Vector2.new(0.5, 1)
        b.BackgroundColor3 = Color3.fromRGB(24, 26, 33)
        b.BackgroundTransparency = 0.12
        b.Text = text
        b.TextColor3 = Color3.fromRGB(235, 240, 250)
        b.Font = FONT_BOLD
        b.TextSize = FS(20)
        b.AutoButtonColor = false
        b.Parent = sg
        table.insert(Drone.pads, b)
        corner(b, 10)
        stroke(b, accent(), 0.45, 1)
        local function set(v)
            Drone.hold[key] = v
            tw(b, 0.1, {BackgroundColor3 = v and accent() or Color3.fromRGB(24, 26, 33)})
        end
        b.InputBegan:Connect(function(input)
            if Drone.lookTouch == input then Drone.lookTouch, Drone.touchPos = nil, nil end
        end)
        b.MouseButton1Down:Connect(function() set(true) end)
        b.MouseButton1Up:Connect(function() set(false) end)
        b.MouseLeave:Connect(function() if Drone.hold[key] then set(false) end end)
    end
    pad("▲", 0, -168, "f")
    pad("▼", 0, -52, "b")
    pad("◀", -58, -110, "l")
    pad("▶", 58, -110, "r")
    pad("↑", 140, -150, "u")
    pad("↓", 140, -72, "d")
end

local function stopDrone()
    Drone.active = false
    S.DroneActive = false
    destroyDroneControls()
    if Drone.conn then Drone.conn:Disconnect(); Drone.conn = nil end
    if Drone.prevType ~= nil then
        if Camera then
            Camera.CameraType = Drone.prevType
            local subject = Drone.prevSubject
            if not (subject and subject.Parent) then
                subject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            end
            Camera.CameraSubject = subject
        end
        Drone.prevType, Drone.prevSubject = nil, nil
    end
    if Drone.model and Drone.model.Parent then Drone.model:Destroy() end
    Drone.model = nil
end

conn(UIS.InputBegan:Connect(function(input, gp)
    if S.MenuOpen or not (Drone.active and S.DroneManual) then return end
    if input.UserInputType == Enum.UserInputType.Touch then
        local overPad = false
        if Drone.gui then
            for _, obj in ipairs(Drone.gui:GetChildren()) do
                if obj:IsA("TextButton") then
                    local p, s = obj.AbsolutePosition, obj.AbsoluteSize
                    if input.Position.X >= p.X and input.Position.X <= p.X + s.X and input.Position.Y >= p.Y and input.Position.Y <= p.Y + s.Y then
                        overPad = true
                        break
                    end
                end
            end
        end
        if gp or overPad or Drone.lookTouch then return end
        Drone.lookTouch, Drone.touchPos = input, input.Position
    end
end))
conn(UIS.InputChanged:Connect(function(input)
    if S.MenuOpen or not (Drone.active and S.DroneManual) then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement and not S.Mobile then
        local dx = clamp(input.Delta.X, -80, 80)
        local dy = clamp(input.Delta.Y, -80, 80)
        Drone.yaw = Drone.yaw - dx * 0.004
        Drone.pitch = clamp(Drone.pitch - dy * 0.004, -1.25, 1.25)
    elseif input == Drone.lookTouch and input.UserInputType == Enum.UserInputType.Touch and Drone.touchPos then
        local d = input.Position - Drone.touchPos
        Drone.touchPos = input.Position
        Drone.yaw = Drone.yaw - clamp(d.X, -60, 60) * 0.006
        Drone.pitch = clamp(Drone.pitch - clamp(d.Y, -60, 60) * 0.006, -1.25, 1.25)
    end
    Drone.yaw = (Drone.yaw + math.pi) % (math.pi * 2) - math.pi
end))
conn(UIS.InputEnded:Connect(function(input)
    if input == Drone.lookTouch then Drone.lookTouch, Drone.touchPos = nil, nil end
end))

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
    if Camera then
        Drone.prevType = Camera.CameraType
        Drone.prevSubject = Camera.CameraSubject
        Camera.CameraType = Enum.CameraType.Scriptable
    end
    if S.DroneManual then
        droneLookFromCamera()
        createDroneControls()
    end
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
        if S.DroneManual then
            local rot = CFrame.fromOrientation(Drone.pitch, Drone.yaw, 0)
            local move = Vector3.zero
            if Drone.hold.f or UIS:IsKeyDown(Enum.KeyCode.W) then move = move + rot.LookVector end
            if Drone.hold.b or UIS:IsKeyDown(Enum.KeyCode.S) then move = move - rot.LookVector end
            if Drone.hold.r or UIS:IsKeyDown(Enum.KeyCode.D) then move = move + rot.RightVector end
            if Drone.hold.l or UIS:IsKeyDown(Enum.KeyCode.A) then move = move - rot.RightVector end
            if Drone.hold.u or UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if Drone.hold.d or UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
            if move.Magnitude > 1 then move = move.Unit end
            local pos = fus.Position + move * S.DroneSpeed * dt
            model:PivotTo(CFrame.new(pos) * rot)
            if Camera then
                local goal
                if S.DroneView == 2 then
                    local camPos = pos + rot.LookVector * 2.45 + Vector3.new(0, 0.3, 0)
                    goal = CFrame.lookAt(camPos, camPos + rot.LookVector * 24)
                else
                    local camPos = pos - rot.LookVector * 9 + Vector3.new(0, 3.4, 0)
                    goal = CFrame.lookAt(camPos, pos + rot.LookVector * 8)
                end
                Camera.CFrame = Camera.CFrame:Lerp(goal, math.min(dt * 20, 1))
            end
        else
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
            if Camera then
                if S.DroneView == 2 then
                    Camera.CFrame = fus.CFrame * CFrame.new(0, 0.35, -2.0)
                else
                    Camera.CFrame = fus.CFrame * CFrame.new(0, 3.4, 9.0)
                end
            end
        end
        if prop and prop.Parent then
            prop.CFrame = fus.CFrame * CFrame.new(0, 0, 1.9) * CFrame.Angles(0, 0, Drone.t * 35)
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local tr = p.Character:FindFirstChild("HumanoidRootPart")
                if tr and (tr.Position - fus.Position).Magnitude < 3.2 then
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.Health = 0 end
                    droneExplode(fus.Position)
                    stopDrone()
                    return
                end
            end
        end
        if Drone.t > 30 then
            droneExplode(fus.Position)
            stopDrone()
        end
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

return {setSilentAim = setSilentAim, setKillAll = setKillAll, KillAll = KillAll, findKnife = findKnife, knifeTouch = knifeTouch}
end)()

local Extras = (function()
    local trail = nil
    local savedColors = nil
    local savedTrans = nil
    local lastEquip, lastGun, lastAura = 0, 0, 0

    local function getChar()
        local char = LocalPlayer.Character
        return char, char and char:FindFirstChild("HumanoidRootPart"), char and char:FindFirstChildOfClass("Humanoid")
    end

    local function findCoin()
        local char, root = getChar()
        if not root then return nil end
        local best, bestD = nil, math.huge
        for _, d in ipairs(Workspace:GetDescendants()) do
            if d:IsA("BasePart") and not d:IsDescendantOf(char) then
                local n = string.lower(d.Name)
                if string.find(n, "coin") or string.find(n, "cash") or string.find(n, "gem") or string.find(n, "money") or string.find(n, "diamond") then
                    local dist = (d.Position - root.Position).Magnitude
                    if dist < bestD then best, bestD = d, dist end
                end
            end
        end
        return best
    end

    local function equipKnife()
        local char, _, hum = getChar()
        if not char or not hum then return nil end
        local knife = CE.findKnife(char)
        if not knife then
            local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
            knife = CE.findKnife(bp)
            if knife then
                local ok = pcall(function() hum:EquipTool(knife) end)
                if not ok then pcall(function() knife.Parent = char end) end
            end
        end
        return knife
    end

    local function findGun(container)
        if not container then return nil end
        for _, tool in ipairs(container:GetChildren()) do
            if tool:IsA("Tool") then
                local n = string.lower(tool.Name)
                if string.find(n, "gun", 1, true) or string.find(n, "revolver", 1, true) or string.find(n, "pistol", 1, true) or string.find(n, "sheriff", 1, true) then
                    return tool
                end
            end
        end
    end

    local function equipGun()
        local char, _, hum = getChar()
        if not char or not hum then return nil end
        local gun = findGun(char)
        if not gun then
            local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
            gun = findGun(bp)
            if gun then
                local ok = pcall(function() hum:EquipTool(gun) end)
                if not ok then pcall(function() gun.Parent = char end) end
            end
        end
        return gun
    end

    local function flingNearest()
        local char, root = getChar()
        if not root then return end
        local best, bestD = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local r = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                local h = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 then
                    local d = (r.Position - root.Position).Magnitude
                    if d < bestD then best, bestD = r, d end
                end
            end
        end
        if best then
            pcall(function()
                best.AssemblyLinearVelocity = best.AssemblyLinearVelocity + Vector3.new(math.random(-140, 140), math.random(380, 560), math.random(-140, 140))
                best.AssemblyAngularVelocity = best.AssemblyAngularVelocity + Vector3.new(math.random(-8, 8), math.random(-8, 8), math.random(-8, 8))
            end)
            toast("flung nearest player")
        else
            toast("no player found")
        end
    end

    local function tpCoin()
        local char, root = getChar()
        local best = findCoin()
        if best and root then
            root.CFrame = CFrame.new(best.Position + Vector3.new(0, 3, 0))
            toast("teleported to " .. best.Name)
        else
            toast("no coin found")
        end
    end

    local function tpNearest()
        local char, root = getChar()
        if not root then return end
        local best, bestD = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local r = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                local h = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 then
                    local d = (r.Position - root.Position).Magnitude
                    if d < bestD then best, bestD = r, d end
                end
            end
        end
        if best then
            root.CFrame = CFrame.new(best.Position + Vector3.new(0, 3, 0))
            toast("teleported to nearest player")
        else
            toast("no player found")
        end
    end

    local function saveChar()
        local char = LocalPlayer.Character
        if not char then return end
        savedColors = savedColors or {}
        savedTrans = savedTrans or {}
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and savedColors[p] == nil then
                savedColors[p] = p.Color
                savedTrans[p] = p.Transparency
            end
        end
    end

    local function restoreChar()
        if savedColors then
            for p, c in pairs(savedColors) do
                if p.Parent then p.Color = c end
            end
            savedColors = nil
        end
        if savedTrans then
            for p, v in pairs(savedTrans) do
                if p.Parent then p.Transparency = v end
            end
            savedTrans = nil
        end
    end

    local function ensureTrail()
        local char, root = getChar()
        if not root then return end
        if trail and trail.trail.Parent then return end
        local a0 = Instance.new("Attachment")
        a0.Position = Vector3.new(-0.45, 0, 0)
        a0.Parent = root
        local a1 = Instance.new("Attachment")
        a1.Position = Vector3.new(0.45, 0, 0)
        a1.Parent = root
        local tr = Instance.new("Trail")
        tr.Attachment0 = a0
        tr.Attachment1 = a1
        tr.Lifetime = 0.65
        tr.MinLength = 0.1
        tr.WidthScale = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
        tr.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, accent()), ColorSequenceKeypoint.new(1, accent():Lerp(Color3.fromRGB(255, 255, 255), 0.7))})
        tr.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.15), NumberSequenceKeypoint.new(1, 1)})
        tr.LightEmission = 0.7
        tr.FaceCamera = true
        tr.Parent = root
        trail = {trail = tr, a0 = a0, a1 = a1}
    end

    local function clearTrail()
        if trail then
            pcall(function() trail.trail:Destroy() end)
            pcall(function() trail.a0:Destroy() end)
            pcall(function() trail.a1:Destroy() end)
            trail = nil
        end
    end

    local clickParams = RaycastParams.new()
    clickParams.FilterType = Enum.RaycastFilterType.Exclude
    clickParams.IgnoreWater = true
    conn(UIS.InputBegan:Connect(function(input, gp)
        if gp or S.MenuOpen or not S.ClickTP or Drone.active then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        clickParams.FilterDescendantsInstances = {char}
        local pos = input.Position
        local ray = Camera:ViewportPointToRay(pos.X, pos.Y)
        local hit = Workspace:Raycast(ray.Origin, ray.Direction * 2000, clickParams)
        if hit then
            root.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
            click()
        end
    end))

    conn(RunService.Heartbeat:Connect(function(dt)
        if Unloaded then return end
        local char, root, hum = getChar()
        local now = os.clock()
        if S.MM2AutoEquip and now - lastEquip > 1 then
            lastEquip = now
            if char and hum and not CE.findKnife(char) then equipKnife() end
        end
        if S.MM2AutoGun and now - lastGun > 1 then
            lastGun = now
            if char and hum and not findGun(char) then equipGun() end
        end
        if S.MM2KnifeAura and root and now - lastAura > 0.15 then
            lastAura = now
            local knife = CE.findKnife(char)
            if not knife and hum then knife = equipKnife() end
            if knife then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer then
                        local tchar = plr.Character
                        local thum = tchar and tchar:FindFirstChildOfClass("Humanoid")
                        local troot = tchar and tchar:FindFirstChild("HumanoidRootPart")
                        if thum and thum.Health > 0 and troot and (troot.Position - root.Position).Magnitude <= S.MM2AuraRange then
                            CE.knifeTouch(troot)
                        end
                    end
                end
            end
        end
        if S.Rainbow or S.Invisible then
            saveChar()
            local t = os.clock()
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then
                        if S.Rainbow then
                            local h = (t * 0.16 + p.Position.Y * 0.03 + p.Position.X * 0.01) % 1
                            p.Color = Color3.fromHSV(h, 0.82, 1)
                        end
                        if S.Invisible then p.Transparency = 1 end
                    end
                end
            end
        elseif savedColors or savedTrans then
            restoreChar()
        end
        if S.GlowTrail then
            ensureTrail()
        elseif trail then
            clearTrail()
        end
    end))

    local function stop()
        S.MM2AutoEquip, S.MM2AutoGun, S.MM2KnifeAura = false, false, false
        S.Rainbow, S.GlowTrail, S.Invisible, S.ClickTP = false, false, false, false
        restoreChar()
        clearTrail()
    end

    return {equip = equipKnife, equipGun = equipGun, tpCoin = tpCoin, tpNearest = tpNearest, fling = flingNearest, stop = stop}
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
    moduleRow("Drone settings", nil, function()
        stepRow("Camera", "DroneView", 1, 2, 1, "", function(v)
            if v ~= 1 and v ~= 2 then S.DroneView = 1 end
        end)
        toggleRow("Manual control", "DroneManual", function(v)
            if Drone.active then
                if v then
                    droneLookFromCamera()
                    createDroneControls()
                else
                    destroyDroneControls()
                end
            end
        end)
        stepRow("Manual speed", "DroneSpeed", 15, 120, 5, "")
    end)
end

builders.mm2 = function()
    moduleRow("Auto equip knife", "MM2AutoEquip")
    moduleRow("Auto equip gun", "MM2AutoGun")
    moduleRow("Knife aura", "MM2KnifeAura", function()
        stepRow("Range", "MM2AuraRange", 5, 30, 1, " st")
    end)
    actionRow("Equip knife now", "Move your knife into your hand.", Extras.equip)
    actionRow("Teleport to nearest coin", "Jump to the closest MM2 coin.", Extras.tpCoin)
end

builders.fun = function()
    moduleRow("Rainbow avatar", "Rainbow")
    moduleRow("Glow trail", "GlowTrail")
    moduleRow("Invisible", "Invisible")
    moduleRow("Click teleport", "ClickTP")
    actionRow("Teleport to nearest player", "Jump next to the closest player.", Extras.tpNearest)
    actionRow("Fling nearest player", "Launch the closest player into the sky.", Extras.fling)
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
    moduleRow("Shaders", nil, function()
        actionRow("Neon", "Bright bloom and cool tint.", function()
            Shaders.apply("neon")
            toast("shader: neon")
        end)
        actionRow("Cinematic", "Warm contrast, bloom and depth of field.", function()
            Shaders.apply("cinematic")
            toast("shader: cinematic")
        end)
        actionRow("Horror", "Desaturated dark look with heavy haze.", function()
            Shaders.apply("horror")
            toast("shader: horror")
        end)
        actionRow("Anime", "Punchy colors and soft glow.", function()
            Shaders.apply("anime")
            toast("shader: anime")
        end)
        actionRow("Vaporwave", "Pink haze, bloom and blur.", function()
            Shaders.apply("vaporwave")
            toast("shader: vaporwave")
        end)
        actionRow("Retro", "Warm faded film look.", function()
            Shaders.apply("retro")
            toast("shader: retro")
        end)
        stepRow("Intensity", "ShaderIntensity", 0, 2, 0.1, "", function()
            Shaders.apply(S.Shader)
        end)
        actionRow("Disable shader", "Remove every post-processing effect.", function()
            Shaders.apply("off")
            toast("shader: off")
        end)
    end)
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
    local pink = Color3.fromRGB(255, 170, 180)
    local model = Instance.new("Model")
    model.Name = "HamerFox"
    model.Parent = Workspace
    Fox.model = model
    local parts = {}
    local function add(shape, size, color, pos, rot, tail)
        local p = neonPart(model, shape, Vector3.new(size.X * sc, size.Y * sc, size.Z * sc), color, false)
        p.Material = Enum.Material.SmoothPlastic
        local off = CFrame.new(pos.X * sc, pos.Y * sc, pos.Z * sc)
        if rot then off = off * rot end
        table.insert(parts, {p = p, off = off, tail = tail or 0})
    end
    add(Enum.PartType.Ball, Vector3.new(0.5, 0.42, 0.72), orange, Vector3.new(0, 0, 0))
    add(Enum.PartType.Block, Vector3.new(0.3, 0.24, 0.18), white, Vector3.new(0, -0.04, -0.35))
    add(Enum.PartType.Ball, Vector3.new(0.46, 0.44, 0.46), orange, Vector3.new(0, 0.27, -0.36))
    add(Enum.PartType.Block, Vector3.new(0.24, 0.16, 0.24), white, Vector3.new(0, 0.18, -0.59))
    add(Enum.PartType.Ball, Vector3.new(0.09, 0.08, 0.09), dark, Vector3.new(0, 0.2, -0.72))
    add(Enum.PartType.Ball, Vector3.new(0.075, 0.085, 0.075), dark, Vector3.new(-0.11, 0.34, -0.55))
    add(Enum.PartType.Ball, Vector3.new(0.075, 0.085, 0.075), dark, Vector3.new(0.11, 0.34, -0.55))
    add(Enum.PartType.Ball, Vector3.new(0.025, 0.025, 0.025), white, Vector3.new(-0.09, 0.37, -0.57))
    add(Enum.PartType.Ball, Vector3.new(0.025, 0.025, 0.025), white, Vector3.new(0.09, 0.37, -0.57))
    add(Enum.PartType.Block, Vector3.new(0.16, 0.26, 0.08), orange, Vector3.new(-0.14, 0.52, -0.33), CFrame.Angles(0, 0, math.rad(16)))
    add(Enum.PartType.Block, Vector3.new(0.16, 0.26, 0.08), orange, Vector3.new(0.14, 0.52, -0.33), CFrame.Angles(0, 0, math.rad(-16)))
    add(Enum.PartType.Block, Vector3.new(0.1, 0.16, 0.03), pink, Vector3.new(-0.14, 0.5, -0.37), CFrame.Angles(0, 0, math.rad(16)))
    add(Enum.PartType.Block, Vector3.new(0.1, 0.16, 0.03), pink, Vector3.new(0.14, 0.5, -0.37), CFrame.Angles(0, 0, math.rad(-16)))
    add(Enum.PartType.Block, Vector3.new(0.13, 0.17, 0.3), orange, Vector3.new(-0.16, -0.27, -0.2))
    add(Enum.PartType.Block, Vector3.new(0.13, 0.17, 0.3), orange, Vector3.new(0.16, -0.27, -0.2))
    add(Enum.PartType.Block, Vector3.new(0.12, 0.08, 0.12), dark, Vector3.new(-0.16, -0.36, -0.31))
    add(Enum.PartType.Block, Vector3.new(0.12, 0.08, 0.12), dark, Vector3.new(0.16, -0.36, -0.31))
    add(Enum.PartType.Block, Vector3.new(0.19, 0.19, 0.5), orange, Vector3.new(0, 0.08, 0.5), CFrame.Angles(math.rad(30), 0, 0), 1)
    add(Enum.PartType.Block, Vector3.new(0.16, 0.16, 0.36), orange, Vector3.new(0, 0.18, 0.79), CFrame.Angles(math.rad(20), 0, 0), 2)
    add(Enum.PartType.Ball, Vector3.new(0.18, 0.18, 0.18), white, Vector3.new(0, 0.27, 0.97), nil, 3)
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
            if e.tail > 0 then
                local wag = math.sin(t * 4.2 - e.tail * 0.7) * math.rad(8 + e.tail * 3)
                e.p.CFrame = base * e.off * CFrame.Angles(0, wag, 0)
            else
                e.p.CFrame = base * e.off
            end
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
    local white = Color3.fromRGB(255, 255, 255)
    local model = Instance.new("Model")
    model.Name = "HamerWings"
    model.Parent = Workspace
    Wings.model = model
    local parts = {}
    local function buildWing(sign)
        for i = 1, 12 do
            local t = (i - 1) / 11
            local x = 0.55 + t * 2.65
            local topY = 2.06 + math.sin(t * math.pi) * 0.36 - t * 0.58
            local h = 1.25 + (1 - t) * 0.78
            local rot = 5 + t * 16
            for row = 1, 3 do
                local p = neonPart(model, Enum.PartType.Block, Vector3.new(0.4, h / 3 + 0.15, 0.12), c:Lerp(white, 0.12 + t * 0.48 + (row - 1) * 0.06), true)
                table.insert(parts, {p = p, sign = sign, x = x, y = topY - h * (row - 0.5) / 3, rot = rot, z = 0.46 + (row - 1) * 0.035})
            end
            local bone = neonPart(model, Enum.PartType.Block, Vector3.new(0.44, 0.13, 0.16), c:Lerp(white, 0.3 + t * 0.4), true)
            table.insert(parts, {p = bone, sign = sign, x = x, y = topY, rot = rot, z = 0.45})
        end
        for i = 1, 6 do
            local t = 0.48 + (i - 1) / 5 * 0.52
            local x = 0.55 + t * 2.65
            local topY = 2.06 + math.sin(t * math.pi) * 0.36 - t * 0.58
            local h = 1.25 + (1 - t) * 0.78
            local len = 0.72 + (1 - t) * 0.5
            local p = neonPart(model, Enum.PartType.Block, Vector3.new(0.23, len, 0.11), white:Lerp(c, 0.2), true)
            table.insert(parts, {p = p, sign = sign, x = x, y = topY - h - len * 0.32, rot = 9 + t * 28, z = 0.48})
        end
        local joint = neonPart(model, Enum.PartType.Ball, Vector3.new(0.36, 0.36, 0.36), c:Lerp(white, 0.18), true)
        table.insert(parts, {p = joint, sign = sign, x = 0.55, y = 1.95, rot = 0, z = 0.45})
    end
    buildWing(-1)
    buildWing(1)
    local t = 0
    Wings.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Wings or not model.Parent then return end
        local ch = LocalPlayer.Character
        local r = ch and ch:FindFirstChild("HumanoidRootPart")
        if not r then return end
        t = t + dt
        local flap = math.sin(t * 3.0) * math.rad(23)
        for _, e in ipairs(parts) do
            if e.p.Parent then
                local pivot = r.CFrame * CFrame.new(e.sign * 0.55, 1.95, 0.45) * CFrame.Angles(0, 0, flap * e.sign)
                local off = CFrame.new(e.sign * (e.x - 0.55), e.y - 1.95, e.z - 0.45) * CFrame.Angles(0, math.rad(e.sign * 4), math.rad(e.sign * e.rot))
                e.p.CFrame = pivot * off
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
    local c2 = c:Lerp(Color3.fromRGB(255, 255, 255), 0.6)
    local model = Instance.new("Model")
    model.Name = "HamerHalo"
    model.Parent = Workspace
    Halo.model = model
    local balls = {}
    for i = 1, 40 do
        local p = neonPart(model, Enum.PartType.Ball, Vector3.new(0.16, 0.16, 0.16), i % 5 == 0 and c2 or c, true)
        if i == 1 then
            local light = Instance.new("PointLight")
            light.Color = c
            light.Range = 8
            light.Brightness = 2
            light.Parent = p
        end
        table.insert(balls, {p = p, a = (i - 1) / 40 * math.pi * 2})
    end
    local t = 0
    Halo.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Halo or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        t = t + dt
        local bob = math.sin(t * 1.8) * 0.05
        for _, e in ipairs(balls) do
            local a = e.a + t * 1.35
            local s = 0.16 + math.sin(t * 4 + e.a * 3) * 0.025
            e.p.Size = Vector3.new(s, s, s)
            e.p.CFrame = h.CFrame * CFrame.new(math.cos(a) * 0.96, 1.16 + bob + math.sin(a * 4 + t * 2) * 0.025, math.sin(a) * 0.96)
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
    local gold = Color3.fromRGB(255, 210, 90)
    local red = Color3.fromRGB(220, 55, 62)
    local model = Instance.new("Model")
    model.Name = "HamerChinaHat"
    model.Parent = Workspace
    ChinaHat.model = model
    local brim = neonPart(model, Enum.PartType.Cylinder, Vector3.new(0.09, 3.05, 3.05), c, true)
    local band = neonPart(model, Enum.PartType.Cylinder, Vector3.new(0.12, 2.78, 2.78), gold, true)
    local rings = {}
    for i = 1, 20 do
        local t = i / 20
        local d = 2.68 * (1 - t) + 0.1 * t
        local p = neonPart(model, Enum.PartType.Cylinder, Vector3.new(0.065, d, d), i % 3 == 0 and gold or c, true)
        table.insert(rings, {p = p, y = 0.24 + t * 1.3})
    end
    local top = neonPart(model, Enum.PartType.Ball, Vector3.new(0.18, 0.18, 0.18), gold, true)
    local tassel = {}
    for i = 1, 5 do
        tassel[i] = neonPart(model, Enum.PartType.Ball, Vector3.new(0.1 - i * 0.012, 0.1 - i * 0.012, 0.1 - i * 0.012), i % 2 == 0 and red or gold, true)
    end
    local t = 0
    ChinaHat.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.ChinaHat or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        t = t + dt
        local bob = math.sin(t * 2) * 0.02
        local sway = math.sin(t * 2.4) * 0.03
        local base = h.CFrame * CFrame.new(0, 0.6 + bob, 0) * CFrame.Angles(sway, 0, 0)
        brim.CFrame = base * CFrame.Angles(0, 0, math.rad(90))
        band.CFrame = base * CFrame.new(0, 0.16, 0) * CFrame.Angles(0, 0, math.rad(90))
        for _, e in ipairs(rings) do
            e.p.CFrame = base * CFrame.new(0, e.y, 0) * CFrame.Angles(0, 0, math.rad(90))
        end
        local tip = base * CFrame.new(0, 1.58, 0)
        top.CFrame = tip
        for i, p in ipairs(tassel) do
            p.CFrame = tip * CFrame.new(math.sin(t * 3 + i * 0.5) * 0.035 * i, -0.16 - i * 0.12, math.cos(t * 3 + i * 0.5) * 0.035 * i)
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
    local model = Instance.new("Model")
    model.Name = "HamerKagune"
    model.Parent = Workspace
    KG.model = model
    local parts = {}
    for sx = -1, 1, 2 do
        for sy = -1, 1, 2 do
            for i = 1, 24 do
                local t = (i - 1) / 23
                local p = Instance.new("Part")
                p.Shape = Enum.PartType.Block
                p.Size = Vector3.new(0.3, 0.3, 0.3)
                p.Color = Color3.fromRGB(220, 30, 40)
                p.Material = Enum.Material.Neon
                p.Anchored = true
                p.CanCollide = false
                p.TopSurface = Enum.SurfaceType.Smooth
                p.BottomSurface = Enum.SurfaceType.Smooth
                p.Parent = model
                p:SetAttribute("x", (0.45 + t * 1.75) * sx)
                p:SetAttribute("y", (0.35 + t * 1.25) * sy)
                p:SetAttribute("z", 0.35 - math.max(0, (t - 0.4) / 0.6) * 1.5)
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
        local idle = math.sin(KG.t * 2.1) * 0.18
        local walk = math.sin(KG.t * 7) * 0.3
        for _, p in ipairs(parts) do
            if p.Parent then
                local t = p:GetAttribute("t")
                local us = p:GetAttribute("us")
                local fo = idle * (1 - KG.blend) + (walk + math.sin(KG.t * 7 - p:GetAttribute("si") * 0.4) * 0.2) * KG.blend
                local off = Vector3.new(
                    p:GetAttribute("x") + math.sin(KG.t * 2.4 + t * 3) * 0.08 * t,
                    p:GetAttribute("y") + fo * us * t * 0.38,
                    p:GetAttribute("z") + math.cos(KG.t * 2.6 + t * 2) * 0.08 * t
                )
                p.CFrame = r.CFrame * CFrame.new(off) * CFrame.Angles(0, 0, math.rad(us * 36) + fo * us * 0.2) * CFrame.Angles(t * 1.1, 0, 0)
            end
        end
    end)
end

local CMP = {model = nil, conn = nil, t = 0, pos = nil}
local function applyCompanion()
    if CMP.conn then CMP.conn:Disconnect(); CMP.conn = nil end
    if CMP.model then CMP.model:Destroy(); CMP.model = nil end
    if not S.Companion then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local color = accent()
    local white = Color3.fromRGB(255, 255, 255)
    local model = Instance.new("Model")
    model.Name = "HamerCompanion"
    model.Parent = Workspace
    CMP.model = model
    local core = neonPart(model, Enum.PartType.Ball, Vector3.new(0.34, 0.34, 0.34), white, true)
    core.Transparency = 0.08
    local light = Instance.new("PointLight")
    light.Color = color
    light.Range = 8
    light.Brightness = 2
    light.Parent = core
    local r1, r2, mini = {}, {}, {}
    for i = 1, 16 do
        r1[i] = {p = neonPart(model, Enum.PartType.Ball, Vector3.new(0.075, 0.075, 0.075), color, true), a = (i - 1) / 16 * math.pi * 2}
        r2[i] = {p = neonPart(model, Enum.PartType.Ball, Vector3.new(0.065, 0.065, 0.065), color:Lerp(white, 0.45), true), a = (i - 1) / 16 * math.pi * 2}
    end
    for i = 1, 3 do
        mini[i] = {p = neonPart(model, Enum.PartType.Ball, Vector3.new(0.11, 0.11, 0.11), color, true), a = i * math.pi * 2 / 3}
    end
    CMP.t, CMP.pos = 0, nil
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
        CMP.pos = CMP.pos and CMP.pos:Lerp(target, math.min(dt * 8, 1)) or target
        local base = CFrame.new(CMP.pos) * CFrame.Angles(math.sin(t * 2) * 0.2, t * 1.7, math.sin(t * 2) * 0.1)
        local cs = 0.34 + math.sin(t * 4) * 0.05
        core.Size = Vector3.new(cs, cs, cs)
        core.CFrame = base
        core.Transparency = 0.06 + math.sin(t * 4) * 0.08
        local spin1 = base * CFrame.Angles(0, 0, t * 1.6)
        local spin2 = base * CFrame.Angles(t * 1.9, 0, 0)
        for _, e in ipairs(r1) do
            e.p.CFrame = spin1 * CFrame.new(math.cos(e.a) * 0.52, math.sin(e.a) * 0.52, 0)
        end
        for _, e in ipairs(r2) do
            e.p.CFrame = spin2 * CFrame.new(math.cos(e.a) * 0.58, 0, math.sin(e.a) * 0.58)
        end
        for i, e in ipairs(mini) do
            local a = e.a + t * (1.2 + i * 0.2)
            e.p.CFrame = base * CFrame.new(math.cos(a) * 0.95, math.sin(t * 2 + i) * 0.3, math.sin(a) * 0.95)
        end
    end)
end

local Cos = (function()
local function cosmeticModel(name)
    local model = Instance.new("Model")
    model.Name = name
    model.Parent = Workspace
    return model
end

local function deco(parent, shape, size, color, material, glow, transparency)
    local p = neonPart(parent, shape, size, color, glow)
    if material then
        if glow and S.CosmeticGlow == false then
            p.Material = Enum.Material.SmoothPlastic
        else
            p.Material = material
        end
    end
    if transparency then p.Transparency = transparency end
    return p
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
    local c2 = c:Lerp(Color3.fromRGB(255, 255, 255), 0.55)
    local white = Color3.fromRGB(255, 255, 255)
    local model = cosmeticModel("HamerAura")
    Aura.model = model
    local vortex = {}
    for i = 1, 80 do
        local a = i * 2.399
        local rad = 0.85 + (i % 7) / 6 * 1.35
        local baseY = 0.15 + (i * 0.37 % 1) * 1.9
        local s = 0.09 + (i * 0.13 % 1) * 0.1
        local col = i % 3 == 0 and c2 or c:Lerp(white, (i % 5) / 5 * 0.45)
        local p = deco(model, Enum.PartType.Ball, Vector3.new(s, s, s), col, Enum.Material.Neon, true, 0.05 + (i % 4) * 0.035)
        table.insert(vortex, {p = p, a = a, rad = rad, baseY = baseY, speed = 0.55 + (i % 5) * 0.19, amp = 0.1 + (i % 3) * 0.07, freq = 1.1 + (i % 4) * 0.32, size = s})
    end
    local halo = {}
    for i = 1, 32 do
        local s = 0.075 + (i % 4) * 0.012
        local p = deco(model, Enum.PartType.Ball, Vector3.new(s, s, s), i % 2 == 0 and c2 or c, Enum.Material.Neon, true, 0.04)
        table.insert(halo, {p = p, a = (i - 1) / 32 * math.pi * 2, size = s})
    end
    local embers = {}
    for i = 1, 12 do
        local s = 0.1 + (i % 3) * 0.03
        local p = deco(model, Enum.PartType.Ball, Vector3.new(s, s, s), i % 2 == 0 and c2 or c:Lerp(white, 0.3), Enum.Material.Neon, true, 0.02)
        table.insert(embers, {p = p, a = i * 0.9, rad = 2.55 + (i % 4) * 0.12, y = 0.45 + (i % 5) * 0.34, speed = 0.8 + (i % 3) * 0.2, size = s})
    end
    local core = deco(model, Enum.PartType.Ball, Vector3.new(0.38, 0.38, 0.38), c2, Enum.Material.Neon, true, 0.68)
    local light = Instance.new("PointLight")
    light.Color = c
    light.Range = 9
    light.Brightness = 1.8
    light.Parent = core
    local t = 0
    Aura.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Aura or not model.Parent then return end
        local ch = LocalPlayer.Character
        local r = ch and ch:FindFirstChild("HumanoidRootPart")
        if not r then return end
        t = t + dt
        for _, e in ipairs(vortex) do
            local a = e.a + t * e.speed
            local y = e.baseY + math.sin(t * e.freq + e.a) * e.amp
            local s = e.size * (1 + math.sin(t * 3.2 + e.a * 2) * 0.24)
            e.p.Size = Vector3.new(s, s, s)
            e.p.CFrame = r.CFrame * CFrame.new(math.cos(a) * e.rad, y, math.sin(a) * e.rad)
        end
        for _, e in ipairs(halo) do
            local a = e.a + t * 0.32
            e.p.CFrame = r.CFrame * CFrame.new(math.cos(a) * 2.42, 0.08 + math.sin(t * 2 + e.a) * 0.03, math.sin(a) * 2.42)
        end
        for i, e in ipairs(embers) do
            local a = e.a + t * e.speed
            local s = e.size * (1 + math.sin(t * 3.6 + i) * 0.22)
            e.p.Size = Vector3.new(s, s, s)
            e.p.CFrame = r.CFrame * CFrame.new(math.cos(a) * e.rad, e.y + math.sin(t * 1.8 + i) * 0.22, math.sin(a) * e.rad)
        end
        core.CFrame = r.CFrame * CFrame.new(0, 1.05 + math.sin(t * 2) * 0.04, 0)
        core.Transparency = 0.64 + math.sin(t * 4) * 0.08
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
    local gold2 = Color3.fromRGB(255, 240, 170)
    local gemColor = accent()
    local model = cosmeticModel("HamerCrown")
    Crown.model = model
    local bands = {}
    for i = 1, 16 do
        bands[i] = {p = deco(model, Enum.PartType.Block, Vector3.new(0.12, 0.2, 0.3), i % 2 == 0 and gold2 or gold, Enum.Material.Neon, true, 0.02), a = (i - 1) / 16 * math.pi * 2}
    end
    local trims = {}
    for i = 1, 16 do
        trims[i] = {p = deco(model, Enum.PartType.Block, Vector3.new(0.1, 0.07, 0.24), gemColor, Enum.Material.Neon, true, 0.12), a = (i - 1) / 16 * math.pi * 2}
    end
    local spikes = {}
    for i = 1, 8 do
        local a = (i - 1) / 8 * math.pi * 2
        spikes[i] = {
            a = a,
            base = deco(model, Enum.PartType.Block, Vector3.new(0.2, 0.32, 0.16), gold, Enum.Material.Neon, true, 0.02),
            mid = deco(model, Enum.PartType.Block, Vector3.new(0.13, 0.22, 0.12), gold2, Enum.Material.Neon, true, 0.02),
            tip = deco(model, Enum.PartType.Ball, Vector3.new(0.1, 0.1, 0.1), i % 2 == 0 and gemColor or gold2, Enum.Material.Neon, true, 0.02)
        }
    end
    local bezel = deco(model, Enum.PartType.Cylinder, Vector3.new(0.08, 0.3, 0.3), gold2, Enum.Material.Neon, true, 0.02)
    local gem = deco(model, Enum.PartType.Ball, Vector3.new(0.19, 0.19, 0.2), gemColor, Enum.Material.Neon, true, 0.02)
    local light = Instance.new("PointLight")
    light.Color = gemColor
    light.Range = 6
    light.Brightness = 2
    light.Parent = gem
    local t = 0
    Crown.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Crown or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        t = t + dt
        local hc = h.CFrame * CFrame.new(0, 0.93 + math.sin(t * 2) * 0.035, 0)
        for _, e in ipairs(bands) do
            e.p.CFrame = hc * CFrame.new(math.cos(e.a) * 0.53, 0, math.sin(e.a) * 0.53) * CFrame.Angles(0, -e.a, 0)
        end
        for _, e in ipairs(trims) do
            e.p.CFrame = hc * CFrame.new(math.cos(e.a) * 0.535, 0.14, math.sin(e.a) * 0.535) * CFrame.Angles(0, -e.a, 0)
        end
        for _, e in ipairs(spikes) do
            local cf = hc * CFrame.new(math.cos(e.a) * 0.53, 0.25, math.sin(e.a) * 0.53) * CFrame.Angles(0, -e.a, 0)
            e.base.CFrame = cf
            e.mid.CFrame = cf * CFrame.new(0, 0.23, 0)
            e.tip.CFrame = cf * CFrame.new(0, 0.38, 0)
        end
        bezel.CFrame = hc * CFrame.new(0, 0, -0.56) * CFrame.Angles(0, math.rad(90), 0)
        gem.CFrame = hc * CFrame.new(0, 0, -0.6)
        gem.Transparency = 0.02 + math.sin(t * 4) * 0.06
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
    local red = Color3.fromRGB(210, 36, 48)
    local hot = Color3.fromRGB(255, 148, 76)
    local model = cosmeticModel("HamerHorns")
    Horns.model = model
    local bases = {}
    local parts = {}
    for sign = -1, 1, 2 do
        bases[sign] = deco(model, Enum.PartType.Ball, Vector3.new(0.3, 0.28, 0.3), Color3.fromRGB(34, 24, 28), Enum.Material.SmoothPlastic, true, 0.02)
        for i = 1, 16 do
            local t = (i - 1) / 15
            local s = 0.27 * (1 - t * 0.68)
            local p = deco(model, Enum.PartType.Ball, Vector3.new(s, s, s), red:Lerp(hot, t), Enum.Material.Neon, true, 0.02)
            if i == 16 then
                local light = Instance.new("PointLight")
                light.Color = hot
                light.Range = 5
                light.Brightness = 1.6
                light.Parent = p
            end
            parts[#parts + 1] = {p = p, sign = sign, t = t}
        end
    end
    local t = 0
    Horns.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Horns or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        t = t + dt
        local hc = h.CFrame
        for sign, p in pairs(bases) do
            local pulse = 1 + math.sin(t * 3 + sign) * 0.03
            p.Size = Vector3.new(0.3 * pulse, 0.28 * pulse, 0.3 * pulse)
            p.CFrame = hc * CFrame.new(sign * 0.3, 0.58, -0.02)
        end
        for _, e in ipairs(parts) do
            local sign = e.sign
            local f = e.t
            local x = sign * (0.3 + f * 0.58 + math.sin(f * math.pi) * 0.12)
            local y = 0.6 + f * 1.08 - f * f * 0.08
            local z = -0.02 - f * 0.3
            local s = 0.27 * (1 - f * 0.68)
            e.p.Size = Vector3.new(s, s, s)
            e.p.CFrame = hc * CFrame.new(x, y, z)
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
    local c = accent()
    local pink = Color3.fromRGB(255, 168, 205)
    local model = cosmeticModel("HamerCatEars")
    CatEars.model = model
    local ears = {}
    for sign = -1, 1, 2 do
        ears[#ears + 1] = {
            sign = sign,
            outer1 = deco(model, Enum.PartType.Block, Vector3.new(0.4, 0.24, 0.13), c, Enum.Material.Neon, true, 0.02),
            outer2 = deco(model, Enum.PartType.Block, Vector3.new(0.28, 0.22, 0.12), c, Enum.Material.Neon, true, 0.02),
            outer3 = deco(model, Enum.PartType.Block, Vector3.new(0.15, 0.18, 0.11), c, Enum.Material.Neon, true, 0.02),
            inner1 = deco(model, Enum.PartType.Block, Vector3.new(0.26, 0.13, 0.05), pink, Enum.Material.Neon, true, 0.04),
            inner2 = deco(model, Enum.PartType.Block, Vector3.new(0.15, 0.12, 0.05), pink, Enum.Material.Neon, true, 0.04),
            tip = deco(model, Enum.PartType.Ball, Vector3.new(0.07, 0.07, 0.07), Color3.fromRGB(255, 255, 255), Enum.Material.Neon, true, 0.02)
        }
    end
    local t = 0
    CatEars.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.CatEars or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        t = t + dt
        for _, e in ipairs(ears) do
            local sign = e.sign
            local tw = math.sin(t * 2.2 + sign) * 0.05
            local base = h.CFrame * CFrame.new(sign * 0.33, 0.6, -0.02) * CFrame.Angles(0, 0, math.rad(sign * 19) + tw)
            e.outer1.CFrame = base
            e.outer2.CFrame = base * CFrame.new(0, 0.2, 0)
            e.outer3.CFrame = base * CFrame.new(0, 0.37, 0)
            e.inner1.CFrame = base * CFrame.new(0, 0.02, -0.03)
            e.inner2.CFrame = base * CFrame.new(0, 0.2, -0.03)
            e.tip.CFrame = base * CFrame.new(0, 0.49, 0)
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
    local c = accent()
    local c2 = c:Lerp(Color3.fromRGB(255, 255, 255), 0.25)
    local dark = Color3.fromRGB(42, 46, 56)
    local model = cosmeticModel("HamerJetpack")
    Jetpack.model = model
    local body = deco(model, Enum.PartType.Block, Vector3.new(0.82, 1.0, 0.34), dark, Enum.Material.Metal, false, 0)
    local plate = deco(model, Enum.PartType.Block, Vector3.new(0.62, 0.7, 0.05), Color3.fromRGB(24, 26, 33), Enum.Material.SmoothPlastic, false, 0)
    local core = deco(model, Enum.PartType.Cylinder, Vector3.new(0.12, 0.34, 0.34), c, Enum.Material.Neon, true, 0.04)
    local tanks, nozzles, fins, flames = {}, {}, {}, {}
    for sign = -1, 1, 2 do
        tanks[#tanks + 1] = {p = deco(model, Enum.PartType.Cylinder, Vector3.new(0.92, 0.3, 0.3), c2, Enum.Material.Neon, true, 0.04), sign = sign}
        nozzles[#nozzles + 1] = {p = deco(model, Enum.PartType.Cylinder, Vector3.new(0.22, 0.25, 0.25), dark, Enum.Material.Metal, false, 0), sign = sign}
        fins[#fins + 1] = {p = deco(model, Enum.PartType.Block, Vector3.new(0.08, 0.5, 0.26), c, Enum.Material.Neon, true, 0.08), sign = sign}
        flames[#flames + 1] = {p = deco(model, Enum.PartType.Ball, Vector3.new(0.24, 0.62, 0.24), Color3.fromRGB(255, 145, 45), Enum.Material.Neon, true, 0.32), sign = sign}
    end
    local t = 0
    Jetpack.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Jetpack or not model.Parent then return end
        local ch = LocalPlayer.Character
        local r = ch and ch:FindFirstChild("HumanoidRootPart")
        if not r then return end
        t = t + dt
        local base = r.CFrame * CFrame.new(0, 0.78, 0.58)
        body.CFrame = base
        plate.CFrame = base * CFrame.new(0, 0, 0.2)
        core.CFrame = base * CFrame.new(0, 0.12, 0.22) * CFrame.Angles(0, math.rad(90), 0)
        core.Transparency = 0.06 + math.sin(t * 5) * 0.08
        for _, e in ipairs(tanks) do
            e.p.CFrame = base * CFrame.new(e.sign * 0.34, 0.02, 0.02) * CFrame.Angles(0, 0, math.rad(90))
        end
        for _, e in ipairs(nozzles) do
            e.p.CFrame = base * CFrame.new(e.sign * 0.34, -0.52, 0.02) * CFrame.Angles(0, 0, math.rad(90))
        end
        for _, e in ipairs(fins) do
            e.p.CFrame = base * CFrame.new(e.sign * 0.57, 0.16, 0.03) * CFrame.Angles(0, 0, math.rad(e.sign * 20))
        end
        for _, e in ipairs(flames) do
            local s = 0.78 + math.sin(t * 18 + e.sign) * 0.22
            e.p.Size = Vector3.new(0.24 * s, 0.62 * s, 0.24 * s)
            e.p.CFrame = base * CFrame.new(e.sign * 0.34, -0.76, 0.02)
            e.p.Transparency = 0.26 + math.sin(t * 14 + e.sign) * 0.12
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
    local c = accent()
    local white = Color3.fromRGB(255, 255, 255)
    local model = cosmeticModel("HamerTail")
    Tail.model = model
    local parts = {}
    for i = 1, 26 do
        local f = (i - 1) / 25
        local s = 0.27 * (1 - f * 0.66)
        local p = deco(model, Enum.PartType.Ball, Vector3.new(s, s, s), c:Lerp(white, f * 0.75), Enum.Material.Neon, true, 0.02)
        if i == 26 then
            local light = Instance.new("PointLight")
            light.Color = c
            light.Range = 5
            light.Brightness = 1.6
            light.Parent = p
        end
        parts[#parts + 1] = {p = p, f = f}
    end
    local t = 0
    Tail.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Tail or not model.Parent then return end
        local ch = LocalPlayer.Character
        local r = ch and ch:FindFirstChild("HumanoidRootPart")
        if not r then return end
        t = t + dt
        for _, e in ipairs(parts) do
            local f = e.f
            local wave = math.sin(t * 3.2 - f * 4.2)
            local x = wave * (0.07 + f * 0.34)
            local y = 0.9 - f * 0.55 + math.sin(t * 4 - f * 5) * 0.1
            local z = 0.52 + f * 2.0
            local s = 0.27 * (1 - f * 0.66)
            e.p.Size = Vector3.new(s, s, s)
            e.p.CFrame = r.CFrame * CFrame.new(x, y, z)
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
    local c = accent()
    local model = cosmeticModel("HamerTopHat")
    TopHat.model = model
    local brim = deco(model, Enum.PartType.Cylinder, Vector3.new(0.07, 1.72, 1.72), dark, Enum.Material.SmoothPlastic, false, 0)
    local top = deco(model, Enum.PartType.Cylinder, Vector3.new(1.1, 1.02, 1.02), dark, Enum.Material.SmoothPlastic, false, 0)
    local band = deco(model, Enum.PartType.Cylinder, Vector3.new(0.22, 1.06, 1.06), c, Enum.Material.Neon, true, 0.04)
    local rim = deco(model, Enum.PartType.Cylinder, Vector3.new(0.05, 1.05, 1.05), c, Enum.Material.Neon, true, 0.1)
    local buckle = deco(model, Enum.PartType.Block, Vector3.new(0.2, 0.16, 0.06), Color3.fromRGB(255, 220, 120), Enum.Material.Neon, true, 0.02)
    local petals = {}
    for i = 1, 5 do
        local a = (i - 1) / 5 * math.pi * 2
        petals[i] = deco(model, Enum.PartType.Ball, Vector3.new(0.12, 0.09, 0.12), Color3.fromRGB(255, 70, 110), Enum.Material.Neon, true, 0.02)
        petals[i]:SetAttribute("a", a)
    end
    local rose = deco(model, Enum.PartType.Ball, Vector3.new(0.1, 0.08, 0.1), Color3.fromRGB(255, 210, 230), Enum.Material.Neon, true, 0.02)
    local t = 0
    TopHat.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.TopHat or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        t = t + dt
        local base = h.CFrame * CFrame.new(0, 0.72 + math.sin(t * 2) * 0.015, 0) * CFrame.Angles(math.rad(-3), 0, 0)
        brim.CFrame = base * CFrame.Angles(0, 0, math.rad(90))
        band.CFrame = base * CFrame.new(0, 0.24, 0) * CFrame.Angles(0, 0, math.rad(90))
        top.CFrame = base * CFrame.new(0, 0.6, 0) * CFrame.Angles(0, 0, math.rad(90))
        rim.CFrame = base * CFrame.new(0, 1.15, 0) * CFrame.Angles(0, 0, math.rad(90))
        buckle.CFrame = base * CFrame.new(0, 0.24, -0.55)
        local flower = base * CFrame.new(0.25, 0.24, -0.52)
        for _, p in ipairs(petals) do
            local a = p:GetAttribute("a")
            p.CFrame = flower * CFrame.new(math.cos(a) * 0.08, math.sin(a) * 0.08, 0)
        end
        rose.CFrame = flower * CFrame.new(0, 0, -0.04)
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
    local c = accent()
    local white = Color3.fromRGB(255, 255, 255)
    local model = cosmeticModel("HamerVisor")
    Visor.model = model
    local bar = deco(model, Enum.PartType.Block, Vector3.new(0.72, 0.16, 0.07), c, Enum.Material.Neon, true, 0.03)
    local lens = deco(model, Enum.PartType.Block, Vector3.new(0.62, 0.1, 0.04), white, Enum.Material.Neon, true, 0.28)
    local sides = {}
    for sign = -1, 1, 2 do
        sides[#sides + 1] = {
            sign = sign,
            frame = deco(model, Enum.PartType.Block, Vector3.new(0.3, 0.16, 0.06), c, Enum.Material.Neon, true, 0.03),
            lens = deco(model, Enum.PartType.Block, Vector3.new(0.26, 0.1, 0.035), white, Enum.Material.Neon, true, 0.32),
            pod = deco(model, Enum.PartType.Ball, Vector3.new(0.14, 0.14, 0.14), c, Enum.Material.Neon, true, 0.02)
        }
    end
    local scan = deco(model, Enum.PartType.Block, Vector3.new(0.1, 0.06, 0.02), white, Enum.Material.Neon, true, 0.02)
    local t = 0
    Visor.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Visor or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        t = t + dt
        local base = h.CFrame * CFrame.new(0, 0.06, -0.57)
        bar.CFrame = base
        lens.CFrame = base * CFrame.new(0, 0, -0.045)
        bar.Transparency = 0.04 + math.sin(t * 4) * 0.07
        lens.Transparency = 0.24 + math.sin(t * 4 + 1) * 0.08
        for _, e in ipairs(sides) do
            local cf = base * CFrame.new(e.sign * 0.36, 0, 0.06) * CFrame.Angles(0, math.rad(e.sign * 34), 0)
            e.frame.CFrame = cf
            e.lens.CFrame = cf * CFrame.new(0, 0, -0.045)
            e.pod.CFrame = base * CFrame.new(e.sign * 0.5, 0, 0.14)
        end
        scan.CFrame = base * CFrame.new(math.sin(t * 2.4) * 0.27, 0, -0.055)
        scan.Transparency = 0.1 + math.sin(t * 7) * 0.12
    end)
end

local OniMask = {model = nil, conn = nil}
local function applyOniMask()
    if OniMask.conn then OniMask.conn:Disconnect(); OniMask.conn = nil end
    if OniMask.model then OniMask.model:Destroy(); OniMask.model = nil end
    if not S.OniMask then return end
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    local c = accent()
    local red = Color3.fromRGB(168, 26, 40)
    local dark = Color3.fromRGB(28, 14, 18)
    local white = Color3.fromRGB(255, 236, 214)
    local model = cosmeticModel("HamerOniMask")
    OniMask.model = model
    local face = deco(model, Enum.PartType.Block, Vector3.new(1.02, 0.86, 0.16), red, Enum.Material.SmoothPlastic, false, 0)
    local mouth = deco(model, Enum.PartType.Block, Vector3.new(0.46, 0.11, 0.08), dark, Enum.Material.SmoothPlastic, false, 0)
    local eyes, brows, fangs, horns = {}, {}, {}, {}
    for sign = -1, 1, 2 do
        eyes[#eyes + 1] = {p = deco(model, Enum.PartType.Ball, Vector3.new(0.17, 0.1, 0.06), c, Enum.Material.Neon, true, 0.03), sign = sign}
        brows[#brows + 1] = {p = deco(model, Enum.PartType.Block, Vector3.new(0.38, 0.1, 0.08), dark, Enum.Material.SmoothPlastic, false, 0), sign = sign}
        fangs[#fangs + 1] = {p = deco(model, Enum.PartType.Block, Vector3.new(0.09, 0.22, 0.07), white, Enum.Material.SmoothPlastic, false, 0), sign = sign}
        for i = 1, 3 do
            local s = 0.17 - i * 0.03
            horns[#horns + 1] = {p = deco(model, Enum.PartType.Ball, Vector3.new(s, s, s), i == 3 and c or red:Lerp(c, i * 0.18), Enum.Material.Neon, true, 0.02), sign = sign, i = i}
        end
    end
    local t = 0
    OniMask.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.OniMask or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        t = t + dt
        local base = h.CFrame * CFrame.new(0, 0.03 + math.sin(t * 2) * 0.008, -0.5)
        face.CFrame = base
        mouth.CFrame = base * CFrame.new(0, -0.24, -0.1)
        for _, e in ipairs(eyes) do
            e.p.CFrame = base * CFrame.new(e.sign * 0.25, 0.11, -0.105) * CFrame.Angles(0, 0, math.rad(-e.sign * 14))
            e.p.Transparency = 0.03 + math.sin(t * 5 + e.sign) * 0.08
        end
        for _, e in ipairs(brows) do
            e.p.CFrame = base * CFrame.new(e.sign * 0.27, 0.29, -0.09) * CFrame.Angles(0, 0, math.rad(e.sign * 24))
        end
        for _, e in ipairs(fangs) do
            e.p.CFrame = base * CFrame.new(e.sign * 0.15, -0.33, -0.1) * CFrame.Angles(0, 0, math.rad(e.sign * 8))
        end
        for _, e in ipairs(horns) do
            local sway = math.sin(t * 2.2 + e.i * 0.4) * 0.05
            e.p.CFrame = base * CFrame.new(e.sign * (0.36 + e.i * 0.06), 0.42 + e.i * 0.17, -0.01) * CFrame.Angles(sway, 0, math.rad(e.sign * (18 + e.i * 8)))
        end
    end)
end

local GasMask = {model = nil, conn = nil}
local function applyGasMask()
    if GasMask.conn then GasMask.conn:Disconnect(); GasMask.conn = nil end
    if GasMask.model then GasMask.model:Destroy(); GasMask.model = nil end
    if not S.GasMask then return end
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    local c = accent()
    local dark = Color3.fromRGB(34, 38, 46)
    local metal = Color3.fromRGB(64, 70, 82)
    local model = cosmeticModel("HamerGasMask")
    GasMask.model = model
    local face = deco(model, Enum.PartType.Block, Vector3.new(1.04, 0.84, 0.2), dark, Enum.Material.Metal, false, 0)
    local rim = deco(model, Enum.PartType.Block, Vector3.new(0.92, 0.42, 0.06), metal, Enum.Material.Metal, false, 0)
    local lens = deco(model, Enum.PartType.Block, Vector3.new(0.78, 0.28, 0.05), c, Enum.Material.Neon, true, 0.15)
    local filters = {}
    for sign = -1, 1, 2 do
        local f = {p = deco(model, Enum.PartType.Cylinder, Vector3.new(0.36, 0.32, 0.32), metal, Enum.Material.Metal, false, 0), sign = sign, hose = {}}
        f.cap = deco(model, Enum.PartType.Ball, Vector3.new(0.13, 0.13, 0.13), c, Enum.Material.Neon, true, 0.04)
        for i = 1, 4 do
            local s = 0.1 - i * 0.012
            f.hose[i] = deco(model, Enum.PartType.Ball, Vector3.new(s, s, s), dark, Enum.Material.SmoothPlastic, false, 0)
        end
        filters[#filters + 1] = f
    end
    local t = 0
    GasMask.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.GasMask or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        t = t + dt
        local base = h.CFrame * CFrame.new(0, 0.02, -0.49)
        face.CFrame = base
        rim.CFrame = base * CFrame.new(0, 0.1, -0.12)
        lens.CFrame = base * CFrame.new(0, 0.1, -0.15)
        lens.Transparency = 0.12 + math.sin(t * 4.5) * 0.08
        for _, e in ipairs(filters) do
            e.p.CFrame = base * CFrame.new(e.sign * 0.38, -0.18, -0.1) * CFrame.Angles(0, math.rad(90), 0)
            e.cap.CFrame = base * CFrame.new(e.sign * 0.38, -0.18, -0.3)
            for i, p in ipairs(e.hose) do
                p.CFrame = base * CFrame.new(e.sign * (0.36 + i * 0.015), -0.34 - i * 0.1, -0.18 + i * 0.04)
            end
        end
    end)
end

local NeonMask = {model = nil, conn = nil}
local function applyNeonMask()
    if NeonMask.conn then NeonMask.conn:Disconnect(); NeonMask.conn = nil end
    if NeonMask.model then NeonMask.model:Destroy(); NeonMask.model = nil end
    if not S.NeonMask then return end
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    local c = accent()
    local dark = Color3.fromRGB(22, 24, 32)
    local white = Color3.fromRGB(255, 255, 255)
    local model = cosmeticModel("HamerNeonMask")
    NeonMask.model = model
    local face = deco(model, Enum.PartType.Block, Vector3.new(1.0, 0.78, 0.12), dark, Enum.Material.SmoothPlastic, false, 0)
    local visor = deco(model, Enum.PartType.Block, Vector3.new(0.84, 0.18, 0.05), c, Enum.Material.Neon, true, 0.04)
    local scan = deco(model, Enum.PartType.Block, Vector3.new(0.12, 0.04, 0.02), white, Enum.Material.Neon, true, 0.02)
    local rails = {}
    for sign = -1, 1, 2 do
        rails[#rails + 1] = {p = deco(model, Enum.PartType.Block, Vector3.new(0.06, 0.62, 0.06), c, Enum.Material.Neon, true, 0.08), sign = sign}
    end
    local grill = {}
    for i = 1, 5 do
        grill[i] = deco(model, Enum.PartType.Block, Vector3.new(0.09, 0.09, 0.04), i % 2 == 0 and white or c, Enum.Material.Neon, true, 0.04)
    end
    local t = 0
    NeonMask.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.NeonMask or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        t = t + dt
        local base = h.CFrame * CFrame.new(0, 0.02, -0.5)
        face.CFrame = base
        visor.CFrame = base * CFrame.new(0, 0.12, -0.08)
        visor.Transparency = 0.04 + math.sin(t * 4) * 0.08
        for _, e in ipairs(rails) do
            e.p.CFrame = base * CFrame.new(e.sign * 0.45, -0.02, -0.06)
        end
        for i, p in ipairs(grill) do
            p.CFrame = base * CFrame.new(-0.24 + (i - 1) * 0.12, -0.28, -0.075)
        end
        scan.CFrame = base * CFrame.new(math.sin(t * 3) * 0.34, 0.12, -0.11)
    end)
end

local Cap = {model = nil, conn = nil}
local function applyCap()
    if Cap.conn then Cap.conn:Disconnect(); Cap.conn = nil end
    if Cap.model then Cap.model:Destroy(); Cap.model = nil end
    if not S.Cap then return end
    local char = LocalPlayer.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    local c = accent()
    local dark = Color3.fromRGB(28, 30, 38)
    local white = Color3.fromRGB(255, 255, 255)
    local model = cosmeticModel("HamerCap")
    Cap.model = model
    local dome = deco(model, Enum.PartType.Ball, Vector3.new(1.08, 0.56, 1.08), dark, Enum.Material.SmoothPlastic, false, 0)
    local brim = deco(model, Enum.PartType.Block, Vector3.new(1.02, 0.08, 0.62), c, Enum.Material.Neon, true, 0.02)
    local button = deco(model, Enum.PartType.Ball, Vector3.new(0.14, 0.14, 0.14), c, Enum.Material.Neon, true, 0.02)
    local logo = deco(model, Enum.PartType.Block, Vector3.new(0.24, 0.1, 0.04), white, Enum.Material.Neon, true, 0.02)
    local t = 0
    Cap.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Cap or not model.Parent then return end
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChild("Head")
        if not h then return end
        t = t + dt
        local base = h.CFrame * CFrame.new(0, 0.58 + math.sin(t * 2) * 0.01, -0.02)
        dome.CFrame = base
        brim.CFrame = base * CFrame.new(0, -0.12, -0.56) * CFrame.Angles(math.rad(-10), 0, 0)
        button.CFrame = base * CFrame.new(0, 0.28, 0)
        logo.CFrame = base * CFrame.new(0, 0.12, -0.52)
    end)
end

local CyberPack = {model = nil, conn = nil}
local function applyCyberPack()
    if CyberPack.conn then CyberPack.conn:Disconnect(); CyberPack.conn = nil end
    if CyberPack.model then CyberPack.model:Destroy(); CyberPack.model = nil end
    if not S.CyberPack then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local c = accent()
    local dark = Color3.fromRGB(34, 38, 48)
    local dark2 = Color3.fromRGB(22, 24, 31)
    local model = cosmeticModel("HamerCyberPack")
    CyberPack.model = model
    local body = deco(model, Enum.PartType.Block, Vector3.new(0.86, 1.0, 0.34), dark, Enum.Material.Metal, false, 0)
    local panel = deco(model, Enum.PartType.Block, Vector3.new(0.64, 0.74, 0.05), dark2, Enum.Material.SmoothPlastic, false, 0)
    local core = deco(model, Enum.PartType.Ball, Vector3.new(0.24, 0.24, 0.24), c, Enum.Material.Neon, true, 0.02)
    local antenna = deco(model, Enum.PartType.Block, Vector3.new(0.05, 0.5, 0.05), dark, Enum.Material.Metal, false, 0)
    local tip = deco(model, Enum.PartType.Ball, Vector3.new(0.09, 0.09, 0.09), c, Enum.Material.Neon, true, 0.02)
    local pods = {}
    for sign = -1, 1, 2 do
        pods[#pods + 1] = {p = deco(model, Enum.PartType.Block, Vector3.new(0.16, 0.6, 0.2), c, Enum.Material.Neon, true, 0.12), sign = sign}
    end
    local ring = {}
    for i = 1, 12 do
        local s = 0.07
        ring[i] = {p = deco(model, Enum.PartType.Ball, Vector3.new(s, s, s), i % 2 == 0 and c or dark2, Enum.Material.Neon, true, 0.02), a = (i - 1) / 12 * math.pi * 2}
    end
    local light = Instance.new("PointLight")
    light.Color = c
    light.Range = 7
    light.Brightness = 1.8
    light.Parent = core
    local t = 0
    CyberPack.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.CyberPack or not model.Parent then return end
        local ch = LocalPlayer.Character
        local r = ch and ch:FindFirstChild("HumanoidRootPart")
        if not r then return end
        t = t + dt
        local base = r.CFrame * CFrame.new(0, 0.72 + math.sin(t * 2) * 0.015, 0.62)
        body.CFrame = base
        panel.CFrame = base * CFrame.new(0, 0, 0.2)
        core.CFrame = base * CFrame.new(0, 0.12, 0.24)
        core.Transparency = 0.02 + math.sin(t * 5) * 0.08
        antenna.CFrame = base * CFrame.new(0, 0.7, 0.05)
        tip.CFrame = base * CFrame.new(0, 0.96, 0.05)
        tip.Transparency = 0.02 + math.sin(t * 6) * 0.2
        for _, e in ipairs(pods) do
            e.p.CFrame = base * CFrame.new(e.sign * 0.53, -0.02, 0.03)
        end
        for _, e in ipairs(ring) do
            local a = e.a + t * 1.6
            e.p.CFrame = base * CFrame.new(math.cos(a) * 0.36, 0.12 + math.sin(a) * 0.36, 0.26)
        end
    end)
end

local AngelPack = {model = nil, conn = nil}
local function applyAngelPack()
    if AngelPack.conn then AngelPack.conn:Disconnect(); AngelPack.conn = nil end
    if AngelPack.model then AngelPack.model:Destroy(); AngelPack.model = nil end
    if not S.AngelPack then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local c = accent()
    local white = Color3.fromRGB(255, 252, 240)
    local gold = Color3.fromRGB(255, 210, 110)
    local model = cosmeticModel("HamerAngelPack")
    AngelPack.model = model
    local body = deco(model, Enum.PartType.Block, Vector3.new(0.58, 0.78, 0.26), white, Enum.Material.SmoothPlastic, false, 0)
    local trim = deco(model, Enum.PartType.Block, Vector3.new(0.44, 0.08, 0.06), gold, Enum.Material.Neon, true, 0.04)
    local core = deco(model, Enum.PartType.Ball, Vector3.new(0.2, 0.2, 0.2), c, Enum.Material.Neon, true, 0.02)
    local halo = {}
    for i = 1, 18 do
        local s = 0.06
        halo[i] = {p = deco(model, Enum.PartType.Ball, Vector3.new(s, s, s), i % 2 == 0 and gold or white, Enum.Material.Neon, true, 0.02), a = (i - 1) / 18 * math.pi * 2}
    end
    local wings = {}
    for sign = -1, 1, 2 do
        for i = 1, 4 do
            local len = 0.7 - i * 0.07
            wings[#wings + 1] = {
                p = deco(model, Enum.PartType.Block, Vector3.new(0.13, len, 0.07), i % 2 == 0 and gold or white, Enum.Material.Neon, true, 0.03),
                sign = sign, i = i, len = len
            }
        end
    end
    local light = Instance.new("PointLight")
    light.Color = c
    light.Range = 8
    light.Brightness = 1.7
    light.Parent = core
    local t = 0
    AngelPack.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.AngelPack or not model.Parent then return end
        local ch = LocalPlayer.Character
        local r = ch and ch:FindFirstChild("HumanoidRootPart")
        if not r then return end
        t = t + dt
        local base = r.CFrame * CFrame.new(0, 0.74 + math.sin(t * 2) * 0.02, 0.6)
        body.CFrame = base
        trim.CFrame = base * CFrame.new(0, 0.3, 0.15)
        core.CFrame = base * CFrame.new(0, 0.02, 0.18)
        core.Transparency = 0.02 + math.sin(t * 4.5) * 0.1
        for _, e in ipairs(halo) do
            local a = e.a + t * 0.9
            e.p.CFrame = base * CFrame.new(math.cos(a) * 0.42, 0.58, 0.05 + math.sin(a) * 0.42)
        end
        for _, e in ipairs(wings) do
            local flap = math.sin(t * 2.6 + e.sign) * math.rad(7)
            e.p.CFrame = base * CFrame.new(e.sign * (0.36 + e.i * 0.07), 0.1 + e.i * 0.08, 0.12) * CFrame.Angles(0, 0, math.rad(e.sign * (28 + e.i * 9)) + flap * e.sign)
        end
    end)
end

local Scythe = {model = nil, conn = nil}
local function applyScythe()
    if Scythe.conn then Scythe.conn:Disconnect(); Scythe.conn = nil end
    if Scythe.model then Scythe.model:Destroy(); Scythe.model = nil end
    if not S.Scythe then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local c = accent()
    local dark = Color3.fromRGB(56, 60, 72)
    local dark2 = Color3.fromRGB(32, 34, 42)
    local model = cosmeticModel("HamerScythe")
    Scythe.model = model
    local shaft = deco(model, Enum.PartType.Cylinder, Vector3.new(5.6, 0.13, 0.13), dark2, Enum.Material.Metal, false, 0)
    local collar = deco(model, Enum.PartType.Cylinder, Vector3.new(0.36, 0.33, 0.33), dark, Enum.Material.Metal, false, 0)
    local grip = deco(model, Enum.PartType.Cylinder, Vector3.new(1.35, 0.2, 0.2), Color3.fromRGB(96, 34, 42), Enum.Material.SmoothPlastic, false, 0)
    local pommel = deco(model, Enum.PartType.Ball, Vector3.new(0.28, 0.28, 0.28), c, Enum.Material.Neon, true, 0.02)
    local gem = deco(model, Enum.PartType.Ball, Vector3.new(0.17, 0.17, 0.17), c, Enum.Material.Neon, true, 0.02)
    local gripRings = {}
    for i = 1, 4 do
        gripRings[i] = deco(model, Enum.PartType.Cylinder, Vector3.new(0.07, 0.24, 0.24), c, Enum.Material.Neon, true, 0.08)
    end
    local blade = {}
    for i = 1, 12 do
        local t = (i - 1) / 11
        local x = 2.45 + t * 1.65
        local y = 0.12 + math.sin(t * math.pi) * 0.72 + t * 0.06
        local ang = math.rad(-18 + t * 100)
        local body = deco(model, Enum.PartType.Block, Vector3.new(0.58, 0.2 - t * 0.06, 0.11), dark, Enum.Material.Metal, false, 0)
        local edge = deco(model, Enum.PartType.Block, Vector3.new(0.56, 0.055, 0.12), c, Enum.Material.Neon, true, 0.02)
        blade[i] = {p = body, e = edge, off = CFrame.new(x, y, 0) * CFrame.Angles(0, 0, ang)}
    end
    local light = Instance.new("PointLight")
    light.Color = c
    light.Range = 7
    light.Brightness = 2
    light.Parent = gem
    local t = 0
    Scythe.conn = RunService.RenderStepped:Connect(function(dt)
        if not S.Scythe or not model.Parent then return end
        local ch = LocalPlayer.Character
        local r = ch and ch:FindFirstChild("HumanoidRootPart")
        if not r then return end
        t = t + dt
        local base = r.CFrame * CFrame.new(0, 1.0 + math.sin(t * 2) * 0.015, 0.78) * CFrame.Angles(0, 0, math.rad(28)) * CFrame.Angles(0, math.rad(18), 0)
        shaft.CFrame = base
        collar.CFrame = base * CFrame.new(2.35, 0, 0)
        grip.CFrame = base * CFrame.new(-2.35, 0, 0)
        pommel.CFrame = base * CFrame.new(-2.9, 0, 0)
        gem.CFrame = base * CFrame.new(2.35, 0.2, 0)
        for i, p in ipairs(gripRings) do
            p.CFrame = base * CFrame.new(-1.82 - (i - 1) * 0.28, 0, 0)
        end
        for _, e in ipairs(blade) do
            e.p.CFrame = base * e.off
            e.e.CFrame = base * e.off * CFrame.new(0, 0.1, 0)
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
    if S.OniMask then applyOniMask() end
    if S.GasMask then applyGasMask() end
    if S.NeonMask then applyNeonMask() end
    if S.Cap then applyCap() end
    if S.CyberPack then applyCyberPack() end
    if S.AngelPack then applyAngelPack() end
end

return {
    applyAura = applyAura, applyCrown = applyCrown, applyHorns = applyHorns,
    applyCatEars = applyCatEars, applyJetpack = applyJetpack, applyTail = applyTail,
    applyTopHat = applyTopHat, applyVisor = applyVisor, applyScythe = applyScythe,
    applyOniMask = applyOniMask, applyGasMask = applyGasMask, applyNeonMask = applyNeonMask,
    applyCap = applyCap, applyCyberPack = applyCyberPack, applyAngelPack = applyAngelPack,
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
    Shaders.apply(S.Shader)
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
    Cos.applyOniMask()
    Cos.applyGasMask()
    Cos.applyNeonMask()
    Cos.applyCap()
    Cos.applyCyberPack()
    Cos.applyAngelPack()
    applyKorblox(S.Korblox)
    applyGhostLegs(S.GhostLegs)
    applyNoAnims(S.NoAnims)
    setAvatarScale(S.AvatarScale)
    applyAccent()
    applyUITransparency()
    uiScale.Scale = computeScale()
    if S.Optimize >= 3 then
        S.MotionBlur = false
        local mb = Lighting:FindFirstChild("HamerMotionBlur")
        if mb then mb.Size = 0 end
    end
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
    Extras.stop()
    S.Dong, S.Wings, S.Halo, S.ChinaHat = false, false, false, false
    S.Kagune, S.Companion, S.NoAnims = false, false, false
    S.Fox, S.CoinFarm, S.FarmNoClip, S.FarmUnderMap = false, false, false, false
    S.ESP, S.ESPChams, S.ESPChamsThrough = false, false, false
    S.Aura, S.Crown, S.Horns, S.CatEars, S.Jetpack = false, false, false, false, false
    S.Tail, S.TopHat, S.Visor, S.Scythe = false, false, false, false
    S.OniMask, S.GasMask, S.NeonMask, S.Cap = false, false, false, false
    S.CyberPack, S.AngelPack = false, false
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
    Cos.applyOniMask()
    Cos.applyGasMask()
    Cos.applyNeonMask()
    Cos.applyCap()
    Cos.applyCyberPack()
    Cos.applyAngelPack()
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
    S.Shader = "off"
    Shaders.clear()
    S.MotionBlur = false
    if UI.mbEffect then UI.mbEffect:Destroy() end
    Wm.cleanup()
    if blur then blur:Destroy() end
    if gui then gui:Destroy() end
    if espGui then espGui:Destroy() end
end

builders.cosmetics = function()
    local folders = {
        {"all", "All"}, {"hats", "Hats"}, {"masks", "Masks"},
        {"packs", "Packs"}, {"auras", "Auras"}, {"effects", "FX"}
    }
    local folder = S.CosFolder
    local valid = false
    for _, f in ipairs(folders) do
        if f[1] == folder then valid = true end
    end
    if not valid then
        folder = "all"
        S.CosFolder = "all"
    end
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, S.Mobile and 36 or 32)
    row.BackgroundTransparency = 1
    row.LayoutOrder = -1
    row.Parent = grid
    local rowLayout = Instance.new("UIListLayout")
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.Padding = UDim.new(0, 6)
    rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rowLayout.Parent = row
    for i, f in ipairs(folders) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1 / #folders, -5, 1, 0)
        b.BackgroundColor3 = f[1] == folder and UI.navHi or UI.card
        b.BackgroundTransparency = f[1] == folder and 0 or 0.4
        b.Text = f[2]
        b.Font = FONT_BOLD
        b.TextSize = FS(11)
        b.TextColor3 = f[1] == folder and UI.text or UI.sub
        b.BorderSizePixel = 0
        b.AutoButtonColor = false
        b.LayoutOrder = i
        b.ZIndex = 12
        b.Parent = row
        corner(b, 8)
        stroke(b, f[1] == folder and accent() or UI.line, f[1] == folder and 0.4 or 0.94, 1)
        b.MouseButton1Click:Connect(function()
            S.CosFolder = f[1]
            click()
            selectTab("cosmetics")
        end)
    end
    local function hats()
        moduleRow("Crown", "Crown", nil, Cos.applyCrown)
        moduleRow("Cap", "Cap", nil, Cos.applyCap)
        moduleRow("Top hat", "TopHat", nil, Cos.applyTopHat)
        moduleRow("China hat", "ChinaHat", nil, applyChinaHat)
        moduleRow("Cat ears", "CatEars", nil, Cos.applyCatEars)
        moduleRow("Demon horns", "Horns", nil, Cos.applyHorns)
    end
    local function masks()
        moduleRow("Oni mask", "OniMask", nil, Cos.applyOniMask)
        moduleRow("Gas mask", "GasMask", nil, Cos.applyGasMask)
        moduleRow("Neon mask", "NeonMask", nil, Cos.applyNeonMask)
        moduleRow("Neon visor", "Visor", nil, Cos.applyVisor)
    end
    local function packs()
        moduleRow("Jetpack", "Jetpack", nil, Cos.applyJetpack)
        moduleRow("Cyber backpack", "CyberPack", nil, Cos.applyCyberPack)
        moduleRow("Angel backpack", "AngelPack", nil, Cos.applyAngelPack)
        moduleRow("Wings", "Wings", nil, applyWings)
        moduleRow("Scythe", "Scythe", nil, Cos.applyScythe)
    end
    local function auras()
        moduleRow("Neon Aura", "Aura", nil, Cos.applyAura)
        moduleRow("Halo", "Halo", nil, applyHalo)
    end
    local function effects()
        moduleRow("Kagune", "Kagune", nil, applyKagune)
        moduleRow("Neon tail", "Tail", nil, Cos.applyTail)
        moduleRow("Mini Fox", "Fox", function()
            stepRow("Size", "FoxSize", 0.5, 2, 0.1, "", applyFox)
        end, applyFox)
        moduleRow("Companion", "Companion", nil, applyCompanion)
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
    end
    moduleRow("Glow all cosmetics", "CosmeticGlow", nil, Cos.refresh)
    if folder == "all" or folder == "hats" then hats() end
    if folder == "all" or folder == "masks" then masks() end
    if folder == "all" or folder == "packs" then packs() end
    if folder == "all" or folder == "auras" then auras() end
    if folder == "all" or folder == "effects" then effects() end
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
    stepRow("Optimization", "Optimize", 1, 3, 1, "", applyOptimization)
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
    if S.OniMask then Cos.applyOniMask() end
    if S.GasMask then Cos.applyGasMask() end
    if S.NeonMask then Cos.applyNeonMask() end
    if S.Cap then Cos.applyCap() end
    if S.CyberPack then Cos.applyCyberPack() end
    if S.AngelPack then Cos.applyAngelPack() end
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
Shaders.apply(S.Shader)
if S.KillAll then CE.setKillAll(true) end
if S.SilentAim then CE.setSilentAim(true) end

selectTab("visual")
setMenu(true)

print("hamer loaded (no key)")
