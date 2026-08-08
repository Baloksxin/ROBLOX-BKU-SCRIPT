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

local autoDistBtn = Instance.new("TextButton")
autoDistBtn.Size = UDim2.new(0.9, 0, 0, 30)
autoDistBtn.Position = UDim2.new(0.05, 0, 0, 140)
autoDistBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
autoDistBtn.Text = "自动距离(Beta): 关闭"
autoDistBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoDistBtn.TextSize = 13
autoDistBtn.Font = Enum.Font.SourceSansBold
autoDistBtn.Parent = frame

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
local autoDist = false
local savedCollisions = {}

local function isBodyPart(part)
    if not part or not part:IsA("BasePart") then return false end
    if part.Name == "Handle" then return false end
    if part:FindFirstAncestorOfClass("Accessory") then return false end
    return true
end

local function saveCollisionStates(character)
    savedCollisions = {}
    for _, part in ipairs(character:GetDescendants()) do
        if isBodyPart(part) then
            savedCollisions[part] = part.CanCollide
        end
    end
end

local function restoreCollisionStates()
    for part, state in pairs(savedCollisions) do
        if part and part:IsA("BasePart") then
            part.CanCollide = state
        end
    end
    savedCollisions = {}
end

local function setCollisionStates(character, state)
    for _, part in ipairs(character:GetDescendants()) do
        if isBodyPart(part) then
            part.CanCollide = state
        end
    end
end

flipToggleBtn.MouseButton1Click:Connect(function()
    isFlipped = not isFlipped
    if isFlipped then
        flipToggleBtn.Text = "倒立: 开启"
        flipToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    else
        flipToggleBtn.Text = "倒立: 关闭"
        flipToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end)

autoDistBtn.MouseButton1Click:Connect(function()
    autoDist = not autoDist
    if autoDist then
        autoDistBtn.Text = "自动距离(Beta): 开启"
        autoDistBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        distBox.Text = "自动"
        distBox.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        distBox.TextColor3 = Color3.fromRGB(200, 200, 200)
        distBox.Selectable = false
        distBox.Active = false
    else
        autoDistBtn.Text = "自动距离(Beta): 关闭"
        autoDistBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        distBox.Text = "10"
        distBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        distBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        distBox.Selectable = true
        distBox.Active = true
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
        
        local realChar = workspace:FindFirstChild(player.Name)
        if realChar then
            saveCollisionStates(realChar)
            setCollisionStates(realChar, false)
        end
    else
        toggleBtn.Text = "开启"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        restoreCollisionStates()
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

local function getNpcY(npcModel)
    local root = npcModel:FindFirstChild("HumanoidRootPart")
    if root then
        return root.Position.Y
    end
    local primary = npcModel.PrimaryPart
    if primary then
        return primary.Position.Y
    end
    return npcModel:GetPivot().Y
end

local function getPlayerHeight(playerChar)
    local hrp = playerChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return 6 end
    
    local lowestY = math.huge
    local highestY = -math.huge
    
    for _, part in ipairs(playerChar:GetDescendants()) do
        if part:IsA("BasePart") and part:IsDescendantOf(playerChar) then
            if part.Name ~= "Handle" then
                local partY = part.Position.Y
                if partY < lowestY then
                    lowestY = partY
                end
                if partY > highestY then
                    highestY = partY
                end
            end
        end
    end
    
    if lowestY == math.huge or highestY == -math.huge then
        return 6
    end
    
    return math.abs(highestY - lowestY)
end

local function findGroundBelowPosition(position, ignoreList)
    local rayOrigin = position + Vector3.new(0, 5, 0)
    local rayDirection = Vector3.new(0, -200, 0)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local filterList = {workspace:FindFirstChild(player.Name)}
    if ignoreList then
        for _, item in ipairs(ignoreList) do
            table.insert(filterList, item)
        end
    end
    raycastParams.FilterDescendantsInstances = filterList
    
    local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if rayResult then
        return rayResult.Position.Y
    end
    return nil
end

local function findOptimalHiddenPosition(npcModel, playerChar)
    local hrp = playerChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local playerHeight = getPlayerHeight(playerChar)
    local npcY = getNpcY(npcModel)
    
    local npcPos = npcModel:GetPivot()
    local npcX = npcPos.X
    local npcZ = npcPos.Z
    
    local groundY = findGroundBelowPosition(Vector3.new(npcX, npcY, npcZ), {npcModel})
    
    local finalY
    
    if groundY then
        local distanceToGround = npcY - groundY
        
        if distanceToGround < 15 and distanceToGround > 0 then
            finalY = groundY - playerHeight - 1
        else
            finalY = npcY - playerHeight - 6
        end
    else
        finalY = npcY - playerHeight - 6
    end
    
    return Vector3.new(npcX, finalY, npcZ)
end

local lastPos = nil

RunService.Heartbeat:Connect(function()
    if not isLocked then return end
    if targetName == "" then return end

    local realChar = getRealPlayerCharacter()
    if not realChar then return end
    
    local hrp = realChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targetModel = findTargetNpc(targetName)
    
    if targetModel and targetModel ~= realChar then
        local targetRoot = targetModel:FindFirstChild("HumanoidRootPart") or targetModel.PrimaryPart or targetModel:FindFirstChild("Head")
        
        if targetRoot then
            local targetCFrame = targetRoot.CFrame
            local targetForward = targetCFrame.LookVector
            local targetAngle = math.atan2(targetForward.X, -targetForward.Z)
            
            local newPos
            
            if autoDist then
                newPos = findOptimalHiddenPosition(targetModel, realChar)
                if not newPos then
                    newPos = targetRoot.Position + Vector3.new(0, -10, 0)
                end
            else
                newPos = targetRoot.Position + Vector3.new(0, -targetDist, 0)
            end
            
            lastPos = newPos
            
            hrp.CFrame = CFrame.new(newPos) * CFrame.Angles(0, targetAngle, 0)
            
            if isFlipped then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(math.pi, 0, 0)
            end
            
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end
    end
end)