-- màu xám theo ảnh + pha trắng nhẹ
local grayMain = Color3.fromRGB(125,125,125) -- xám chính
local grayLight = Color3.fromRGB(170,170,170) -- xám pha trắng 30%

local function convertEffect(obj)
    if obj:IsA("ParticleEmitter") then
        obj.Rate = obj.Rate * 0.05
        obj.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, grayMain),
            ColorSequenceKeypoint.new(1, grayLight)
        }
    end

    if obj:IsA("Beam") or obj:IsA("Trail") then
        obj.Color = ColorSequence.new(grayMain)
    end

    if obj:IsA("PointLight") or obj:IsA("SpotLight") then
        obj.Brightness = obj.Brightness * 0.05
        obj.Color = grayLight
    end
end

workspace.DescendantAdded:Connect(convertEffect)

for _,v in pairs(workspace:GetDescendants()) do
    convertEffect(v)
end
