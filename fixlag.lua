--// BLOX FRUITS LOW FX + GRAY WORLD (CLIENT SIDE)
--// tối ưu nhẹ, tránh loop nặng & xung đột

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

--// cấu hình
local KEEP_SKY = true
local GRAY_COLOR = Color3.fromRGB(120,120,120)

--// function chuyển part sang màu xám
local function makeGray(obj)
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.SmoothPlastic
        obj.Color = GRAY_COLOR
        obj.Reflectance = 0
    end
end

--// xoá phụ kiện nhân vật
local function removeAccessories(char)
    for _,v in ipairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            v:Destroy()
        end
    end
end

--// giảm hiệu ứng skill
local function reduceEffects(obj)
    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam") then
        obj.Enabled = false -- xoá 95%
    end
    
    if obj:IsA("PointLight")
    or obj:IsA("SpotLight") then
        obj.Color = GRAY_COLOR -- 5% còn lại xám
        obj.Brightness = 0.2
    end
end

--// xử lý map (đất + biển xám, giữ trời)
local function processWorld()
    for _,obj in ipairs(Workspace:GetDescendants()) do
        
        -- bỏ qua sky nếu cần
        if KEEP_SKY and obj:IsA("Sky") then
            continue
        end
        
        if obj.Name:lower():find("water")
        or obj.Name:lower():find("sea")
        or obj.Name:lower():find("ground")
        or obj.Name:lower():find("terrain") then
            makeGray(obj)
        end
        
        reduceEffects(obj)
    end
end

--// tối ưu lighting
local function optimizeLighting()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.Brightness = 1
    
    for _,v in ipairs(Lighting:GetChildren()) do
        if v:IsA("BlurEffect")
        or v:IsA("SunRaysEffect")
        or v:IsA("ColorCorrectionEffect")
        or v:IsA("BloomEffect") then
            v.Enabled = false
        end
    end
end

--// chạy chính
optimizeLighting()
processWorld()

--// nhân vật spawn
if LocalPlayer.Character then
    removeAccessories(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(2)
    removeAccessories(char)
end)

print("✅ Low FX Gray Mode Loaded - Optimized")
