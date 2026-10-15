if not isfolder("MySounds") then
    makefolder("MySounds")
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SoundReplacerGUI"
ScreenGui.Parent = game.CoreGui

local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 100, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.Text = "开关 UI"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local InfoLabel = Instance.new("TextLabel", MainFrame)
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Position = UDim2.new(0, 0, 0, 0)
InfoLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
InfoLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
InfoLabel.Text = "放入: workspace/MySounds (支持: mp3, wav, ogg, flac, aac, m4a, wma, mpeg)"
InfoLabel.Font = Enum.Font.SourceSansBold
InfoLabel.TextScaled = true

local SoundList = Instance.new("ScrollingFrame", MainFrame)
SoundList.Size = UDim2.new(0.5, 0, 0.55, 0)
SoundList.Position = UDim2.new(0, 0, 0, 30)
SoundList.AutomaticCanvasSize = Enum.AutomaticSize.XY
SoundList.ScrollBarThickness = 12
SoundList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UIListLayout", SoundList)

local FileList = Instance.new("ScrollingFrame", MainFrame)
FileList.Size = UDim2.new(0.5, 0, 0.55, 0)
FileList.Position = UDim2.new(0.5, 0, 0, 30)
FileList.AutomaticCanvasSize = Enum.AutomaticSize.XY
FileList.ScrollBarThickness = 12
FileList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UIListLayout", FileList)

local ActionFrame = Instance.new("Frame", MainFrame)
ActionFrame.Size = UDim2.new(1, 0, 0, 40)
ActionFrame.Position = UDim2.new(0, 0, 0.65, 0)
ActionFrame.BackgroundTransparency = 1

local RefreshBtn = Instance.new("TextButton", ActionFrame)
RefreshBtn.Size = UDim2.new(0.48, 0, 1, 0)
RefreshBtn.Position = UDim2.new(0.01, 0, 0, 0)
RefreshBtn.Text = "刷新数据"
RefreshBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
RefreshBtn.TextColor3 = Color3.new(1, 1, 1)

local ClearBtn = Instance.new("TextButton", ActionFrame)
ClearBtn.Size = UDim2.new(0.48, 0, 1, 0)
ClearBtn.Position = UDim2.new(0.51, 0, 0, 0)
ClearBtn.Text = "替换为空白"
ClearBtn.BackgroundColor3 = Color3.fromRGB(150, 60, 60)
ClearBtn.TextColor3 = Color3.new(1, 1, 1)

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, 0, 0, 90)
StatusLabel.Position = UDim2.new(0, 0, 0.75, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.Text = "请选择左侧音效"
StatusLabel.TextWrapped = true

local SelectedSound = nil
local validExtensions = {".mp3", ".wav", ".ogg", ".flac", ".aac", ".m4a", ".wma", ".mpeg"}

local function isValidAudio(path)
    local p = path:lower()
    for _, ext in pairs(validExtensions) do
        if p:sub(-#ext) == ext then return true end
    end
    return false
end

local function getAllFilesRecursive(dir)
    local allFiles = {}
    local success, items = pcall(listfiles, dir)
    if not success then return allFiles end
    for _, path in pairs(items) do
        if isfolder(path) then
            local subFiles = getAllFilesRecursive(path)
            for _, f in pairs(subFiles) do table.insert(allFiles, f) end
        elseif isValidAudio(path) then
            table.insert(allFiles, path)
        end
    end
    return allFiles
end

local function refreshSounds()
    SoundList:ClearAllChildren()
    Instance.new("UIListLayout", SoundList)
    local foundSounds = {}
    local services = {game:GetService("Workspace"), game:GetService("SoundService")}
    for _, service in pairs(services) do
        local success, descendants = pcall(function() return service:GetDescendants() end)
        if success then
            for _, obj in pairs(descendants) do
                if obj:IsA("Sound") then table.insert(foundSounds, obj) end
            end
        end
    end
    table.sort(foundSounds, function(a, b) return a:GetFullName():lower() < b:GetFullName():lower() end)
    for _, obj in pairs(foundSounds) do
        local btn = Instance.new("TextButton", SoundList)
        btn.Text = obj:GetFullName()
        btn.Size = UDim2.new(0, 800, 0, 30)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.MouseButton1Click:Connect(function()
            SelectedSound = obj
            StatusLabel.Text = "已选中: " .. obj:GetFullName()
        end)
    end
end

local function refreshFiles()
    FileList:ClearAllChildren()
    Instance.new("UIListLayout", FileList)
    local files = getAllFilesRecursive("MySounds")
    table.sort(files)
    for _, path in pairs(files) do
        local btn = Instance.new("TextButton", FileList)
        btn.Text = path:match("([^/]+)$")
        btn.Size = UDim2.new(0, 800, 0, 30)
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.MouseButton1Click:Connect(function()
            if SelectedSound then
                SelectedSound.SoundId = getcustomasset(path)
                StatusLabel.Text = "已替换: " .. SelectedSound.Name
            else
                StatusLabel.Text = "请先选择左侧音效！"
            end
        end)
    end
end

RefreshBtn.MouseButton1Click:Connect(function() refreshSounds() refreshFiles() end)
ClearBtn.MouseButton1Click:Connect(function()
    if SelectedSound then
        SelectedSound.SoundId = ""
        StatusLabel.Text = "已清空: " .. SelectedSound.Name
    else
        StatusLabel.Text = "请先选择左侧音效！"
    end
end)

refreshSounds()
refreshFiles()