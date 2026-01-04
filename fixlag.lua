local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

-- 1. Remove 90% skill effects: melee, sword, gun, fruit, normal attacks (particles, trails, etc.)
local function clearEffects()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Attachment") or 
           obj:IsA("Explosion") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or 
           obj:IsA("Light") or obj.Name:lower():find("effect") or obj.Name:lower():find("vfx") then
            Debris:AddItem(obj, 0)
        end
    end
end

-- Clear effects continuously, but throttle to avoid lag
spawn(function()
    while true do
        clearEffects()
        wait(0.1)
    end
end)

-- 2. Make ground and sea gray, no sun change
for _, obj in pairs(Workspace:GetChildren()) do
    if obj:IsA("BasePart") and (obj.Name:lower():find("ground") or obj.Name:lower():find("terrain") or 
       obj.Name:lower():find("sea") or obj.Name:lower():find("water") or obj.Parent.Name:lower():find("sea")) then
        obj.Color = Color3.fromRGB(128, 128, 128)  -- Gray
        obj.Material = Enum.Material.Concrete
    end
    -- Skip sun/lighting
    if obj.Name:lower():find("sun") or obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Lighting") then
        -- Do nothing
    end
end

-- Update sea/ground colors continuously for new parts
RunService.Heartbeat:Connect(function()
    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("ground") or obj.Name:lower():find("sea") or 
           obj.Name:lower():find("water")) and obj.Color ~= Color3.fromRGB(128, 128, 128) then
            obj.Color = Color3.fromRGB(128, 128, 128)
        end
    end
end)

-- 3. Delete trees, houses, accessories; keep sea1,2,3 ground
local protectNames = {"sea1", "sea2", "sea3", "ground", "terrain", "water", "sea"}
local function shouldProtect(name)
    for _, p in pairs(protectNames) do
        if name:lower():find(p) then return true end
    end
    return false
end

for _, model in pairs(Workspace:GetChildren()) do
    if model:IsA("Model") and not shouldProtect(model.Name) then
        -- Trees, houses often have these
        if model.Name:lower():find("tree") or model.Name:lower():find("house") or model.Name:lower():find("building") or 
           model.Name:lower():find("rock") or model.Name:lower():find("bush") or model.Name:lower():find("grass") or
           model.Name:lower():find("accessory") or #model:GetChildren() < 50 then  -- Small models likely props
            model:Destroy()
        end
    end
end

-- Continuous delete for respawning props
spawn(function()
    while true do
        for _, model in pairs(Workspace:GetChildren()) do
            if model:IsA("Model") and not shouldProtect(model.Name) and 
               (model.Name:lower():find("tree") or model.Name:lower():find("house") or 
                model.Name:lower():find("building") or model.Name:lower():find("foliage")) then
                model:Destroy()
            end
        end
        wait(1)
    end
end)

-- 4. No effects when using skills (continuous clear)
-- Already handled in clearEffects loop

-- 5. Special: remove dragon, thunder (rumble), pain, control fruit effects; skull guitar, dragon gun
spawn(function()
    while true do
        clearEffects()  -- General clear
        -- Specific names if needed
        for _, obj in pairs(Workspace:GetDescendants()) do
            local name = obj.Name:lower()
            if name:find("dragon") or name:find("rumble") or name:find("thunder") or name:find("pain") or 
               name:find("control") or name:find("skull") or name:find("guitar") then
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Explosion") then
                    Debris:AddItem(obj, 0)
                end
            end
        end
        wait(0.05)  -- Faster for special effects
    end
end)

-- Additional FPS boost: reduce quality
settings().Rendering.QualityLevel = Enum.SavedQualitySetting.QualityLevel10  -- Lowest
game.Lighting.FogEnd = 100000
game.Lighting.GlobalShadows = false
game.Lighting.Brightness = 1

print("Blox Fruits Lag Fix Loaded")
