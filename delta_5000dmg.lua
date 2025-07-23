-- DELTA FINAL ULTIMATE (Mobile/PC)
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
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local MainWindow = Instance.new("Frame")
MainWindow.Name = "DeltaWindow"
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 250, 0, 320)
MainWindow.Position = UDim2.new(0.7, 0, 0.5, -160)
MainWindow.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
MainWindow.Active = true
MainWindow.Draggable = true

-- Заголовок с кнопками управления
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainWindow
TitleBar.Size = UDim2.new(1, 0, 0, 25)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 70)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TitleBar
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Text = "DELTA ULTIMATE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = TitleBar
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(0.8, 0, 0, 0)
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(0.9, 0, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 150, 150)
CloseBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)

-- Основные элементы
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = MainWindow
Content.Size = UDim2.new(1, 0, 1, -25)
Content.Position = UDim2.new(0, 0, 0, 25)
Content.BackgroundTransparency = 1

-- Кнопки режимов
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

-- Ползунки
local SpeedSlider = createSlider("SPEED: "..DEFAULT_SPEED.."x", UDim2.new(0.9, 0, 0, 50), UDim2.new(0.05, 0, 0.35, 0), MIN_SPEED, MAX_SPEED, DEFAULT_SPEED)
SpeedSlider.Parent = Content

local HitboxSlider = createSlider("ENEMY HITBOX: "..DEFAULT_HITBOX.."x", UDim2.new(0.9, 0, 0, 50), UDim2.new(0.05, 0, 0.5, 0), MIN_HITBOX, MAX_HITBOX, DEFAULT_HITBOX)
HitboxSlider.Parent = Content

local HurtboxSlider = createSlider("ATTACK RANGE: "..DEFAULT_HURTBOX.."x", UDim2.new(0.9, 0, 0, 50), UDim2.new(0.05, 0, 0.65, 0), MIN_HURTBOX, MAX_HURTBOX, DEFAULT_HURTBOX)
HurtboxSlider.Parent = Content

-- Стилизация
local function applyStyles()
    local corners = {MainWindow, ToggleBtn, GodModeBtn, ShowHitboxesBtn, MinimizeBtn, CloseBtn}
    
    for _, element in pairs(corners) do
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.2, 0)
        corner.Parent = element
        
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

-- Функция создания ползунка
function createSlider(text, size, position, min, max, default)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = frame
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 255)
    label.Font = Enum.Font.Gotham
    label.BackgroundTransparency = 1

    local slider = Instance.new("Frame")
    slider.Name = "Slider"
    slider.Parent = frame
    slider.Size = UDim2.new(1, 0, 0, 10)
    slider.Position = UDim2.new(0, 0, 0.5, 0)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Parent = slider
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    fill.ZIndex = 2

    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Parent = slider
    button.Size = UDim2.new(0, 20, 0, 20)
    button.Position = UDim2.new(fill.Size.X.Scale, 0, 0, -5)
    button.Text = ""
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.ZIndex = 3

    return frame
end

-- Остальные функции и обработчики событий...
