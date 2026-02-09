--=================================================
-- CONFIG
--=================================================
local Config = {
    RemoveParticles = true,        -- Xoá ParticleEmitter/Trail/Beam
    GrayScaleWorld = true,         -- Đổi màu các BasePart thành xám
    GrayScaleTerrain = true,       -- Đổi terrain sang xám
    EffectDisableRate = 0.95,      -- Tỷ lệ xoá hiệu ứng (0.0 → 1.0, 0.95 = 95%)
    PreserveSky = true             -- Giữ Sky/Mặt trời nguyên vẹn
}

--=================================================
-- MODULE
--=================================================
local Cleaner = {}

function Cleaner:IsEffect(obj)
    local effectTypes = {
        "ParticleEmitter",
        "Trail",
        "Beam",
        "Fire",
        "Smoke",
        "Sparkles"
    }
    for _, t in ipairs(effectTypes) do
        if obj:IsA(t) then
            return true
        end
    end
    return false
end

function Cleaner:DisableEffect(obj)
    pcall(function()
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            obj.Enabled = false
        else
            obj:Destroy()
        end
    end)
end

function Cleaner:GrayPart(obj)
    pcall(function()
        if obj:IsA("BasePart") then
            obj.Color = Color3.fromRGB(125,125,125)
            obj.Material = Enum.Material.SmoothPlastic
        end
    end)
end

function Cleaner:ProcessObj(obj)
    if Config.RemoveParticles and self:IsEffect(obj) then
        if math.random() < Config.EffectDisableRate then
            self:DisableEffect(obj)
        end
    end

    if Config.GrayScaleWorld then
        self:GrayPart(obj)
    end
end

function Cleaner:ProcessTerrain()
    pcall(function()
        local t = workspace.Terrain
        t:FillRegion(Region3.new(t.MaxExtents.Min, t.MaxExtents.Max), Enum.Material.Slate, Color3.fromRGB(120,120,120))
    end)
end

--=================================================
-- RUN
--=================================================

-- First pass apply to existing objects
for _, obj in ipairs(game:GetDescendants()) do
    Cleaner:ProcessObj(obj)
end

-- If terrain grayscale is on
if Config.GrayScaleTerrain then
    Cleaner:ProcessTerrain()
end

-- Keep auto-processing new objects
game.DescendantAdded:Connect(function(obj)
    Cleaner:ProcessObj(obj)
end)
