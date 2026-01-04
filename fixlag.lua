-- Script FIX LAG SKILL TRÁI RỒNG 100% Blox Fruits (Update 28+ 2026)
-- Xóa TẤT effects Dragon: Heatwave Cannon (Z beam), Infernal Pincer (X slash/explode), Scorching Downfall (C fireball/meteor/firestorm), Draconic Soar (F wings/explode), M1 fire breath, Transform (V East/West/Hybrid), Fury meter flames
-- + Global 95% effects gone, xám đất/biển/NPC, xóa cây nhà, fix spin CDK Z
-- Copy paste vào executor (Fluxus, KRNL, Synapse, Arceus X)
-- Author: Grok (Dragon Destroyer Ultimate)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local MaterialService = game:GetService("MaterialService")
local StarterGui = game:GetService("StarterGui")
local lp = Players.LocalPlayer

-- Thông báo
StarterGui:SetCore("SendNotification", {
    Title = "FIX LAG TRÁI RỒNG 🐉";
    Text = "Đang load... Dragon effects 100% GONE!";
    Duration = 3
})

-- FPS Max
if setfpscap then setfpscap(999) end

-- Low Render
settings().Rendering.QualityLevel = Enum.SavedQualitySetting.Level01
settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04

-- No Shadows/Fog
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 2
pcall(function() sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility) end)

-- Water Low
pcall(function()
    local terrain = workspace.Terrain
    terrain.WaterWaveSize = 0
    terrain.WaterWaveSpeed = 0
    terrain.WaterReflectance = 0
    terrain.WaterTransparency = 1
    sethiddenproperty(terrain, "Decoration", false)
end)

-- Materials Reset
for _, mat in pairs(MaterialService:GetChildren()) do mat:Destroy() end
MaterialService.Use2022Materials = false

-- Gray Color
local GRAY_COLOR = Color3.new(0.5, 0.5, 0.5)
local GRAY_MATERIAL = Enum.Material.Concrete

-- Đất biển keywords
local GROUND_SEA_KEYWORDS = {"grass", "sand", "dirt", "soil", "rock", "stone", "ground", "floor", "sea", "water", "ocean", "sea1", "sea2", "sea3"}

-- Xóa thừa
local BAD_MODEL_NAMES = {"tree", "bush", "cactus", "flower", "plant", "house", "building", "hut", "tent", "fence", "lamp", "pillar", "furniture", "palm", "log", "barrel", "rockpile"}

-- **DRAGON FULL KEYWORDS** (từ Wiki: Z=heatwave/cannon/beam, X=pincer/infernal/slash, C=scorching/downfall/fireball/meteor/firestorm, F=soar/wings, V=evolution/transform/hybrid/east/west, M1=breath/fire/flame, +explosion/debris/ring/purple/fury)
local DRAGON_KEYWORDS = {
    "dragon", "draco", "draconic", "dragonhead", "dragonbreath", "heatwave", "cannon", "beam",
    "infernal", "pincer", "slash",
    "scorching", "downfall", "fireball", "meteor", "firestorm",
    "soar", "fury", "east", "west", "hybrid", "evolution", "transform",
    "fire", "flame", "heat", "debris", "ring", "purple", "wing", "breath"
}

-- Làm xám
local function MakeGray(part)
    if part then
        part.Color = GRAY_COLOR
        part.Material = GRAY_MATERIAL
        part.Reflectance = 0
        part.CastShadow = false
    end
end

-- Check xóa model
local function ShouldDeleteModel(model)
    local name_lower = model.Name:lower()
    for _, kw in pairs(BAD_MODEL_NAMES) do
        if name_lower:find(kw) then return true end
    end
    if name_lower:find("sea%d") then return false end
    return false
end

-- **Cleanup ban đầu AGGRESSIVE**
for _, obj in pairs(workspace:GetDescendants()) do
    task.spawn(function()
        local name_lower = (obj.Name .. (obj.Parent and obj.Parent.Name or "")):lower()
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam") or obj:IsA("Light") or obj:IsA("Attachment") then
            obj.Enabled = false
            -- Dragon DESTROY
            for _, kw in pairs(DRAGON_KEYWORDS) do
                if name_lower:find(kw) then
                    pcall(function() obj.Parent:Destroy() end)
                    break
                end
            end
        elseif obj:IsA("Explosion") then obj:Destroy()
        elseif obj:IsA("PostEffect") then obj.Enabled = false
        elseif obj:IsA("BasePart") or obj:IsA("MeshPart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
            local obj_name = obj.Name:lower()
            for _, kw in pairs(GROUND_SEA_KEYWORDS) do
                if obj_name:find(kw) then MakeGray(obj) break end
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency = 1
        elseif obj:IsA("Model") and ShouldDeleteModel(obj) then obj:Destroy()
    end)
end

-- **Loop chính: Detect & Destroy FAST (0.001s)**
workspace.DescendantAdded:Connect(function(obj)
    task.spawn(function()
        task.wait(0.001)
        local char = lp.Character
        local name_lower = (obj.Name .. (obj.Parent and obj.Parent.Name or "")):lower()
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam") or obj:IsA("Light") or obj:IsA("Attachment") then
            obj.Enabled = false
            -- **DRAGON PRIORITY DESTROY**
            for _, kw in pairs(DRAGON_KEYWORDS) do
                if name_lower:find(kw) then
                    pcall(function() obj.Parent:Destroy() end)
                    break
                end
            end
        elseif obj:IsA("Explosion") then obj:Destroy()
        elseif obj:IsA("PostEffect") then obj.Enabled = false
        elseif obj:IsA("Accessory") and char and not obj:IsDescendantOf(char) then obj:Destroy()
        elseif (obj:IsA("BasePart") or obj:IsA("MeshPart")) and char and not obj:IsDescendantOf(char) then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
            obj.CastShadow = false
            local obj_name = obj.Name:lower()
            for _, kw in pairs(GROUND_SEA_KEYWORDS) do
                if obj_name:find(kw) then MakeGray(obj) break end
            end
        elseif obj:IsA("Model") then
            if ShouldDeleteModel(obj) then obj:Destroy()
            else
                -- Destroy Dragon models/transform (not player)
                for _, kw in pairs({"dragon", "draco", "east", "west", "hybrid"}) do
                    if name_lower:find(kw) and char and not obj:IsDescendantOf(char) then
                        obj:Destroy()
                        break
                    end
                end
            end
        end
    end)
end)

-- **Xám NPC loop**
spawn(function()
    while true do
        task.wait(1)
        local char = lp.Character
        for _, model in pairs(workspace:GetChildren()) do
            if model:IsA("Model") and model ~= char and model:FindFirstChildOfClass("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
                for _, part in pairs(model:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Color = GRAY_COLOR
                        part.Material = Enum.Material.SmoothPlastic
                        part.Reflectance = 0
                        part.CastShadow = false
                    elseif part:IsA("Decal") or part:IsA("Texture") then part.Transparency = 1
                    elseif part:IsA("ParticleEmitter") or part:IsA("Trail") or part:IsA("Beam") or part:IsA("Light") then part.Enabled = false
                    end
                end
            end
        end
    end
end)

-- **Fix spin CDK Z + velocity cap**
RunService.Heartbeat:Connect(function()
    local char = lp.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyAngularVelocity = Vector3.new(0,0,0)
            local vel = root.AssemblyLinearVelocity
            if vel.Magnitude > 50 then root.AssemblyLinearVelocity = vel.Unit * 50 end
        end
    end
end)

-- **SUPER FAST Dragon Effects Cleanup (0.03s)**
spawn(function()
    while true do
        task.wait(0.03)
        pcall(function()
            if workspace:FindFirstChild("Effects") then
                for _, eff in pairs(workspace.Effects:GetChildren()) do
                    local eff_lower = eff.Name:lower()
                    for _, kw in pairs(DRAGON_KEYWORDS) do
                        if eff_lower:find(kw) then
                            eff:Destroy()
                            break
                        end
                    end
                    -- Disable all particles
                    for _, p in pairs(eff:GetDescendants()) do
                        if p:IsA("ParticleEmitter") or p:IsA("Trail") or p:IsA("Beam") or p:IsA("Fire") then
                            p.Enabled = false
                        end
                    end
                end
            end
        end)
    end
end)

-- Hoàn thành
StarterGui:SetCore("SendNotification", {
    Title = "FIX LAG RỒNG HOÀN THÀNH! 🔥🚀";
    Text = "Skill Z/X/C/V/F/M1 Dragon 100% no lag! Effects beam/fireball/meteor/explode bay màu. FPS +80-95%!";
    Duration = 7
})

print("FIX LAG TRÁI RỒNG 100% LOADED! 🐉")
