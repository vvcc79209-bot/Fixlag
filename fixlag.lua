-- FIX LAG ANDROID | KHÔNG XOÁ NHÂN VẬT
-- Xoá hiệu ứng lướt, skill, sóng biển

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

------------------------------------------------
-- LIGHTING (giảm gánh nặng)
------------------------------------------------
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 1
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0
Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)

------------------------------------------------
-- XOÁ EFFECT TRONG LIGHTING
------------------------------------------------
for _,v in pairs(Lighting:GetChildren()) do
	if v:IsA("BloomEffect")
	or v:IsA("SunRaysEffect")
	or v:IsA("BlurEffect")
	or v:IsA("ColorCorrectionEffect")
	or v:IsA("DepthOfFieldEffect") then
		v:Destroy()
	end
end

------------------------------------------------
-- GIẢM CHẤT LƯỢNG TERRAIN / NƯỚC
------------------------------------------------
if Terrain then
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 1
end

------------------------------------------------
-- XOÁ HIỆU ỨNG SKILL / LƯỚT (AN TOÀN)
------------------------------------------------
local function ClearEffects(obj)
	for _,v in pairs(obj:GetDescendants()) do
		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Beam")
		or v:IsA("Fire")
		or v:IsA("Smoke")
		or v:IsA("Sparkles")
		or v:IsA("Explosion")
		or v:IsA("PointLight")
		or v:IsA("SurfaceLight")
		or v:IsA("SpotLight") then
			v:Destroy()
		end
	end
end

-- Map + Workspace
ClearEffects(workspace)

------------------------------------------------
-- BẢO VỆ NHÂN VẬT (KHÔNG XOÁ PLAYER)
------------------------------------------------
for _,plr in pairs(Players:GetPlayers()) do
	if plr.Character then
		ClearEffects(plr.Character)
	end
	plr.CharacterAdded:Connect(function(char)
		task.wait(1)
		ClearEffects(char)
	end)
end

------------------------------------------------
-- TỰ ĐỘNG XOÁ EFFECT MỚI SINH RA (SKILL)
------------------------------------------------
workspace.DescendantAdded:Connect(function(v)
	if v:IsA("ParticleEmitter")
	or v:IsA("Trail")
	or v:IsA("Beam")
	or v:IsA("Explosion")
	or v:IsA("Fire")
	or v:IsA("Smoke")
	or v:IsA("Sparkles")
	or v:IsA("PointLight")
	or v:IsA("SurfaceLight")
	or v:IsA("SpotLight") then
		task.wait()
		if v and v.Parent then
			v:Destroy()
		end
	end
end)

print("✅ Fix Lag ON | Không xoá nhân vật | Đã tắt hiệu ứng skill/lướt/sóng")
