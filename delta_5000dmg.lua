-- Ultimate Mobile Kill-Aura для Jurassic Blocky
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Константы
local FIXED_RADIUS = 1500 -- Фиксированный радиус ауры (метры)
local MIN_SPEED = 0.1
local MAX_SPEED = 10
local DEFAULT_SPEED = 1

-- Интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Главное окно
local MainWindow = Instance.new("Frame")
MainWindow.Name = "DeltaUltimateWindow"
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 220, 0, 200)
MainWindow.Position = UDim2.new(0.7, 0, 0.5, -100)
MainWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainWindow.Active = true
MainWindow.Draggable = true

-- Кнопка сворачивания
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Parent = MainWindow
MinimizeBtn.Size = UDim2.new(0, 30, 0, 20)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 0)
MinimizeBtn.Text = "_"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

-- Заголовок (разворачивает окно)
local Title = Instance.new("TextButton")
Title.Name = "Title"
Title.Parent = MainWindow
Title.Text = "DELTA ULTIMATE ▼"
Title.TextColor3 = Color3.fromRGB(220, 220, 255)
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- Основной контент (скрывается при сворачивании)
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Parent = MainWindow
Content.Size = UDim2.new(1, 0, 1, -30)
Content.Position = UDim2.new(0, 0, 0, 30)
Content.BackgroundTransparency = 1

-- Кнопка вкл/выкл
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = Content
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.05, 0, 0, 10)
ToggleBtn.Text = "AURA: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 120, 120)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

-- Ползунок скорости
local SpeedSliderFrame = Instance.new("Frame")
SpeedSliderFrame.Name = "SpeedSliderFrame"
SpeedSliderFrame.Parent = Content
SpeedSliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
SpeedSliderFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
SpeedSliderFrame.BackgroundTransparency = 1

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Parent = SpeedSliderFrame
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.Text = "SPEED: "..DEFAULT_SPEED.."x"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.BackgroundTransparency = 1

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Parent = SpeedSliderFrame
SpeedSlider.Size = UDim2.new(1, 0, 0, 10)
SpeedSlider.Position = UDim2.new(0, 0, 0.5, 0)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)

local SpeedFill = Instance.new("Frame")
SpeedFill.Name = "SpeedFill"
SpeedFill.Parent = SpeedSlider
SpeedFill.Size = UDim2.new((DEFAULT_SPEED-MIN_SPEED)/(MAX_SPEED-MIN_SPEED), 0, 1, 0)
SpeedFill.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
SpeedFill.ZIndex = 2

local SpeedButton = Instance.new("TextButton")
SpeedButton.Name = "SpeedButton"
SpeedButton.Parent = SpeedSlider
SpeedButton.Size = UDim2.new(0, 20, 0, 20)
SpeedButton.Position = UDim2.new(SpeedFill.Size.X.Scale, 0, 0, -5)
SpeedButton.Text = ""
SpeedButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.ZIndex = 3

-- Кнопка телепорта
local TeleportBtn = Instance.new("TextButton")
TeleportBtn.Name = "TeleportBtn"
TeleportBtn.Parent = Content
TeleportBtn.Size = UDim2.new(0.9, 0, 0, 30)
TeleportBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
TeleportBtn.Text = "TELEPORT TO PLAYER"
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(80, 50, 120)

-- Стилизация
local function applyStyles()
    local elements = {MainWindow, ToggleBtn, SpeedSlider, SpeedButton, TeleportBtn, MinimizeBtn}
    for _, element in pairs(elements) do
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.3, 0)
        corner.Parent = element
        
        if element ~= MainWindow then
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(100, 100, 140)
            stroke.Thickness = 1
            stroke.Parent = element
        end
    end
end
applyStyles()

-- Логика работы
local currentSpeed = DEFAULT_SPEED
local isActive = false
local speedDragging = false
local isMinimized = false

-- Фиксированная Kill-Aura
local function executeKill(target)
    if target and target:FindFirstChildOfClass("Humanoid") then
        target.Humanoid.Health = 0
        if UIS.TouchEnabled then
            pcall(function() UIS:Vibrate(Enum.VibrationType.Light, 0.05) end)
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
                if distance <= FIXED_RADIUS then
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
        end
    end
end

-- Обновление скорости
local function updateSpeed(value)
    local percent = math.clamp((value - MIN_SPEED)/(MAX_SPEED-MIN_SPEED), 0, 1)
    currentSpeed = math.floor(value * 10)/10
    SpeedLabel.Text = "SPEED: "..currentSpeed.."x"
    SpeedFill.Size = UDim2.new(percent, 0, 1, 0)
    SpeedButton.Position = UDim2.new(percent, 0, 0, -5)
end

-- Обработчики событий
ToggleBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    ToggleBtn.Text = "AURA: "..(isActive and "ON" or "OFF")
    ToggleBtn.TextColor3 = isActive and Color3.fromRGB(120, 255, 120) or Color3.fromRGB(255, 120, 120)
    
    while isActive do
        local startTime = os.clock()
        killInRadius()
        local elapsed = os.clock() - startTime
        local delay = (1/currentSpeed) - elapsed
        if delay > 0 then task.wait(delay) end
    end
end)

TeleportBtn.MouseButton1Click:Connect(function()
    teleportToRandomPlayer()
end)

-- Ползунок скорости
SpeedButton.MouseButton1Down:Connect(function()
    speedDragging = true
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        speedDragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if speedDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local sliderPos = SpeedSlider.AbsolutePosition.X
        local sliderSize = SpeedSlider.AbsoluteSize.X
        local mousePos = input.Position.X
        
        local percent = math.clamp((mousePos - sliderPos)/sliderSize, 0, 1)
        local newValue = MIN_SPEED + percent * (MAX_SPEED-MIN_SPEED)
        updateSpeed(newValue)
    end
end)

-- Сворачивание/разворачивание
local function toggleMinimize()
    isMinimized = not isMinimized
    if isMinimized then
        Content.Visible = false
        MainWindow.Size = UDim2.new(0, 220, 0, 30)
        Title.Text = "DELTA ULTIMATE ▲"
    else
        Content.Visible = true
        MainWindow.Size = UDim2.new(0, 220, 0, 200)
        Title.Text = "DELTA ULTIMATE ▼"
    end
end

Title.MouseButton1Click:Connect(toggleMinimize)
MinimizeBtn.MouseButton1Click:Connect(toggleMinimize)

-- Инициализация
updateSpeed(DEFAULT_SPEED)
print("Delta Ultimate loaded! | Fixed Radius:", FIXED_RADIUS, "| Speed:", currentSpeed.."x")
