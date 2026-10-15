local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

local function notify(title, text, duration)
    duration = duration or 3
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration,
    })
end

for _, gui in ipairs(player:WaitForChild("PlayerGui"):GetChildren()) do
    if gui:IsA("ScreenGui") and (gui.Name:match("NpcVisualSkin") or gui.Name == "BTMUI") then
        gui:Destroy()
    end
end
pcall(function()
    for _, gui in ipairs(CoreGui:GetChildren()) do
        if gui:IsA("ScreenGui") and (gui.Name:match("NpcVisualSkin") or gui.Name == "BTMUI") then
            gui:Destroy()
        end
    end
end)

local uiName = "BTMUI"

local screenGui = Instance.new("ScreenGui")
screenGui.Name = uiName
screenGui.ResetOnSpawn = false

pcall(function()
    screenGui.Parent = CoreGui
end)
if not screenGui.Parent then
    screenGui.Parent = player.PlayerGui
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 365)
mainFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 5)
corner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 24)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 5)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "BTM UI"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = titleBar

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -12, 1, -32)
content.Position = UDim2.new(0, 6, 0, 28)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, 0, 0, 14)
nameLabel.Position = UDim2.new(0, 0, 0, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = "NPC 名称"
nameLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
nameLabel.TextSize = 11
nameLabel.Font = Enum.Font.SourceSansBold
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Parent = content

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, 0, 0, 22)
textBox.Position = UDim2.new(0, 0, 0, 15)
textBox.PlaceholderText = "输入 NPC 模型名称"
textBox.Text = ""
textBox.TextColor3 = Color3.fromRGB(240, 240, 240)
textBox.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
textBox.TextSize = 11
textBox.Font = Enum.Font.SourceSans
textBox.Parent = content
Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 3)

local offsetLabel = Instance.new("TextLabel")
offsetLabel.Size = UDim2.new(0.5, 0, 0, 14)
offsetLabel.Position = UDim2.new(0, 0, 0, 41)
offsetLabel.BackgroundTransparency = 1
offsetLabel.Text = "偏移量"
offsetLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
offsetLabel.TextSize = 11
offsetLabel.Font = Enum.Font.SourceSansBold
offsetLabel.TextXAlignment = Enum.TextXAlignment.Left
offsetLabel.Parent = content

local stepFrame = Instance.new("Frame")
stepFrame.Size = UDim2.new(0.4, 0, 0, 20)
stepFrame.Position = UDim2.new(0.6, 0, 0, 40)
stepFrame.BackgroundTransparency = 1
stepFrame.Parent = content

local stepLabel = Instance.new("TextLabel")
stepLabel.Size = UDim2.new(0.4, 0, 1, 0)
stepLabel.BackgroundTransparency = 1
stepLabel.Text = "步长"
stepLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
stepLabel.TextSize = 10
stepLabel.Font = Enum.Font.SourceSans
stepLabel.TextXAlignment = Enum.TextXAlignment.Right
stepLabel.Parent = stepFrame

local stepBox = Instance.new("TextBox")
stepBox.Size = UDim2.new(0.55, 0, 1, 0)
stepBox.Position = UDim2.new(0.45, 0, 0, 0)
stepBox.Text = "0.5"
stepBox.TextColor3 = Color3.fromRGB(240, 240, 240)
stepBox.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
stepBox.TextSize = 11
stepBox.Font = Enum.Font.SourceSans
stepBox.Parent = stepFrame
Instance.new("UICorner", stepBox).CornerRadius = UDim.new(0, 3)

local currentStepSize = 0.5
stepBox.FocusLost:Connect(function()
    local val = tonumber(stepBox.Text)
    if val and val > 0 then
        currentStepSize = val
    else
        stepBox.Text = tostring(currentStepSize)
    end
end)

local function createAxisControl(posY, label, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 20)
    frame.Position = UDim2.new(0, 0, 0, posY)
    frame.BackgroundTransparency = 1
    frame.Parent = content
    
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.12, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = Color3.fromRGB(180, 180, 200)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    
    local valDisplay = Instance.new("TextLabel")
    valDisplay.Size = UDim2.new(0.18, 0, 1, 0)
    valDisplay.Position = UDim2.new(0.14, 0, 0, 0)
    valDisplay.BackgroundTransparency = 1
    valDisplay.Text = "0.00"
    valDisplay.TextColor3 = Color3.fromRGB(80, 180, 240)
    valDisplay.TextSize = 11
    valDisplay.Font = Enum.Font.SourceSansBold
    valDisplay.TextXAlignment = Enum.TextXAlignment.Left
    valDisplay.Parent = frame
    
    local leftBtn = Instance.new("TextButton")
    leftBtn.Size = UDim2.new(0.1, 0, 1, 0)
    leftBtn.Position = UDim2.new(0.38, 0, 0, 0)
    leftBtn.Text = "<"
    leftBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
    leftBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    leftBtn.TextSize = 11
    leftBtn.Font = Enum.Font.SourceSansBold
    leftBtn.Parent = frame
    Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 3)
    
    local rightBtn = Instance.new("TextButton")
    rightBtn.Size = UDim2.new(0.1, 0, 1, 0)
    rightBtn.Position = UDim2.new(0.5, 0, 0, 0)
    rightBtn.Text = ">"
    rightBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
    rightBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    rightBtn.TextSize = 11
    rightBtn.Font = Enum.Font.SourceSansBold
    rightBtn.Parent = frame
    Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 3)
    
    local val = 0
    
    local update = function(newVal)
        val = newVal
        valDisplay.Text = string.format("%.2f", val)
        callback(val)
    end
    
    leftBtn.MouseButton1Click:Connect(function()
        update(val - currentStepSize)
    end)
    
    rightBtn.MouseButton1Click:Connect(function()
        update(val + currentStepSize)
    end)
    
    return {
        Reset = function()
            update(0)
        end
    }
end

local offsetX = 0
local offsetY = 0
local offsetZ = 0

local axisX = createAxisControl(62, "X", function(v) offsetX = v end)
local axisY = createAxisControl(84, "Y", function(v) offsetY = v end)
local axisZ = createAxisControl(106, "Z", function(v) offsetZ = v end)

local audioSectionLabel = Instance.new("TextLabel")
audioSectionLabel.Size = UDim2.new(1, 0, 0, 14)
audioSectionLabel.Position = UDim2.new(0, 0, 0, 130)
audioSectionLabel.BackgroundTransparency = 1
audioSectionLabel.Text = "音频列表"
audioSectionLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
audioSectionLabel.TextSize = 11
audioSectionLabel.Font = Enum.Font.SourceSansBold
audioSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
audioSectionLabel.Parent = content

local audioListFrame = Instance.new("Frame")
audioListFrame.Size = UDim2.new(1, 0, 0, 100)
audioListFrame.Position = UDim2.new(0, 0, 0, 146)
audioListFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
audioListFrame.Parent = content
Instance.new("UICorner", audioListFrame).CornerRadius = UDim.new(0, 3)

local audioScrolling = Instance.new("ScrollingFrame")
audioScrolling.Size = UDim2.new(1, -4, 1, -4)
audioScrolling.Position = UDim2.new(0, 2, 0, 2)
audioScrolling.BackgroundTransparency = 1
audioScrolling.ScrollBarThickness = 3
audioScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
audioScrolling.Parent = audioListFrame

local audioControlFrame = Instance.new("Frame")
audioControlFrame.Size = UDim2.new(1, 0, 0, 24)
audioControlFrame.Position = UDim2.new(0, 0, 0, 250)
audioControlFrame.BackgroundTransparency = 1
audioControlFrame.Parent = content

local playSelectedBtn = Instance.new("TextButton")
playSelectedBtn.Size = UDim2.new(0.48, 0, 1, 0)
playSelectedBtn.Position = UDim2.new(0, 0, 0, 0)
playSelectedBtn.Text = "播放选中"
playSelectedBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
playSelectedBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 110)
playSelectedBtn.TextSize = 11
playSelectedBtn.Font = Enum.Font.SourceSansBold
playSelectedBtn.Parent = audioControlFrame
Instance.new("UICorner", playSelectedBtn).CornerRadius = UDim.new(0, 3)

local stopAllBtn = Instance.new("TextButton")
stopAllBtn.Size = UDim2.new(0.48, 0, 1, 0)
stopAllBtn.Position = UDim2.new(0.52, 0, 0, 0)
stopAllBtn.Text = "停止全部"
stopAllBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
stopAllBtn.BackgroundColor3 = Color3.fromRGB(160, 50, 50)
stopAllBtn.TextSize = 11
stopAllBtn.Font = Enum.Font.SourceSansBold
stopAllBtn.Parent = audioControlFrame
Instance.new("UICorner", stopAllBtn).CornerRadius = UDim.new(0, 3)

local btnFrame = Instance.new("Frame")
btnFrame.Size = UDim2.new(1, 0, 0, 28)
btnFrame.Position = UDim2.new(0, 0, 0, 278)
btnFrame.BackgroundTransparency = 1
btnFrame.Parent = content

local applyBtn = Instance.new("TextButton")
applyBtn.Size = UDim2.new(0.68, 0, 1, 0)
applyBtn.Position = UDim2.new(0, 0, 0, 0)
applyBtn.Text = "应用"
applyBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
applyBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 110)
applyBtn.TextSize = 11
applyBtn.Font = Enum.Font.SourceSansBold
applyBtn.Parent = btnFrame
Instance.new("UICorner", applyBtn).CornerRadius = UDim.new(0, 3)

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(0.28, 0, 1, 0)
resetBtn.Position = UDim2.new(0.72, 0, 0, 0)
resetBtn.Text = "重置"
resetBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
resetBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
resetBtn.TextSize = 11
resetBtn.Font = Enum.Font.SourceSansBold
resetBtn.Parent = btnFrame
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 3)

resetBtn.MouseButton1Click:Connect(function()
    axisX.Reset()
    axisY.Reset()
    axisZ.Reset()
end)

local audioList = {}
local selectedAudios = {}
local currentPlayingSounds = {}
local currentVisualNpc = nil
local followConnection = nil

local function stopAllAudio()
    for _, sound in ipairs(currentPlayingSounds) do
        pcall(function()
            sound:Stop()
            sound:Destroy()
        end)
    end
    currentPlayingSounds = {}
end

local function playSelectedAudios()
    stopAllAudio()
    
    if #selectedAudios == 0 then
        notify("音频选择", "请先选择音频", 2)
        return
    end
    
    notify("音频播放", "播放 " .. #selectedAudios .. " 个音频", 2)
    
    for _, audioData in ipairs(selectedAudios) do
        if audioData and audioData.Sound then
            local soundClone = audioData.Sound:Clone()
            soundClone.Parent = SoundService
            soundClone.Volume = audioData.Sound.Volume or 0.5
            soundClone.Looped = true
            
            pcall(function()
                soundClone:Play()
            end)
            
            table.insert(currentPlayingSounds, soundClone)
            
            soundClone.Ended:Connect(function()
                if soundClone and soundClone.Parent then
                    pcall(function()
                        soundClone:Play()
                    end)
                end
            end)
        end
    end
end

local function refreshAudioList(npcModel)
    audioList = {}
    selectedAudios = {}
    
    for _, child in ipairs(audioScrolling:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    if not npcModel then
        audioScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
        return
    end
    
    local index = 1
    for _, descendant in ipairs(npcModel:GetDescendants()) do
        if descendant:IsA("Sound") then
            local soundName = descendant.Name ~= "" and descendant.Name or "未命名音频 #" .. index
            table.insert(audioList, {
                Name = soundName,
                Sound = descendant,
                Index = index,
                Selected = false
            })
            index = index + 1
        end
    end
    
    if #audioList == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 1, 0)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "此 NPC 没有音频文件"
        emptyLabel.TextColor3 = Color3.fromRGB(140, 140, 160)
        emptyLabel.TextSize = 11
        emptyLabel.Font = Enum.Font.SourceSans
        emptyLabel.Parent = audioScrolling
        audioScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
        return
    end
    
    local yPos = 0
    for i, audioData in ipairs(audioList) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 22)
        btn.Position = UDim2.new(0, 0, 0, yPos)
        btn.Text = "[ ] " .. audioData.Name
        btn.TextColor3 = Color3.fromRGB(200, 200, 220)
        btn.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
        btn.TextSize = 11
        btn.Font = Enum.Font.SourceSans
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextTruncate = Enum.TextTruncate.AtEnd
        btn.Parent = audioScrolling
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 3)
        
        btn.MouseEnter:Connect(function()
            if not audioData.Selected then
                btn.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
            end
        end)
        btn.MouseLeave:Connect(function()
            if not audioData.Selected then
                btn.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
            end
        end)
        
        btn.MouseButton1Click:Connect(function()
            audioData.Selected = not audioData.Selected
            
            if audioData.Selected then
                btn.Text = "[X] " .. audioData.Name
                btn.BackgroundColor3 = Color3.fromRGB(0, 100, 170)
                table.insert(selectedAudios, audioData)
            else
                btn.Text = "[ ] " .. audioData.Name
                btn.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
                for j = #selectedAudios, 1, -1 do
                    if selectedAudios[j] == audioData then
                        table.remove(selectedAudios, j)
                    end
                end
            end
            
            if #selectedAudios > 0 then
                playSelectedBtn.Text = "播放选中 (" .. #selectedAudios .. ")"
            else
                playSelectedBtn.Text = "播放选中"
            end
        end)
        
        yPos = yPos + 24
    end
    
    audioScrolling.CanvasSize = UDim2.new(0, 0, 0, yPos + 2)
    playSelectedBtn.Text = "播放选中"
end

playSelectedBtn.MouseButton1Click:Connect(playSelectedAudios)
stopAllBtn.MouseButton1Click:Connect(stopAllAudio)

local function applyVisualSkin(npcName)
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        notify("失败", "玩家角色未就绪", 2)
        return
    end

    local targetNpc = nil
    for _, descendant in ipairs(Workspace:GetDescendants()) do
        if descendant:IsA("Model") and descendant.Name == npcName then
            if descendant:FindFirstChildOfClass("Humanoid") then
                targetNpc = descendant
                break
            end
        end
    end

    if not targetNpc then
        notify("失败", "未找到 NPC: " .. npcName, 3)
        return
    end

    if currentVisualNpc then
        currentVisualNpc:Destroy()
        currentVisualNpc = nil
    end
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    
    stopAllAudio()

    targetNpc.Archivable = true
    for _, obj in ipairs(targetNpc:GetDescendants()) do
        pcall(function() obj.Archivable = true end)
    end

    local cloneNpc = targetNpc:Clone()
    if not cloneNpc then
        notify("失败", "克隆 NPC 失败", 2)
        return
    end
    cloneNpc.Name = "VisualSkin_" .. player.Name

    local cloneRoot = cloneNpc:FindFirstChild("HumanoidRootPart") or cloneNpc:FindFirstChild("Head") or cloneNpc:FindFirstChildWhichIsA("BasePart")
    if not cloneRoot then
        cloneNpc:Destroy()
        notify("失败", "NPC 缺少基础部件", 2)
        return
    end
    cloneNpc.PrimaryPart = cloneRoot

    for _, part in ipairs(cloneNpc:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = false
            part.CanCollide = false
        end
    end

    local cloneHum = cloneNpc:FindFirstChildOfClass("Humanoid")
    if cloneHum then
        local animator = cloneHum:FindFirstChildOfClass("Animator")
        if not animator then animator = Instance.new("Animator", cloneHum) end
        
        task.spawn(function()
            task.wait(0.1)
            for _, desc in ipairs(targetNpc:GetDescendants()) do
                if desc:IsA("Animation") then
                    pcall(function()
                        local track = animator:LoadAnimation(desc)
                        track.Looped = true
                        track:Play()
                    end)
                end
            end
        end)
    end

    cloneNpc.Parent = Workspace
    currentVisualNpc = cloneNpc

    task.spawn(function()
        task.wait(0.3)
        refreshAudioList(targetNpc)
        if #audioList > 0 then
            notify("音频列表", "找到 " .. #audioList .. " 个音频", 3)
        end
    end)

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("Decal") then
            part.Transparency = 1
        elseif part:IsA("Accessory") then
            local handle = part:FindFirstChild("Handle")
            if handle then handle.Transparency = 1 end
        end
    end

    followConnection = RunService.RenderStepped:Connect(function()
        if not character or not character.Parent or not cloneNpc.Parent then
            if followConnection then followConnection:Disconnect() end
            return
        end
        local root = character:FindFirstChild("HumanoidRootPart")
        if root and cloneNpc.PrimaryPart then
            local offsetCFrame = CFrame.new(offsetX, offsetY, offsetZ)
            cloneNpc:SetPrimaryPartCFrame(root.CFrame * offsetCFrame)
        end
    end)

    player.CharacterAdded:Once(function()
        if currentVisualNpc then
            currentVisualNpc:Destroy()
            currentVisualNpc = nil
        end
        if followConnection then
            followConnection:Disconnect()
            followConnection = nil
        end
        stopAllAudio()
    end)

    notify("成功", "已应用 " .. npcName, 2)
end

applyBtn.MouseButton1Click:Connect(function()
    local nameInput = textBox.Text
    if nameInput ~= "" then
        pcall(function()
            applyVisualSkin(nameInput)
        end)
    else
        notify("输入错误", "请输入 NPC 名称", 2)
    end
end)
