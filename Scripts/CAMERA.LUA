local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

if CoreGui:FindFirstChild("CameraPartMoverUI") then
    CoreGui.CameraPartMoverUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CameraPartMoverUI"
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 335)
Frame.Position = UDim2.new(0.5, -160, 0.5, -167)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "跳杀镜头修改工具"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0.55, 0, 0, 26)
TextBox.Position = UDim2.new(0.075, 0, 0, 32)
TextBox.PlaceholderText = "输入 怪物 名称..."
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
TextBox.BorderSizePixel = 0
TextBox.TextSize = 13
TextBox.Font = Enum.Font.SourceSans
TextBox.Parent = Frame

local StepBox = Instance.new("TextBox")
StepBox.Size = UDim2.new(0.27, 0, 0, 26)
StepBox.Position = UDim2.new(0.655, 0, 0, 32)
StepBox.PlaceholderText = "步长/角度"
StepBox.Text = "1"
StepBox.TextColor3 = Color3.fromRGB(255, 255, 255)
StepBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
StepBox.BorderSizePixel = 0
StepBox.TextSize = 13
StepBox.Font = Enum.Font.SourceSans
StepBox.Parent = Frame

local function findTargetModel(name)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == name then
            return obj
        end
    end
    return nil
end

local function unbindPart(targetModel, part)
    local connectPart = nil
    for _, obj in ipairs(targetModel:GetDescendants()) do
        local isConnected = false
        if obj:IsA("JointInstance") or obj:IsA("WeldConstraint") then
            if obj.Part0 == part then
                isConnected = true
                connectPart = obj.Part1
            elseif obj.Part1 == part then
                isConnected = true
                connectPart = obj.Part0
            end
        elseif obj:IsA("Constraint") then
            if obj.Attachment0 and obj.Attachment0.Parent == part then
                isConnected = true
                if obj.Attachment1 and obj.Attachment1.Parent and obj.Attachment1.Parent ~= part then
                    connectPart = obj.Attachment1.Parent
                end
            elseif obj.Attachment1 and obj.Attachment1.Parent == part then
                isConnected = true
                if obj.Attachment0 and obj.Attachment0.Parent and obj.Attachment0.Parent ~= part then
                    connectPart = obj.Attachment0.Parent
                end
            end
        end
        if isConnected then
            obj:Destroy()
        end
    end
    
    if not connectPart then
        connectPart = targetModel.PrimaryPart
        if not connectPart then
            for _, p in ipairs(targetModel:GetDescendants()) do
                if p:IsA("BasePart") and p ~= part then
                    connectPart = p
                    break
                end
            end
        end
    end
    return connectPart
end

local function bindPart(connectPart, part)
    if connectPart and connectPart ~= part then
        local newWeld = Instance.new("WeldConstraint")
        newWeld.Part0 = connectPart
        newWeld.Part1 = part
        newWeld.Parent = part
    end
end

local SaveConfigButton = Instance.new("TextButton")
SaveConfigButton.Size = UDim2.new(0.41, 0, 0, 24)
SaveConfigButton.Position = UDim2.new(0.075, 0, 0, 62)
SaveConfigButton.Text = "保存当前镜头配置"
SaveConfigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveConfigButton.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
SaveConfigButton.BorderSizePixel = 0
SaveConfigButton.TextSize = 12
SaveConfigButton.Font = Enum.Font.SourceSansBold
SaveConfigButton.Parent = Frame

SaveConfigButton.MouseButton1Click:Connect(function()
    local modelName = TextBox.Text
    if modelName == "" then 
        warn("请输入 怪物 名称！") 
        return 
    end

    local targetModel = findTargetModel(modelName)
    if not targetModel then 
        warn("未找到 怪物：" .. modelName) 
        return 
    end

    if makefolder and isfolder then
        pcall(function()
            if not isfolder("SavedCamra") then
                makefolder("SavedCamra")
            end
        end)
    end

    local rootPart = targetModel:FindFirstChild("HumanoidRootPart")
    local refCFrame = (rootPart and rootPart:IsA("BasePart")) and rootPart.CFrame or targetModel:GetPivot()

    local cameraDataList = {}
    for _, part in ipairs(targetModel:GetDescendants()) do
        if part:IsA("BasePart") and part.Name:lower() == "camera" then
            local relCF = refCFrame:ToObjectSpace(part.CFrame)
            table.insert(cameraDataList, {
                name = part.Name,
                components = {relCF:GetComponents()}
            })
        end
    end

    local configData = {
        modelName = modelName,
        stepValue = StepBox.Text,
        cameras = cameraDataList
    }

    local filePath = "SavedCamra/" .. modelName .. ".txt"
    if writefile then
        local success, err = pcall(function()
            writefile(filePath, HttpService:JSONEncode(configData))
        end)
        
        if success then
            SaveConfigButton.Text = "保存成功"
            SaveConfigButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            task.delay(1, function()
                if SaveConfigButton and SaveConfigButton.Parent then
                    SaveConfigButton.Text = "保存当前镜头配置"
                    SaveConfigButton.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
                end
            end)
            print("配置文件已成功写入: Workspace/SavedCamra/" .. modelName .. ".txt")
        else
            warn("写入文件失败: " .. tostring(err))
        end
    else
        warn("当前 执行器 不支持 writefile 函数！")
    end
end)

local LoadConfigButton = Instance.new("TextButton")
LoadConfigButton.Size = UDim2.new(0.41, 0, 0, 24)
LoadConfigButton.Position = UDim2.new(0.515, 0, 0, 62)
LoadConfigButton.Text = "加载镜头配置"
LoadConfigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadConfigButton.BackgroundColor3 = Color3.fromRGB(180, 120, 0)
LoadConfigButton.BorderSizePixel = 0
LoadConfigButton.TextSize = 12
LoadConfigButton.Font = Enum.Font.SourceSansBold
LoadConfigButton.Parent = Frame

LoadConfigButton.MouseButton1Click:Connect(function()
    local modelName = TextBox.Text
    if modelName == "" then 
        warn("请输入要加载的 怪物 名称！") 
        return 
    end

    local filePath = "SavedCamra/" .. modelName .. ".txt"
    if readfile and isfile and isfile(filePath) then
        local success, err = pcall(function()
            local content = readfile(filePath)
            local data = HttpService:JSONDecode(content)
            
            if data then
                if data.stepValue then
                    StepBox.Text = tostring(data.stepValue)
                end
                
                local targetModel = findTargetModel(modelName)
                if targetModel and data.cameras then
                    local rootPart = targetModel:FindFirstChild("HumanoidRootPart")
                    local refCFrame = (rootPart and rootPart:IsA("BasePart")) and rootPart.CFrame or targetModel:GetPivot()
                    
                    for _, camInfo in ipairs(data.cameras) do
                        for _, part in ipairs(targetModel:GetDescendants()) do
                            if part:IsA("BasePart") and part.Name == camInfo.name then
                                local connectPart = unbindPart(targetModel, part)
                                local oldCanCollide = part.CanCollide
                                part.CanCollide = false
                                
                                local relCF = CFrame.new(unpack(camInfo.components))
                                part.CFrame = refCFrame * relCF
                                
                                part.CanCollide = oldCanCollide
                                bindPart(connectPart, part)
                                break
                            end
                        end
                    end
                else
                    warn("未找到对应的 怪物，或配置文件无 camera 数据！")
                end
            end
        end)
        
        if success then
            LoadConfigButton.Text = "加载成功"
            LoadConfigButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            task.delay(1, function()
                if LoadConfigButton and LoadConfigButton.Parent then
                    LoadConfigButton.Text = "加载镜头配置"
                    LoadConfigButton.BackgroundColor3 = Color3.fromRGB(180, 120, 0)
                end
            end)
            print("配置已成功加载并应用到 Model: " .. modelName)
        else
            warn("解析或应用配置失败: " .. tostring(err))
        end
    else
        warn("未找到对应的配置文件: " .. filePath)
    end
end)

local function moveParts(localDirection)
    local modelName = TextBox.Text
    if modelName == "" then warn("请输入 怪物 名称！") return end

    local targetModel = findTargetModel(modelName)
    if not targetModel then warn("未找到 怪物！") return end

    local stepValue = tonumber(StepBox.Text) or 1
    
    local rootPart = targetModel:FindFirstChild("HumanoidRootPart")
    local worldOffset
    if rootPart and rootPart:IsA("BasePart") then
        worldOffset = rootPart.CFrame:VectorToWorldSpace(localDirection * stepValue)
    else
        worldOffset = targetModel:GetPivot():VectorToWorldSpace(localDirection * stepValue)
    end

    local foundCount = 0
    for _, part in ipairs(targetModel:GetDescendants()) do
        if part:IsA("BasePart") and part.Name:lower() == "camera" then
            local connectPart = unbindPart(targetModel, part)
            
            local oldCanCollide = part.CanCollide
            part.CanCollide = false
            part.CFrame = part.CFrame + worldOffset
            part.CanCollide = oldCanCollide

            bindPart(connectPart, part)
            foundCount = foundCount + 1
        end
    end
    if foundCount > 0 then print("移动完成，步长: " .. stepValue) end
end

local function rotateParts(localAxis)
    local modelName = TextBox.Text
    if modelName == "" then warn("请输入 怪物 名称！") return end

    local targetModel = findTargetModel(modelName)
    if not targetModel then warn("未找到 怪物！") return end

    local stepValue = tonumber(StepBox.Text) or 15
    local radAngle = math.rad(stepValue)

    local rootPart = targetModel:FindFirstChild("HumanoidRootPart")
    local refCFrame = (rootPart and rootPart:IsA("BasePart")) and rootPart.CFrame or targetModel:GetPivot()

    local foundCount = 0
    for _, part in ipairs(targetModel:GetDescendants()) do
        if part:IsA("BasePart") and part.Name:lower() == "camera" then
            local connectPart = unbindPart(targetModel, part)
            
            local oldCanCollide = part.CanCollide
            part.CanCollide = false

            local worldAxis = refCFrame:VectorToWorldSpace(localAxis)
            local currentCF = part.CFrame
            local rotCF = CFrame.fromAxisAngle(worldAxis, radAngle)
            
            part.CFrame = CFrame.new(currentCF.Position) * rotCF * CFrame.new(-currentCF.Position) * currentCF

            part.CanCollide = oldCanCollide

            bindPart(connectPart, part)
            foundCount = foundCount + 1
        end
    end
    if foundCount > 0 then print("旋转完成，角度: " .. stepValue .. "度") end
end

local moveButtons = {
    {text = "前 (Z-)", pos = UDim2.new(0.075, 0, 0, 92), size = UDim2.new(0.26, 0, 0, 30), offset = Vector3.new(0, 0, -1)},
    {text = "上 (Y+)", pos = UDim2.new(0.37, 0, 0, 92),  size = UDim2.new(0.26, 0, 0, 30), offset = Vector3.new(0, 1, 0)},
    {text = "后 (Z+)", pos = UDim2.new(0.665, 0, 0, 92), size = UDim2.new(0.26, 0, 0, 30), offset = Vector3.new(0, 0, 1)},
    
    {text = "左 (X-)", pos = UDim2.new(0.075, 0, 0, 126), size = UDim2.new(0.26, 0, 0, 30), offset = Vector3.new(-1, 0, 0)},
    {text = "下 (Y-)", pos = UDim2.new(0.37, 0, 0, 126),  size = UDim2.new(0.26, 0, 0, 30), offset = Vector3.new(0, -1, 0)},
    {text = "右 (X+)", pos = UDim2.new(0.665, 0, 0, 126), size = UDim2.new(0.26, 0, 0, 30), offset = Vector3.new(1, 0, 0)},
}

for _, data in ipairs(moveButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = data.size
    btn.Position = data.pos
    btn.Text = data.text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    btn.BorderSizePixel = 0
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = Frame
    
    btn.MouseButton1Click:Connect(function()
        moveParts(data.offset)
    end)
end

local rotateButtons = {
    {text = "转X-", pos = UDim2.new(0.075, 0, 0, 162), size = UDim2.new(0.26, 0, 0, 30), axis = Vector3.new(-1, 0, 0)},
    {text = "转Y+", pos = UDim2.new(0.37, 0, 0, 162),  size = UDim2.new(0.26, 0, 0, 30), axis = Vector3.new(0, 1, 0)},
    {text = "转X+", pos = UDim2.new(0.665, 0, 0, 162), size = UDim2.new(0.26, 0, 0, 30), axis = Vector3.new(1, 0, 0)},
    
    {text = "转Z-", pos = UDim2.new(0.075, 0, 0, 196), size = UDim2.new(0.26, 0, 0, 30), axis = Vector3.new(0, 0, -1)},
    {text = "转Y-", pos = UDim2.new(0.37, 0, 0, 196),  size = UDim2.new(0.26, 0, 0, 30), axis = Vector3.new(0, -1, 0)},
    {text = "转Z+", pos = UDim2.new(0.665, 0, 0, 196), size = UDim2.new(0.26, 0, 0, 30), axis = Vector3.new(0, 0, 1)},
}

for _, data in ipairs(rotateButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = data.size
    btn.Position = data.pos
    btn.Text = data.text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundColor3 = Color3.fromRGB(150, 80, 0)
    btn.BorderSizePixel = 0
    btn.TextSize = 13
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = Frame
    
    btn.MouseButton1Click:Connect(function()
        rotateParts(data.axis)
    end)
end

local camera = Workspace.CurrentCamera
local player = Players.LocalPlayer
local isLocked = false
local cameraConnection = nil

local LockButton = Instance.new("TextButton")
LockButton.Size = UDim2.new(0.85, 0, 0, 28)
LockButton.Position = UDim2.new(0.075, 0, 0, 235)
LockButton.Text = "锁定镜头到 camera"
LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LockButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
LockButton.BorderSizePixel = 0
LockButton.TextSize = 13
LockButton.Font = Enum.Font.SourceSansBold
LockButton.Parent = Frame

LockButton.MouseButton1Click:Connect(function()
    isLocked = not isLocked
    if isLocked then
        local modelName = TextBox.Text
        if modelName == "" then warn("请输入 怪物 名称！") isLocked = false return end
        local targetModel = findTargetModel(modelName)
        if not targetModel then warn("未找到 怪物！") isLocked = false return end
        
        local targetPart = nil
        for _, part in ipairs(targetModel:GetDescendants()) do
            if part:IsA("BasePart") and part.Name:lower() == "camera" then
                targetPart = part
                break
            end
        end
        
        if not targetPart then warn("未找到 [camera] 部件！") isLocked = false return end
        
        camera.CameraType = Enum.CameraType.Scriptable
        cameraConnection = RunService.RenderStepped:Connect(function()
            if targetPart and targetPart.Parent then
                camera.CFrame = targetPart.CFrame
            else
                isLocked = false
                if cameraConnection then cameraConnection:Disconnect() end
                camera.CameraType = Enum.CameraType.Custom
                LockButton.Text = "锁定镜头到 camera"
                LockButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
            end
        end)
        
        LockButton.Text = "解除镜头锁定"
        LockButton.BackgroundColor3 = Color3.fromRGB(180, 100, 0)
    else
        if cameraConnection then
            cameraConnection:Disconnect()
            cameraConnection = nil
        end
        camera.CameraType = Enum.CameraType.Custom
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            camera.CameraSubject = player.Character.Humanoid
        end
        LockButton.Text = "锁定镜头到 camera"
        LockButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    end
end)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.85, 0, 0, 28)
CloseButton.Position = UDim2.new(0.075, 0, 0, 273)
CloseButton.Text = "关闭界面"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.TextSize = 13
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Parent = Frame

CloseButton.MouseButton1Click:Connect(function()
    if cameraConnection then
        cameraConnection:Disconnect()
    end
    camera.CameraType = Enum.CameraType.Custom
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        camera.CameraSubject = player.Character.Humanoid
    end
    ScreenGui:Destroy()
end)
