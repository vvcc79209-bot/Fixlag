-- Script Auto Farm Blox Fruits
-- Tự động từ Level 1 đến Level Max
-- Yêu cầu: Executor (Synapse, Krnl, Fluxus...)

-- Cấu hình
local AutoFarm = true
local MaxLevel = 2400 -- Đổi theo level max hiện tại
local AttackDelay = 1.5 -- Delay giữa các đòn tấn công

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Kết nối sự kiện respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
end)

-- Tìm quái gần nhất
function FindNearestEnemy()
    local nearest = nil
    local nearestDistance = math.huge
    
    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            local distance = (Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearest = enemy
            end
        end
    end
    
    -- Kiểm tra NPC trong các zone
    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
            local distance = (Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearest = npc
            end
        end
    end
    
    return nearest
end

-- Teleport đến quái
function TeleportTo(enemy)
    if enemy and enemy:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
    end
end

-- Tự động tấn công
function AutoAttack()
    spawn(function()
        while AutoFarm do
            wait()
            
            local enemy = FindNearestEnemy()
            if enemy then
                -- Teleport đến quái
                TeleportTo(enemy)
                
                -- Mô phỏng nhấn phím tấn công (Z, X, C, V)
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
                wait(AttackDelay)
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "X", false, game)
                wait(AttackDelay)
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "C", false, game)
                wait(AttackDelay)
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "V", false, game)
                wait(AttackDelay)
            else
                -- Di chuyển tìm quái
                Character.Humanoid.WalkSpeed = 50
                Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -20)
                wait(1)
            end
        end
    end)
end

-- Tự động nâng cấp stat (Melee, Defense, Sword, Gun, Fruit)
function AutoStat()
    spawn(function()
        while AutoFarm do
            wait(10) -- Kiểm tra mỗi 10 giây
            
            local stats = {
                "Melee",
                "Defense",
                "Sword",
                "Gun",
                "Devil Fruit"
            }
            
            for _, stat in pairs(stats) do
                -- Ưu tiên Melee và Defense khi level thấp
                local playerLevel = LocalPlayer.Data.Level.Value
                if playerLevel < 100 then
                    if stat == "Melee" or stat == "Defense" then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", stat, 1)
                    end
                else
                    -- Phân phối stat theo chiến lược
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", stat, 1)
                end
            end
        end
    end)
end

-- Tự động mua vật phẩm cần thiết
function AutoBuy()
    spawn(function()
        while AutoFarm do
            wait(30) -- Kiểm tra mỗi 30 giây
            
            -- Tự động mua thanh máu
            if LocalPlayer.Data.Beli.Value >= 500 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Combat")
            end
        end
    end)
end

-- Kiểm tra level và chuyển đảo
function CheckLevelAndTeleport()
    spawn(function()
        while AutoFarm do
            wait(60) -- Kiểm tra mỗi 1 phút
            
            local playerLevel = LocalPlayer.Data.Level.Value
            local currentIsland = nil
            
            -- Xác định đảo phù hợp với level
            if playerLevel >= 700 then
                currentIsland = "Ice Admiral"
            elseif playerLevel >= 450 then
                currentIsland = "Fishman Captain"
            elseif playerLevel >= 250 then
                currentIsland = "Sky Bandit"
            elseif playerLevel >= 120 then
                currentIsland = "Military Soldier"
            elseif playerLevel >= 50 then
                currentIsland = "Bandit"
            else
                currentIsland = "Starter Island"
            end
            
            -- Teleport đến đảo
            TeleportToIsland(currentIsland)
        end
    end)
end

-- Teleport đến đảo
function TeleportToIsland(islandName)
    -- Cần cập nhật tọa độ cho từng đảo
    local islandPositions = {
        ["Starter Island"] = CFrame.new(100, 50, 100),
        ["Bandit"] = CFrame.new(1000, 50, 1000),
        -- Thêm tọa độ các đảo khác
    }
    
    if islandPositions[islandName] then
        Character.HumanoidRootPart.CFrame = islandPositions[islandName]
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
local Window = Library.CreateLib("Blox Fruits Auto Farm", "Sentinel")

-- Tab chính
local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Auto Farm Settings")

MainSection:NewToggle("Bật/Tắt Auto Farm", "Tự động farm level", function(state)
    AutoFarm = state
    if state then
        AutoAttack()
        AutoStat()
        AutoBuy()
        CheckLevelAndTeleport()
    end
end)

MainSection:NewSlider("Tốc độ tấn công", "Delay giữa các đòn", 5, 0.5, function(value)
    AttackDelay = value
end)

MainSection:NewDropdown("Ưu tiên stat", "Chọn stat chính", {"Melee", "Defense", "Sword", "Gun", "Fruit"}, function(option)
    -- Logic phân phối stat ưu tiên
end)

-- Tab Teleport
local TeleportTab = Window:NewTab("Teleport")
local TeleportSection = TeleportTab:NewSection("Đảo")

TeleportSection:NewButton("Đảo Starter", "Teleport đến đảo bắt đầu", function()
    TeleportToIsland("Starter Island")
end)

TeleportSection:NewButton("Đảo Jungle", "Teleport đến Jungle", function()
    TeleportToIsland("Jungle")
end)

-- Thông báo
print("Script Blox Fruits Auto Farm đã được khởi động!")
print("Tự động farm từ level 1 đến " .. MaxLevel)
print("Nhấn F9 để xem giao diện điều khiển")
