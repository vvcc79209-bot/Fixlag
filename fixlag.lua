-- BLOX FRUITS FIXLAG + FIX SPIN Z (DELTA SAFE)

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

--------------------------------------------------
-- 1. FIX LAG LIGHTING (KHÔNG ĐỘNG SUN)
--------------------------------------------------
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 1
    Lighting.Ambient = Color3.fromRGB(140,140,140)
    Lighting.OutdoorAmbient = Color3.fromRGB(140,140,140)
end)

--------------------------------------------------
-- 2. BIỂN MÀU XÁM (AN TOÀN)
--------------------------------------------------
pcall(function()
    local t = workspace:FindFirstChildOfClass("Terrain")
    if t then
        t.WaterColor = Color3.fromRGB(120,120,120)
        t.WaterWaveSize = 0
        t.WaterWaveSpeed = 0
    end
end)

--------------------------------------------------
-- 3. XOÁ CÂY / NHÀ / DECOR (KHÔNG ĐỤNG ĐẤT)
--------------------------------------------------
for _,m in pairs(workspace:GetChildren()) do
    if m:IsA("Model") then
        local n = m.Name:lower()
        if n:find("tree") or n:find("house") or n:find("decor") then
            pcall(function() m:Destroy() end)
        end
    end
end

--------------------------------------------------
-- 4. GIẢM EFFECT SKILL (DELTA SAFE)
--------------------------------------------------
for _,v in pairs(workspace:GetDescendants()) do
    if v:IsA("ParticleEmitter")
    or v:IsA("Trail")
    or v:IsA("Beam") then
        v.Enabled = false
    end
end

--------------------------------------------------
-- 5. NPC MÀU XÁM
--------------------------------------------------
for _,npc in pairs(workspace:GetChildren()) do
    if npc:FindFirstChildOfClass("Humanoid")
    and not Players:GetPlayerFromCharacter(npc) then
        for _,p in pairs(npc:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Color = Color3.fromRGB(150,150,150)
                p.Material = Enum.Material.Plastic
            end
        end
    end
end

--------------------------------------------------
-- 6. FIX XOAY KIẾM Z (DELTA – GIẢM MẠNH)
--------------------------------------------------
local function FixSpinOnce()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _,v in pairs(hrp:GetChildren()) do
        if v:IsA("BodyGyro")
        or v:IsA("BodyAngularVelocity") then
            v:Destroy()
        end
    end
end

-- chỉ chạy khi cầm tool (an toàn cho Delta)
player.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(obj)
        if obj:IsA("Tool") then
            task.delay(0.3, FixSpinOnce)
            task.delay(1, FixSpinOnce)
        end
    end)
end)

print("✅ DELTA FIXLAG + FIX SPIN Z LOADED")
