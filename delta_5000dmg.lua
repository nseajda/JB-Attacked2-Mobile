-- DELTA WORKING SCRIPT (Mobile/PC)
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Настройки
local ULTRA_MULTIPLIER = 100
local DEFAULT_SPEED = 1
local MIN_SPEED = 0.1
local MAX_SPEED = 10
local DEFAULT_HITBOX = 1
local MIN_HITBOX = 0.1
local MAX_HITBOX = 10
local DEFAULT_HURTBOX = 1
local MIN_HURTBOX = 0.1
local MAX_HURTBOX = 5

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui") -- Исправлено для надежности

local MainWindow = Instance.new("Frame")
MainWindow.Name = "DeltaWindow"
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 250, 0, 320)
MainWindow.Position = UDim2.new(0.7, 0, 0.5, -160)
MainWindow.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
MainWindow.Active = true
MainWindow.Draggable = true

-- Заголовок с кнопками
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainWindow
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Text = "DELTA ULTIMATE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TitleBar
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(0.7, 0, 0, 0)
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
CloseBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)

-- Основное содержимое
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = MainWindow
Content.Size = UDim2.new(1, 0, 1, -25)
Content.Position = UDim2.new(0, 0, 0, 25)
Content.BackgroundTransparency = 1

-- Кнопки функций
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = Content
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.05, 0)
ToggleBtn.Text = "ULTRA MODE: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

local GodModeBtn = Instance.new("TextButton")
GodModeBtn.Name = "GodModeBtn"
GodModeBtn.Parent = Content
GodModeBtn.Size = UDim2.new(0.9, 0, 0, 30)
GodModeBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
GodModeBtn.Text = "GOD MODE: OFF"
GodModeBtn.TextColor3 = Color3.fromRGB(120, 120, 255)
GodModeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

local ShowHitboxesBtn = Instance.new("TextButton")
ShowHitboxesBtn.Name = "ShowHitboxesBtn"
ShowHitboxesBtn.Parent = Content
ShowHitboxesBtn.Size = UDim2.new(0.9, 0, 0, 30)
ShowHitboxesBtn.Position = UDim2.new(0.05, 0, 0.25, 0)
ShowHitboxesBtn.Text = "SHOW HITBOXES: OFF"
ShowHitboxesBtn.TextColor3 = Color3.fromRGB(120, 255, 120)
ShowHitboxesBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

-- Ползунок скорости
local SpeedFrame = Instance.new("Frame")
SpeedFrame.Name = "SpeedFrame"
SpeedFrame.Parent = Content
SpeedFrame.Size = UDim2.new(0.9, 0, 0, 50)
SpeedFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
SpeedFrame.BackgroundTransparency = 1

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Parent = SpeedFrame
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Text = "SPEED: "..DEFAULT_SPEED.."x"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.BackgroundTransparency = 1

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Parent = SpeedFrame
SpeedSlider.Size = UDim2.new(1, 0, 0, 10)
SpeedSlider.Position = UDim2.new(0, 0, 0.5, 0)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

local SpeedFill = Instance.new("Frame")
SpeedFill.Name = "SpeedFill"
SpeedFill.Parent = SpeedSlider
SpeedFill.Size = UDim2.new((DEFAULT_SPEED-MIN_SPEED)/(MAX_SPEED-MIN_SPEED), 0, 1, 0)
SpeedFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
SpeedFill.ZIndex = 2

local SpeedButton = Instance.new("TextButton")
SpeedButton.Name = "SpeedButton"
SpeedButton.Parent = SpeedSlider
SpeedButton.Size = UDim2.new(0, 20, 0, 20)
SpeedButton.Position = UDim2.new(SpeedFill.Size.X.Scale, 0, 0, -5)
SpeedButton.Text = ""
SpeedButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.ZIndex = 3

-- Ползунок хитбоксов
local HitboxFrame = Instance.new("Frame")
HitboxFrame.Name = "HitboxFrame"
HitboxFrame.Parent = Content
HitboxFrame.Size = UDim2.new(0.9, 0, 0, 50)
HitboxFrame.Position = UDim2.new(0.05, 0, 0.5, 0)
HitboxFrame.BackgroundTransparency = 1

local HitboxLabel = Instance.new("TextLabel")
HitboxLabel.Name = "HitboxLabel"
HitboxLabel.Parent = HitboxFrame
HitboxLabel.Size = UDim2.new(1, 0, 0, 20)
HitboxLabel.Text = "ENEMY HITBOX: "..DEFAULT_HITBOX.."x"
HitboxLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
HitboxLabel.Font = Enum.Font.Gotham
HitboxLabel.BackgroundTransparency = 1

local HitboxSlider = Instance.new("Frame")
HitboxSlider.Name = "HitboxSlider"
HitboxSlider.Parent = HitboxFrame
HitboxSlider.Size = UDim2.new(1, 0, 0, 10)
HitboxSlider.Position = UDim2.new(0, 0, 0.5, 0)
HitboxSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

local HitboxFill = Instance.new("Frame")
HitboxFill.Name = "HitboxFill"
HitboxFill.Parent = HitboxSlider
HitboxFill.Size = UDim2.new((DEFAULT_HITBOX-MIN_HITBOX)/(MAX_HITBOX-MIN_HITBOX), 0, 1, 0)
HitboxFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
HitboxFill.ZIndex = 2

local HitboxButton = Instance.new("TextButton")
HitboxButton.Name = "HitboxButton"
HitboxButton.Parent = HitboxSlider
HitboxButton.Size = UDim2.new(0, 20, 0, 20)
HitboxButton.Position = UDim2.new(HitboxFill.Size.X.Scale, 0, 0, -5)
HitboxButton.Text = ""
HitboxButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HitboxButton.ZIndex = 3

-- Стилизация
local function applyStyles()
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.2, 0)
    corner.Parent = MainWindow
    
    local elements = {ToggleBtn, GodModeBtn, ShowHitboxesBtn, MinimizeBtn, CloseBtn, SpeedSlider, HitboxSlider}
    
    for _, element in pairs(elements) do
        local elementCorner = Instance.new("UICorner")
        elementCorner.CornerRadius = UDim.new(0.3, 0)
        elementCorner.Parent = element
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(100, 100, 140)
        stroke.Thickness = 1
        stroke.Parent = element
    end
end
applyStyles()

-- Логика работы
local ultraActive = false
local godModeActive = false
local showHitboxesActive = false
local currentSpeed = DEFAULT_SPEED
local currentHitboxSize = DEFAULT_HITBOX
local currentHurtboxSize = DEFAULT_HURTBOX
local originalAttack = nil
local hitboxVisuals = {}

-- Функции
local function updateSpeed(value)
    currentSpeed = math.clamp(value, MIN_SPEED, MAX_SPEED)
    SpeedLabel.Text = "SPEED: "..string.format("%.1f", currentSpeed).."x"
    SpeedFill.Size = UDim2.new((currentSpeed-MIN_SPEED)/(MAX_SPEED-MIN_SPEED), 0, 1, 0)
    SpeedButton.Position = UDim2.new(SpeedFill.Size.X.Scale, 0, 0, -5)
end

local function updateHitboxSize(value)
    currentHitboxSize = math.clamp(value, MIN_HITBOX, MAX_HITBOX)
    HitboxLabel.Text = "ENEMY HITBOX: "..string.format("%.1f", currentHitboxSize).."x"
    HitboxFill.Size = UDim2.new((currentHitboxSize-MIN_HITBOX)/(MAX_HITBOX-MIN_HITBOX), 0, 1, 0)
    HitboxButton.Position = UDim2.new(HitboxFill.Size.X.Scale, 0, 0, -5)
end

-- Обработчики событий
ToggleBtn.MouseButton1Click:Connect(function()
    ultraActive = not ultraActive
    ToggleBtn.Text = "ULTRA MODE: "..(ultraActive and "ON" or "OFF")
    ToggleBtn.TextColor3 = ultraActive and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
end)

GodModeBtn.MouseButton1Click:Connect(function()
    godModeActive = not godModeActive
    GodModeBtn.Text = "GOD MODE: "..(godModeActive and "ON" or "OFF")
    
    if godModeActive then
        Player.Character.Humanoid:SetAttribute("Invulnerable", true)
    else
        Player.Character.Humanoid:SetAttribute("Invulnerable", false)
    end
end)

ShowHitboxesBtn.MouseButton1Click:Connect(function()
    showHitboxesActive = not showHitboxesActive
    ShowHitboxesBtn.Text = "SHOW HITBOXES: "..(showHitboxesActive and "ON" or "OFF")
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    Content.Visible = not Content.Visible
    MainWindow.Size = UDim2.new(0, 250, 0, Content.Visible and 320 or 25)
    MinimizeBtn.Text = Content.Visible and "_" or "+"
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Инициализация ползунков
updateSpeed(DEFAULT_SPEED)
updateHitboxSize(DEFAULT_HITBOX)

print("Delta Ultimate GUI loaded successfully!") игра шутер от вида сверху красная синяя команда, не стикманы, есть режимы оружие постройка карт
