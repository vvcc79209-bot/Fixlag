-- REMOVE 90% EFFECTS (Blox Fruits - SAFE)
-- Fruit / Melee / Sword / Gun / Basic Attack
-- No skill break | No hitbox loss

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

--------------------------------------------------
-- CONFIG
--------------------------------------------------
local REMOVE_PARTICLE = true
local REMOVE_TRAIL = true
local REMOVE_BEAM = true
local REMOVE_DECAL = true
local REMOVE_EFFECT_MODEL = true

--------------------------------------------------
-- SAFE CHECK
--------------------------------------------------
local function IsImportant(obj)
    if not obj then return false end

    local name = obj.Name:lower()

    -- giữ lại mấy thứ quan trọng
    if name:find("hitbox") then return true end
    if name:find("damage") then return true end
    if name:find("hurt") then return true end
    if name:find("root") then return true end
    if obj:IsA("Humanoid") then return true end

    return false
end

--------------------------------------------------
-- REMOVE EFFECT
--------------------------------------------------
local function ClearEffect(obj)
    if IsImportant(obj) then return end

    pcall(function()
        if REMOVE_PARTICLE and obj:IsA("ParticleEmitter") then
            obj.Enabled = false
            obj:Destroy()
        elseif REMOVE_TRAIL and obj:IsA("Trail") then
            obj.Enabled = false
            obj:Destroy()
        elseif REMOVE_BEAM and obj:IsA("Beam") then
            obj:Destroy()
        elseif REMOVE_DECAL and (obj:IsA("Decal") or obj:IsA("Texture")) then
            obj.Transparency = 1
        elseif REMOVE_EFFECT_MODEL and obj:IsA("Model") then
            local n = obj.Name:lower()
            if n:find("effect") or n:find("fx") or n:find("vfx") then
                obj:Destroy()
            end
        end
    end)
end

--------------------------------------------------
-- INITIAL CLEAN
--------------------------------------------------
for _,v in ipairs(Workspace:GetDescendants()) do
    ClearEffect(v)
end

--------------------------------------------------
-- REALTIME CLEAN (ANTI LAG)
--------------------------------------------------
Workspace.DescendantAdded:Connect(function(obj)
    task.wait(0.05)
    ClearEffect(obj)
end)

--------------------------------------------------
-- CHARACTER EFFECT CLEAN
--------------------------------------------------
local function OnCharacter(char)
    for _,v in ipairs(char:GetDescendants()) do
        ClearEffect(v)
    end

    char.DescendantAdded:Connect(function(obj)
        task.wait(0.05)
        ClearEffect(obj)
    end)
end

local player = Players.LocalPlayer
if player.Character then
    OnCharacter(player.Character)
end

player.CharacterAdded:Connect(OnCharacter)

--------------------------------------------------
print("✅ REMOVE 90% EFFECTS ENABLED | LOW LAG MODE")
--------------------------------------------------
