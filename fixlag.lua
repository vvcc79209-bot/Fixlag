-- Reduce 85% Melee/Gun/Sword Normal Attack + Some Skill VFX (by ~Gs request)
-- Giảm ~85% hiệu ứng particle, trail, beam của đánh thường và một số skill

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ReductionPercent = 0.15  -- 15% = giữ lại 15% → giảm 85%

-- Danh sách các effect thường gặp khi đánh thường / skill
local VFX_Keywords = {
    "Slash", "Hit", "Impact", "Particle", "Trail", "Beam", "Spark", "Smoke",
    "SwordSlash", "GunShot", "Muzzle", "Explosion", "Wave", "Aura", "Electric",
    "Fire", "Ice", "Acid", "Dark", "Light", "Blood", "Cut", "Stab"
}

local function ReduceVFX(part)
    if not part:IsA("BasePart") and not part:IsA("Model") then return end
    
    for _, obj in pairs(part:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            -- Kiểm tra xem có phải effect đánh thường/skill không
            local shouldReduce = false
            local name = obj.Name:lower()
            
            for _, keyword in pairs(VFX_Keywords) do
                if name:find(keyword:lower()) then
                    shouldReduce = true
                    break
                end
            end
            
            if shouldReduce then
                if obj:IsA("ParticleEmitter") then
                    obj.Rate = obj.Rate * ReductionPercent
                    obj.Lifetime = NumberRange.new(obj.Lifetime.Min * ReductionPercent, obj.Lifetime.Max * ReductionPercent)
                    obj.Speed = NumberRange.new(obj.Speed.Min * ReductionPercent, obj.Speed.Max * ReductionPercent)
                    obj.Size = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, obj.Size.Keypoints[1].Value * ReductionPercent),
                        NumberSequenceKeypoint.new(1, obj.Size.Keypoints[#obj.Size.Keypoints].Value * ReductionPercent)
                    })
                elseif obj:IsA("Trail") then
                    obj.Lifetime = obj.Lifetime * ReductionPercent
                    obj.MinLength = obj.MinLength * ReductionPercent
                    obj.WidthScale = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, obj.WidthScale.Keypoints[1].Value * ReductionPercent),
                        NumberSequenceKeypoint.new(1, obj.WidthScale.Keypoints[#obj.WidthScale.Keypoints].Value * ReductionPercent)
                    })
                elseif obj:IsA("Beam") then
                    obj.Width0 = obj.Width0 * ReductionPercent
                    obj.Width1 = obj.Width1 * ReductionPercent
                end
            end
        end
    end
end

-- Theo dõi các combat mới (đánh thường + skill)
local connection
connection = RunService.Heartbeat:Connect(function()
    if not LocalPlayer.Character then return end
    
    local char = LocalPlayer.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    
    if humanoid then
        -- Theo dõi các phần vừa spawn ra (thường là hitbox + vfx)
        for _, part in pairs(workspace:GetChildren()) do
            if part:IsA("Part") or part:IsA("MeshPart") then
                if (part.Name:find("Hit") or part.Name:find("Slash") or part.Name:find("Effect")) 
                and (part.Position - char.HumanoidRootPart.Position).Magnitude < 50 then
                    
                    ReduceVFX(part)
                end
            end
        end
        
        -- Giảm luôn các effect trên nhân vật
        ReduceVFX(char)
    end
end)

-- Clean up khi disconnect
game:BindToClose(function()
    if connection then connection:Disconnect() end
end)

print("Đã kích hoạt giảm 85% hiệu ứng đánh thường Melee/Gun/Sword + một số skill!")
