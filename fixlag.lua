-- EFFECT REMOVER 95% (FRUIT / MELEE / SWORD / GUN / BASIC ATTACK)
-- Client-side | Optimized | Safe

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer

-- ==== SETTINGS ====
local EFFECT_LIFETIME = 0.05 -- giữ hiệu ứng rất ngắn (95% bị xoá)
local MAX_PART_SIZE = 12     -- part quá to coi là effect
-- ==================

-- Xoá particle, beam, trail
local function clearVisual(obj)
	if obj:IsA("ParticleEmitter")
	or obj:IsA("Beam")
	or obj:IsA("Trail") then
		obj.Enabled = false
		Debris:AddItem(obj, EFFECT_LIFETIME)
	end
end

-- Xử lý part hiệu ứng
local function handlePart(part)
	if not part:IsA("BasePart") then return end
	if part.Size.Magnitude > MAX_PART_SIZE then
		part.Transparency = 1
		part.CanCollide = false
		part.Anchored = true
		Debris:AddItem(part, EFFECT_LIFETIME)
	end
end

-- Quét object mới sinh ra (skill)
workspace.DescendantAdded:Connect(function(obj)
	task.spawn(function()
		clearVisual(obj)
		handlePart(obj)
	end)
end)

-- Xoá effect trong ReplicatedStorage (skill clone)
for _,v in pairs(ReplicatedStorage:GetDescendants()) do
	clearVisual(v)
end

-- Dọn effect liên tục (chống hồi sinh)
RunService.Heartbeat:Connect(function()
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("ParticleEmitter")
		or v:IsA("Beam")
		or v:IsA("Trail") then
			v.Enabled = false
		end
	end
end)

-- Giảm ánh sáng phụ
pcall(function()
	game:GetService("Lighting").Bloom.Enabled = false
	game:GetService("Lighting").Blur.Enabled = false
	game:GetService("Lighting").SunRays.Enabled = false
end)
