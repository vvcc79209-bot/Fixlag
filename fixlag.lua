-- BLOX FRUITS EXTREME LAG FIX (CLIENT SAFE)
-- Remove 95% Effects + Clean Map + Gray Terrain
-- Fix Skull Guitar, Dragon Storm, Control, Dragon, Rumble

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- 1. REMOVE 95% EFFECTS (ALL SKILLS)
--------------------------------------------------
local function ClearEffects(obj)
	for _, v in pairs(obj:GetDescendants()) do
		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Beam")
		or v:IsA("Fire")
		or v:IsA("Smoke")
		or v:IsA("Sparkles")
		or v:IsA("Explosion")
		or v:IsA("Decal")
		or v:IsA("Texture") then
			v:Destroy()
		end
	end
end

-- realtime remove effects
Workspace.DescendantAdded:Connect(function(obj)
	task.wait()
	if obj:IsA("ParticleEmitter")
	or obj:IsA("Trail")
	or obj:IsA("Beam")
	or obj:IsA("Explosion") then
		obj:Destroy()
	end
end)

--------------------------------------------------
-- 2. MAP CLEAN (NO GROUND DELETE)
--------------------------------------------------
for _, v in pairs(Workspace:GetChildren()) do
	if v:IsA("Model") then
		local name = string.lower(v.Name)

		if not string.find(name,"ground")
		and not string.find(name,"terrain")
		and not string.find(name,"sea")
		and not string.find(name,"water") then
			pcall(function()
				v:Destroy()
			end)
		end
	end
end

--------------------------------------------------
-- 3. GRAY GROUND + SEA
--------------------------------------------------
for _, v in pairs(Workspace:GetDescendants()) do
	if v:IsA("BasePart") then
		local n = string.lower(v.Name)

		if string.find(n,"ground")
		or string.find(n,"terrain")
		or string.find(n,"land") then
			v.Color = Color3.fromRGB(120,120,120)
			v.Material = Enum.Material.Concrete
		end

		if string.find(n,"sea")
		or string.find(n,"water") then
			v.Color = Color3.fromRGB(130,130,130)
			v.Material = Enum.Material.SmoothPlastic
		end
	end
end

--------------------------------------------------
-- 4. FIX SKULL GUITAR / DRAGON STORM
--------------------------------------------------
RunService.RenderStepped:Connect(function()
	for _, v in pairs(Workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			local n = string.lower(v.Name)

			if string.find(n,"skull")
			or string.find(n,"guitar")
			or string.find(n,"dragonstorm") then
				v.CastShadow = false
				v.Material = Enum.Material.SmoothPlastic
			end
		end
	end
end)

--------------------------------------------------
-- 5. FIX CONTROL / DRAGON / RUMBLE
--------------------------------------------------
Lighting.GlobalShadows = false
Lighting.Brightness = 1
Lighting.FogEnd = 1e9

--------------------------------------------------
-- 6. PLAYER SKILL EFFECT CLEAN
--------------------------------------------------
LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(1)
	ClearEffects(char)
end)

if LocalPlayer.Character then
	ClearEffects(LocalPlayer.Character)
end

--------------------------------------------------
print("✅ BLOX FRUITS EXTREME LAG FIX LOADED")
