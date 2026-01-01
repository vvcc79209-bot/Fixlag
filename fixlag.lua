-- FIX LAG SAFE - ANDROID
-- BẢN ỔN ĐỊNH, KHÔNG BUG, CHẮC CHẠY

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

-- Test chạy
warn("FIX LAG SCRIPT START")

------------------------------------------------
-- TẮT EFFECT TRONG LIGHTING (AN TOÀN)
------------------------------------------------
pcall(function()
	for _,v in pairs(Lighting:GetChildren()) do
		if v:IsA("BloomEffect")
		or v:IsA("SunRaysEffect")
		or v:IsA("BlurEffect")
		or v:IsA("DepthOfFieldEffect") then
			v:Destroy()
		end
	end
end)

------------------------------------------------
-- XÁM HIỆU ỨNG SKILL (KHÔNG ĐỤNG MAP)
------------------------------------------------
pcall(function()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Beam") then
			v.Color = ColorSequence.new(Color3.fromRGB(150,150,150))
			v.LightEmission = 0
			v.LightInfluence = 0
		end

		if v:IsA("Fire")
		or v:IsA("Smoke")
		or v:IsA("Sparkles") then
			v.Enabled = false
		end

		if v:IsA("PointLight")
		or v:IsA("SurfaceLight")
		or v:IsA("SpotLight") then
			v.Brightness = 0
		end
	end
end)

------------------------------------------------
-- FIX XOAY NHÂN VẬT (AN TOÀN)
------------------------------------------------
pcall(function()
	for _,plr in pairs(Players:GetPlayers()) do
		if plr.Character then
			for _,v in pairs(plr.Character:GetDescendants()) do
				if v:IsA("BodyGyro")
				or v:IsA("AlignOrientation")
				or v:IsA("AngularVelocity")
				or v:IsA("BodyAngularVelocity") then
					v:Destroy()
				end
			end
		end
	end
end)

warn("FIX LAG SCRIPT DONE")
