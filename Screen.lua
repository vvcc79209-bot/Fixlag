-- BLOX FRUITS - ABSOLUTE NO SHAKE
-- KHÔNG RUNG - KHÔNG GIẬT - KHÔNG LẮC CAMERA
-- ÁP DỤNG MỌI SKILL (MELEE / KIẾM / TRÁI)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--------------------------------------------------
-- 1. KHOÁ CỨNG CAMERA (NO SHAKE TUYỆT ĐỐI)
--------------------------------------------------
RunService:BindToRenderStep("LOCK_CAMERA", Enum.RenderPriority.Camera.Value + 1, function()
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		camera.CameraType = Enum.CameraType.Custom
		camera.CameraSubject = player.Character.Humanoid
		camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + camera.CFrame.LookVector)
	end
end)

--------------------------------------------------
-- 2. TẮT TOÀN BỘ HIỆU ỨNG MÀN HÌNH
--------------------------------------------------
local function disableLightingEffects()
	for _,v in pairs(Lighting:GetDescendants()) do
		if v:IsA("BlurEffect")
		or v:IsA("BloomEffect")
		or v:IsA("ColorCorrectionEffect")
		or v:IsA("SunRaysEffect")
		or v:IsA("DepthOfFieldEffect") then
			v.Enabled = false
		end
	end
end

disableLightingEffects()
Lighting.DescendantAdded:Connect(disableLightingEffects)

--------------------------------------------------
-- 3. XOÁ / TẮT TOÀN BỘ EFFECT SKILL
--------------------------------------------------
local function killEffects(obj)
	for _,v in pairs(obj:GetDescendants()) do
		if v:IsA("ParticleEmitter")
		or v:IsA("Trail")
		or v:IsA("Beam")
		or v:IsA("Explosion") then
			pcall(function()
				v.Enabled = false
				v:Destroy()
			end)
		end
	end
end

-- Nhân vật
if player.Character then
	killEffects(player.Character)
end

player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	killEffects(char)
end)

-- Effect sinh ra ngoài map
workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("ParticleEmitter")
	or obj:IsA("Trail")
	or obj:IsA("Beam")
	or obj:IsA("Explosion") then
		task.wait()
		pcall(function()
			obj.Enabled = false
			obj:Destroy()
		end)
	end
end)

--------------------------------------------------
-- 4. FIX GIẬT DO CHẤT LƯỢNG ĐỒ HOẠ
--------------------------------------------------
settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
game:GetService("UserSettings")
	:GetService("UserGameSettings")
	.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1

--------------------------------------------------
-- 5. CHẶN CAMERA BỊ ÉP LẮC TỪ SERVER
--------------------------------------------------
camera:GetPropertyChangedSignal("CFrame"):Connect(function()
	camera.CFrame = CFrame.new(
		camera.CFrame.Position,
		camera.CFrame.Position + camera.CFrame.LookVector
	)
end)
