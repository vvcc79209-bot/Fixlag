-- EFFECT REMOVER 90% (SAFE MODE)
-- No teleport | No rubberband | Low CPU

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

-- Chỉ tắt hiệu ứng hình ảnh
local function disableVisual(obj)
	if obj:IsA("ParticleEmitter") then
		obj.Enabled = false

	elseif obj:IsA("Beam") then
		obj.Enabled = false

	elseif obj:IsA("Trail") then
		obj.Enabled = false

	elseif obj:IsA("Decal") or obj:IsA("Texture") then
		obj.Transparency = 0.9 -- giữ lại 10%
	end
end

-- Chỉ xử lý object mới spawn (skill)
Workspace.DescendantAdded:Connect(function(obj)
	disableVisual(obj)
end)

-- Dọn effect hiện có (1 lần)
for _,v in pairs(Workspace:GetDescendants()) do
	disableVisual(v)
end

-- Giảm post-processing (an toàn)
pcall(function()
	Lighting.Bloom.Enabled = false
	Lighting.Blur.Enabled = false
	Lighting.SunRays.Enabled = false
end)
