-- BLOX FRUITS FIX LAG SEA 1-3
-- Fix xoay | Xoá cây + props dư | Xoá effect skill | An toàn

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

------------------------------------------------
-- LIGHTING (KHÔNG ĐỔI MÀU TRỜI)
------------------------------------------------
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9

for _,v in ipairs(Lighting:GetChildren()) do
	if v:IsA("BloomEffect")
	or v:IsA("SunRaysEffect")
	or v:IsA("BlurEffect")
	or v:IsA("DepthOfFieldEffect") then
		v:Destroy()
	end
end

------------------------------------------------
-- GIẢM BIỂN / NƯỚC (SEA 1-3)
------------------------------------------------
if Terrain then
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 1
end

------------------------------------------------
-- FIX LỖI XOAY NGƯỜI SAU KHI DÙNG SKILL
------------------------------------------------
local function FixRotation(char)
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BodyGyro")
		or v:IsA("BodyAngularVelocity")
		or v:IsA("AlignOrientation")
		or v:IsA("AngularVelocity") then
			pcall(function() v:Destroy() end)
		end
	end
end

------------------------------------------------
-- XOÁ HIỆU ỨNG SKILL DƯ THỪA (CONTROL, DRAGON, ETC)
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
			pcall(function() v:Destroy() end)
		end
	end
end

------------------------------------------------
-- XOÁ CÂY CỐI + PROP DƯ (SEA 1-3)
------------------------------------------------
for _,v in ipairs(workspace:GetDescendants()) do
	if v:IsA("Model") then
		local n = v.Name:lower()

		-- Cây, lá, cỏ
		if n:find("tree")
		or n:find("bush")
		or n:find("leaf")
		or n:find("grass")
		or n:find("plant") then
			pcall(function() v:Destroy() end)
		end

		-- Nhà / prop nhỏ không có NPC
		if not v:FindFirstChildOfClass("Humanoid") then
			if #v:GetDescendants() <= 15 then
				pcall(function() v:Destroy() end)
			end
		end
	end
end

------------------------------------------------
-- PLAYER (KHÔNG XOÁ NHÂN VẬT)
------------------------------------------------
for _,plr in ipairs(Players:GetPlayers()) do
	if plr.Character then
		FixRotation(plr.Character)
		ClearSkillEffects(plr.Character)
	end

	plr.CharacterAdded:Connect(function(char)
		task.wait(1)
		FixRotation(char)
		ClearSkillEffects(char)
	end)
end

------------------------------------------------
-- TỰ XOÁ EFFECT + LỖI XOAY SINH RA KHI SPAM SKILL
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
	or v:IsA("SpotLight")
	or v:IsA("BodyGyro")
	or v:IsA("AlignOrientation")
	or v:IsA("AngularVelocity")
	or v:IsA("BodyAngularVelocity") then
		task.wait()
		pcall(function() v:Destroy() end)
	end
end)

print("✅ FixLag Sea 1-3 ON | Fix xoay | Xoá cây + effect dư")
