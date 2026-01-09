-- TRUE ANTI-LAG EFFECT BLOCKER
-- NO DESTROY | NO SCAN LOOP | NO RENDERSTEPPED
-- BLOCK EFFECTS BEFORE THEY WORK

local Workspace = game:GetService("Workspace")

-- Chỉ block class nặng
local BLOCK = {
	ParticleEmitter = true,
	Beam = true,
	Trail = true,
	Explosion = true,
	Sound = true,
	PointLight = true,
	SpotLight = true,
	SurfaceLight = true
}

local function block(obj)
	if not BLOCK[obj.ClassName] then return end

	pcall(function()
		if obj:IsA("ParticleEmitter") then
			obj.Enabled = false
			obj.Rate = 0
			obj.Lifetime = NumberRange.new(0)

		elseif obj:IsA("Beam") or obj:IsA("Trail") then
			obj.Enabled = false

		elseif obj:IsA("Explosion") then
			obj.BlastRadius = 0
			obj.BlastPressure = 0
			obj.Visible = false

		elseif obj:IsA("Sound") then
			obj.Volume = 0
			obj.Playing = false
		end
	end)
end

-- Chỉ xử lý object mới (KHÔNG quét liên tục)
Workspace.DescendantAdded:Connect(block)

-- Dọn ban đầu 1 lần
for _, v in ipairs(Workspace:GetDescendants()) do
	block(v)
end

print("TRUE EFFECT BLOCKER ENABLED")
