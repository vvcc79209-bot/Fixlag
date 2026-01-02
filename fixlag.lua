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

print("✅ FixLag Sea 1-3 ON | Fix xoay | Xoá cây + effect dư")-- BLOX FRUITS FIX LAG SEA 3
-- Fix xoay sau khi dùng skill | Xoá cây & nhà phụ | Không lỗi

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
-- NƯỚC / BIỂN (SEA 3)
------------------------------------------------
if Terrain then
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 1
end

------------------------------------------------
-- FIX LỖI XOAY SAU KHI DÙNG SKILL
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
			pcall(function() v:Destroy() end)
		end
	end
end

------------------------------------------------
-- XOÁ CÂY CỐI / NHÀ PHỤ (GIỮ MAP CHÍNH)
------------------------------------------------
for _,v in ipairs(workspace:GetDescendants()) do
	-- Cây, lá, trang trí
	if v:IsA("Model") then
		local name = v.Name:lower()
		if name:find("tree")
		or name:find("bush")
		or name:find("leaf")
		or name:find("grass")
		or name:find("plant")
		or name:find("decoration") then
			pcall(function() v:Destroy() end)
		end
	end

	-- Nhà phụ / props nhỏ (không có Humanoid)
	if v:IsA("Model") and not v:FindFirstChildOfClass("Humanoid") then
		local parts = v:GetDescendants()
		if #parts < 15 then -- model nhỏ
			pcall(function() v:Destroy() end)
		end
	end
end

------------------------------------------------
-- PLAYER (AN TOÀN)
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
-- SKILL SINH RA LIÊN TỤC
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

print("✅ FixLag Sea 3 | Fix xoay | Xoá cây & nhà phụ | An toàn")-- BLOX FRUITS FIX LAG SEA 3
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
