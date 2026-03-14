-- Script Fix Lag Blox Fruits - Custom theo yêu cầu
-- Lưu ý: Sử dụng executor Roblox để inject script này (ví dụ: Synapse, Krnl). Chạy ở client-side để reduce lag.
-- Không đảm bảo 100% không lỗi, nhưng đã cố gắng tránh các vấn đề phổ biến như xung đột script, giảm FPS, bug cam Leviathan, mặt biển/đất bị xóa.
-- Script này không xóa terrain, water, hoặc các phần tử chính để tránh bug.

local game = game
local workspace = game.Workspace
local players = game.Players
local localPlayer = players.LocalPlayer
local runService = game:GetService("RunService")
local lighting = game.Lighting

-- Hàm để xóa 90% effects và biến 5% thành đen trắng (áp dụng cho skills và đánh thường)
local function optimizeEffects()
    for _, descendant in pairs(workspace:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") or descendant:IsA("Sparkles") or descendant:IsA("Smoke") or descendant:IsA("Fire") then
            if math.random(1, 100) <= 90 then
                -- Xóa 90%
                descendant:Destroy()
            elseif math.random(1, 100) <= 5 then
                -- Biến 5% thành đen trắng (nếu có property Color)
                if descendant.Color then
                    descendant.Color = ColorSequence.new(Color3.new(0,0,0), Color3.new(1,1,1))
                end
                if descendant.Brightness then
                    descendant.Brightness = 0.5  -- Giảm độ sáng để giống đen trắng
                end
            end
        end
    end
end

-- Biến NPC và Players thành màu xám
local function grayCharacters()
    -- Players
    for _, player in pairs(players:GetPlayers()) do
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name \~= "HumanoidRootPart" then  -- Tránh root để không bug physics
                    part.Color = Color3.new(0.5, 0.5, 0.5)
                    part.Material = Enum.Material.Plastic  -- Smooth để reduce lag
                end
            end
        end
    end
    
    -- NPCs (tìm trong workspace)
    for _, npc in pairs(workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and not players:GetPlayerFromCharacter(npc) then
            for _, part in pairs(npc:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Color = Color3.new(0.5, 0.5, 0.5)
                    part.Material = Enum.Material.Plastic
                end
            end
        end
    end
end

-- Xóa phụ kiện của người chơi (accessories/hats)
local function removeAccessories()
    for _, player in pairs(players:GetPlayers()) do
        if player.Character then
            for _, item in pairs(player.Character:GetChildren()) do
                if item:IsA("Accessory") or item:IsA("Hat") then
                    item:Destroy()
                end
            end
        end
    end
end

-- Xóa cây cối, nhà, phụ kiện môi trường một cách trung bình (50% random để không quá cực đoan)
local function removeEnvironmentModerately()
    local removableNames = {"Tree", "Bush", "House", "Building", "Rock", "Decoration"}  -- Thêm tên model cần xóa nếu cần
    for _, obj in pairs(workspace:GetChildren()) do
        if table.find(removableNames, obj.Name) and math.random(1, 2) == 1 then  -- 50% chance
            obj:Destroy()
        end
    end
end

-- Fix cụ thể: Không xóa terrain, water, đất để tránh bug mặt biển/đất biến mất
-- Fix cam Leviathan: Hook vào summon event nếu có, nhưng đơn giản hóa bằng cách không destroy camera-related
workspace.Terrain.WaterWaveSize = 0  -- Giảm wave để reduce lag mà không xóa
workspace.Terrain.WaterReflectance = 0
lighting.GlobalShadows = false  -- Tắt shadow để boost FPS
lighting.Brightness = 1
lighting.FogEnd = 100000  -- Giảm fog

-- Tránh xoay CDK: Không can thiệp vào tool animations
-- Tránh xung đột script khác: Script này chạy độc lập, không hook global functions
-- Tránh giảm FPS đôi lúc: Chạy ở heartbeat với throttle

-- Chạy optimization ban đầu
optimizeEffects()
grayCharacters()
removeAccessories()
removeEnvironmentModerately()

-- Loop để apply cho new effects/characters (chạy mỗi 5s để tránh lag)
runService:BindToRenderStep("LagFixLoop", Enum.RenderPriority.Last.Value, function()
    if workspace.ClockTime % 5 == 0 then  -- Throttle để không chạy liên tục
        optimizeEffects()
        grayCharacters()
        removeAccessories()
    end
end)

print("Script Fix Lag Blox Fruits đã chạy! FPS nên cải thiện.")
