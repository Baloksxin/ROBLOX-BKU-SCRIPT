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
    
    if humanoid._jumpHeightConnection then
        humanoid._jumpHeightConnection:Disconnect()
        humanoid._jumpHeightConnection = nil
    end
    
    humanoid.UseJumpPower = false
    humanoid.JumpHeight = actualJumpHeight
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
    
    local connection
    local function onJumpHeightChanged()
        if humanoid.JumpHeight ~= actualJumpHeight then
            if connection then
                connection:Disconnect()
                connection = nil
            end
            humanoid.JumpHeight = actualJumpHeight
            connection = humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(onJumpHeightChanged)
            humanoid._jumpHeightConnection = connection
        end
    end
    
    connection = humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(onJumpHeightChanged)
    humanoid._jumpHeightConnection = connection
end

if LocalPlayer.Character then
    setupCharacter(LocalPlayer.Character)
end

_G.JumpHeightConnection = LocalPlayer.CharacterAdded:Connect(setupCharacter)