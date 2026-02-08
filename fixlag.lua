--// ULTRA FPS BOOST BLOX FRUITS (LIGHTWEIGHT)
--// Anti Skill + Gray Map + Remove Heavy Objects
--// Client side only

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Terrain = Workspace:FindFirstChildOfClass("Terrain")

local GRAY = Color3.fromRGB(135,135,135)

-- tắt shadow global (nhẹ máy)
pcall(function()
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
end)

-- giảm nước
pcall(function()
	if Terrain then
		Terrain.WaterWaveSize = 0
		Terrain.WaterWaveSpeed = 0
		Terrain.WaterReflectance = 0
		Terrain.WaterTransparency = 0.2
	end
end)

local function isCharacter(model)
	return model and model:FindFirstChildOfClass("Humanoid")
end

local function process(obj)
	pcall(function()

		-- 🚫 tắt toàn bộ hiệu ứng skill
		if obj:IsA("ParticleEmitter")
		or obj:IsA("Trail")
		or obj:IsA("Beam")
		or obj:IsA("Fire")
		or obj:IsA("Smoke")
		or obj:IsA("Sparkles") then
			obj.Enabled = false
		end

		if obj:IsA("Explosion") then
			obj.BlastPressure = 0
			obj.BlastRadius = 0
		end

		if obj:IsA("PointLight")
		or obj:IsA("SpotLight")
		or obj:IsA("SurfaceLight") then
			obj.Enabled = false
		end

		-- 🧱 map xám + xoá texture
		if obj:IsA("BasePart") then
			if not isCharacter(obj.Parent) then
				obj.Material = Enum.Material.SmoothPlastic
				obj.Color = GRAY
				
				for _,d in ipairs(obj:GetChildren()) do
					if d:IsA("Decal") or d:IsA("Texture") then
						d.Transparency = 1
					end
				end
			end
		end

		-- 🌴 xoá lá/cây nặng
		if obj:IsA("MeshPart") then
			local n = obj.Name:lower()
			if n:find("tree") or n:find("leaf") or n:find("grass") or n:find("bush") then
				obj.LocalTransparencyModifier = 1
			end
		end

	end)
end

-- scan lần đầu
for _,v in ipairs(Workspace:GetDescendants()) do
	process(v)
end

-- object mới
Workspace.DescendantAdded:Connect(function(obj)
	task.wait()
	process(obj)
end)
