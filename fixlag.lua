--// BLOX FRUITS - GREY WORLD + 95% EFFECT REMOVER
--// LocalScript - StarterPlayerScripts

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

local GREY = Color3.fromRGB(120,120,120)

--// check sky
local function isSky(obj)
	if obj:IsA("Sky") then return true end
	if obj:IsA("Atmosphere") and obj.Parent == Lighting then return true end
	if obj:IsA("Clouds") and obj.Parent == Terrain then return true end
	if obj.Name == "SunRays" then return true end
	return false
end

--// remove heavy effects (95%)
local function removeHeavyEffect(obj)
	if obj:IsA("ParticleEmitter")
	or obj:IsA("Trail")
	or obj:IsA("Beam")
	or obj:IsA("Explosion")
	or obj:IsA("Fire")
	or obj:IsA("Smoke") then

		obj.Enabled = false
		return true
	end
	return false
end

--// grey remaining visuals
local function makeGrey(obj)

	if isSky(obj) then return end

	-- part
	if obj:IsA("BasePart") then
		obj.Color = GREY
		if obj.Material == Enum.Material.Neon then
			obj.Material = Enum.Material.SmoothPlastic
		end
	end

	-- decal texture
	if obj:IsA("Decal") or obj:IsA("Texture") then
		obj.Color3 = GREY
	end

	-- remaining particle (5%)
	if obj:IsA("ParticleEmitter") then
		obj.Color = ColorSequence.new(GREY)
	end

	if obj:IsA("Beam") or obj:IsA("Trail") then
		obj.Color = ColorSequence.new(GREY)
	end

	-- light
	if obj:IsA("PointLight")
	or obj:IsA("SpotLight")
	or obj:IsA("SurfaceLight") then
		obj.Color = GREY
		obj.Brightness = obj.Brightness * 0.3
	end

	-- highlight
	if obj:IsA("Highlight") then
		obj.FillColor = GREY
		obj.OutlineColor = GREY
	end
end

--// main process
local function process(obj)
	if isSky(obj) then return end

	local removed = removeHeavyEffect(obj)
	if not removed then
		makeGrey(obj)
	end
end

-- scan existing
for _,v in ipairs(game:GetDescendants()) do
	pcall(function()
		process(v)
	end)
end

-- new objects (skills spawn liên tục trong blox fruits)
game.DescendantAdded:Connect(function(obj)
	pcall(function()
		process(obj)
	end)
end)

print("✅ Blox Fruits Grey Mode + Effect Reducer Running")
