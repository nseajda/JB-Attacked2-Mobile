-- TELEPORT TO SPECIFIC PLAYERS
local Player = game:GetService("Players").LocalPlayer
local UIS = game:GetService("UserInputService")

-- Настройки
local TARGET_PLAYERS = {
    ["XxPandaxX"] = {
        Color = Color3.fromRGB(255, 100, 100) -- Красный
    },
    ["VasilekVasilek81037"] = {
        Color = Color3.fromRGB(100, 100, 255) -- Синий
    }
}

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

local MainWindow = Instance.new("Frame")
MainWindow.Name = "TeleportWindow"
MainWindow.Parent = ScreenGui
MainWindow.Size = UDim2.new(0, 200, 0, 150)
MainWindow.Position = UDim2.new(0.8, 0, 0.5, -75)
MainWindow.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
MainWindow.Active = true
MainWindow.Draggable = true

-- Заголовок
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = MainWindow
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "TELEPORT TO PLAYERS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- Кнопки для каждого игрока
local buttonPositionY = 35
for playerName, settings in pairs(TARGET_PLAYERS) do
    local TeleportBtn = Instance.new("TextButton")
    TeleportBtn.Name = playerName.."_Btn"
    TeleportBtn.Parent = MainWindow
    TeleportBtn.Size = UDim2.new(0.9, 0, 0, 30)
    TeleportBtn.Position = UDim2.new(0.05, 0, 0, buttonPositionY)
    TeleportBtn.Text = "TP to "..playerName
    TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportBtn.BackgroundColor3 = settings.Color
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.3, 0)
    corner.Parent = TeleportBtn
    
    TeleportBtn.MouseButton1Click:Connect(function()
        teleportToPlayer(playerName)
    end)
    
    buttonPositionY = buttonPositionY + 35
end

-- Функция телепортации
function teleportToPlayer(targetName)
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player.Name == targetName and player.Character then
            local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
            local myHRP = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            
            if targetHRP and myHRP then
                -- Эффект телепорта
                local effect = Instance.new("Part")
                effect.Size = Vector3.new(1, 1, 1)
                effect.CFrame = targetHRP.CFrame
                effect.Anchored = true
                effect.CanCollide = false
                effect.Transparency = 1
                local particle = Instance.new("ParticleEmitter", effect)
                particle.Texture = "rbxassetid://242487987"
                game:GetService("Debris"):AddItem(effect, 1)
                
                -- Телепорт
                myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
                print("Телепортирован к игроку "..targetName)
                return
            end
        end
    end
    print("Игрок "..targetName.." не найден!")
end

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Parent = MainWindow
CloseBtn.Size = UDim2.new(0.3, 0, 0, 25)
CloseBtn.Position = UDim2.new(0.35, 0, 0, buttonPositionY)
CloseBtn.Text = "Закрыть"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 120)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

print("Teleport GUI loaded! Target players: "..table.concat(table.keys(TARGET_PLAYERS), ", "))
