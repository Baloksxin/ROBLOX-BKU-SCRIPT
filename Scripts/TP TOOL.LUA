local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local backpack = player:WaitForChild("Backpack")

local tool = Instance.new("Tool")
tool.Name = "点击传送"
tool.RequiresHandle = false
tool.CanBeDropped = true
tool.ToolTip = "点击任意地方传送"

tool.Equipped:Connect(function(mouse)
    mouse.Icon = "rbxasset://textures/GunCursor.png"
    
    mouse.Button1Down:Connect(function()
        if not mouse.Target then return end
        local targetPos = mouse.Hit.Position
        local teleportPos = targetPos + Vector3.new(0, 5, 0)
        
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = CFrame.new(teleportPos)
            
            local effect = Instance.new("ParticleEmitter")
            effect.Texture = "rbxassetid://243098098"
            effect.Lifetime = NumberRange.new(1)
            effect.Speed = NumberRange.new(10)
            effect.Rate = 100
            effect.Parent = root
            game.Debris:AddItem(effect, 1.5)
        end
    end)
end)

tool.Parent = backpack

wait(0.5)
if character then
    tool.Parent = character
end
