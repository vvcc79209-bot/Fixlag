-- REMOVE ~90% SKILL EFFECTS (BALANCED MODE)
-- FRUIT | MELEE | SWORD | GUN | BASIC ATTACK
-- KEEP GAME STABLE | LOW LAG

local Workspace = game:GetService("Workspace")

-- Class xử lý
local REDUCE = {
	ParticleEmitter = true,
	Beam = true,
	Trail = true,
	Sound = true,
	PointLight = true,
	SpotLight = true,
	SurfaceLight = true
}

local function reduceEffect(obj)
	if not REDUCE[obj.ClassName] then return end

	pcall(function()
		if obj:IsA("ParticleEmitter") then
			-- giữ lại 1 ít để còn nhìn chiêu
			obj.Rate = obj.Rate * 0.1
			obj.Lifetime = NumberRange.new(
				obj.Lifetime.Min * 0.3,
				obj.Lifetime.Max * 0.3
			)

		elseif obj:IsA("Beam") or obj:IsA("Trail") then
			obj.Enabled = false

		elseif obj:IsA("Sound") then
			obj.Volume = obj.Volume * 0.2

		elseif obj:IsA("PointLight")
		or obj:IsA("SpotLight")
		or obj:IsA("SurfaceLight") then
			obj.Brightness = obj.Brightness * 0.2
			obj.Range = obj.Range * 0.3
		end
	end)
end

-- xử lý object mới
Workspace.DescendantAdded:Connect(reduceEffect)

-- dọn ban đầu (1 lần)
for _, v in ipairs(Workspace:GetDescendants()) do
	reduceEffect(v)
end

print("90% EFFECT REDUCTION ENABLED")
