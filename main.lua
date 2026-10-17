-- DRAYKO UNIVERSAL v2
-- Interface de exemplo com controles de movimento para testes no Roblox Studio.
-- Instale como LocalScript em StarterPlayer > StarterPlayerScripts.
-- Não é um script de executor para jogos de terceiros.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local C = {
    bg = Color3.fromRGB(16, 18, 27),
    panel = Color3.fromRGB(28, 32, 46),
    row = Color3.fromRGB(35, 40, 57),
    blue = Color3.fromRGB(55, 145, 255),
    text = Color3.fromRGB(244, 247, 255),
    muted = Color3.fromRGB(164, 175, 198),
    red = Color3.fromRGB(232, 72, 91),
    green = Color3.fromRGB(52, 200, 110),
}

local gui = Instance.new("ScreenGui")
gui.Name = "DraykoUniversal"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local function corner(obj, radius)
    local u = Instance.new("UICorner")
    u.CornerRadius = UDim.new(0, radius or 10)
    u.Parent = obj
    return u
end

local function label(parent, text, size, position, font, color)
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Text = text
    t.Size = size
    t.Position = position
    t.Font = font or Enum.Font.Gotham
    t.TextColor3 = color or C.text
    t.TextSize = 14
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = parent
    return t
end

-- Loading splash
local splash = Instance.new("Frame")
splash.AnchorPoint = Vector2.new(0.5, 0.5)
splash.Position = UDim2.fromScale(0.5, 0.5)
splash.Size = UDim2.fromOffset(290, 112)
splash.BackgroundColor3 = C.bg
splash.Parent = gui
corner(splash, 14)
label(splash, "DRAYKO UNIVERSAL", UDim2.new(1, -28, 0, 26), UDim2.fromOffset(14, 12), Enum.Font.GothamBold)
local loadingText = label(splash, "Loading...", UDim2.new(1, -28, 0, 20), UDim2.fromOffset(14, 42), Enum.Font.Gotham, C.muted)
local track = Instance.new("Frame")
track.Position = UDim2.fromOffset(14, 78)
track.Size = UDim2.new(1, -28, 0, 7)
track.BackgroundColor3 = C.row
track.Parent = splash
corner(track, 5)
local fill = Instance.new("Frame")
fill.Size = UDim2.fromScale(0, 1)
fill.BackgroundColor3 = C.blue
fill.Parent = track
corner(fill, 5)
TweenService:Create(fill, TweenInfo.new(0.9), {Size = UDim2.fromScale(1, 1)}):Play()
task.wait(1)
if splash.Parent then splash:Destroy() end

-- Main panel
local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = UDim2.fromOffset(370, 390)
panel.BackgroundColor3 = C.bg
panel.Parent = gui
corner(panel, 16)
local outline = Instance.new("UIStroke")
outline.Color = Color3.fromRGB(67, 83, 115)
outline.Thickness = 1.5
outline.Parent = panel

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = C.panel
header.Parent = panel
corner(header, 16)
local cover = Instance.new("Frame")
cover.Position = UDim2.new(0, 0, 1, -14)
cover.Size = UDim2.new(1, 0, 0, 14)
cover.BackgroundColor3 = C.panel
cover.BorderSizePixel = 0
cover.Parent = header
label(header, "DRAYKO UNIVERSAL", UDim2.new(1, -120, 1, 0), UDim2.fromOffset(14, 0), Enum.Font.GothamBold)

local function headerButton(text, rightOffset, color)
    local b = Instance.new("TextButton")
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, rightOffset, 0.5, 0)
    b.Size = UDim2.fromOffset(34, 30)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = C.text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 18
    b.Parent = header
    corner(b, 8)
    return b
end
local minimize = headerButton("—", -50, Color3.fromRGB(69, 79, 103))
local close = headerButton("×", -10, C.red)

local tabBar = Instance.new("Frame")
tabBar.BackgroundTransparency = 1
tabBar.Position = UDim2.fromOffset(12, 60)
tabBar.Size = UDim2.new(1, -24, 0, 36)
tabBar.Parent = panel

local content = Instance.new("Frame")
content.BackgroundTransparency = 1
content.Position = UDim2.fromOffset(12, 104)
content.Size = UDim2.new(1, -24, 1, -116)
content.Parent = panel

local orb = Instance.new("TextButton")
orb.Name = "DraykoFloatingOrb"
orb.AnchorPoint = Vector2.new(0.5, 0.5)
orb.Position = UDim2.new(0.88, 0, 0.5, 0)
orb.Size = UDim2.fromOffset(54, 54)
orb.BackgroundColor3 = C.blue
orb.Text = "D"
orb.TextColor3 = C.text
orb.Font = Enum.Font.GothamBlack
orb.TextSize = 23
orb.Visible = false
orb.Parent = gui
corner(orb, 27)

local function draggable(target, handle)
    local active, start, origin = false, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            active, start, origin = true, input.Position, target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then active = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if active and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - start
            target.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
        end
    end)
end
draggable(panel, header)
draggable(orb, orb)

local activeTab = nil
local pages = {}
local tabButtons = {}

local function clearPage()
    for _, child in ipairs(content:GetChildren()) do child:Destroy() end
end

local function makeButton(parent, text, y, callback)
    local b = Instance.new("TextButton")
    b.Position = UDim2.fromOffset(0, y)
    b.Size = UDim2.new(1, 0, 0, 38)
    b.BackgroundColor3 = C.row
    b.Text = text
    b.TextColor3 = C.text
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 13
    b.Parent = parent
    corner(b, 9)
    b.MouseButton1Click:Connect(callback)
    return b
end

local function showTab(name)
    activeTab = name
    clearPage()
    for tabName, b in pairs(tabButtons) do
        b.BackgroundColor3 = tabName == name and C.blue or C.row
    end
    pages[name]()
end

local function makeTab(name, x)
    local b = Instance.new("TextButton")
    b.Position = UDim2.fromOffset(x, 0)
    b.Size = UDim2.new(0.25, -5, 1, 0)
    b.BackgroundColor3 = C.row
    b.Text = name
    b.TextColor3 = C.text
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 11
    b.Parent = tabBar
    corner(b, 8)
    b.MouseButton1Click:Connect(function() showTab(name) end)
    tabButtons[name] = b
end
makeTab("Movimento", 0)
makeTab("Jogadores", 86)
makeTab("Auto", 172)
makeTab("Config", 258)

local flying = false
local flySpeed = 48
local flyConnection
local flyVelocity
local flyAttachment
local savedWalkSpeed = 16
local savedJumpPower = 50
local speedEnabled = false
local jumpEnabled = false

local function getCharacter()
    local char = player.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if hum and root then return char, hum, root end
    return nil
end

local function stopFly()
    flying = false
    if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    if flyVelocity then flyVelocity:Destroy(); flyVelocity = nil end
    if flyAttachment then flyAttachment:Destroy(); flyAttachment = nil end
end

local function startFly()
    local _, hum, root = getCharacter()
    if not hum or not root then return false end
    stopFly()
    flying = true
    flyAttachment = Instance.new("Attachment")
    flyAttachment.Name = "DraykoFlyAttachment"
    flyAttachment.Parent = root
    flyVelocity = Instance.new("LinearVelocity")
    flyVelocity.Name = "DraykoFlyVelocity"
    flyVelocity.Attachment0 = flyAttachment
    flyVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
    flyVelocity.MaxForce = 100000
    flyVelocity.VectorVelocity = Vector3.zero
    flyVelocity.Parent = root
    flyConnection = RunService.RenderStepped:Connect(function()
        local camera = workspace.CurrentCamera
        local character, humanoid, rootPart = getCharacter()
        if not character or not camera or not flyVelocity then stopFly(); return end
        local direction = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then direction += camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then direction -= camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then direction -= camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then direction += camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then direction += Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then direction -= Vector3.yAxis end
        flyVelocity.VectorVelocity = direction.Magnitude > 0 and direction.Unit * flySpeed or Vector3.zero
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end)
    return true
end

pages["Movimento"] = function()
    label(content, "Movimento (teste no seu próprio jogo)", UDim2.new(1, 0, 0, 22), UDim2.fromOffset(0, 0), Enum.Font.Gotham, C.muted)
    makeButton(content, flying and "Desativar voo" or "Ativar voo", 28, function()
        if flying then
            stopFly()
        else
            if not startFly() then
                -- Mostra um aviso se o personagem ainda não estiver carregado.
                statusMessage = "Personagem ainda carregando."
            end
        end
        showTab("Movimento")
    end)
    makeButton(content, speedEnabled and "Velocidade: ON" or "Alternar velocidade (30)", 74, function()
        local _, hum = getCharacter()
        if hum then
            speedEnabled = not speedEnabled
            hum.WalkSpeed = speedEnabled and 30 or savedWalkSpeed
        end
        showTab("Movimento")
    end)
    makeButton(content, jumpEnabled and "Pulo alto: ON" or "Alternar pulo alto", 120, function()
        local _, hum = getCharacter()
        if hum then
            jumpEnabled = not jumpEnabled
            hum.UseJumpPower = true
            hum.JumpPower = jumpEnabled and 90 or savedJumpPower
        end
        showTab("Movimento")
    end)
    label(content, "PC: WASD para mover • Espaço sobe • Ctrl desce", UDim2.new(1, 0, 0, 42), UDim2.fromOffset(0, 170), Enum.Font.Gotham, C.muted)
end

pages["Jogadores"] = function()
    label(content, "Jogadores na sessão", UDim2.new(1, 0, 0, 22), UDim2.fromOffset(0, 0), Enum.Font.Gotham, C.muted)
    local list = Instance.new("ScrollingFrame")
    list.Position = UDim2.fromOffset(0, 28)
    list.Size = UDim2.new(1, 0, 1, -28)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = 4
    list.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 35)
    list.Parent = content
    local y = 0
    for _, p in ipairs(Players:GetPlayers()) do
        local row = label(list, p.DisplayName .. "  (@" .. p.Name .. ")", UDim2.new(1, -8, 0, 30), UDim2.fromOffset(4, y), Enum.Font.Gotham, p == player and C.blue or C.text)
        y += 35
    end
    list.CanvasSize = UDim2.new(0, 0, 0, y)
end

pages["Auto"] = function()
    label(content, "Automação local", UDim2.new(1, 0, 0, 22), UDim2.fromOffset(0, 0), Enum.Font.Gotham, C.muted)
    makeButton(content, "Anti-AFK: alternar", 30, function()
        -- Exemplo visual; não altera eventos do servidor.
        autoAfkEnabled = not autoAfkEnabled
        showTab("Auto")
    end)
    label(content, "Anti-AFK demonstrativo: " .. (autoAfkEnabled and "ON" or "OFF"), UDim2.new(1, 0, 0, 22), UDim2.fromOffset(0, 78), Enum.Font.Gotham, C.muted)
    label(content, "Use automações apenas em experiências onde você tem autorização.", UDim2.new(1, 0, 0, 52), UDim2.fromOffset(0, 110), Enum.Font.Gotham, C.muted)
end

pages["Config"] = function()
    label(content, "Configurações", UDim2.new(1, 0, 0, 22), UDim2.fromOffset(0, 0), Enum.Font.Gotham, C.muted)
    makeButton(content, "Atalho K: mostrar/esconder", 30, function()
        label(content, "O atalho K está ativo.", UDim2.new(1, 0, 0, 24), UDim2.fromOffset(0, 78), Enum.Font.Gotham, C.blue)
    end)
    makeButton(content, "Restaurar movimento padrão", 76, function()
        local _, hum = getCharacter()
        if hum then
            hum.WalkSpeed = savedWalkSpeed
            hum.UseJumpPower = true
            hum.JumpPower = savedJumpPower
        end
        speedEnabled, jumpEnabled = false, false
        stopFly()
        showTab("Config")
    end)
end

autoAfkEnabled = false
local statusMessage = ""
showTab("Movimento")

minimize.MouseButton1Click:Connect(function()
    panel.Visible = false
    orb.Visible = true
end)
orb.MouseButton1Click:Connect(function()
    panel.Visible = true
    orb.Visible = false
end)
close.MouseButton1Click:Connect(function()
    stopFly()
    local _, hum = getCharacter()
    if hum then
        hum.WalkSpeed = savedWalkSpeed
        hum.UseJumpPower = true
        hum.JumpPower = savedJumpPower
    end
    gui:Destroy()
end)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.K then
        if panel.Visible then panel.Visible = false; orb.Visible = true
        else panel.Visible = true; orb.Visible = false end
    end
end)
player.CharacterAdded:Connect(function()
    stopFly()
    speedEnabled, jumpEnabled = false, false
end)
