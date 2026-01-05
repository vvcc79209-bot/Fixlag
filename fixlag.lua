-- BLOX FRUITS LAG FIX - SAFE VERSION
-- Remove ~95% effects + Hide heavy map + Gray color
-- Client-side only

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

--------------------------------------------------
-- 1. REMOVE HEAVY EFFECTS (SAFE)
--------------------------------------------------
local function RemoveEffects(obj)
	for _, v in ipairs(obj:GetDescendants()) do
		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Beam")
		or v:IsA("Fire")
		or v:IsA("Smoke")
		or v:IsA("Sparkles") then
			v.Enabled = false
		end
	end
end

-- remove new effects when spawned
Workspace.DescendantAdded:Connect(function(v)
	if v:IsA("ParticleEmitter")
	or v:IsA("Trail")
	or v:IsA("Beam") then
		task.wait()
		pcall(function()
			v.Enabled = false
		end)
	end
end)

--------------------------------------------------
-- 2. HIDE TREE / HOUSE / PROPS (NO DELETE)
--------------------------------------------------
for _, v in ipairs(Workspace:GetDescendants()) do
	if v:IsA("BasePart") then
		local name = string.lower(v.Name)

		if string.find(name,"tree")
		or string.find(name,"house")
		or string.find(name,"rock")
		or string.find(name,"decor")
		or string.find(name,"prop") then
			v.Transparency = 1
			v.CanCollide = false
		end
	end
end

--------------------------------------------------
-- 3. GRAY GROUND & SEA (SAFE)
--------------------------------------------------
for _, v in ipairs(Workspace:GetDescendants()) do
	if v:IsA("BasePart") then
		local n = string.lower(v.Name)

		if string.find(n,"ground")
		or string.find(n,"terrain")
		or string.find(n,"land") then
			v.Color = Color3.fromRGB(130,130,130)
			v.Material = Enum.Material.Concrete
		end

		if string.find(n,"water")
		or string.find(n,"sea") then
			v.Color = Color3.fromRGB(120,120,120)
			v.Material = Enum.Material.SmoothPlastic
		end
	end
end

--------------------------------------------------
-- 4. FIX SKULL GUITAR / DRAGON STORM
--------------------------------------------------
RunService.RenderStepped:Connect(function()
	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			local n = string.lower(v.Name)

			if string.find(n,"skull")
			or string.find(n,"guitar")
			or string.find(n,"dragonstorm") then
				v.Material = Enum.Material.SmoothPlastic
				v.CastShadow = false
			end
		end
	end
end)

--------------------------------------------------
-- 5. FIX CONTROL / DRAGON / RUMBLE (LIGHTING)
--------------------------------------------------
Lighting.GlobalShadows = false
Lighting.FogEnd = 1000000
Lighting.Brightness = 1

--------------------------------------------------
-- 6. PLAYER EFFECT CLEAN
--------------------------------------------------
local function OnCharacter(char)
	task.wait(1)
	RemoveEffects(char)
end

player.CharacterAdded:Connect(OnCharacter)
if player.Character then
	OnCharacter(player.Character)
end

--------------------------------------------------
print("✅ BLOX FRUITS LAG FIX (SAFE) LOADED")
