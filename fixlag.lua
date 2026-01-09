-- EXTREME LOW LAG EFFECT BLOCKER
-- ONLY BLOCK PARTICLE (MAIN LAG SOURCE)

local Workspace = game:GetService("Workspace")

local function blockParticle(obj)
	if obj.ClassName ~= "ParticleEmitter" then return end

	pcall(function()
		obj.Enabled = false
		obj.Rate = 0
		obj.Lifetime = NumberRange.new(0)
		obj.Speed = NumberRange.new(0)
		obj.Size = NumberSequence.new(0)
		obj.Transparency = NumberSequence.new(1)
	end)
end

-- chỉ xử lý object mới
Workspace.DescendantAdded:Connect(blockParticle)

-- dọn ban đầu 1 lần
for _, v in ipairs(Workspace:GetDescendants()) do
	blockParticle(v)
end

print("EXTREME LOW PARTICLE MODE ENABLED")
