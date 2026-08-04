local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

if CoreGui:FindFirstChild("MobileShiftLock") then
    CoreGui.MobileShiftLock:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileShiftLock"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ShiftLockBtn"
ToggleButton.Size = UDim2.new(0, 48, 0, 48)
ToggleButton.Position = UDim2.new(0.85, 0, 0.5, -24)
ToggleButton.BackgroundTransparency = 0.4
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.BorderSizePixel = 0
ToggleButton.Image = "rbxassetid://182223762"
ToggleButton.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleButton

local isLocked = false
local dragging = false
local dragStart, startPos
local hasMoved = false

local function setCustomShiftLock(state)
    isLocked = state
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if isLocked then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        if humanoid then
            humanoid.AutoRotate = false
            humanoid.CameraOffset = Vector3.new(1.7, 0, 0)
        end
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        if humanoid then
            humanoid.AutoRotate = true
            humanoid.CameraOffset = Vector3.new(0, 0, 0)
        end
    end
end

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
        hasMoved = false
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if delta.Magnitude > 5 then
            hasMoved = true
        end
        ToggleButton.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    if not hasMoved then
        setCustomShiftLock(not isLocked)
    end
end)

RunService.Heartbeat:Connect(function()
    if not isLocked then return end
    
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local camera = workspace.CurrentCamera
    
    if rootPart and humanoid and camera then
        local moveDir = humanoid.MoveDirection
        local vel = rootPart.AssemblyLinearVelocity
        local horizontalVel = Vector3.new(vel.X, 0, vel.Z)
        
        local isHittingWall = (moveDir.Magnitude > 0.1) and (horizontalVel.Magnitude < 0.5)
        
        if not isHittingWall then
            local camLook = camera.CFrame.LookVector
            rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + Vector3.new(camLook.X, 0, camLook.Z))
        end
    end
end)

player.CharacterAdded:Connect(function(newChar)
    setCustomShiftLock(false)
end)

player.CharacterRemoving:Connect(function(oldChar)
    local humanoid = oldChar:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.AutoRotate = true
        humanoid.CameraOffset = Vector3.new(0, 0, 0)
    end
end)
