-- ULTIMATE DELTA SCRIPT (Mobile/PC)
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Конфигурация
local ULTRA_MULTIPLIER = 100 -- Усиление атаки
local HEAL_RATE = 5 -- Скорость восстановления HP
local DEFAULT_RADIUS = 50
local MIN_RADIUS = 10
local MAX_RADIUS = 200
local DEFAULT_SPEED = 1
local MIN_SPEED = 0.1
local MAX_SPEED = 5

-- Интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = Player:WaitForChild("PlayerGui")

local MainWindow = Instance.new("Frame")
MainWindow.Name = "DeltaUltimateWindow"
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 220, 0, 250)
MainWindow.Position = UDim2.new(0.7, 0, 0.5, -125)
MainWindow.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainWindow.Active = true
MainWindow.Draggable = true

-- Элементы GUI
local elements = {
    ToggleBtn = createButton("ULTRA: OFF", Color3.fromRGB(255,80,80), UDim2.new(0.9,0,0,30), UDim2.new(0.05,0,0.05,0)),
    HealToggle = createButton("HEAL AURA: OFF", Color3.fromRGB(80,80,255), UDim2.new(0.9,0,0,30), UDim2.new(0.05,0,0.15,0)),
    SpeedSlider = createSlider("SPEED: "..DEFAULT_SPEED.."x", UDim2.new(0.9,0,0,50), UDim2.new(0.05,0,0.3,0), MIN_SPEED, MAX_SPEED, DEFAULT_SPEED),
    RadiusSlider = createSlider("RADIUS: "..DEFAULT_RADIUS, UDim2.new(0.9,0,0,50), UDim2.new(0.05,0,0.5,0), MIN_RADIUS, MAX_RADIUS, DEFAULT_RADIUS),
    TeleportBtn = createButton("TELEPORT PLAYER", Color3.fromRGB(120,40,120), UDim2.new(0.9,0,0,30), UDim2.new(0.05,0,0.8,0))
}

-- Логика
local ultraActive = false
local healActive = false
local currentSpeed = DEFAULT_SPEED
local currentRadius = DEFAULT_RADIUS
local originalAttack = nil

-- Мобильный ввод
local mobileAttackActive = false
if UIS.TouchEnabled then
    local attackBtn = createButton("ATTACK", Color3.fromRGB(255,60,60), UDim2.new(0,100,0,100), UDim2.new(0.8,0,0.7,0))
    attackBtn.MouseButton1Down:Connect(function()
        mobileAttackActive = true
        while mobileAttackActive do
            handleAttack()
            task.wait(0.1)
        end
    end)
    attackBtn.MouseButton1Up:Connect(function() mobileAttackActive = false end)
end

-- Функции
function handleAttack()
    if ultraActive then
        for i = 1, ULTRA_MULTIPLIER do
            task.spawn(originalAttack)
            if i % 10 == 0 then
                spawnParticle(Player.Character.HumanoidRootPart)
            end
        end
    else
        originalAttack()
    end
end

function healAura()
    if healActive and Player.Character then
        local humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health < humanoid.MaxHealth then
            humanoid.Health = math.min(humanoid.Health + HEAL_RATE, humanoid.MaxHealth)
        end
    end
end

-- Основной цикл
RunService.Heartbeat:Connect(function()
    healAura()
    if ultraActive and not UIS.TouchEnabled then
        if UIS:IsKeyDown(Enum.KeyCode.F) then
            handleAttack()
        end
    end
end)

-- Инициализация
hijackOriginalAttack()
setupGUI()
print("Delta Ultimate loaded!")
