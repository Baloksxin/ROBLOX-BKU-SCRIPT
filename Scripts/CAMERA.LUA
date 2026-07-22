local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration or 3
        })
    end)
end

if CoreGui:FindFirstChild("CameraPartMoverUI") then
    CoreGui.CameraPartMoverUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CameraPartMoverUI"
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 340, 0, 520)
Frame.Position = UDim2.new(0.5, -170, 0.5, -260)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "跳杀镜头修改工具 (多配置版)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
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

local ConfigLabel = Instance.new("TextLabel")
ConfigLabel.Size = UDim2.new(0.85, 0, 0, 20)
ConfigLabel.Position = UDim2.new(0.075, 0, 0, 62)
ConfigLabel.BackgroundTransparency = 1
ConfigLabel.Text = "当前配置名称:"
ConfigLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ConfigLabel.TextSize = 12
ConfigLabel.Font = Enum.Font.SourceSansBold
ConfigLabel.TextXAlignment = Enum.TextXAlignment.Left
ConfigLabel.Parent = Frame

local ConfigNameBox = Instance.new("TextBox")
ConfigNameBox.Size = UDim2.new(0.85, 0, 0, 26)
ConfigNameBox.Position = UDim2.new(0.075, 0, 0, 82)
ConfigNameBox.PlaceholderText = "输入配置名称..."
ConfigNameBox.Text = "默认配置"
ConfigNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfigNameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ConfigNameBox.BorderSizePixel = 0
ConfigNameBox.TextSize = 13
ConfigNameBox.Font = Enum.Font.SourceSans
ConfigNameBox.Parent = Frame

local NewConfigButton = Instance.new("TextButton")
NewConfigButton.Size = UDim2.new(0.26, 0, 0, 24)
NewConfigButton.Position = UDim2.new(0.075, 0, 0, 112)
NewConfigButton.Text = "新建配置"
NewConfigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NewConfigButton.BackgroundColor3 = Color3.fromRGB(0, 130, 180)
NewConfigButton.BorderSizePixel = 0
NewConfigButton.TextSize = 12
NewConfigButton.Font = Enum.Font.SourceSansBold
NewConfigButton.Parent = Frame

local RenameConfigButton = Instance.new("TextButton")
RenameConfigButton.Size = UDim2.new(0.26, 0, 0, 24)
RenameConfigButton.Position = UDim2.new(0.37, 0, 0, 112)
RenameConfigButton.Text = "重命名配置"
RenameConfigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RenameConfigButton.BackgroundColor3 = Color3.fromRGB(140, 100, 0)
RenameConfigButton.BorderSizePixel = 0
RenameConfigButton.TextSize = 12
RenameConfigButton.Font = Enum.Font.SourceSansBold
RenameConfigButton.Parent = Frame

local DeleteConfigButton = Instance.new("TextButton")
DeleteConfigButton.Size = UDim2.new(0.26, 0, 0, 24)
DeleteConfigButton.Position = UDim2.new(0.665, 0, 0, 112)
DeleteConfigButton.Text = "删除配置"
DeleteConfigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DeleteConfigButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
DeleteConfigButton.BorderSizePixel = 0
DeleteConfigButton.TextSize = 12
DeleteConfigButton.Font = Enum.Font.SourceSansBold
DeleteConfigButton.Parent = Frame

local ConfigListFrame = Instance.new("ScrollingFrame")
ConfigListFrame.Size = UDim2.new(0.85, 0, 0, 100)
ConfigListFrame.Position = UDim2.new(0.075, 0, 0, 140)
ConfigListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ConfigListFrame.BorderSizePixel = 0
ConfigListFrame.ScrollBarThickness = 6
ConfigListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ConfigListFrame.Parent = Frame

local ConfigListLayout = Instance.new("UIListLayout")
ConfigListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ConfigListLayout.Padding = UDim.new(0, 2)
ConfigListLayout.Parent = ConfigListFrame

local selectedConfigButton = nil
local selectedConfigName = nil

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

local function getModelConfigFolder(modelName)
    return "SavedCamra/" .. modelName
end

local function getConfigFilePath(modelName, configName)
    return getModelConfigFolder(modelName) .. "/" .. configName .. ".txt"
end

local function listConfigs(modelName)
    local configs = {}
    if not (isfolder and listfiles) then return configs end
    
    local folder = getModelConfigFolder(modelName)
    if not isfolder(folder) then return configs end
    
    for _, filePath in ipairs(listfiles(folder)) do
        local fileName = filePath:match("([^/\\]+)%.txt$")
        if fileName then
            table.insert(configs, fileName)
        end
    end
    table.sort(configs)
    return configs
end

local function migrateOldConfigs()
    if not (isfolder and listfiles and isfile and readfile and writefile and delfile and makefolder) then return end
    if not isfolder("SavedCamra") then return end
    
    for _, filePath in ipairs(listfiles("SavedCamra")) do
        if filePath:match("^SavedCamra/[^/]+%.txt$") then
            local fileName = filePath:match("([^/\\]+)%.txt$")
            if not fileName then continue end
            
            local success, content = pcall(function() return readfile(filePath) end)
            if success and content then
                local decodeSuccess, data = pcall(function() return HttpService:JSONDecode(content) end)
                if decodeSuccess and data and data.modelName then
                    local folderPath = getModelConfigFolder(data.modelName)
                    pcall(function()
                        if not isfolder(folderPath) then
                            makefolder(folderPath)
                        end
                    end)
                    local newPath = folderPath .. "/" .. fileName .. ".txt"
                    if not isfile(newPath) then
                        pcall(function()
                            writefile(newPath, content)
                            delfile(filePath)
                        end)
                    end
                end
            end
        end
    end
end

local function refreshConfigList()
    for _, child in ipairs(ConfigListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    selectedConfigButton = nil
    selectedConfigName = nil
    
    local modelName = TextBox.Text
    if modelName == "" or not (isfolder and listfiles) then
        ConfigListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        return
    end
    
    local configs = listConfigs(modelName)
    for i, configName in ipairs(configs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -6, 0, 24)
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = configName
        btn.TextSize = 12
        btn.Font = Enum.Font.SourceSans
        btn.BorderSizePixel = 0
        btn.LayoutOrder = i
        btn.Parent = ConfigListFrame
        
        btn.MouseButton1Click:Connect(function()
            if selectedConfigButton and selectedConfigButton.Parent then
                selectedConfigButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            end
            selectedConfigButton = btn
            selectedConfigName = configName
            btn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
            ConfigNameBox.Text = configName
        end)
    end
    
    local totalHeight = #configs * 26
    ConfigListFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight, 100))
end

TextBox.FocusLost:Connect(function()
    refreshConfigList()
end)

NewConfigButton.MouseButton1Click:Connect(function()
    local modelName = TextBox.Text
    local configName = ConfigNameBox.Text
    if modelName == "" then
        notify("提示", "请输入 怪物 名称！", 3)
        return
    end
    if configName == "" then
        notify("提示", "请输入配置名称！", 3)
        return
    end
    
    if makefolder and isfolder then
        local folder = getModelConfigFolder(modelName)
        pcall(function()
            if not isfolder("SavedCamra") then makefolder("SavedCamra") end
            if not isfolder(folder) then makefolder(folder) end
        end)
    end
    
    local filePath = getConfigFilePath(modelName, configName)
    if writefile then
        local emptyData = {
            modelName = modelName,
            stepValue = StepBox.Text,
            cameras = {}
        }
        pcall(function()
            writefile(filePath, HttpService:JSONEncode(emptyData))
        end)
        notify("成功", "配置 '" .. configName .. "' 已创建！", 3)
        refreshConfigList()
    else
        notify("错误", "当前执行器不支持 writefile 函数！", 3)
    end
end)

RenameConfigButton.MouseButton1Click:Connect(function()
    local modelName = TextBox.Text
    local oldName = selectedConfigName
    local newName = ConfigNameBox.Text
    
    if modelName == "" then
        notify("提示", "请输入 怪物 名称！", 3)
        return
    end
    if oldName == nil or oldName == "" then
        notify("提示", "请先从列表中点击选择一个要重命名的配置！", 3)
        return
    end
    if newName == "" then
        notify("提示", "请在输入框输入新的配置名称！", 3)
        return
    end
    if newName == oldName then
        notify("提示", "新名称与旧名称相同，无需重命名！", 3)
        return
    end
    
    if not (isfile and readfile and writefile and delfile) then
        notify("错误", "当前执行器不支持文件操作！", 3)
        return
    end
    
    local oldPath = getConfigFilePath(modelName, oldName)
    local newPath = getConfigFilePath(modelName, newName)
    
    if not isfile(oldPath) then
        notify("错误", "未找到要重命名的配置！", 3)
        return
    end
    
    if isfile(newPath) then
        notify("错误", "新名称已存在，请换其他名称！", 3)
        return
    end
    
    local success, err = pcall(function()
        local content = readfile(oldPath)
        local data = HttpService:JSONDecode(content)
        writefile(newPath, HttpService:JSONEncode(data))
        delfile(oldPath)
    end)
    
    if success then
        notify("成功", "配置已重命名为 '" .. newName .. "'！", 3)
        selectedConfigName = newName
        refreshConfigList()
    else
        notify("错误", "重命名失败: " .. tostring(err), 3)
    end
end)

DeleteConfigButton.MouseButton1Click:Connect(function()
    local modelName = TextBox.Text
    local configName = ConfigNameBox.Text
    if modelName == "" or configName == "" then
        notify("提示", "请先从列表选择要删除的配置！", 3)
        return
    end
    
    if not (isfile and delfile) then
        notify("错误", "当前执行器不支持文件操作！", 3)
        return
    end
    
    local filePath = getConfigFilePath(modelName, configName)
    if not isfile(filePath) then
        notify("错误", "未找到该配置文件！", 3)
        return
    end
    
    local success = pcall(function()
        delfile(filePath)
    end)
    
    if success then
        notify("成功", "配置 '" .. configName .. "' 已删除！", 3)
        ConfigNameBox.Text = ""
        selectedConfigName = nil
        refreshConfigList()
    else
        notify("错误", "删除失败！", 3)
    end
end)

local SaveConfigButton = Instance.new("TextButton")
SaveConfigButton.Size = UDim2.new(0.41, 0, 0, 26)
SaveConfigButton.Position = UDim2.new(0.075, 0, 0, 248)
SaveConfigButton.Text = "保存当前镜头配置"
SaveConfigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SaveConfigButton.BackgroundColor3 = Color3.fromRGB(80, 80, 180)
SaveConfigButton.BorderSizePixel = 0
SaveConfigButton.TextSize = 12
SaveConfigButton.Font = Enum.Font.SourceSansBold
SaveConfigButton.Parent = Frame

SaveConfigButton.MouseButton1Click:Connect(function()
    local modelName = TextBox.Text
    local configName = ConfigNameBox.Text
    if modelName == "" then 
        notify("提示", "请输入 怪物 名称！", 3)
        return 
    end
    if configName == "" then
        notify("提示", "请输入配置名称！", 3)
        return
    end

    local targetModel = findTargetModel(modelName)
    if not targetModel then 
        notify("错误", "未找到 怪物：" .. modelName, 3)
        return 
    end

    if makefolder and isfolder then
        pcall(function()
            if not isfolder("SavedCamra") then makefolder("SavedCamra") end
            local folder = getModelConfigFolder(modelName)
            if not isfolder(folder) then makefolder(folder) end
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

    local filePath = getConfigFilePath(modelName, configName)
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
            notify("成功", "镜头配置已成功保存！", 3)
            print("配置文件已成功写入: " .. filePath)
            refreshConfigList()
        else
            warn("写入文件失败: " .. tostring(err))
            notify("错误", "写入文件失败: " .. tostring(err), 3)
        end
    else
        warn("当前 执行器 不支持 writefile 函数！")
        notify("错误", "当前执行器不支持 writefile 函数！", 3)
    end
end)

local LoadConfigButton = Instance.new("TextButton")
LoadConfigButton.Size = UDim2.new(0.41, 0, 0, 26)
LoadConfigButton.Position = UDim2.new(0.515, 0, 0, 248)
LoadConfigButton.Text = "加载镜头配置"
LoadConfigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LoadConfigButton.BackgroundColor3 = Color3.fromRGB(180, 120, 0)
LoadConfigButton.BorderSizePixel = 0
LoadConfigButton.TextSize = 12
LoadConfigButton.Font = Enum.Font.SourceSansBold
LoadConfigButton.Parent = Frame

LoadConfigButton.MouseButton1Click:Connect(function()
    local modelName = TextBox.Text
    local configName = ConfigNameBox.Text
    if modelName == "" then 
        notify("提示", "请输入 怪物 名称！", 3)
        return 
    end
    if configName == "" then
        notify("提示", "请输入或选择配置名称！", 3)
        return
    end

    local filePath = getConfigFilePath(modelName, configName)
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
                    notify("警告", "未找到对应的 怪物，或配置文件无 camera 数据！", 3)
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
            notify("成功", "配置 '" .. configName .. "' 已成功加载并应用！", 3)
            print("配置已成功加载并应用到 Model: " .. modelName)
        else
            warn("解析或应用配置失败: " .. tostring(err))
            notify("错误", "解析或应用配置失败: " .. tostring(err), 3)
        end
    else
        warn("未找到对应的配置文件: " .. filePath)
        notify("错误", "未找到对应的配置文件！", 3)
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
    {text = "前 (Z-)", pos = UDim2.new(0.075, 0, 0, 282), size = UDim2.new(0.26, 0, 0, 30), offset = Vector3.new(0, 0, -1)},
    {text = "上 (Y+)", pos = UDim2.new(0.37, 0, 0, 282),  size = UDim2.new(0.26, 0, 0, 30), offset = Vector3.new(0, 1, 0)},
    {text = "后 (Z+)", pos = UDim2.new(0.665, 0, 0, 282), size = UDim2.new(0.26, 0, 0, 30), offset = Vector3.new(0, 0, 1)},
    
    {text = "左 (X-)", pos = UDim2.new(0.075, 0, 0, 316), size = UDim2.new(0.26, 0, 0, 30), offset = Vector3.new(-1, 0, 0)},
    {text = "下 (Y-)", pos = UDim2.new(0.37, 0, 0, 316),  size = UDim2.new(0.26, 0, 0, 30), offset = Vector3.new(0, -1, 0)},
    {text = "右 (X+)", pos = UDim2.new(0.665, 0, 0, 316), size = UDim2.new(0.26, 0, 0, 30), offset = Vector3.new(1, 0, 0)},
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
    {text = "转X-", pos = UDim2.new(0.075, 0, 0, 352), size = UDim2.new(0.26, 0, 0, 30), axis = Vector3.new(-1, 0, 0)},
    {text = "转Y+", pos = UDim2.new(0.37, 0, 0, 352),  size = UDim2.new(0.26, 0, 0, 30), axis = Vector3.new(0, 1, 0)},
    {text = "转X+", pos = UDim2.new(0.665, 0, 0, 352), size = UDim2.new(0.26, 0, 0, 30), axis = Vector3.new(1, 0, 0)},
    
    {text = "转Z-", pos = UDim2.new(0.075, 0, 0, 386), size = UDim2.new(0.26, 0, 0, 30), axis = Vector3.new(0, 0, -1)},
    {text = "转Y-", pos = UDim2.new(0.37, 0, 0, 386),  size = UDim2.new(0.26, 0, 0, 30), axis = Vector3.new(0, -1, 0)},
    {text = "转Z+", pos = UDim2.new(0.665, 0, 0, 386), size = UDim2.new(0.26, 0, 0, 30), axis = Vector3.new(0, 0, 1)},
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
LockButton.Position = UDim2.new(0.075, 0, 0, 425)
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
CloseButton.Position = UDim2.new(0.075, 0, 0, 463)
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

migrateOldConfigs()
refreshConfigList()
