-- BLOX FRUITS FIX LAG (SAFE VERSION)
-- Không mất võ | Map xám | Effect Control xám | Không xoá nền

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

------------------------------------------------
-- KHÔNG ĐỤNG LIGHTING MÀU TRỜI
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
-- NƯỚC (AN TOÀN)
------------------------------------------------
if Terrain then
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 1
end

------------------------------------------------
-- CHUYỂN MAP + EFFECT SANG MÀU XÁM (KHÔNG XOÁ)
------------------------------------------------
local function GrayObject(obj)
	for _,v in ipairs(obj:GetDescendants()) do

		-- Chỉ xử lý Part KHÔNG thuộc nhân vật
		if v:IsA("BasePart") and not v:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid") then
			pcall(function()
				v.Material = Enum.Material.Plastic
				v.Color = Color3.fromRGB(160,160,160)
				v.Reflectance = 0
			end)
		end

		-- Hiệu ứng skill (Control, Dragon, etc) → XÁM + TẮT
		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Beam") then
			pcall(function()
				v.Color = ColorSequence.new(Color3.fromRGB(160,160,160))
				v.LightEmission = 0
				v.LightInfluence = 0
			end)
		end

		if v:IsA("Fire")
		or v:IsA("Smoke")
		or v:IsA("Sparkles") then
			pcall(function()
				v.Enabled = false
			end)
		end

		if v:IsA("PointLight")
		or v:IsA("SurfaceLight")
		or v:IsA("SpotLight") then
			pcall(function()
				v.Brightness = 0
			end)
		end
	end
end

------------------------------------------------
-- ÁP DỤNG CHO MAP + SKILL
------------------------------------------------
GrayObject(workspace)

------------------------------------------------
-- PLAYER: KHÔNG ĐỤNG VÕ, CHỈ XOÁ XOAY
------------------------------------------------
local function FixRotation(char)
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BodyGyro")
		or v:IsA("AlignOrientation")
		or v:IsA("AngularVelocity")
		or v:IsA("BodyAngularVelocity") then
			pcall(function() v:Destroy() end)
		end
	end
end

for _,plr in ipairs(Players:GetPlayers()) do
	if plr.Character then
		FixRotation(plr.Character)
	end
	plr.CharacterAdded:Connect(function(char)
		task.wait(1)
		FixRotation(char)
	end)
end

------------------------------------------------
-- SKILL SINH RA SAU → TỰ CHUYỂN XÁM
------------------------------------------------
workspace.DescendantAdded:Connect(function(v)
	task.wait()
	pcall(function()
		if v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.Color = Color3.fromRGB(160,160,160)
		end
		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Beam") then
			v.Color = ColorSequence.new(Color3.fromRGB(160,160,160))
		end
	end)
end)

print("✅ FixLag SAFE | Không mất võ | Map & skill xám | Không bug")
