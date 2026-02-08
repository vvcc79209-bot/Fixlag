--// BLOX FRUITS LOW FX + GRAYSCALE (NON-CONFLICT VERSION)

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

--========================
-- SETTINGS
--========================
local FX_REDUCTION = 0.1 -- giữ lại 10% hiệu ứng (~xoá 90%)

--========================
-- GRAYSCALE (TRỪ SKY)
--========================
local color = Instance.new("ColorCorrectionEffect")
color.Name = "LowFx_GrayScale"
color.Saturation = -1
color.Contrast = 0
color.TintColor = Color3.fromRGB(200,200,200)
color.Parent = Lighting

--========================
-- FX REDUCTION FUNCTION
--========================
local function reduceFX(obj)

	-- Particle
	if obj:IsA("ParticleEmitter") then
		obj.Rate = obj.Rate * FX_REDUCTION
		obj.LightEmission = 0
	end

	-- Trail
	if obj:IsA("Trail") then
		obj.Lifetime = obj.Lifetime * FX_REDUCTION
	end

	-- Beam
	if obj:IsA("Beam") then
		obj.Width0 = obj.Width0 * FX_REDUCTION
		obj.Width1 = obj.Width1 * FX_REDUCTION
	end

	-- Explosion
	if obj:IsA("Explosion") then
		obj.BlastPressure = 0
	end

	-- Light
	if obj:IsA("PointLight")
	or obj:IsA("SpotLight")
	or obj:IsA("SurfaceLight") then
		obj.Brightness = obj.Brightness * FX_REDUCTION
	end
end

--========================
-- APPLY TO EXISTING
--========================
for _,v in ipairs(Workspace:GetDescendants()) do
	reduceFX(v)
end

--========================
-- APPLY TO NEW OBJECTS
--========================
Workspace.DescendantAdded:Connect(function(obj)
	reduceFX(obj)
end)

print("Low FX + Grayscale Loaded (Non Conflict Mode)")
