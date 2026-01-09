-- ULTRA OPTIMIZED REMOVE SKILL EFFECTS
-- FRUIT | MELEE | SWORD | GUN | BASIC ATTACK
-- NO RENDERSTEPPED | NO FULL SCAN | LOW CPU

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

-- Class cần xoá
local REMOVE_CLASS = {
	ParticleEmitter = true,
	Beam = true,
	Trail = true,
	Explosion = true,
	Sound = true,
	PointLight = true,
	SpotLight = true,
	SurfaceLight = true
}

-- Debounce để tránh xử lý lặp
local handled = setmetatable({}, {__mode = "k"})

local function removeEffect(obj)
	if handled[obj] then return end
	handled[obj] = true

	local class = obj.ClassName
	if not REMOVE_CLASS[class] then return end

	pcall(function()
		if obj:IsA("Sound") then
			obj.Volume = 0
			obj.Playing = false
		elseif obj:IsA("Explosion") then
			obj.BlastPressure = 0
			obj.BlastRadius = 0
			obj.Visible = false
		end
		obj:Destroy()
	end)
end

-- Chỉ lắng nghe khi hiệu ứng mới xuất hiện
Workspace.DescendantAdded:Connect(removeEffect)
Lighting.DescendantAdded:Connect(removeEffect)

-- Dọn nhẹ ban đầu (1 lần duy nhất)
task.spawn(function()
	for _, v in ipairs(Workspace:GetDescendants()) do
		removeEffect(v)
	end
	for _, v in ipairs(Lighting:GetDescendants()) do
		removeEffect(v)
	end
end)

print("OPTIMIZED REMOVE EFFECTS ENABLED")
