-- BLOX FRUITS FIX LAG - FINAL STABLE
-- FIX SWORD SPIN BUG
-- FIX SEA 2 GROUND BUG

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace.Terrain
local RunService = game:GetService("RunService")

--------------------------------------------------
-- LIGHTING (GIỮ TRỜI / MẶT TRỜI)
--------------------------------------------------
Lighting.GlobalShadows = false
Lighting.FogEnd = 1e10

for _,v in ipairs(Lighting:GetChildren()) do
    if v:IsA("BloomEffect")
    or v:IsA("SunRaysEffect")
    or v:IsA("BlurEffect")
    or v:IsA("ColorCorrectionEffect") then
        v:Destroy()
    end
end

--------------------------------------------------
-- SEA (XÁM)
--------------------------------------------------
Terrain.WaterColor = Color3.fromRGB(150,150,150)
Terrain.WaterTransparency = 0
Terrain.WaterReflectance = 0

--------------------------------------------------
-- CHECK FUNCTIONS
--------------------------------------------------
local function IsCharacter(obj)
    local m = obj:FindFirstAncestorOfClass("Model")
    return m and m:FindFirstChildOfClass("Humanoid")
end

local function IsNPC(obj)
    local m = obj:FindFirstAncestorOfClass("Model")
    return m and m:FindFirstChildOfClass("Humanoid")
       and not Players:GetPlayerFromCharacter(m)
end

local function IsGround(part)
    -- GIỮ TẤT CẢ TERRAIN
    if part:IsDescendantOf(Terrain) then
        return true
    end
    -- GIỮ PART NỀN THẬT (SEA 2)
    if part:IsA("BasePart") and part.Anchored and part.CanCollide then
        return true
    end
    return false
end

--------------------------------------------------
-- FIX SWORD SPIN (CỐT LÕI)
--------------------------------------------------
local function FixSwordSpin(v)
    if v:IsA("AlignOrientation") or v:IsA("BodyGyro") then
        pcall(function()
            v.Enabled = false
            v.MaxTorque = Vector3.zero
            v.Responsiveness = 0
        end)
    end

    if v:IsA("AngularVelocity") or v:IsA("BodyAngularVelocity") then
        pcall(function()
            v.AngularVelocity = Vector3.zero
            v.MaxTorque = Vector3.zero
        end)
    end
end

--------------------------------------------------
-- CORE FIX
--------------------------------------------------
local function Fix(v)
    -- KHÔNG ĐỤNG PLAYER
    if IsCharacter(v) then
        FixSwordSpin(v)
        return
    end

    -- NPC MÀU XÁM
    if IsNPC(v) and v:IsA("BasePart") then
        v.Material = Enum.Material.SmoothPlastic
        v.Color = Color3.fromRGB(150,150,150)
        v.CastShadow = false
        return
    end

    -- GIỮ NỀN (SEA 1 + SEA 2)
    if v:IsA("BasePart") and IsGround(v) then
        v.Material = Enum.Material.SmoothPlastic
        v.Color = Color3.fromRGB(150,150,150)
        v.CastShadow = false
        return
    end

    -- CÂY / NHÀ / DECOR
    if v:IsA("BasePart") then
        v.Transparency = 1
        v.CanCollide = false
        v.CastShadow = false
    end

    -- XOÁ HIỆU ỨNG SKILL
    if v:IsA("ParticleEmitter")
    or v:IsA("Beam")
    or v:IsA("Explosion")
    or v:IsA("Fire")
    or v:IsA("Smoke")
    or v:IsA("Sparkles")
    or v:IsA("Highlight")
    or v:IsA("PointLight")
    or v:IsA("SurfaceLight")
    or v:IsA("SpotLight")
    or v:IsA("Trail") then
        pcall(function()
            v.Enabled = false
            v:Destroy()
        end)
    end

    -- FIX XOAY LIÊN TỤC
    FixSwordSpin(v)
end

--------------------------------------------------
-- APPLY BAN ĐẦU
--------------------------------------------------
for _,v in ipairs(workspace:GetDescendants()) do
    Fix(v)
end

--------------------------------------------------
-- CHẶN OBJECT / SKILL MỚI
--------------------------------------------------
workspace.DescendantAdded:Connect(function(v)
    task.wait()
    Fix(v)
end)

settings().Rendering.QualityLevel = 1

print("✅ FIX LAG OK | SWORD BUG FIXED | SEA 2 SAFE")--------------------------------------------------
-- FIX XOAY CHIÊU Z KIẾM (DELTA – CỐT LÕI)
--------------------------------------------------
local LocalPlayer = Players.LocalPlayer

local function HardStopSpin()
    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    -- 1. DỪNG TOÀN BỘ LỰC XOAY
    for _,v in ipairs(hrp:GetChildren()) do
        if v:IsA("BodyGyro")
        or v:IsA("BodyAngularVelocity")
        or v:IsA("AngularVelocity")
        or v:IsA("AlignOrientation") then
            pcall(function() v:Destroy() end)
        end
    end

    -- 2. RESET XOAY GỐC
    hrp.AssemblyAngularVelocity = Vector3.zero
    hrp.RotVelocity = Vector3.zero

    -- 3. ÉP HUMANOID TRỞ LẠI TRẠNG THÁI BÌNH THƯỜNG
    hum:ChangeState(Enum.HumanoidStateType.Running)
end

-- 🔒 FIX KHI DÙNG TOOL (KIẾM)
LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(obj)
        if obj:IsA("Tool") then
            -- Sau khi nhấn Z thường 0.3–1s mới bug
            task.delay(0.35, HardStopSpin)
            task.delay(0.8, HardStopSpin)
            task.delay(1.4, HardStopSpin)
        end
    end)
end)

-- 🔒 FIX KHI TRẠNG THÁI NHÂN VẬT BỊ KẸT XOAY
task.spawn(function()
    while task.wait(1.2) do
        pcall(HardStopSpin)
    end
end)
