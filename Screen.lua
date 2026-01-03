-- BLOX FRUITS - NO SHAKE / NO STUTTER SKILL
-- FIX CAMERA RUNG - BLUR - GIẬT KHI XÀI CHIÊU
-- Local Script

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--------------------------------------------------
-- 1. FIX CAMERA SHAKE
--------------------------------------------------
RunService.RenderStepped:Connect(function()
	if camera then
		camera.CameraType = Enum.CameraType.Custom
		camera.CameraSubject = player.Character and player.Character:FindFirstChild("Humanoid")
	end
end)

--------------------------------------------------
-- 2. TẮT BLUR + HIỆU ỨNG ÁNH SÁNG
--------------------------------------------------
for _,v in pairs(Lighting:GetChildren()) do
	if v:IsA("BlurEffect")
	or v:IsA("ColorCorrectionEffect")
	or v:IsA("BloomEffect")
	or v:IsA("SunRaysEffect")
	or v:IsA("DepthOfFieldEffect") then
		v.Enabled = false
	end
end

Lighting.ChildAdded:Connect(function(v)
	if v:IsA("BlurEffect")
	or v:IsA("ColorCorrectionEffect")
	or v:IsA("BloomEffect")
	or v:IsA("SunRaysEffect")
	or v:IsA("DepthOfFieldEffect") then
		v.Enabled = false
	end
end)

--------------------------------------------------
-- 3. GIẢM GIẬT DO EFFECT SKILL
--------------------------------------------------
local function removeEffects(obj)
	for _,v in pairs(obj:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		elseif v:IsA("Trail") then
			v.Enabled = false
		elseif v:IsA("Beam") then
			v.Enabled = false
		end
	end
end

-- Áp dụng cho nhân vật
player.CharacterAdded:Connect(function(char)
	wait(1)
	removeEffects(char)
end)

if player.Character then
	removeEffects(player.Character)
end

-- Áp dụng cho effect sinh ra trong Workspace
workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("ParticleEmitter")
	or obj:IsA("Trail")
	or obj:IsA("Beam") then
		task.wait()
		obj.Enabled = false
	end
end)

--------------------------------------------------
-- 4. FIX GIẬT NHẸ KHI DÙNG SKILL
--------------------------------------------------
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
game:GetService("UserSettings"):GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
