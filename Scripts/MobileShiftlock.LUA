local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

local platform = UserInputService:GetPlatform()
if platform == Enum.Platform.Windows or platform == Enum.Platform.OSX or platform == Enum.Platform.Linux or not UserInputService.TouchEnabled then
    warn("仅支持移动端")
    return
end

local ShoulderOffset = Vector3.new(1.7, 0.6, 0)

if CoreGui:FindFirstChild("MobileShiftLockGUI") then
    CoreGui.MobileShiftLockGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileShiftLockGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Button = Instance.new("TextButton")
Button.Name = "ShiftLockBtn"
Button.Parent = ScreenGui
Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Button.BackgroundTransparency = 0.4
Button.Position = UDim2.new(0.85, -30, 0.65, -30)
Button.Size = UDim2.new(0, 48, 0, 48)
Button.Text = "🔒"
Button.TextSize = 22
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Active = true
Button.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = Button

local active = false
local renderConnection = nil

local function toggleShiftlock()
    active = not active
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if active then
        Button.BackgroundTransparency = 0.15
        if humanoid then
            humanoid.AutoRotate = false
        end
        
        renderConnection = RunService.RenderStepped:Connect(function()
            if not character or not humanoid or not rootPart or humanoid.Health <= 0 then
                active = false
                if humanoid then humanoid.AutoRotate = true end
                if renderConnection then renderConnection:Disconnect() end
                Button.BackgroundTransparency = 0.4
                return
            end
            
            local camera = workspace.CurrentCamera
            if not camera then return end
            
            local camVector = camera.CFrame.LookVector
            local flatVector = Vector3.new(camVector.X, 0, camVector.Z).Unit
            
            if flatVector.Magnitude > 0 then
                rootPart.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + flatVector)
            end
            
            camera.CFrame = camera.CFrame * CFrame.new(ShoulderOffset)
        end)
    else
        Button.BackgroundTransparency = 0.4
        if humanoid then
            humanoid.AutoRotate = true
        end
        if renderConnection then
            renderConnection:Disconnect()
            renderConnection = nil
        end
    end
end

Button.MouseButton1Click:Connect(toggleShiftlock)

player.CharacterAdded:Connect(function(newChar)
    if active then
        toggleShiftlock()
    end
end)
