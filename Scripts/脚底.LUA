local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

pcall(function()
    if CoreGui:FindFirstChild("NpcLockGui") then
        CoreGui.NpcLockGui:Destroy()
    end
end)
local playerGui = player:FindFirstChild("PlayerGui")
if playerGui and playerGui:FindFirstChild("NpcLockGui") then
    playerGui.NpcLockGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NpcLockGui"
screenGui.ResetOnSpawn = false

pcall(function()
    screenGui.Parent = CoreGui
end)
if not screenGui.Parent then
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 225)
frame.Position = UDim2.new(0.5, -110, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "固定在NPC脚底下"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 13
title.Font = Enum.Font.SourceSansBold
title.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(0.9, 0, 0, 30)
textBox.Position = UDim2.new(0.05, 0, 0, 32)
textBox.PlaceholderText = "输入 NPC 名称..."
textBox.Text = ""
textBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.TextSize = 13
textBox.Font = Enum.Font.SourceSans
textBox.Parent = frame

local distBox = Instance.new("TextBox")
distBox.Size = UDim2.new(0.9, 0, 0, 30)
distBox.Position = UDim2.new(0.05, 0, 0, 68)
distBox.PlaceholderText = "输入距离"
distBox.Text = "10"
distBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
distBox.TextColor3 = Color3.fromRGB(255, 255, 255)
distBox.TextSize = 13
distBox.Font = Enum.Font.SourceSans
distBox.Parent = frame

local flipToggleBtn = Instance.new("TextButton")
flipToggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
flipToggleBtn.Position = UDim2.new(0.05, 0, 0, 104)
flipToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
flipToggleBtn.Text = "倒立: 关闭"
flipToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
flipToggleBtn.TextSize = 13
flipToggleBtn.Font = Enum.Font.SourceSansBold
flipToggleBtn.Parent = frame

local autoHeightBtn = Instance.new("TextButton")
autoHeightBtn.Size = UDim2.new(0.9, 0, 0, 30)
autoHeightBtn.Position = UDim2.new(0.05, 0, 0, 140)
autoHeightBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
autoHeightBtn.Text = "自动隐藏(Beta): 关闭"
autoHeightBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoHeightBtn.TextSize = 13
autoHeightBtn.Font = Enum.Font.SourceSansBold
autoHeightBtn.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
toggleBtn.Position = UDim2.new(0.05, 0, 0, 176)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.Text = "开启"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 14
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.Parent = frame

local isLocked = false
local targetName = ""
local targetDist = 10
local isFlipped = false
local autoHeight = false

flipToggleBtn.MouseButton1Click:Connect(function()
    isFlipped = not isFlipped
    if isFlipped then
        flipToggleBtn.Text = "倒立: 开启"
        flipToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    else
        flipToggleBtn.Text = "倒立: 关闭"
        flipToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        
        if isLocked then
            local realChar = workspace:FindFirstChild(player.Name)
            if realChar then
                local hrp = realChar:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local currentPos = hrp.Position
                    local targetModel = findTargetNpc(targetName)
                    if targetModel then
                        local targetRoot = targetModel:FindFirstChild("HumanoidRootPart") or targetModel.PrimaryPart or targetModel:FindFirstChild("Head")
                        if targetRoot then
                            local targetCFrame = targetRoot.CFrame
                            local targetForward = targetCFrame.LookVector
                            local targetAngle = math.atan2(targetForward.X, -targetForward.Z)
                            hrp.CFrame = CFrame.new(currentPos) * CFrame.Angles(0, targetAngle, 0)
                        end
                    end
                end
            end
        end
    end
end)

autoHeightBtn.MouseButton1Click:Connect(function()
    autoHeight = not autoHeight
    if autoHeight then
        autoHeightBtn.Text = "自动隐藏(Beta): 开启"
        autoHeightBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    else
        autoHeightBtn.Text = "自动隐藏(Beta): 关闭"
        autoHeightBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    targetName = textBox.Text
    local parsedDist = tonumber(distBox.Text)
    if parsedDist then
        targetDist = parsedDist
    end
    
    isLocked = not isLocked
    
    if isLocked then
        toggleBtn.Text = "关闭"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    else
        toggleBtn.Text = "开启"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        
        local realChar = workspace:FindFirstChild(player.Name)
        if realChar then
            for _, part in ipairs(realChar:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
            local hrp = realChar:FindFirstChild("HumanoidRootPart")
            if hrp then
                local currentPos = hrp.Position
                hrp.CFrame = CFrame.new(currentPos) * CFrame.Angles(0, 0, 0)
            end
        end
    end
end)

local function getRealPlayerCharacter()
    local char = workspace:FindFirstChild(player.Name)
    if char and char:IsA("Model") and char:FindFirstChild("HumanoidRootPart") then
        return char
    end
    return nil
end

local function findTargetNpc(name)
    local found = workspace:FindFirstChild(name, true)
    if found and found:IsA("Model") then
        if found:FindFirstChild("HumanoidRootPart") or found:FindFirstChildOfClass("Humanoid") then
            return found
        end
    end
    return nil
end

local function findGroundHeight(position)
    local rayOrigin = position + Vector3.new(0, 10, 0)
    local rayDirection = Vector3.new(0, -50, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {workspace:FindFirstChild(player.Name)}
    
    local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if rayResult then
        return rayResult.Position.Y
    end
    return nil
end

local function getOptimalHeight(npcPos, playerChar)
    local hrp = playerChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return npcPos.Y - 10 end
    
    local charHeight = 5
    local head = playerChar:FindFirstChild("Head")
    if head then
        charHeight = (hrp.Position.Y - head.Position.Y) + 2
    end
    
    local groundY = findGroundHeight(npcPos)
    if groundY then
        local hiddenY = groundY - charHeight
        if hiddenY < npcPos.Y - 50 then
            return npcPos.Y - 10
        end
        return hiddenY
    end
    
    return npcPos.Y - 10
end

RunService.RenderStepped:Connect(function()
    if not isLocked then return end
    if targetName == "" then return end

    local realChar = getRealPlayerCharacter()
    if not realChar then return end
    
    local hrp = realChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, part in ipairs(realChar:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    local targetModel = findTargetNpc(targetName)
    
    if targetModel and targetModel ~= realChar then
        local targetRoot = targetModel:FindFirstChild("HumanoidRootPart") or targetModel.PrimaryPart or targetModel:FindFirstChild("Head")
        
        if targetRoot then
            local targetPos = targetRoot.Position
            local targetCFrame = targetRoot.CFrame
            local targetForward = targetCFrame.LookVector
            local targetAngle = math.atan2(targetForward.X, -targetForward.Z)
            
            local newPos
            
            if autoHeight then
                local optimalY = getOptimalHeight(targetPos, realChar)
                local hrpHeight = hrp.Position.Y - realChar:GetPivot().Y
                newPos = Vector3.new(targetPos.X, optimalY, targetPos.Z)
            else
                newPos = targetPos + Vector3.new(0, -targetDist, 0)
            end
            
            if isFlipped then
                hrp.CFrame = CFrame.new(newPos) * CFrame.Angles(math.pi, 0, 0) * CFrame.Angles(0, targetAngle, 0)
            else
                hrp.CFrame = CFrame.new(newPos) * CFrame.Angles(0, targetAngle, 0)
            end
            
            hrp.AssemblyLinearVelocity = targetRoot.AssemblyLinearVelocity
            hrp.AssemblyAngularVelocity = targetRoot.AssemblyAngularVelocity
        end
    end
end)