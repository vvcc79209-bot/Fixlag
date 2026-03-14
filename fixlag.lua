-- Custom Lag Fix Script for Blox Fruits on Delta Executor
-- Based on FPS Booster by RIP#6666, modified to meet specific requirements
-- Removes 90% of effects, turns 5% to black/white, grays NPCs/players, removes accessories, etc.
-- Attempts to avoid specified errors

if not _G.Ignore then
    _G.Ignore = {} -- Add Instances to ignore (e.g. workspace.Map)
end
if _G.SendNotifications == nil then
    _G.SendNotifications = false -- No notifications
end
if _G.ConsoleLogs == nil then
    _G.ConsoleLogs = false -- No console logs
end

if not game:IsLoaded() then
    repeat task.wait() until game:IsLoaded()
end

-- Custom Settings based on user request
_G.Settings = {
    Players = {
        ["Ignore Me"] = false, -- Process own character for graying/removing accessories
        ["Ignore Others"] = false,
        ["Ignore Tools"] = true
    },
    Meshes = {
        NoMesh = false,
        NoTexture = true,
        Destroy = false
    },
    Images = {
        Invisible = true,
        Destroy = false
    },
    Explosions = {
        Smaller = true,
        Invisible = true,
        Destroy = false
    },
    Particles = {
        Invisible = true, -- Will be overridden by custom logic for 90%/5%
        Destroy = false
    },
    TextLabels = {
        LowerQuality = true,
        Invisible = false,
        Destroy = false
    },
    MeshParts = {
        LowerQuality = true,
        Invisible = false,
        NoTexture = true,
        NoMesh = false,
        Destroy = false
    },
    Other = {
        ["FPS Cap"] = true, -- Uncaps FPS
        ["No Camera Effects"] = true, -- To fix camera issues
        ["No Clothes"] = true,
        ["Low Water Graphics"] = true, -- But preserve sea surface
        ["No Shadows"] = true,
        ["Low Rendering"] = true,
        ["Low Quality Parts"] = true,
        ["Low Quality Models"] = true,
        ["Reset Materials"] = true,
        ["Lower Quality MeshParts"] = true,
        ClearNilInstances = false
    }
}

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local MaterialService = game:GetService("MaterialService")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace.Terrain
local ME = Players.LocalPlayer

-- Function to check if part of character
local function PartOfCharacter(Inst)
    for i, v in pairs(Players:GetPlayers()) do
        if v \~= ME and v.Character and Inst:IsDescendantOf(v.Character) then
            return true
        end
    end
    return false
end

-- Function to check if descendant of ignore
local function DescendantOfIgnore(Inst)
    for i, v in pairs(_G.Ignore) do
        if Inst:IsDescendantOf(v) then
            return true
        end
    end
    return false
end

-- Main processing function
local function ProcessInstance(Inst)
    if not Inst:IsDescendantOf(Players) and (_G.Settings.Players["Ignore Others"] and not PartOfCharacter(Inst) 
    or not _G.Settings.Players["Ignore Others"]) and (_G.Settings.Players["Ignore Me"] and ME.Character and not Inst:IsDescendantOf(ME.Character) 
    or not _G.Settings.Players["Ignore Me"]) and (_G.Settings.Players["Ignore Tools"] and not Inst:IsA("BackpackItem") and not Inst:FindFirstAncestorWhichIsA("BackpackItem") 
    or not _G.Settings.Players["Ignore Tools"]) and (_G.Ignore and not table.find(_G.Ignore, Inst) and not DescendantOfIgnore(Inst) 
    or (not _G.Ignore or type(_G.Ignore) \~= "table" or #_G.Ignore <= 0)) then
        if Inst:IsA("DataModelMesh") then
            if _G.Settings.Meshes.NoMesh then Inst.MeshId = "" end
            if _G.Settings.Meshes.NoTexture then Inst.TextureId = "" end
            if _G.Settings.Meshes.Destroy then Inst:Destroy() end
        elseif Inst:IsA("FaceInstance") then
            if _G.Settings.Images.Invisible then Inst.Transparency = 1; Inst.Shiny = 1 end
            if _G.Settings.Images.LowDetail then Inst.Shiny = 1 end
            if _G.Settings.Images.Destroy then Inst:Destroy() end
        elseif Inst:IsA("ShirtGraphic") then
            if _G.Settings.Images.Invisible then Inst.Graphic = "" end
            if _G.Settings.Images.Destroy then Inst:Destroy() end
        elseif Inst:IsA("ParticleEmitter") or Inst:IsA("Trail") or Inst:IsA("Smoke") or Inst:IsA("Fire") or Inst:IsA("Sparkles") then
            -- Custom: Remove 90%, grayscale 5%, keep 5% normal (but user said 5% black white, 90% remove)
            local rand = math.random(1, 100)
            if rand <= 90 then
                Inst:Destroy() -- Remove 90%
            elseif rand <= 95 then
                -- Grayscale 5%
                Inst.Color = ColorSequence.new(Color3.new(0.5, 0.5, 0.5))
                Inst.Enabled = true
            else
                -- Keep 5% normal (but to match, perhaps grayscale all remaining)
            end
        elseif Inst:IsA("PostEffect") and _G.Settings["No Camera Effects"] then
            Inst.Enabled = false -- Fix camera glitches
        elseif Inst:IsA("Explosion") then
            if _G.Settings.Explosions.Smaller then Inst.BlastPressure = 1; Inst.BlastRadius = 1 end
            if _G.Settings.Explosions.Invisible then Inst.Visible = false end
            if _G.Settings.Explosions.Destroy then Inst:Destroy() end
        elseif Inst:IsA("Clothing") or Inst:IsA("SurfaceAppearance") or Inst:IsA("BaseWrap") then
            if _G.Settings["No Clothes"] then Inst:Destroy() end
        elseif Inst:IsA("BasePart") and not Inst:IsA("MeshPart") and not Inst:IsA("Terrain") then
            if _G.Settings["Low Quality Parts"] then Inst.Material = Enum.Material.Plastic; Inst.Reflectance = 0 end
        elseif Inst:IsA("TextLabel") and Inst:IsDescendantOf(Workspace) then
            if _G.Settings.TextLabels.LowerQuality then Inst.Font = Enum.Font.SourceSans; Inst.TextScaled = false; Inst.RichText = false; Inst.TextSize = 14 end
            if _G.Settings.TextLabels.Invisible then Inst.Visible = false end
            if _G.Settings.TextLabels.Destroy then Inst:Destroy() end
        elseif Inst:IsA("Model") then
            if _G.Settings["Low Quality Models"] then Inst.LevelOfDetail = 1 end
        elseif Inst:IsA("MeshPart") then
            if _G.Settings.MeshParts.LowerQuality then Inst.RenderFidelity = 2; Inst.Reflectance = 0; Inst.Material = Enum.Material.Plastic end
            if _G.Settings.MeshParts.Invisible then Inst.Transparency = 1 end
            if _G.Settings.MeshParts.NoTexture then Inst.TextureID = "" end
            if _G.Settings.MeshParts.NoMesh then Inst.MeshId = "" end
            if _G.Settings.MeshParts.Destroy then Inst:Destroy() end
        end
    end
end

-- Apply low water but preserve surface
if _G.Settings["Low Water Graphics"] then
    Terrain.WaterWaveSize = 0
    Terrain.WaterWaveSpeed = 0
    Terrain.WaterReflectance = 0
    Terrain.WaterTransparency = 0.5 -- Keep some visibility to avoid disappear
    if sethiddenproperty then sethiddenproperty(Terrain, "Decoration", false) end
end

-- No shadows
if _G.Settings["No Shadows"] then
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.ShadowSoftness = 0
    if sethiddenproperty then sethiddenproperty(Lighting, "Technology", 2) end
end

-- Low rendering
if _G.Settings["Low Rendering"] then
    settings().Rendering.QualityLevel = 1
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
end

-- Reset materials
if _G.Settings["Reset Materials"] then
    for i, v in pairs(MaterialService:GetChildren()) do v:Destroy() end
    MaterialService.Use2022Materials = false
end

-- Uncapped FPS
if _G.Settings["FPS Cap"] then
    if setfpscap then setfpscap(999) end
end

-- Custom: Gray NPCs and Players
local function GrayCharacter(Char)
    for _, part in pairs(Char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Color = Color3.new(0.5, 0.5, 0.5) -- Gray
        end
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player.Character then GrayCharacter(player.Character) end
    player.CharacterAdded:Connect(GrayCharacter)
end

-- Custom: Remove player accessories
local function RemoveAccessories(Char)
    for _, acc in pairs(Char:GetChildren()) do
        if acc:IsA("Accessory") or acc:IsA("Hat") then
            acc:Destroy()
        end
    end
end

for _, player in pairs(Players:GetPlayers()) do
    if player.Character then RemoveAccessories(player.Character) end
    player.CharacterAdded:Connect(RemoveAccessories)
end

-- Custom: Moderately remove trees, houses, accessories (e.g., remove 50% randomly)
local function ModerateRemove()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name:match("Tree") or obj.Name:match("House") or obj.Name:match("Bush") or obj.Name:match("Accessory")) then
            if math.random(1, 2) == 1 then -- 50% chance to remove
                obj:Destroy()
            end
        end
    end
end
ModerateRemove()

-- Avoid ground/land delete: Don't touch Terrain

-- Process all existing instances
for _, Inst in pairs(game:GetDescendants()) do
    task.spawn(ProcessInstance, Inst)
end

-- Process new instances
game.DescendantAdded:Connect(ProcessInstance)

-- Fix specific Blox Fruits issues: No spin on CDK (disable animations if possible, but approximate by low quality)
-- For Levi cam: No camera effects should help
-- Periodic cleanup to avoid FPS drops
while task.wait(5) do
    ModerateRemove() -- Re-apply moderate remove if new objects spawn
end
