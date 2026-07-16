local DEFAULT_JUMP_HEIGHT = 15

local actualJumpHeight = (jumph == 0 or jumph == nil) and DEFAULT_JUMP_HEIGHT or jumph

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

task.spawn(function()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
    if playerGui then
        local touchGui = playerGui:WaitForChild("TouchGui", 5)
        if touchGui then
            local touchControlFrame = touchGui:WaitForChild("TouchControlFrame", 5)
            if touchControlFrame then
                local jumpButton = touchControlFrame:WaitForChild("JumpButton", 5)
                if jumpButton then
                    jumpButton.Visible = false
                    jumpButton:GetPropertyChangedSignal("Visible"):Connect(function()
                        if jumpButton.Visible then
                            jumpButton.Visible = false
                        end
                    end)
                end
            end
        end
    end
end)

local function performCustomJump()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid.UseJumpPower = false
            humanoid.JumpHeight = actualJumpHeight
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end

ContextActionService:BindAction("OverrideJumpAction", function(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        performCustomJump()
    end
    return Enum.ContextActionResult.Sink
end, false, Enum.KeyCode.Space)

local playerGui = LocalPlayer:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("CustomJumpGui") then
    playerGui.CustomJumpGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomJumpGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

local CustomButton = Instance.new("TextButton")
CustomButton.Name = "CustomJumpButton"
CustomButton.Size = UDim2.new(0, 70, 0, 70)
CustomButton.Position = UDim2.new(0.85, -35, 0.75, -35)
CustomButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CustomButton.BackgroundTransparency = 0.3
CustomButton.Text = "JUMP"
CustomButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CustomButton.Font = Enum.Font.SourceSansBold
CustomButton.TextSize = 20
CustomButton.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.5, 0)
UICorner.Parent = CustomButton

CustomButton.MouseButton1Down:Connect(performCustomJump)
