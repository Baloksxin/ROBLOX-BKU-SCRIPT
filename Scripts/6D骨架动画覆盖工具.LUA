local TweenService = game:GetService("TweenService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BoneReplacerUI"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 220)
Frame.Position = UDim2.new(0.5, -150, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", Frame)
Stroke.Color = Color3.fromRGB(60, 60, 60)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Frame)
Title.Text = "骨架替换工具"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 18
Title.BackgroundTransparency = 1

local function createInput(placeholder, position)
    local Box = Instance.new("TextBox", Frame)
    Box.Size = UDim2.new(0.8, 0, 0, 35)
    Box.Position = position
    Box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Box.TextColor3 = Color3.new(1, 1, 1)
    Box.PlaceholderText = placeholder
    Box.Text = ""
    Box.Font = Enum.Font.Gotham
    Box.TextSize = 14
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 6)
    Instance.new("UIPadding", Box).PaddingLeft = UDim.new(0, 10)
    return Box
end

local SourceBox = createInput("请输入源模型名称", UDim2.new(0.1, 0, 0.25, 0))
local TargetBox = createInput("请输入目标模型名称", UDim2.new(0.1, 0, 0.45, 0))

local RunButton = Instance.new("TextButton", Frame)
RunButton.Text = "执行替换"
RunButton.Size = UDim2.new(0.8, 0, 0, 40)
RunButton.Position = UDim2.new(0.1, 0, 0.7, 0)
RunButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
RunButton.TextColor3 = Color3.new(1, 1, 1)
RunButton.Font = Enum.Font.GothamBold
RunButton.TextSize = 14
Instance.new("UICorner", RunButton).CornerRadius = UDim.new(0, 6)

RunButton.MouseEnter:Connect(function()
    TweenService:Create(RunButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 140, 255)}):Play()
end)

RunButton.MouseLeave:Connect(function()
    TweenService:Create(RunButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 120, 255)}):Play()
end)

local function findModel(name)
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == name then
            return obj
        end
    end
end

local function findRootPart(model)
    return model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("RootPart")
end

local function setArchivableRecursive(obj)
    obj.Archivable = true
    for _, child in pairs(obj:GetDescendants()) do
        child.Archivable = true
    end
end

RunButton.MouseButton1Click:Connect(function()
    local sModel = findModel(SourceBox.Text)
    local tModel = findModel(TargetBox.Text)

    if sModel and tModel then
        local sRoot = findRootPart(sModel)
        local tRoot = findRootPart(tModel)

        if sRoot and tRoot then
            local sArmature = sRoot:FindFirstChild("Armature")
            if sArmature then
                local oldArmature = tRoot:FindFirstChild("Armature")
                if oldArmature then
                    oldArmature:Destroy()
                end

                setArchivableRecursive(sArmature)
                local newArmature = sArmature:Clone()
                newArmature.Parent = tRoot
            end
        end
    end
end)