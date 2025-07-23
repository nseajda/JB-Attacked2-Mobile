-- ULTRA ATTACK для Jurassic Blocky (мобильная версия)
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Настройки
local ATTACK_MULTIPLIER = 100 -- Во сколько раз усиливается атака
local BOOST_KEY = Enum.KeyCode.F -- Клавиша атаки (можно поменять)

-- Интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

-- Главное окно
local MainWindow = Instance.new("Frame")
MainWindow.Name = "UltraAttackWindow"
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 200, 0, 120)
MainWindow.Position = UDim2.new(0.75, 0, 0.7, 0)
MainWindow.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
MainWindow.Active = true
MainWindow.Draggable = true

-- Кнопка вкл/выкл
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MainWindow
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 50)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.1, 0)
ToggleBtn.Text = "ULTRA MODE: OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
ToggleBtn.TextSize = 14

-- Индикатор
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Parent = MainWindow
StatusLabel.Size = UDim2.new(0.9, 0, 0, 20)
StatusLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
StatusLabel.Text = "Нажми "..BOOST_KEY.Name.." для УЛЬТРА-атаки"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextSize = 12

-- Стиль
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.1, 0)
UICorner.Parent = MainWindow

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(100, 100, 150)
UIStroke.Thickness = 2
UIStroke.Parent = MainWindow

-- Логика
local isUltraMode = false
local originalAttack = nil

-- Захватываем оригинальную атаку
local function hijackAttack()
    if Player.Character then
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            originalAttack = humanoid.Attack
        end
    end
end

-- Ультра-атака (100 ударов за 1 клик)
local function ultraAttack()
    if not Player.Character then return end
    
    local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Имитируем 100 атак подряд
    for i = 1, ATTACK_MULTIPLIER do
        task.spawn(function()
            if originalAttack then
                originalAttack:Invoke()
            else
                humanoid:ChangeState(Enum.HumanoidStateType.Attacking)
            end
            
            -- Визуальный эффект
            if i % 10 == 0 then
                local effect = Instance.new("ParticleEmitter")
                effect.Parent = Player.Character:FindFirstChild("HumanoidRootPart")
                effect.Texture = "rbxassetid://242487987"
                game:GetService("Debris"):AddItem(effect, 0.5)
            end
        end)
    end
end

-- Перехват нажатия атаки
UIS.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == BOOST_KEY and isUltraMode then
        ultraAttack()
    end
end)

-- Включение/выключение
ToggleBtn.MouseButton1Click:Connect(function()
    isUltraMode = not isUltraMode
    ToggleBtn.Text = "ULTRA MODE: "..(isUltraMode and "ON" or "OFF")
    ToggleBtn.TextColor3 = isUltraMode and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    
    if isUltraMode then
        hijackAttack()
        StatusLabel.Text = "Режим: УЛЬТРА-АКТИВЕН"
    else
        StatusLabel.Text = "Нажми "..BOOST_KEY.Name.." для атаки"
    end
end)

-- Авто-обновление
Player.CharacterAdded:Connect(function()
    if isUltraMode then
        hijackAttack()
    end
end)

print("ULTRA ATTACK loaded! Press", BOOST_KEY.Name, "to destroy!")
