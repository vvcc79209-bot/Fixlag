-- SAFE EFFECT REMOVER 95%
-- No teleport | No rubberband | Low CPU

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local Debris = game:GetService("Debris")

-- Tắt effect thuần hình ảnh
local function disableVisual(obj)
	if obj:IsA("ParticleEmitter") then
		obj.Enabled = false

	elseif obj:IsA("Beam") then
		obj.Enabled = false

	elseif obj:IsA("Trail") then
		obj.Enabled = false

	elseif obj:IsA("Decal") or obj:IsA("Texture") then
		obj.Transparency = 1
	end
end

-- Chỉ xử lý effect mới spawn (skill)
Workspace.DescendantAdded:Connect(function(obj)
	disableVisual(obj)

	-- Xoá model effect sau 0.2s (KHÔNG đụng part con)
	if obj:IsA("Model") and obj.Name:lower():find("effect") then
		Debris:AddItem(obj, 0.2)
	end
end)

-- Dọn effect có sẵn (1 lần duy nhất)
for _,v in pairs(Workspace:GetDescendants()) do
	disableVisual(v)
end

-- Giảm post-processing (an toàn)
pcall(function()
	Lighting.Bloom.Enabled = false
	Lighting.Blur.Enabled = false
	Lighting.SunRays.Enabled = false
end)
