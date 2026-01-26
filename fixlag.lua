--[[
    Blox Fruits Auto Farm Script
    Tự động farm từ level 1 đến level max
    Chức năng: Tự động farm, tự động hồi máu, thay đổi vũ khí, v.v.
--]]

-- Cấu hình
local Settings = {
    AutoFarm = true,
    AutoHealth = true,
    HealthPercent = 30, -- Tự động hồi máu khi dưới % này
    AutoNewWorld = true, -- Tự động đến New World khi đủ level
    AutoRedeemCodes = true, -- Tự động nhập code
    WebhookURL = "" -- Để trống nếu không dùng webhook
}

-- Khai báo biến
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Thư viện
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Blox Fruits Auto Farm", "Sentinel")

-- Tạo giao diện
local MainTab = Window:NewTab("Main")
local FarmingSection = MainTab:NewSection("Auto Farming")
local PlayerSection = MainTab:NewSection("Player Settings")
local TeleportSection = MainTab:NewSection("Teleports")
local MiscTab = Window:NewTab("Miscellaneous")

-- Auto Farm Toggle
FarmingSection:NewToggle("Auto Farm", "Tự động farm mob", function(state)
    Settings.AutoFarm = state
    if state then
        coroutine.wrap(function()
            while Settings.AutoFarm do
                AutoFarm()
                wait(0.1)
            end
        end)()
    end
end)

-- Auto Health Toggle
FarmingSection:NewToggle("Auto Health", "Tự động hồi máu", function(state)
    Settings.AutoHealth = state
    if state then
        coroutine.wrap(function()
            while Settings.AutoHealth do
                if (Humanoid.Health / Humanoid.MaxHealth) * 100 < Settings.HealthPercent then
                    UseHealthItem()
                end
                wait(1)
            end
        end)()
    end
end)

-- Health Percent Slider
FarmingSection:NewSlider("Health %", "Phần trăm máu để hồi", 100, 10, function(value)
    Settings.HealthPercent = value
end)

-- Player Section
PlayerSection:NewToggle("Walk on Water", "Đi trên nước", function(state)
    if state then
        EnableWaterWalk()
    else
        DisableWaterWalk()
    end
end)

PlayerSection:NewToggle("No Clip", "Xuyên qua vật thể", function(state)
    Settings.NoClip = state
    if state then
        NoClip()
    end
end)

-- Teleport Section
TeleportSection:NewButton("Teleport to Nearest Mob", "Dịch chuyển đến mob gần nhất", function()
    TeleportToNearestMob()
end)

TeleportSection:NewButton("Teleport to Safe Spot", "Dịch chuyển đến vị trí an toàn", function()
    TeleportToSafeSpot()
end)

-- Misc Section
MiscTab:NewButton("Redeem All Codes", "Nhập tất cả code có sẵn", function()
    RedeemCodes()
end)

MiscTab:NewButton("Anti AFK", "Chống AFK", function()
    AntiAFK()
end)

MiscTab:NewButton("Collect Chests", "Thu thập rương", function()
    CollectChests()
end)

-- Hàm Auto Farm chính
function AutoFarm()
    if not Settings.AutoFarm then return end
    
    -- Tìm mob gần nhất
    local target = FindNearestMob()
    if target then
        -- Dịch chuyển đến mob
        TeleportToTarget(target)
        
        -- Tấn công mob
        AttackTarget(target)
    else
        -- Nếu không có mob, di chuyển đến khu vực farm
        MoveToFarmArea()
    end
end

function FindNearestMob()
    local closest = nil
    local distance = math.huge
    
    for _, mob in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            local mobDistance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
            if mobDistance < distance then
                distance = mobDistance
                closest = mob
            end
        end
    end
    
    return closest
end

function TeleportToTarget(target)
    if not target then return end
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(HumanoidRootPart, tweenInfo, {CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)})
    tween:Play()
end

function AttackTarget(target)
    -- Kích hoạt kỹ năng tấn công
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "X", false, game)
    wait(0.1)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, "X", false, game)
    
    -- Sử dụng vũ khí
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
    wait(0.1)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, "Z", false, game)
end

function UseHealthItem()
    -- Mô phỏng nhấn phím hồi máu (giả sử là phím H)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "H", false, game)
    wait(0.1)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, "H", false, game)
end

function EnableWaterWalk()
    -- Code đi trên nước
    local waterWalkScript = Instance.new("Script", Player.PlayerScripts)
    waterWalkScript.Name = "WaterWalkScript"
    -- Thêm code đi trên nước tại đây
end

function NoClip()
    coroutine.wrap(function()
        while Settings.NoClip do
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            wait(0.1)
        end
    end)()
end

function RedeemCodes()
    -- Danh sách code (cần cập nhật)
    local codes = {
        "SUB2GAMERROBOT_EXP1",
        "SUB2NOOBMASTER123",
        "Sub2Daigrock",
        "Axiore",
        "TantaiGaming",
        -- Thêm code khác tại đây
    }
    
    for _, code in pairs(codes) do
        game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
        wait(1)
    end
end

function AntiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- Khởi tạo
Player.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

print("Blox Fruits Auto Farm Script đã được tải!")
print("Lưu ý: Đây chỉ là script mẫu. Bạn cần tự điều chỉnh cho phù hợp với game.")
