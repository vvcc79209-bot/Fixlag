-- BLOX FRUITS | FULL RAINBOW EFFECTS (LOCAL)
-- Fruit | Melee | Sword | Gun | Skin
-- Cosmetic only

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local SPEED = 1.2 -- tốc độ đổi màu (0.5 = chậm | 2+ = nhanh)

local function ApplyRainbow(obj, hue)
    if obj:IsA("BasePart") then
        obj.Color = Color3.fromHSV(hue, 1, 1)
        obj.Material = Enum.Material.Neon
        obj.Reflectance = 0
    elseif obj:IsA("ParticleEmitter") then
        obj.Color = ColorSequence.new(Color3.fromHSV(hue,1,1))
    elseif obj:IsA("Trail") then
        obj.Color = ColorSequence.new(Color3.fromHSV(hue,1,1))
    elseif obj:IsA("Beam") then
        obj.Color = ColorSequence.new(Color3.fromHSV(hue,1,1))
    end
end

RunService.RenderStepped:Connect(function()
    local hue = (tick() * SPEED) % 1

    -- Nhân vật + skin + biến hình
    if player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            ApplyRainbow(v, hue)
        end
    end

    -- Hiệu ứng skill trong Workspace
    for _,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart")
        or v:IsA("ParticleEmitter")
        or v:IsA("Trail")
        or v:IsA("Beam") then
            ApplyRainbow(v, hue)
        end
    end
end)
