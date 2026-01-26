-- Blox Fruits Effect Cleaner (STABLE VERSION)
-- Remove most effects + gray remaining parts

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local GRAY = Color3.fromRGB(140,140,140)

-- Gray effect parts
local function grayPart(obj)
    if obj:IsA("BasePart") then
        obj.Color = GRAY
        obj.Material = Enum.Material.SmoothPlastic
        obj.Reflectance = 0
        if obj.Transparency < 0.6 then
            obj.Transparency = 0.3
        end
    end
end

-- Remove effect instances
local function clearEffect(obj)
    if obj:IsA("ParticleEmitter")
    or obj:IsA("Trail")
    or obj:IsA("Beam")
    or obj:IsA("Fire")
    or obj:IsA("Smoke")
    or obj:IsA("Sparkles")
    or obj:IsA("Explosion") then
        
        obj:Destroy()
    end
end

-- Scan existing objects
for _,v in ipairs(Workspace:GetDescendants()) do
    pcall(function()
        clearEffect(v)
        grayPart(v)
    end)
end

-- Handle new effects
Workspace.DescendantAdded:Connect(function(v)
    task.wait()
    pcall(function()
        clearEffect(v)
        grayPart(v)
    end)
end)

print("✅ Effect cleaned + gray mode ON")
