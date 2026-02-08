-- Blox Fruits Visual Cleanup + Remove Accessories 2026
-- 95% xóa effects skill → 5% xám | Đất + biển xám | Xóa phụ kiện nhân vật | No lag
-- Paste vào Delta → Execute

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local GRAY_COLOR = Color3.fromRGB(85, 85, 85)          -- Xám cho đất/biển
local EFFECT_GRAY = Color3.fromRGB(135, 135, 135)     -- Xám nhạt cho effects còn sót

-- Danh sách class effect cần xử lý
local effectClasses = {
    "ParticleEmitter", "Trail", "Beam", "Fire", "Smoke", "Sparkles",
    "Explosion", "PointLight", "SpotLight", "SurfaceLight", "BloomEffect",
    "BlurEffect", "ColorCorrectionEffect", "DepthOfFieldEffect", "SunRaysEffect"
}

-- Xử lý effect mới (event-driven, ít lag nhất)
local function handleEffect(obj)
    task.spawn(function()
        task.wait(0.02 + math.random(1,6)/100)  -- delay nhỏ random tránh FPS drop
        
        if not obj or not obj.Parent then return end
        
        if table.find(effectClasses, obj.ClassName) then
            local rand = math.random(1, 100)
            if rand <= 5 then
                -- Giữ 5% nhưng làm xám + giảm hiệu suất
                pcall(function()
                    if obj:IsA("ParticleEmitter") then
                        obj.Color = ColorSequence.new(EFFECT_GRAY)
                        obj.LightEmission = 0
                        obj.Brightness = 0
                        obj.Rate = math.max(1, obj.Rate * 0.25)
                        obj.Lifetime = NumberRange.new(0.3, 1)
                        obj.Speed = NumberRange.new(1, 5)
                    elseif obj:IsA("Trail") or obj:IsA("Beam") then
                        obj.Color = ColorSequence.new(EFFECT_GRAY)
                        obj.Transparency = NumberSequence.new(0.5, 0.9)
                        obj.WidthScale = NumberSequence.new(0.1, 0.2)
                    elseif obj:IsA("BaseLight") then
                        obj.Color = EFFECT_GRAY
                        obj.Brightness = 0.05
                        obj.Range = obj.Range * 0.4
                    elseif obj:IsA("Explosion") then
                        obj.BlastRadius = 0
                        obj.BlastPressure = 0
                    end
                end)
            else
                -- Xóa 95%
                pcall(function() obj:Destroy() end)
            end
        end
    end)
end

-- Đăng ký event cho effect mới
Workspace.DescendantAdded:Connect(function(child)
    if table.find(effectClasses, child.ClassName) then
        handleEffect(child)
    end
end)

-- Cleanup effects cũ (chạy 1 lần sau khi load)
task.delay(2, function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if table.find(effectClasses, obj.ClassName) then
            pcall(function() obj:Destroy() end)
        end
    end
end)

-- Xử lý biển (Sea) → xám + cố gắng giảm sóng
task.spawn(function()
    task.wait(3)
    local sea = Workspace:FindFirstChild("Sea", true)
    if sea and sea:IsA("BasePart") then
        sea.Color = GRAY_COLOR
        sea.Material = Enum.Material.SmoothPlastic
        sea.Transparency = 0.1
        sea.Reflectance = 0
        sea.CastShadow = false
        
        -- Tắt particle/wave nếu có
        for _, child in ipairs(sea:GetDescendants()) do
            if child:IsA("ParticleEmitter") or child.Name:lower():find("wave") then
                child.Enabled = false
            end
        end
        
        -- Lock color
        sea:GetPropertyChangedSignal("Color"):Connect(function()
            sea.Color = GRAY_COLOR
        end)
    end
    
    -- Thử với Terrain water (nếu game dùng)
    pcall(function()
        local terrain = Workspace.Terrain
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 0.15
        terrain.WaterColor = GRAY_COLOR
    end)
end)

-- Làm xám mặt đất/island ground
task.spawn(function()
    task.wait(3.5)
    local groundMaterials = {
        Enum.Material.Grass, Enum.Material.Sand, Enum.Material.Mud, Enum.Material.Ground,
        Enum.Material.Rock, Enum.Material.Basalt, Enum.Material.Concrete, Enum.Material.Asphalt,
        Enum.Material.Pavement, Enum.Material.Slate
    }
    
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") 
            and part.Anchored 
            and part.Size.Y <= 15 
            and part.Transparency < 0.9
            and not part.Parent:FindFirstChild("Humanoid")
            and not part:FindFirstAncestorWhichIsA("Accessory")
            and table.find(groundMaterials, part.Material) then
            
            part.Color = GRAY_COLOR
            part.Material = Enum.Material.SmoothPlastic
            part.Reflectance = 0
            part.CastShadow = false
        end
    end
end)

-- Xóa toàn bộ accessories trên nhân vật của bạn (hats, back, face, neck, shoulder...)
local function removeMyAccessories()
    if not player.Character then return end
    local char = player.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        humanoid:RemoveAccessories()  -- Roblox built-in, xóa hết accessories
    end
    
    -- Cleanup thêm nếu có sót (hiếm)
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Accessory") then
            item:Destroy()
        end
    end
end

-- Chạy khi character load/spawn lại
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    removeMyAccessories()
end)

-- Chạy lần đầu nếu character đã load
if player.Character then
    task.wait(1)
    removeMyAccessories()
end

-- FPS boost nhẹ (tắt shadow/fog nặng)
Lighting.GlobalShadows = false
Lighting.FogEnd = 100000
Lighting.Brightness = 1.2

if setfpscap then
    setfpscap(120)  -- Nếu Delta hỗ trợ
end

print("Cleanup loaded: 95% effects xóa + 5% xám | Đất & biển xám | Accessories xóa | No lag mode")
