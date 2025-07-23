-- Улучшенный мобильный Kill-Aura для Jurassic Blocky
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")

-- Настройки
local DEFAULT_RADIUS = 100
local MIN_RADIUS = 20
local MAX_RADIUS = 300
local KILL_DELAY = 0.3
local VIBRATE_ON_KILL = true

-- Интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Главное окно
local MainWindow = Instance.new("Frame")
MainWindow.Name = "DeltaWindow"
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 200, 0, 180)
MainWindow.Position = UDim2.new(0.75, 0, 0.5, -90)
MainWindow.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
MainWindow.Active = true
MainWindow.Draggable = true

-- Стиль окна
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.1, 0)
UICorner.Parent = MainWindow

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 120)
UIStroke.Thickness = 2
UIStroke.Parent = MainWindow

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainWindow
Title.Text = "DELTA MOBILE v2"
Title.TextColor3 = Color3.fromRGB(220, 220, 255)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- Кнопка вкл/выкл
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainWindow
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.Text = "AURA: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

-- Ползунок радиуса
local SliderFrame = Instance.new("Frame")
SliderFrame.Name = "SliderFrame"
SliderFrame.Parent = MainWindow
SliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
SliderFrame.Position = UDim2.new(0.05, 0, 0.45, 0)
SliderFrame.BackgroundTransparency = 1

local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Name = "RadiusLabel"
RadiusLabel.Parent = SliderFrame
RadiusLabel.Size = UDim2.new(1, 0, 0, 20)
RadiusLabel.Text = "RADIUS: "..DEFAULT_RADIUS
RadiusLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
RadiusLabel.Font = Enum.Font.Gotham
RadiusLabel.BackgroundTransparency = 1

local Slider = Instance.new("Frame")
Slider.Name = "Slider"
Slider.Parent = SliderFrame
Slider.Size = UDim2.new(1, 0, 0, 10)
Slider.Position = UDim2.new(0, 0, 0.5, 0)
Slider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Parent = Slider
SliderFill.Size = UDim2.new((DEFAULT_RADIUS-MIN_RADIUS)/(MAX_RADIUS-MIN_RADIUS), 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
SliderFill.ZIndex = 2

local SliderButton = Instance.new("TextButton")
SliderButton.Name = "SliderButton"
SliderButton.Parent = Slider
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new(SliderFill.Size.X.Scale, 0, 0, -5)
SliderButton.Text = ""
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.ZIndex = 3

-- Кнопка телепорта
local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Name = "TeleportBtn"
TeleportBtn.Parent = MainWindow
TeleportBtn.Size = UDim2.new(0.9, 0, 0, 30)
TeleportBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
TeleportBtn.Text = "TELEPORT TO PLAYER"
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 120)

-- Стилизация элементов
local function applyStyles()
    local elements = {ToggleBtn, Slider, SliderButton, TeleportBtn}
    for _, element in pairs(elements) do
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.3, 0)
        corner.Parent = element
    end
end
applyStyles()

-- Логика работы
local currentRadius = DEFAULT_RADIUS
local isActive = false
local dragging = false

-- Kill-Aura функция
local function executeKill(target)
    if target and target:FindFirstChildOfClass("Humanoid") then
        target.Humanoid.Health = 0
        if VIBRATE_ON_KILL and UIS.TouchEnabled then
            pcall(function() UIS:Vibrate(Enum.VibrationType.Light, 0.1) end)
        end
    end
end

local function killInRadius()
    if not Player.Character then return end
    local root = Player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, target in ipairs(game.Players:GetPlayers()) do
        if target ~= Player and target.Character then
            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            
            if humanoid and humanoid.Health > 0 and targetRoot then
                local distance = (root.Position - targetRoot.Position).Magnitude
                if distance <= currentRadius then
                    executeKill(target.Character)
                end
            end
        end
    end
end

-- Телепорт к случайному игроку
local function teleportToRandomPlayer()
    local players = game.Players:GetPlayers()
    local validTargets = {}
    
    for _, player in ipairs(players) do
        if player ~= Player and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                table.insert(validTargets, hrp)
            end
        end
    end
    
    if #validTargets > 0 then
        local target = validTargets[math.random(1, #validTargets)]
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0, 3, 0)
            
            -- Анимация телепорта
            local effect = Instance.new("Part")
            effect.Size = Vector3.new(1, 1, 1)
            effect.CFrame = target.CFrame
            effect.Anchored = true
            effect.CanCollide = false
            effect.Transparency = 1
            local particle = Instance.new("ParticleEmitter", effect)
            particle.Texture = "rbxassetid://242487987"
            game.Debris:AddItem(effect, 1)
        end
    end
end

-- Обработчики событий
ToggleBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    ToggleBtn.Text = "AURA: "..(isActive and "ON" or "OFF")
    ToggleBtn.TextColor3 = isActive and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
    
    while isActive do
        killInRadius()
        task.wait(KILL_DELAY)
    end
end)

TeleportBtn.MouseButton1Click:Connect(function()
    teleportToRandomPlayer()
end)

-- Логика ползунка
local function updateSlider(value)
    local percent = math.clamp((value - MIN_RADIUS)/(MAX_RADIUS-MIN_RADIUS), 0, 1)
    currentRadius = math.floor(value)
    RadiusLabel.Text = "RADIUS: "..currentRadius
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    SliderButton.Position = UDim2.new(percent, 0, 0, -5)
end

SliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local sliderPos = Slider.AbsolutePosition.X
        local sliderSize = Slider.AbsoluteSize.X
        local mousePos = input.Position.X
        
        local percent = math.clamp((mousePos - sliderPos)/sliderSize, 0, 1)
        local newValue = MIN_RADIUS + math.floor(percent * (MAX_RADIUS-MIN_RADIUS))
        updateSlider(newValue)
    end
end)

-- Инициализация
updateSlider(DEFAULT_RADIUS)
print("Delta Mobile v2 loaded! | Radius:", currentRadius)
