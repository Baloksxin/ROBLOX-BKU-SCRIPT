local DEFAULT_JUMP_HEIGHT = 15
local actualJumpHeight = (jumph == 0 or jumph == nil) and DEFAULT_JUMP_HEIGHT or jumph

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

if _G.JumpHeightConnection then
    _G.JumpHeightConnection:Disconnect()
    _G.JumpHeightConnection = nil
end

local function setupCharacter(character)
    local humanoid = character:WaitForChild("Humanoid")
    
    humanoid.UseJumpPower = false
    humanoid.JumpHeight = actualJumpHeight
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    
    local isUpdating = false
    humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(function()
        if not isUpdating and humanoid.JumpHeight ~= actualJumpHeight then
            isUpdating = true
            humanoid.JumpHeight = actualJumpHeight
            isUpdating = false
        end
    end)
end

if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end

_G.JumpHeightConnection = LocalPlayer.CharacterAdded:Connect(setupCharacter)
