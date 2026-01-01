-- BLOX FRUITS FIX LAG | CONTROL + DRAGON | SEA 3 SAFE
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

------------------------------------------------
-- LIGHTING: XÁM TOÀN GAME (NHẸ)
------------------------------------------------
Lighting.GlobalShadows = false
Lighting.Brightness = 1
Lighting.FogEnd = 9e9
Lighting.OutdoorAmbient = Color3.fromRGB(130,130,130)
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0

for _,v in ipairs(Lighting:GetChildren()) do
	if v:IsA("BloomEffect") or v:IsA("SunRaysEffect")
	or v:IsA("BlurEffect") or v:IsA("DepthOfFieldEffect")
	or v:IsA("ColorCorrectionEffect") then
		v:Destroy()
	end
end

local Gray = Instance.new("ColorCorrectionEffect")
Gray.Saturation = -1
Gray.Contrast = 0
Gray.Brightness = 0
Gray.Parent = Lighting

------------------------------------------------
-- BIỂN / NƯỚC (SEA 3)
------------------------------------------------
if Terrain then
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 1
end

------------------------------------------------
-- HÀM GIẢM / XOÁ EFFECT (KHÔNG ĐỤNG HITBOX)
------------------------------------------------
local function NerfEffects(root)
	for _,v in ipairs(root:GetDescendants()) do
		-- Xoá effect nặng (Control vòng, Dragon lửa/sấm)
		if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam")
		or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles")
		or v:IsA("PointLight") or v:IsA("SurfaceLight") or v:IsA("SpotLight") then
			pcall(function()
				v.Enabled = false
				v:Destroy()
			end)
		end

		-- Explosion của Dragon: giữ damage, bỏ ánh sáng
		if v:IsA("Explosion") then
			pcall(function()
				v.BlastPressure = v.BlastPressure -- giữ nguyên
				v.Visible = false
			end)
		end

		-- Part skill: chuyển xám, giảm vật liệu (nhẹ GPU)
		if v:IsA("BasePart") then
			pcall(function()
				v.Material = Enum.Material.Plastic
				v.Color = Color3.fromRGB(150,150,150)
				v.Reflectance = 0
			end)
		end
	end
end

------------------------------------------------
-- ÁP DỤNG TOÀN MAP (TRÁI CONTROL + DRAGON)
------------------------------------------------
NerfEffects(workspace)

------------------------------------------------
-- PLAYER (KHÔNG XOÁ NHÂN VẬT)
------------------------------------------------
for _,plr in ipairs(Players:GetPlayers()) do
	if plr.Character then
		NerfEffects(plr.Character)
	end
	plr.CharacterAdded:Connect(function(char)
		task.wait(1)
		NerfEffects(char)
	end)
end

------------------------------------------------
-- XOÁ EFFECT MỚI SINH RA (SPAM SKILL)
------------------------------------------------
workspace.DescendantAdded:Connect(function(v)
	if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam")
	or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles")
	or v:IsA("PointLight") or v:IsA("SurfaceLight") or v:IsA("SpotLight") then
		task.wait()
		pcall(function() v:Destroy() end)
	end
end)

print("✅ FixLag Control + Dragon ON | Xám | Sea 3 SAFE")
