-- BLOX FRUITS FIXLAG + FIX SWORD Z SPIN (SEA 2 SAFE)

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- 1. FIX LAG LIGHTING (KHÔNG ĐỘNG MẶT TRỜI)
--------------------------------------------------
pcall(function()
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.FogEnd = 1e9
    Lighting.Ambient = Color3.fromRGB(150,150,150)
    Lighting.OutdoorAmbient = Color3.fromRGB(150,150,150)

    for _,v in pairs(Lighting:GetChildren()) do
        if v:IsA("BloomEffect")
        or v:IsA("SunRaysEffect")
        or v:IsA("BlurEffect")
        or v:IsA("ColorCorrectionEffect") then
            v.Enabled = false
        end
    end
end)

--------------------------------------------------
-- 2. BIỂN MÀU XÁM (KHÔNG XOÁ TERRAIN)
--------------------------------------------------
pcall(function()
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterColor = Color3.fromRGB(120,120,120)
        terrain.WaterTransparency = 0.35
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
    end
end)

--------------------------------------------------
-- 3. XOÁ CÂY / NHÀ / PHỤ KIỆN (KHÔNG XOÁ ĐẤT SEA 2)
--------------------------------------------------
for _,v in pairs(workspace:GetDescendants()) do
    if v:IsA("BasePart") and not v:IsDescendantOf(workspace:FindFirstChildOfClass("Terrain") or Instance.new("Folder")) then
        local n = v.Name:lower()

        if (n:find("tree") or n:find("leaf") or n:find("bush")
        or n:find("house") or n:find("building")
        or n:find("decor") or n:find("prop"))
        and v.Size.Magnitude < 300 then -- tránh xoá đảo/đất lớn
            pcall(function() v:Destroy() end)
        end
    end
end

--------------------------------------------------
-- 4. XOÁ HIỆU ỨNG SKILL (DRAGON + SKULL GUITAR MẠNH)
--------------------------------------------------
task.spawn(function()
    while task.wait(2) do
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter")
            or v:IsA("Trail")
            or v:IsA("Beam")
            or v:IsA("Explosion") then
                v.Enabled = false
            end
        end
    end
end)

--------------------------------------------------
-- 5. NPC MÀU XÁM
--------------------------------------------------
for _,m in pairs(workspace:GetChildren()) do
    if m:FindFirstChildOfClass("Humanoid")
    and not Players:GetPlayerFromCharacter(m) then
        for _,p in pairs(m:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Color = Color3.fromRGB(150,150,150)
                p.Material = Enum.Material.SmoothPlastic
            end
        end
    end
end

--------------------------------------------------
-- 6. FIX LỖI XOAY SAU KHI DÙNG CHIÊU Z CỦA KIẾM (QUAN TRỌNG)
--------------------------------------------------
local function FixSwordSpin()
    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- xoá toàn bộ lực xoay
    for _,v in pairs(hrp:GetChildren()) do
        if v:IsA("BodyGyro")
        or v:IsA("BodyAngularVelocity")
        or v:IsA("AngularVelocity") then
            v:Destroy()
        end
    end

    hrp.AssemblyAngularVelocity = Vector3.zero
end

-- fix liên tục sau khi dùng skill
task.spawn(function()
    while task.wait(0.3) do
        FixSwordSpin()
    end
end)

-- fix thêm khi cầm kiếm
LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(function(tool)
        if tool:IsA("Tool") then
            task.wait(0.1)
            FixSwordSpin()
        end
    end)
end)

--------------------------------------------------
-- 7. FIX LỖI KHÔNG HIỆN VẬT PHẨM TRONG KHO ĐỒ
--------------------------------------------------
pcall(function()
    local backpack = LocalPlayer:WaitForChild("Backpack")
    for _,tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            tool.Parent = LocalPlayer.Character
            task.wait()
            tool.Parent = backpack
        end
    end
end)

print("✅ FIXLAG + FIX XOAY KIẾM Z (SEA 2 SAFE) LOADED")
