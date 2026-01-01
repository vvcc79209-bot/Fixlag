-- BLOX FRUITS FIX LAG SEA 3
-- Chỉ xám mặt đất | Giữ bầu trời | Xoá effect dư thừa | Không lỗi

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

------------------------------------------------
-- KHÔNG ĐỤNG SKY / LIGHTING MÀU
------------------------------------------------
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9

-- Xoá effect nặng trong Lighting (KHÔNG đổi màu)
for _,v in ipairs(Lighting:GetChildren()) do
	if v:IsA("BloomEffect")
	or v:IsA("SunRaysEffect")
	or v:IsA("BlurEffect")
	or v:IsA("DepthOfFieldEffect") then
		v:Destroy()
	end
end

------------------------------------------------
-- GIẢM BIỂN / NƯỚC (SEA 3)
------------------------------------------------
if Terrain then
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 1
end

------------------------------------------------
-- CHỈ XÁM MAP (KHÔNG ĐỤNG SKYBOX)
------------------------------------------------
local function GrayMap(obj)
	for _,v in ipairs(obj:GetDescendants()) do
		if v:IsA("BasePart") then
			-- Bỏ qua part của nhân vật
			if not v:IsDescendantOf(Players) then
				pcall(function()
					v.Material = Enum.Material.Plastic
					v.Color = Color3.fromRGB(150,150,150)
					v.Reflectance = 0
				end)
			end
		end
	end
end

------------------------------------------------
-- XOÁ HIỆU ỨNG SKILL DƯ THỪA
------------------------------------------------
local function ClearSkillEffects(obj)
	for _,v in ipairs(obj:GetDescendants()) do
		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Beam")
		or v:IsA("Fire")
		or v:IsA("Smoke")
		or v:IsA("Sparkles")
		or v:IsA("PointLight")
		or v:IsA("SurfaceLight")
		or v:IsA("SpotLight") then
			pcall(function()
				v.Enabled = false
				v:Destroy()
			end)
		end
	end
end

------------------------------------------------
-- ÁP DỤNG
------------------------------------------------
GrayMap(workspace)
ClearSkillEffects(workspace)

------------------------------------------------
-- PLAYER (KHÔNG XOÁ NHÂN VẬT)
------------------------------------------------
for _,plr in ipairs(Players:GetPlayers()) do
	if plr.Character then
		ClearSkillEffects(plr.Character)
	end
	plr.CharacterAdded:Connect(function(char)
		task.wait(1)
		ClearSkillEffects(char)
	end)
end

------------------------------------------------
-- XOÁ EFFECT MỚI SINH RA (SPAM SKILL)
------------------------------------------------
workspace.DescendantAdded:Connect(function(v)
	if v:IsA("ParticleEmitter")
	or v:IsA("Trail")
	or v:IsA("Beam")
	or v:IsA("Fire")
	or v:IsA("Smoke")
	or v:IsA("Sparkles")
	or v:IsA("PointLight")
	or v:IsA("SurfaceLight")
	or v:IsA("SpotLight") then
		task.wait()
		pcall(function() v:Destroy() end)
	end
end)

print("✅ FixLag Sea 3 | Chỉ xám mặt đất | Giữ bầu trời | Xoá effect dư thừa")
