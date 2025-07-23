-- Мобильный Kill-Aura для Jurassic Blocky
-- Репозиторий: JB-Attacked-Mobile
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")

-- Настройки
local DEFAULT_RADIUS = 150 -- Стандартный радиус 
local KILL_DELAY = 0.4 -- Задержка между атаками
local VIBRATE_ON_KILL = true -- Вибрация при убийстве

-- Интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Главная кнопка (стиль Delta)
local MainBtn = Instance.new("TextButton")
MainBtn.Name = "DeltaAuraBtn"
MainBtn.Parent = ScreenGui
MainBtn.Size = UDim2.new(0, 110, 0, 110)
MainBtn.Position = UDim2.new(0.82, 0, 0.75, 0)
MainBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MainBtn.Text = "DELTA\nOFF"
MainBtn.TextSize = 16
MainBtn.Font = Enum.Font.SourceSansBold
MainBtn.ZIndex = 999

-- Индикатор радиуса
local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Name = "RadiusLabel"
RadiusLabel.Parent = ScreenGui
RadiusLabel.Size = UDim2.new(0, 80, 0, 30)
RadiusLabel.Position = UDim2.new(0.7, 0, 0.75, 0)
RadiusLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
RadiusLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
RadiusLabel.Text = "RADIUS: "..DEFAULT_RADIUS
RadiusLabel.TextSize = 12

-- Стиль Delta
local function applyDeltaStyle()
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.2, 0)
    corner.Parent = MainBtn
    
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(255, 80, 80)
    stroke.Thickness = 2
    stroke.Parent = MainBtn
    
    RadiusLabel.Font = Enum.Font.Code
end

applyDeltaStyle()

-- Логика Kill-Aura
local currentRadius = DEFAULT_RADIUS
local isActive = false

local function executeKill(target)
    if target and target:FindFirstChildOfClass("Humanoid") then
        -- Основной метод
        target.Humanoid.Health = 0
        
        -- Резервные методы
        pcall(function() target.Humanoid:TakeDamage(9999) end)
        pcall(function() target.Humanoid:ChangeState(Enum.HumanoidStateType.Dead) end)
        
        -- Вибрация
        if VIBRATE_ON_KILL and UIS.TouchEnabled then
            pcall(function() UIS:Vibrate(Enum.VibrationType.Light, 0.2) end)
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

-- Изменение радиуса
local radiusOptions = {100, 150, 200, 250}
local currentOption = 2

RadiusLabel.MouseButton1Click:Connect(function()
    currentOption = currentOption % #radiusOptions + 1
    currentRadius = radiusOptions[currentOption]
    RadiusLabel.Text = "RADIUS: "..currentRadius
end)

-- Управление аурой
MainBtn.MouseButton1Click:Connect(function()
    isActive = not isActive
    MainBtn.Text = "DELTA\n"..(isActive and "ON" or "OFF")
    MainBtn.BackgroundColor3 = isActive and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
    
    while isActive do
        killInRadius()
        task.wait(KILL_DELAY)
    end
end)

-- Авто-обновление при смерти
Player.CharacterAdded:Connect(function()
    if isActive then
        MainBtn.Text = "DELTA\nON"
        MainBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
    end
end)

print("Delta Mobile Kill-Aura loaded! | Radius: "..currentRadius)
