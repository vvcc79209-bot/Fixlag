-- REMOVE 100% SKILL EFFECTS (FRUIT / MELEE / SWORD / GUN / BASIC ATTACK)
-- SAFE | NO DAMAGE EDIT | NO HITBOX REMOVE

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- ===== SETTINGS =====
local REMOVE_PARTICLES = true
local REMOVE_BEAMS = true
local REMOVE_TRAILS = true
local REMOVE_SOUNDS = true
local REMOVE_LIGHTS = true
local REMOVE_DECALS = true

-- ===== FUNCTION =====
local function removeEffects(obj)
	if obj:IsA("ParticleEmitter") and REMOVE_PARTICLES then
		obj.Enabled = false
		obj:Destroy()

	elseif obj:IsA("Beam") and REMOVE_BEAMS then
		obj.Enabled = false
		obj:Destroy()

	elseif obj:IsA("Trail") and REMOVE_TRAILS then
		obj.Enabled = false
		obj:Destroy()

	elseif obj:IsA("Sound") and REMOVE_SOUNDS then
		obj.Volume = 0
		obj.Playing = false
		obj:Destroy()

	elseif (obj:IsA("PointLight") or obj:IsA("SurfaceLight") or obj:IsA("SpotLight")) and REMOVE_LIGHTS then
		obj.Enabled = false
		obj:Destroy()

	elseif (obj:IsA("Decal") or obj:IsA("Texture")) and REMOVE_DECALS then
		obj.Transparency = 1
		obj:Destroy()
	end
end

-- ===== INITIAL CLEAN =====
for _, v in ipairs(Workspace:GetDescendants()) do
	pcall(removeEffects, v)
end

for _, v in ipairs(Lighting:GetDescendants()) do
	pcall(removeEffects, v)
end

for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
	pcall(removeEffects, v)
end

-- ===== REALTIME CLEAN (NEW EFFECTS) =====
Workspace.DescendantAdded:Connect(function(v)
	pcall(removeEffects, v)
end)

Lighting.DescendantAdded:Connect(function(v)
	pcall(removeEffects, v)
end)

ReplicatedStorage.DescendantAdded:Connect(function(v)
	pcall(removeEffects, v)
end)

-- ===== EXTRA: REMOVE EXPLOSION VISUAL =====
Workspace.ChildAdded:Connect(function(v)
	if v:IsA("Explosion") then
		v.BlastPressure = 0
		v.BlastRadius = 0
		v.Visible = false
		task.delay(0, function()
			v:Destroy()
		end)
	end
end)

-- ===== FPS STABILIZER =====
RunService.RenderStepped:Connect(function()
	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Beam") or v:IsA("Trail") then
			pcall(function()
				v.Enabled = false
			end)
		end
	end
end)

print("REMOVE 100% SKILL EFFECTS : ENABLED")
