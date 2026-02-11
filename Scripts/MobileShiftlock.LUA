local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local isLocked = false
local OFFSET = Vector3.new(1.7, 0.5, 0)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DraggableShiftLockGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("ImageButton")
button.Name = "ShiftLockButton"
button.Size = UDim2.new(0, 55, 0, 55) 
button.Position = UDim2.new(0.85, 0, 0.5, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.BackgroundTransparency = 0.5
button.ZIndex = 10
button.Active = true
button.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0.5, 0)
uiCorner.Parent = button

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Lock OFF"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextSize = 10
textLabel.Parent = button

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

button.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = button.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

button.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local function toggleShiftLock()
    isLocked = not isLocked
    local character = player.Character
    local humanoid = character and character:FindFirstChild("Humanoid")
    if isLocked then
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        button.BackgroundTransparency = 0.3
        textLabel.Text = "Lock ON"
        if humanoid then humanoid.CameraOffset = OFFSET end
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    else
        button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        button.BackgroundTransparency = 0.5
        textLabel.Text = "Lock OFF"
        if humanoid then humanoid.CameraOffset = Vector3.new(0, 0, 0) end
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end

button.Activated:Connect(function()
    toggleShiftLock()
end)

player.CharacterAdded:Connect(function()
    isLocked = false
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Text = "Lock OFF"
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end)

RunService.RenderStepped:Connect(function()
    if isLocked then
        local character = player.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")
        if humanoid and humanoid.Health > 0 and rootPart then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            local lookVector = camera.CFrame.LookVector
            local yaw = math.atan2(-lookVector.X, -lookVector.Z)
            rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, yaw, 0)
        else
            if isLocked then toggleShiftLock() end
        end
    end
end)
