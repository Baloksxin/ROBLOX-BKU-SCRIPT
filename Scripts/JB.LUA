local DEFAULT_JUMP_HEIGHT = 15
local actualJumpHeight = (jumph == 0 or jumph == nil) and DEFAULT_JUMP_HEIGHT or jumph

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.UseJumpPower = false
    humanoid.JumpHeight = actualJumpHeight
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    
    humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(function()
        if humanoid.JumpHeight ~= actualJumpHeight then
            humanoid.JumpHeight = actualJumpHeight
        end
    end)
    
    humanoid.StateChanged:Connect(function()
        if not humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        end
    end)
end

if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(setupCharacter)
