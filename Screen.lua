-- Script Auto Farm Blox Fruits - Bay lên đầu quái & Tấn công xa
-- Yêu cầu: Executor hỗ trợ Fly và Click Detector

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Cấu hình
local AutoFarm = false
local MaxDistance = 100 -- Khoảng cách tấn công tối đa
local FlyingHeight = 15 -- Độ cao bay so với quái
local AttackDelay = 2 -- Delay giữa các đòn tấn công
local UseRangedAttacks = true -- Sử dụng tấn công tầm xa

-- Kích hoạt bay (NoClip)
function EnableFly()
    local Noclip = Instance.new("BodyVelocity")
    Noclip.Name = "FlyNoclip"
    Noclip.Parent = HumanoidRootPart
    Noclip.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    Noclip.Velocity = Vector3.new(0, 0, 0)
    
    Character.Humanoid:ChangeState(11) -- StateType.Jumping
    return Noclip
end

-- Vô hiệu hóa bay
function DisableFly()
    if HumanoidRootPart:FindFirstChild("FlyNoclip") then
        HumanoidRootPart.FlyNoclip:Destroy()
    end
    Character.Humanoid:ChangeState(15) -- StateType.Freefall
end

-- Bay đến vị trí
function FlyToPosition(targetCF)
    if not HumanoidRootPart:FindFirstChild("FlyNoclip") then
        EnableFly()
    end
    
    local Fly = HumanoidRootPart.FlyNoclip
    local Distance = (HumanoidRootPart.Position - targetCF.Position).Magnitude
    
    while Distance > 10 and AutoFarm do
        wait()
        Fly.Velocity = (targetCF.Position - HumanoidRootPart.Position).Unit * 100
        Distance = (HumanoidRootPart.Position - targetCF.Position).Magnitude
    end
    
    -- Giữ vị trí trên đầu quái
    Fly.Velocity = Vector3.new(0, 0, 0)
end

-- Bay lên trên đầu quái
function FlyAboveEnemy(enemy)
    if enemy and enemy:FindFirstChild("HumanoidRootPart") then
        local targetPosition = enemy.HumanoidRootPart.Position + Vector3.new(0, FlyingHeight, 0)
        local targetCF = CFrame.new(targetPosition)
        FlyToPosition(targetCF)
        
        -- Hướng mặt về phía quái
        HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, enemy.HumanoidRootPart.Position)
    end
end

-- Tìm quái gần nhất trong phạm vi
function FindNearestEnemy()
    local nearest = nil
    local nearestDistance = math.huge
    
    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            if enemy:FindFirstChild("HumanoidRootPart") then
                local distance = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                if distance < nearestDistance and distance < MaxDistance then
                    nearestDistance = distance
                    nearest = enemy
                end
            end
        end
    end
    
    -- Kiểm tra Boss
    for _, boss in pairs(workspace:GetChildren()) do
        if string.find(boss.Name, "Boss") or boss:FindFirstChild("Boss") then
            if boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                if boss:FindFirstChild("HumanoidRootPart") then
                    local distance = (HumanoidRootPart.Position - boss.HumanoidRootPart.Position).Magnitude
                    if distance < nearestDistance and distance < MaxDistance then
                        nearestDistance = distance
                        nearest = boss
                    end
                end
            end
        end
    end
    
    return nearest, nearestDistance
end

-- Tấn công từ xa với skill
function RangedAttack(enemy)
    if not enemy then return end
    
    -- Sử dụng các kỹ năng tầm xa
    local skills = {"Z", "X", "C", "V", "F"}
    
    for _, skill in pairs(skills) do
        if AutoFarm then
            -- Nhấn phím skill
            game:GetService("VirtualInputManager"):SendKeyEvent(true, skill, false, game)
            wait(0.2)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, skill, false, game)
            
            -- Nhấn chuột để kích hoạt skill (nếu cần)
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            
            wait(AttackDelay)
        end
    end
end

-- Sử dụng Gun/Canon từ xa
function UseGunAttack(enemy)
    if not enemy then return end
    
    -- Chuyển sang vũ khí Gun (nếu có)
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("LoadItem", "Gun")
    
    -- Nhắm bắn
    local mouse = game:GetService("Players").LocalPlayer:GetMouse()
    mouse.TargetFilter = enemy
    mouse.Hit = enemy.HumanoidRootPart.CFrame
    
    -- Bắn
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
    wait(0.1)
    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
end

-- Sử dụng Devil Fruit Skill từ xa
function UseFruitSkill(enemy)
    if not enemy then return end
    
    -- Sử dụng các skill của Devil Fruit (E, R, T, Y)
    local fruitSkills = {"E", "R", "T", "Y"}
    
    for _, skill in pairs(fruitSkills) do
        if AutoFarm then
            game:GetService("VirtualInputManager"):SendKeyEvent(true, skill, false, game)
            wait(0.3)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, skill, false, game)
            wait(AttackDelay)
        end
    end
end

-- Auto Aim (tự động nhắm)
function AutoAim(enemy)
    if not enemy or not enemy:FindFirstChild("HumanoidRootPart") then return end
    
    -- Tính toán hướng
    local direction = (enemy.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
    local lookAt = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + direction)
    HumanoidRootPart.CFrame = lookAt
    
    -- Giữ khoảng cách an toàn
    local distance = (HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
    if distance < 20 then
        local backward = HumanoidRootPart.Position - direction * 10
        HumanoidRootPart.CFrame = CFrame.new(backward, enemy.HumanoidRootPart.Position)
    end
end

-- Chính auto farm
function StartAutoFarm()
    while AutoFarm do
        wait()
        
        local enemy, distance = FindNearestEnemy()
        
        if enemy then
            -- Hiển thị thông tin quái
            game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(
                "🎯 Đang farm: " .. enemy.Name .. " | Khoảng cách: " .. math.floor(distance)
            )
            
            -- Bay lên trên đầu quái
            FlyAboveEnemy(enemy)
            
            -- Auto Aim
            AutoAim(enemy)
            
            if UseRangedAttacks then
                -- Tấn công từ xa
                RangedAttack(enemy)
                UseFruitSkill(enemy)
                UseGunAttack(enemy)
            else
                -- Tấn công cận chiến
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                wait(0.2)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "Z", false, game)
            end
            
        else
            -- Di chuyển tìm quái
            if HumanoidRootPart:FindFirstChild("FlyNoclip") then
                HumanoidRootPart.FlyNoclip.Velocity = Vector3.new(0, 0, 50)
                wait(1)
                HumanoidRootPart.FlyNoclip.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end

-- Chống AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Giao diện điều khiển
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Blox Fruits - Bay & Đánh Xa", "DarkTheme")

-- Tab Auto Farm
local MainTab = Window:NewTab("Auto Farm")
local MainSection = MainTab:NewSection("Cài Đặt Chính")

MainSection:NewToggle("Bật/Tắt Auto Farm", "Bay lên đầu quái và đánh xa", function(state)
    AutoFarm = state
    if state then
        EnableFly()
        spawn(StartAutoFarm)
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Auto Farm",
            Text = "Đã bật Auto Farm - Bay & Đánh Xa",
            Duration = 5
        })
    else
        DisableFly()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Auto Farm",
            Text = "Đã tắt Auto Farm",
            Duration = 5
        })
    end
end)

MainSection:NewSlider("Độ cao bay", "Điều chỉnh độ cao", 50, 5, function(value)
    FlyingHeight = value
end)

MainSection:NewSlider("Khoảng cách tấn công", "Max distance", 200, 20, function(value)
    MaxDistance = value
end)

MainSection:NewSlider("Delay tấn công", "Thời gian giữa các đòn", 5, 0.5, function(value)
    AttackDelay = value
end)

-- Tab Kỹ Năng
local SkillsTab = Window:NewTab("Kỹ Năng")
local SkillsSection = SkillsTab:NewSection("Cài Đặt Kỹ Năng")

SkillsSection:NewToggle("Sử dụng tấn công xa", "Dùng skill tầm xa", function(state)
    UseRangedAttacks = state
end)

SkillsSection:NewDropdown("Loại tấn công", "Chọn loại tấn công", {"Skill", "Gun", "Fruit", "Kết hợp"}, function(option)
    -- Tùy chọn loại tấn công
end)

SkillsSection:NewKeybind("Hotkey bật/tắt", "Phím nhanh", Enum.KeyCode.F, function()
    AutoFarm = not AutoFarm
    if AutoFarm then
        EnableFly()
        spawn(StartAutoFarm)
    else
        DisableFly()
    end
end)

-- Tab Teleport
local TeleportTab = Window:NewTab("Teleport")
local TeleportSection = TeleportTab:NewSection("Di Chuyển Nhanh")

TeleportSection:NewButton("Bay đến Safe Zone", "Teleport an toàn", function()
    DisableFly()
    HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
end)

TeleportSection:NewButton("Tìm Boss gần nhất", "Bay đến Boss", function()
    local boss = nil
    for _, v in pairs(workspace:GetChildren()) do
        if string.find(v.Name, "Boss") and v:FindFirstChild("HumanoidRootPart") then
            boss = v
            break
        end
    end
    if boss then
        FlyAboveEnemy(boss)
    end
end)

-- Auto Click (nếu cần)
local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
local AutoClick = false

SkillsSection:NewToggle("Tự động click", "Auto click chuột", function(state)
    AutoClick = state
    while AutoClick do
        wait(0.1)
        game:GetService("VirtualUser"):ClickButton1(Vector2.new(Mouse.X, Mouse.Y))
    end
end)

-- Hiệu ứng visual khi bay
local Trail = Instance.new("Trail")
Trail.Parent = HumanoidRootPart
Trail.Color = ColorSequence.new(Color3.fromRGB(0, 200, 255))
Trail.Transparency = NumberSequence.new(0.5)
Trail.Lifetime = 0.5
Trail.Enabled = false

MainSection:NewToggle("Hiệu ứng bay", "Hiển thị đường bay", function(state)
    Trail.Enabled = state
end)

-- Thông báo khi bắt đầu
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Blox Fruits Auto Farm",
    Text = "Script đã sẵn sàng! Nhấn F9 để mở menu",
    Duration = 10
})

print("✅ Script Blox Fruits - Bay & Đánh Xa đã được load!")
print("📌 Tính năng:")
print("   ✈️ Bay lên đầu quái")
print("   🎯 Tấn công từ xa")
print("   🔫 Auto Aim")
print("   ⚡ Tự động dùng skill")
