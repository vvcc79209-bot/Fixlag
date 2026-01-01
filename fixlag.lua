-- BLOX FRUITS FIX LAG SAFE SEA 1-3
-- KHÔNG MẤT VÕ | KHÔNG XÁM MAP | FIX XOAY | XÁM EFFECT

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

------------------------------------------------
-- LIGHTING (KHÔNG ĐỤNG BẦU TRỜI)
------------------------------------------------
pcall(function()
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
end)

------------------------------------------------
-- GIẢM BIỂN
------------------------------------------------
if Terrain then
	Terrain.WaterWaveSize = 0
	Terrain.WaterWaveSpeed = 0
	Terrain.WaterReflectance = 0
	Terrain.WaterTransparency = 1
end

------------------------------------------------
-- FIX XOAY (KHÔNG ĐỤNG TOOL)
------------------------------------------------
local function FixRotation(char)
	for _,v in ipairs(char:GetDescendants()) do
		if v:IsA("BodyGyro")
		or v:IsA("BodyAngularVelocity")
		or v:IsA("AlignOrientation")
		or v:IsA("AngularVelocity") then
			v:Destroy()
		end
	end
end

------------------------------------------------
-- XÁM EFFECT SKILL (KHÔNG XOÁ)
------------------------------------------------
local function GrayEffect(obj)
	for _,v in ipairs(obj:GetDescendants()) do
		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Beam") then
			v.Color = ColorSequence.new(Color3.fromRGB(160,160,160))
			v.LightEmission = 0
			v.LightInfluence = 0
		end

		if v:IsA("PointLight")
		or v:IsA("SurfaceLight")
		or v:IsA("SpotLight") then
			v.Brightness = 0
		end
	end
end

------------------------------------------------
-- XOÁ CÂY CỐI ĐÚNG TÊN (KHÔNG XOÁ MAP)
------------------------------------------------
for _,v in ipairs(workspace:GetDescendants()) do
	if v:IsA("Model") then
		local n = v.Name:lower()
		if n:find("tree")
		or n:find("bush")
		or n:find("leaf")
		or n:find("grass")
		or n:find("plant") then
			v:Destroy()
		end
	end
end

------------------------------------------------
-- PLAYER
------------------------------------------------
for _,plr in ipairs(Players:GetPlayers()) do
	if plr.Character then
		FixRotation(plr.Character)
		GrayEffect(plr.Character)
	end

	plr.CharacterAdded:Connect(function(char)
		task.wait(1)
		FixRotation(char)
		GrayEffect(char)
	end)
end

------------------------------------------------
-- EFFECT PHÁT SINH (CONTROL / DRAGON)
------------------------------------------------
workspace.DescendantAdded:Connect(function(v)
	if v:IsA("ParticleEmitter")
	or v:IsA("Trail")
	or v:IsA("Beam") then
		task.wait()
		v.Color = ColorSequence.new(Color3.fromRGB(160,160,160))
		v.LightEmission = 0
		v.LightInfluence = 0
	end
end)

print("✅ FIX LAG SAFE ON | KHÔNG MẤT VÕ | KHÔNG XÁM MAP")
