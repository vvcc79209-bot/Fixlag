-- BLOX FRUITS PERFORMANCE SCRIPT
-- Effects Cleaner + Gray World
-- Terrain Safe / Sun Safe

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer

--------------------------------------------------
-- SETTINGS
--------------------------------------------------
local REMOVE_EFFECTS = true
local REMOVE_MAP_OBJECTS = true
local GRAY_WORLD = true

--------------------------------------------------
-- EFFECT KEYWORDS (STRONG FILTER)
--------------------------------------------------
local EffectKeywords = {
	"effect","fx","vfx","particle","trail","beam","flash","aura","shock",
	"explosion","spark","light","ring","fire","electric","lightning",
	"dragon","rumble","pain","control",
	"skull","guitar","gun","bullet","blast"
}

--------------------------------------------------
-- REMOVE EFFECTS FUNCTION
--------------------------------------------------
local function IsEffect(obj)
	if obj:IsA("ParticleEmitter") or
	   obj:IsA("Trail") or
	   obj:IsA("Beam") or
	   obj:IsA("Fire") or
	   obj:IsA("Smoke") or
	   obj:IsA("Sparkles") then
		return true
	end
	
	for _, key in pairs(EffectKeywords) do
		if string.find(string.lower(obj.Name), key) then
			return true
		end
	end
	
	return false
end

local function CleanEffects(container)
	for _, obj in pairs(container:GetDescendants()) do
		if IsEffect(obj) then
			pcall(function()
				obj.Enabled = false
				obj:Destroy()
			end)
		end
	end
end

--------------------------------------------------
-- AUTO CLEAN EFFECTS (REAL-TIME)
--------------------------------------------------
if REMOVE_EFFECTS then
	RunService.Heartbeat:Connect(function()
		for _, v in pairs(Workspace:GetChildren()) do
			if v:IsA("Model") or v:IsA("Folder") then
				CleanEffects(v)
			end
		end
	end)
end

--------------------------------------------------
-- GRAY TERRAIN (GROUND + SEA)
--------------------------------------------------
if GRAY_WORLD then
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") then
			if not obj:IsDescendantOf(Workspace.Terrain) then
				obj.Material = Enum.Material.Concrete
				obj.Color = Color3.fromRGB(130,130,130)
				obj.Reflectance = 0
			end
		end
	end
end

--------------------------------------------------
-- REMOVE MAP OBJECTS (SAFE)
--------------------------------------------------
if REMOVE_MAP_OBJECTS then
	for _, obj in pairs(Workspace:GetChildren()) do
		if obj:IsA("Model") then
			local lname = string.lower(obj.Name)
			if lname:find("tree") or
			   lname:find("house") or
			   lname:find("building") or
			   lname:find("decor") or
			   lname:find("prop") then
				pcall(function()
					obj:Destroy()
				end)
			end
		end
	end
end

--------------------------------------------------
-- CHARACTER EFFECT CLEAN
--------------------------------------------------
LocalPlayer.CharacterAdded:Connect(function(char)
	task.wait(1)
	CleanEffects(char)
end)

--------------------------------------------------
-- FINAL CLEAN PASS
--------------------------------------------------
task.delay(2, function()
	CleanEffects(Workspace)
end)
