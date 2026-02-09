--// CONFIG
local KEEP_SKY = true
local GRAY = Color3.fromRGB(120,120,120)

--// EFFECT LIST (xoá mạnh)
local Effects = {
    ParticleEmitter=true,
    Trail=true,
    Beam=true,
    Fire=true,
    Smoke=true,
    Sparkles=true,
    Explosion=true,
    Highlight=true,
    PointLight=true,
    SpotLight=true,
    SurfaceLight=true,
    Decal=true,
    Texture=true,
    Sound=true
}

--// POST EFFECT (flash trắng, blur, bloom…)
for _,v in pairs(game:GetService("Lighting"):GetChildren()) do
    if v:IsA("BloomEffect")
    or v:IsA("BlurEffect")
    or v:IsA("ColorCorrectionEffect")
    or v:IsA("SunRaysEffect")
    or v:IsA("DepthOfFieldEffect") then
        v:Destroy()
    end
end

--// REMOVE FX
local function Process(obj)

    -- giữ mặt trời
    if KEEP_SKY and obj:IsA("Sky") then
        return
    end

    -- xoá hiệu ứng
    if Effects[obj.ClassName] then
        pcall(function()
            obj:Destroy()
        end)
        return
    end

    -- xoá mesh effect skill
    if obj:IsA("SpecialMesh") or obj:IsA("BlockMesh") then
        pcall(function()
            obj:Destroy()
        end)
    end

    -- đổi màu xám
    if obj:IsA("BasePart") then
        obj.Color = GRAY
        obj.Material = Enum.Material.SmoothPlastic
    end
end

--// FIRST CLEAN
for _,v in pairs(game:GetDescendants()) do
    Process(v)
end

--// AUTO CLEAN FX MỚI
game.DescendantAdded:Connect(function(v)
    task.wait()
    Process(v)
end)
