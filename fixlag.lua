-- Blox Fruits Effect Cleaner
-- Remove 98% effects, 2% transparent, no leftovers

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local REMOVE_NAMES = {
	"Effect","FX","VFX","Particle","Trail","Beam",
	"Smoke","Fire","Explosion","Shock","Ring","Wave",
	"Slash","Hit","Aura","Glow","Light"
}

local function isEffect(obj)
	for _,name in pairs(REMOVE_NAMES) do
		if string.find(obj.Name:lower(), name:lower()) then
			return true
		end
	end
	return false
end

local function clearEffect(obj)
	if obj:IsA("ParticleEmitter")
	or obj:IsA("Trail")
	or obj:IsA("Beam") then
		obj.Enabled = false
		Debris:AddItem(obj, 0)
	elseif obj:IsA("BasePart") then
		obj.Transparency = 1
		obj.Material = Enum.Material.SmoothPlastic
		obj.CanCollide = false
		obj.CastShadow = false
		Debris:AddItem(obj, 0)
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
		obj.Transparency = 1
		Debris:AddItem(obj, 0)
	elseif obj:IsA("Light") then
		obj.Enabled = false
		Debris:AddItem(obj, 0)
	end
end

-- Main loop
RunService.Heartbeat:Connect(function()
	for _,obj in pairs(Workspace:GetDescendants()) do
		if isEffect(obj) then
			clearEffect(obj)
		end
	end
end)
