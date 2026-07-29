local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local currentSession = tick()
_G.SecCameraSession = currentSession

local oldGui = CoreGui:FindFirstChild("SecCameraSelectorGui")
if oldGui then
    oldGui:Destroy()
end

local oldBlur = Lighting:FindFirstChild("SecCameraBlur")
if oldBlur then
    oldBlur:Destroy()
end

local blurEffect = Instance.new("BlurEffect")
blurEffect.Name = "SecCameraBlur"
blurEffect.Size = 0
blurEffect.Parent = Lighting

local colorBlindEffect = Lighting:FindFirstChild("RandomColorBlindnessEffect")
if not colorBlindEffect then
    colorBlindEffect = Instance.new("ColorCorrectionEffect")
    colorBlindEffect.Name = "RandomColorBlindnessEffect"
    colorBlindEffect.Enabled = false
    colorBlindEffect.Parent = Lighting
end

local chairList = {}
local function collectChairs()
    chairList = {}
    for _, desc in ipairs(Workspace:GetDescendants()) do
        if desc.Name == "Chair" then
            local exists = false
            for _, c in ipairs(chairList) do if c == desc then exists = true break end end
            if not exists then table.insert(chairList, desc) end
        end
    end
end
collectChairs()

local cameraList = {}
for _, desc in ipairs(Workspace:GetDescendants()) do
    if desc.Name == "SecCamera" and desc:IsA("BasePart") then
        local exists = false
        for _, c in ipairs(cameraList) do if c == desc then exists = true break end end
        if not exists then table.insert(cameraList, desc) end
    end
end

if #cameraList == 0 then
    return
end

local currentCameraIndex = 1

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SecCameraSelectorGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 99999

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(screenGui)
    elseif protectgui then
        protectgui(screenGui)
    end
end)
screenGui.Parent = CoreGui

local crtOverlay = Instance.new("Frame")
crtOverlay.Name = "CRTOverlay"
crtOverlay.Size = UDim2.new(1, 0, 1, 0)
crtOverlay.BackgroundTransparency = 1
crtOverlay.Visible = false
crtOverlay.ZIndex = 1
crtOverlay.Parent = screenGui

local crtTint = Instance.new("Frame")
crtTint.Name = "Tint"
crtTint.Size = UDim2.new(1, 0, 1, 0)
crtTint.BackgroundColor3 = Color3.fromRGB(30, 60, 40)
crtTint.BackgroundTransparency = 0.85
crtTint.BorderSizePixel = 0
crtTint.ZIndex = 1
crtTint.Parent = crtOverlay

local darknessFrame = Instance.new("Frame")
darknessFrame.Name = "DarknessFrame"
darknessFrame.Size = UDim2.new(1, 0, 1, 0)
darknessFrame.BackgroundColor3 = Color3.new(0, 0, 0)
darknessFrame.BackgroundTransparency = 1 
darknessFrame.BorderSizePixel = 0
darknessFrame.ZIndex = 2
darknessFrame.Parent = crtOverlay

local scanlineContainer = Instance.new("Frame")
scanlineContainer.Name = "Scanlines"
scanlineContainer.Size = UDim2.new(1, 0, 1, 0)
scanlineContainer.BackgroundTransparency = 1
scanlineContainer.ZIndex = 3
scanlineContainer.Parent = crtOverlay

for i = 0, 100, 3 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0, i * 10)
    line.BackgroundColor3 = Color3.new(0, 0, 0)
    line.BackgroundTransparency = 0.65
    line.BorderSizePixel = 0
    line.Parent = scanlineContainer
end

local vignette = Instance.new("UIStroke")
vignette.Thickness = 40
vignette.Color = Color3.new(0, 0, 0)
vignette.Parent = crtOverlay

local crackContainer = Instance.new("Folder")
crackContainer.Name = "CrackContainer"
crackContainer.Parent = crtOverlay

local function createCrackLine(pos, size, rotation)
    local crack = Instance.new("Frame")
    crack.Size = size
    crack.Position = pos
    crack.Rotation = rotation
    crack.BackgroundColor3 = Color3.new(0, 0, 0)
    crack.BorderSizePixel = 0
    crack.ZIndex = 5
    crack.Parent = crackContainer
    return crack
end

local stage1Cracks = {
    createCrackLine(UDim2.new(0.5, -50, 0.4, 0), UDim2.new(0, 120, 0, 3), 25),
    createCrackLine(UDim2.new(0.45, 0, 0.45, 0), UDim2.new(0, 90, 0, 2), -45),
    createCrackLine(UDim2.new(0.5, 0, 0.5, 0), UDim2.new(0, 150, 0, 3), 80),
}

local stage2Cracks = {
    createCrackLine(UDim2.new(0.3, 0, 0.2, 0), UDim2.new(0, 180, 0, 2), 15),
    createCrackLine(UDim2.new(0.6, 0, 0.3, 0), UDim2.new(0, 140, 0, 3), -60),
    createCrackLine(UDim2.new(0.25, 0, 0.6, 0), UDim2.new(0, 200, 0, 2), 40),
    createCrackLine(UDim2.new(0.5, 0, 0.7, 0), UDim2.new(0, 160, 0, 3), -20),
}

local stage3Cracks = {
    createCrackLine(UDim2.new(0.1, 0, 0.1, 0), UDim2.new(0, 250, 0, 3), 55),
    createCrackLine(UDim2.new(0.7, 0, 0.6, 0), UDim2.new(0, 220, 0, 2), -30),
    createCrackLine(UDim2.new(0.15, 0, 0.8, 0), UDim2.new(0, 300, 0, 3), -15),
    createCrackLine(UDim2.new(0.6, 0, 0.85, 0), UDim2.new(0, 240, 0, 2), 70),
    createCrackLine(UDim2.new(0.05, 0, 0.4, 0), UDim2.new(0, 180, 0, 3), 10),
}

local function setCracksVisible(list, visible)
    for _, c in ipairs(list) do c.Visible = visible end
end
setCracksVisible(stage1Cracks, false)
setCracksVisible(stage2Cracks, false)
setCracksVisible(stage3Cracks, false)

local fatigueGui = Instance.new("Frame")
fatigueGui.Name = "FatigueGui"
fatigueGui.Size = UDim2.new(1, 0, 1, 0)
fatigueGui.BackgroundColor3 = Color3.new(0, 0, 0)
fatigueGui.BackgroundTransparency = 0
fatigueGui.Visible = false
fatigueGui.ZIndex = 100
fatigueGui.Parent = screenGui

local fatigueText = Instance.new("TextLabel")
fatigueText.Size = UDim2.new(1, 0, 1, 0)
fatigueText.BackgroundTransparency = 1
fatigueText.Text = "眼部疲劳"
fatigueText.TextColor3 = Color3.fromRGB(255, 0, 0)
fatigueText.TextSize = 72
fatigueText.Font = Enum.Font.SourceSansBold
fatigueText.ZIndex = 101
fatigueText.Parent = fatigueGui

local leftButton = Instance.new("TextButton")
leftButton.Name = "LeftButton"
leftButton.Size = UDim2.new(0, 160, 0, 75)
leftButton.Position = UDim2.new(0, 30, 0.8, -35)
leftButton.Text = "< 上一个相机"
leftButton.TextSize = 18
leftButton.TextColor3 = Color3.new(1, 1, 1)
leftButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
leftButton.Visible = false
leftButton.ZIndex = 10
leftButton.Parent = screenGui

local leftCorner = Instance.new("UICorner")
leftCorner.CornerRadius = UDim.new(0, 12)
leftCorner.Parent = leftButton

local rightButton = Instance.new("TextButton")
rightButton.Name = "RightButton"
rightButton.Size = UDim2.new(0, 160, 0, 75)
rightButton.Position = UDim2.new(1, -190, 0.8, -35)
rightButton.Text = "下一个相机 >"
rightButton.TextSize = 18
rightButton.TextColor3 = Color3.new(1, 1, 1)
rightButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
rightButton.Visible = false
rightButton.ZIndex = 10
rightButton.Parent = screenGui

local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 12)
rightCorner.Parent = rightButton

local exitButton = Instance.new("TextButton")
exitButton.Name = "ExitButton"
exitButton.Size = UDim2.new(0, 180, 0, 50)
exitButton.Position = UDim2.new(0.5, -90, 0.1, 0)
exitButton.Text = "✕ 退出查看"
exitButton.TextSize = 20
exitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
exitButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
exitButton.Visible = false
exitButton.ZIndex = 10
exitButton.Parent = screenGui

local exitCorner = Instance.new("UICorner")
exitCorner.CornerRadius = UDim.new(0, 12)
exitCorner.Parent = exitButton

local hasTriggered = false
local canTrigger = true 
local watchDuration = 0 
local myopiaStage = 0
local hasGivenContactLenses = false

local function giveContactLenses()
    if hasGivenContactLenses then return end
    local backpack = player:FindFirstChildOfClass("Backpack")
    if not backpack then return end
    
    hasGivenContactLenses = true
    
    local tool = Instance.new("Tool")
    tool.Name = "隐形眼镜"
    tool.ToolTip = "隐形眼镜，但好像有点不适配"
    tool.RequiresHandle = false
    
    tool.Activated:Connect(function()
        myopiaStage = 1
        if blurEffect then blurEffect.Size = 10 end
        
        if colorBlindEffect then
            colorBlindEffect.Enabled = true
            local randType = math.random(1, 4)
            if randType == 1 then
                colorBlindEffect.Saturation = -0.35
                colorBlindEffect.TintColor = Color3.fromRGB(210, 190, 140)
            elseif randType == 2 then
                colorBlindEffect.Saturation = -0.35
                colorBlindEffect.TintColor = Color3.fromRGB(170, 210, 220)
            elseif randType == 3 then
                colorBlindEffect.Saturation = -1
                colorBlindEffect.TintColor = Color3.fromRGB(240, 240, 240)
            else
                colorBlindEffect.Saturation = -0.6
                colorBlindEffect.TintColor = Color3.fromRGB(200, 170, 200)
            end
        end
        
        tool:Destroy()
    end)
    
    tool.Parent = backpack
end

local function applyCurrentCamera()
    local target = cameraList[currentCameraIndex]
    if not target then return end
    camera.CameraType = Enum.CameraType.Scriptable
    camera.CFrame = target.CFrame
    rightButton.Text = "相机 [" .. currentCameraIndex .. "/" .. #cameraList .. "] >"
end

local function resetCamera()
    camera.CameraType = Enum.CameraType.Custom
    local char = player.Character
    if char then
        camera.CameraSubject = char:FindFirstChildOfClass("Humanoid")
    end
end

local function hideButtons()
    leftButton.Visible = false
    rightButton.Visible = false
    exitButton.Visible = false
    crtOverlay.Visible = false
    fatigueGui.Visible = false
    darknessFrame.BackgroundTransparency = 1
    setCracksVisible(stage1Cracks, false)
    setCracksVisible(stage2Cracks, false)
    setCracksVisible(stage3Cracks, false)
end

rightButton.MouseButton1Click:Connect(function()
    if not hasTriggered then return end
    currentCameraIndex = currentCameraIndex + 1
    if currentCameraIndex > #cameraList then currentCameraIndex = 1 end
    applyCurrentCamera()
end)

leftButton.MouseButton1Click:Connect(function()
    if not hasTriggered then return end
    currentCameraIndex = currentCameraIndex - 1
    if currentCameraIndex < 1 then currentCameraIndex = #cameraList end
    applyCurrentCamera()
end)

exitButton.MouseButton1Click:Connect(function()
    resetCamera()
    hideButtons()
    hasTriggered = false
    watchDuration = 0
    canTrigger = false 
end)

local function checkIfOnAnyChair()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end
    if #chairList == 0 then collectChairs() end
    if #chairList == 0 then return false end
    
    local hrp = character.HumanoidRootPart
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = chairList
    raycastParams.FilterType = Enum.RaycastFilterType.Include
    raycastParams.IgnoreWater = true
    
    local rayResult = Workspace:Raycast(hrp.Position, Vector3.new(0, -6, 0), raycastParams)
    if rayResult then return true end
    
    for _, chairModel in ipairs(chairList) do
        local chairPos = nil
        pcall(function() chairPos = chairModel:GetPivot().Position end)
        if not chairPos then
            local primary = chairModel.PrimaryPart or chairModel:FindFirstChildWhichIsA("BasePart", true)
            if primary then chairPos = primary.Position end
        end
        if chairPos then
            local horizontalDist = Vector2.new(hrp.Position.X - chairPos.X, hrp.Position.Z - chairPos.Z).Magnitude
            local heightDiff = hrp.Position.Y - chairPos.Y
            if horizontalDist <= 4 and heightDiff >= -2 and heightDiff <= 6 then
                return true
            end
        end
    end
    return false
end

local function bindCharacterDeath(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.Died:Connect(function()
            resetCamera()
            hideButtons()
            if blurEffect then blurEffect.Size = 0 end
            if colorBlindEffect then colorBlindEffect.Enabled = false end
            
            local backpack = player:FindFirstChildOfClass("Backpack") or char:FindFirstChildOfClass("Backpack")
            if backpack then
                local lens = backpack:FindFirstChild("隐形眼镜")
                if lens then lens:Destroy() end
            end
            
            hasTriggered = false
            watchDuration = 0
            myopiaStage = 0
            hasGivenContactLenses = false
            canTrigger = true
        end)
    end
end

if player.Character then
    bindCharacterDeath(player.Character)
end
player.CharacterAdded:Connect(bindCharacterDeath)

task.spawn(function()
    while true do
        task.wait(0.2)
        
        if _G.SecCameraSession ~= currentSession then
            break
        end
        
        local isOnChair = checkIfOnAnyChair()
        
        if not hasTriggered then
            if not isOnChair then
                canTrigger = true 
            elseif isOnChair and canTrigger then
                hasTriggered = true 
                watchDuration = 0
                leftButton.Visible = true
                rightButton.Visible = true
                exitButton.Visible = true
                crtOverlay.Visible = true
                darknessFrame.BackgroundTransparency = 1
                applyCurrentCamera()
            end
        else
            if not crtOverlay.Visible then
                hasTriggered = false
                watchDuration = 0
            else
                watchDuration = watchDuration + 0.2
                
                local darkFactor = math.clamp(watchDuration / 22, 0, 0.85)
                darknessFrame.BackgroundTransparency = 1 - darkFactor
                
                if watchDuration >= 6 and watchDuration < 12 then
                    setCracksVisible(stage1Cracks, true)
                elseif watchDuration >= 12 and watchDuration < 18 then
                    setCracksVisible(stage2Cracks, true)
                elseif watchDuration >= 18 then
                    setCracksVisible(stage3Cracks, true)
                end
                
                if watchDuration >= 22 then
                    myopiaStage = math.clamp(myopiaStage + 1, 1, 3)
                    
                    local char = player.Character
                    if char then
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            humanoid.Health = math.max(0, humanoid.Health - 25)
                        end
                    end
                    
                    leftButton.Visible = false
                    rightButton.Visible = false
                    exitButton.Visible = false
                    fatigueGui.Visible = true
                    
                    if blurEffect then
                        if myopiaStage == 1 then
                            blurEffect.Size = 10
                        elseif myopiaStage == 2 then
                            blurEffect.Size = 20
                            giveContactLenses()
                        elseif myopiaStage >= 3 then
                            blurEffect.Size = 34
                            giveContactLenses()
                        end
                    end
                    
                    task.wait(2.5)
                    resetCamera()
                    hideButtons()
                    hasTriggered = false
                    watchDuration = 0
                    canTrigger = false 
                end
            end
        end
    end
end)
