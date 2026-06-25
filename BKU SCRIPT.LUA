local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/BK-PE-SCRIPT/refs/heads/main/UI.txt"))()
local LPlr = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local RS, UIS, Light = game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("Lighting")
local Cam = workspace.CurrentCamera

local initSpeed = 16
if LPlr.Character and LPlr.Character:FindFirstChild("Humanoid") then
    initSpeed = LPlr.Character.Humanoid.WalkSpeed
end

local Config = { Speed = initSpeed, FOV = Cam.FieldOfView, SpeedEn = false, FOVEn = false, InfJump = false, Noclip = false, NightVis = false, SCPHighlight = false, InfStamina = false, ThirdPerson = false, MonkeyESP = false, AutoGold = false, EarGameESP = false, ScrapESP = false, CardESP = false, AutoEarMoney = false, RecyclerESP = false }
local Orig = { FOV = Cam.FieldOfView, Bright = Light.Brightness, Ambient = Light.Ambient, Clock = Light.ClockTime, Speed = initSpeed }
local Window = OrionLib:MakeWindow({Name = "BKU HUB BY BALOKSXIN", HidePremium = true, SaveConfig = false, IntroText = "BKU HUB"})

OrionLib:MakeNotification({Name = "BKU HUB", Content = "辛巴爸爸卢比呀", Time = 3})

local t1 = Window:MakeTab({Name = "信息", Icon = "rbxassetid://77348087165494"})
t1:AddSection({Name = "信息"})
t1:AddLabel("使用者: " .. LPlr.DisplayName)
t1:AddLabel("执行器: " .. ((identifyexecutor and identifyexecutor()) or "未知"))
t1:AddLabel("游戏 ID (PlaceId): " .. tostring(game.PlaceId))
t1:AddLabel("服务器 ID (JobId): " .. (game.JobId ~= "" and game.JobId or "单人/私服"))
t1:AddButton({Name = "点击复制服务器 ID", Callback = function() setclipboard(game.JobId) end})
t1:AddButton({Name = "复制作者KS ID", Callback = function() setclipboard("Baloksxin") end})

local t2 = Window:MakeTab({Name = "通用", Icon = "rbxassetid://77348087165494"})
t2:AddSection({Name = "角色属性修改"})
t2:AddTextbox({Name = "修改速度值", Default = tostring(Orig.Speed), Callback = function(v) Config.Speed = tonumber(v) or Orig.Speed end})
t2:AddToggle({Name = "开启速度修改", Callback = function(v) Config.SpeedEn = v if not v and LPlr.Character:FindFirstChild("Humanoid") then LPlr.Character.Humanoid.WalkSpeed = Orig.Speed end end})
t2:AddTextbox({Name = "修改FOV值", Default = tostring(Orig.FOV), Callback = function(v) Config.FOV = tonumber(v) or Orig.FOV end})
t2:AddToggle({Name = "开启 FOV 修改", Callback = function(v) Config.FOVEn = v if not v then Cam.FieldOfView = Orig.FOV end end})
t2:AddToggle({Name = "第三人称", Callback = function(v) Config.ThirdPerson = v end})
t2:AddToggle({Name = "无限跳跃", Callback = function(v) Config.InfJump = v end})
t2:AddToggle({Name = "穿墙模式 (Noclip)", Callback = function(v) Config.Noclip = v end})
t2:AddToggle({Name = "夜视模式", Callback = function(v) Config.NightVis = v if not v then Light.Brightness, Light.Ambient, Light.ClockTime = Orig.Bright, Orig.Ambient, Orig.Clock end end})
t2:AddSection({Name = "工具"})
t2:AddButton({Name = "手机版Shiftlock", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/Scripts/MobileShiftlock.LUA"))() end})
t2:AddButton({Name = "Infinite Yield", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end})
t2:AddButton({Name = "飞行 GUI", Callback = function() loadstring(game:HttpGet("https://github.com/MiniCapy/scripts/raw/refs/heads/main/fly%20GUI"))() end})
t2:AddButton({Name = "R15动作脚本", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Gazer-Ha/Free-emote/refs/heads/main/Delta%20mad%20stuffs"))() end})

local t3 = Window:MakeTab({Name = "DOORS", Icon = "rbxassetid://77348087165494"})
t3:AddButton({Name = "Velocity X", Callback = function() loadstring(game:HttpGet("https://velocityloader.vercel.app/"))() end})
t3:AddButton({Name = "OP实体生成器", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/althan99/doors-entity-spawner/main/Script"))() end})

local t4 = Window:MakeTab({Name = "Forsaken", Icon = "rbxassetid://77348087165494"})
t4:AddButton({Name = "Byby Hub", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/Edulucas2013/Byby-hub/refs/heads/main/Forsaken%20byby%20hub'))() end})

local t5 = Window:MakeTab({Name = "自然灾害幸存", Icon = "rbxassetid://77348087165494"})
t5:AddButton({Name = "NDS HUB", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/KaterHub-Inc/NaturalDisasterSurvival/refs/heads/main/main.lua"))() end})
t5:AddButton({Name = "Super Ring Parts V4", Callback = function() loadstring(game:HttpGet("https://rscripts.net/raw/super-ring-parts-v4-by-lukas_1741980981842_td0ummjymf.txt",true))() end})

local t6 = Window:MakeTab({Name = "Blox Fruits", Icon = "rbxassetid://77348087165494"})
t6:AddButton({Name = "4479Hub", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/4479cantcode/4479Hub/refs/heads/main/Script.lua"))() end})

local t7 = Window:MakeTab({Name = "Rooms&Doors", Icon = "rbxassetid://77348087165494"})
t7:AddButton({Name = "Xera Hub", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NobodyOrIdk/XeraHub/main/main.lua"))() end})

local t8 = Window:MakeTab({Name = "逃离海啸，获得脑腐", Icon = "rbxassetid://77348087165494"})
t8:AddButton({Name = "1", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptify12/EscapeTsunami/main/KeySystem.lua", true))() end})

local t9 = Window:MakeTab({Name = "偷走脑腐", Icon = "rbxassetid://77348087165494"})
t9:AddButton({Name = "1", Callback = function() loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/fcc63f5f04efa9a6a85d6f16a179b870.lua"))() end})

local t10 = Window:MakeTab({Name = "疯狂电梯", Icon = "rbxassetid://77348087165494"})
t10:AddButton({Name = "免费工具", Callback = function() loadstring(game:HttpGet(('https://pastebin.com/raw/vE8WMLit'),true))() end})

local t11 = Window:MakeTab({Name = "Fish It", Icon = "rbxassetid://77348087165494"})
t11:AddButton({Name = "1", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/dilleron964/Fish-It/main/Fish-It.lua'))() end})

local t12 = Window:MakeTab({Name = "内脏与黑火药", Icon = "rbxassetid://77348087165494"})
t12:AddButton({Name = "Katchi Hub", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/XaviscoZ/roblox/refs/heads/main/g%26b.lua"))() end})

local t13 = Window:MakeTab({Name = "森林中的99夜", Icon = "rbxassetid://77348087165494"})
t13:AddButton({Name = "UNPERFORMED HUB", Callback = function() loadstring(game:HttpGet("https://api.junkie-development.de/api/v1/luascripts/public/6ed3b0b29cae165a5df389c3650171583312f6baeaf622f2330521e9c340436c/download"))() end})

local t14 = Window:MakeTab({Name = "FNAF:永恒之夜", Icon = "rbxassetid://77348087165494"})
t14:AddButton({Name = "1", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Snipez-Dev/Rbx-Scripts/refs/heads/main/Eternal%20Nights"))() end})

local t15 = Window:MakeTab({Name = "种植花园", Icon = "rbxassetid://77348087165494"})
t15:AddButton({Name = "Zap Hub", Callback = function() loadstring(game:HttpGet('https://zaphub.xyz/Exec'))() end})

local t16 = Window:MakeTab({Name = "莱辛顿和康科德", Icon = "rbxassetid://77348087165494"})
t16:AddButton({Name = "1", Callback = function() loadstring(game:HttpGet("https://rawscripts.net/raw/Lexington-and-Concord-LC-75016"))() end})

local t17 = Window:MakeTab({Name = "SCP:3199示范", Icon = "rbxassetid://77348087165494"})
t17:AddToggle({Name = "SCP-3199高亮", Callback = function(v) Config.SCPHighlight = v if not v then for _,o in pairs(workspace:GetChildren()) do if o:FindFirstChild("SCP3199_ESP") then o.SCP3199_ESP:Destroy() end end end end})
t17:AddToggle({Name = "无限体力", Callback = function(v) Config.InfStamina = v end})

local t18 = Window:MakeTab({Name = "黑客GUI", Icon = "rbxassetid://77348087165494"})
t18:AddButton({Name = "c00lgui", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/Scripts/c00lgui.LUA"))() end})
t18:AddButton({Name = "1x1x1x1gui", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/Scripts/1x1x1x1gui%203.3.LUA"))() end})
t18:AddButton({Name = "k00pgui", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/Scripts/k00pgui%20v12.LUA"))() end})

local t19 = Window:MakeTab({Name = "BloxStrike", Icon = "rbxassetid://77348087165494"})
t19:AddButton({Name = "wyvern gui v2", Callback = function() loadstring(game:HttpGet("https://gist.githubusercontent.com/wydirdscripts/f6daf1950dd645377bb8a86e941baf9f/raw/c0b8895d18d12ceb8c1e5ae3d30798c5e10d972b/gistfile1.txt"))() end})

local t20 = Window:MakeTab({Name = "Solo Hunters", Icon = "rbxassetid://77348087165494"})
t20:AddButton({Name = "1", Callback = function() loadstring(game:HttpGet('https://gist.githubusercontent.com/weeew07/d477f12afffdec7131886d9bdb06dbe7/raw/1a13b69b74915e3effa36ed447f6863cebd743a5/Solo%20Hunters'))() end})

local t21 = Window:MakeTab({Name = "ROB IT", Icon = "rbxassetid://77348087165494"})
t21:AddButton({Name = "ROB IT HUB", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/agentstojak/ROB-IT/refs/heads/main/ROB%20IT"))() end})

local t22 = Window:MakeTab({Name = "死亡之死", Icon = "rbxassetid://77348087165494"})
t22:AddButton({Name = "RedScripter102 HUB", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/RedScripter102/Script/refs/heads/main/Die%20of%20death%20updated"))() end})

local tFused = Window:MakeTab({Name = "致命猴子 & Ear Game", Icon = "rbxassetid://77348087165494"})

tFused:AddSection({Name = "两个游戏通用"})
tFused:AddToggle({
    Name = "开启刷钱",
    Default = false,
    Callback = function(v)
        Config.AutoGold = v
    end
})

tFused:AddToggle({
    Name = "开关废品Esp",
    Callback = function(v)
        Config.ScrapESP = v
        if not v then
            for _, o in pairs(workspace:GetDescendants()) do
                if o.Name == "Scrap_Highlight_ESP" or o.Name == "Scrap_Text_ESP" then
                    o:Destroy()
                end
            end
        end
    end
})

tFused:AddToggle({
    Name = "开关回收机Esp",
    Callback = function(v)
        Config.RecyclerESP = v
        if not v then
            for _, o in pairs(workspace:GetDescendants()) do
                if o.Name == "Recycler_Highlight_ESP" or o.Name == "Recycler_Text_ESP" then
                    o:Destroy()
                end
            end
        end
    end
})

tFused:AddSection({Name = "致命猴子"})
tFused:AddToggle({
    Name = "开关怪物Esp", 
    Callback = function(v) 
        Config.MonkeyESP = v 
        if not v then 
            for _, o in pairs(workspace:GetDescendants()) do 
                if o.Name == "Monkey_Highlight_ESP" or o.Name == "Monkey_Text_ESP" then 
                    o:Destroy() 
                end 
            end 
        end 
    end
})

tFused:AddSection({Name = "Ear Game "})
tFused:AddToggle({
    Name = "开关怪物Esp",
    Callback = function(v)
        Config.EarGameESP = v
        if not v then
            for _, o in pairs(workspace:GetDescendants()) do
                if o.Name == "EarGame_Highlight_ESP" or o.Name == "EarGame_Text_ESP" then
                    o:Destroy()
                end
            end
        end
    end
})

tFused:AddToggle({
    Name = "开关卡片Esp",
    Callback = function(v)
        Config.CardESP = v
        if not v then
            for _, o in pairs(workspace:GetDescendants()) do
                if o.Name == "Card_Highlight_ESP" or o.Name == "Card_Text_ESP" then
                    o:Destroy()
                end
            end
        end
    end
})

local TargetMonkeys = { 
    ["Kus"] = true, 
    ["Dus"] = true, 
    ["Gus"] = true, 
    ["SandMan"] = true, 
    ["Ashy"] = true, 
    ["Lost"] = true, 
    ["Scar"] = true,
    ["Billy"] = true,      
    ["SangGuy"] = true,
    ["Meat"] = true,   
    ["???"] = true       
}

local TargetEarMonkeys = { ["SawRunner"] = true, ["Crawly"] = true, ["Claw"] = true, ["slender"] = true }

local function CreateOutlineESP(model)
    if not model:FindFirstChild("Monkey_Highlight_ESP") then
        local hl = Instance.new("Highlight")
        hl.Name = "Monkey_Highlight_ESP"
        hl.FillColor = Color3.fromRGB(255, 60, 0)      
        hl.FillTransparency = 0.5                     
        hl.OutlineColor = Color3.fromRGB(255, 255, 255) 
        hl.OutlineTransparency = 0                    
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop 
        hl.Parent = model
    end
    if not model:FindFirstChild("Monkey_Text_ESP") then
        local targetPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model:FindFirstChildOfClass("BasePart")
        if targetPart then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "Monkey_Text_ESP"
            billboard.Size = UDim2.new(0, 180, 0, 50)
            billboard.AlwaysOnTop = true
            billboard.ExtentsOffset = Vector3.new(0, 3.5, 0)
            billboard.Adornee = targetPart
            billboard.Parent = model
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = model.Name 
            label.TextColor3 = Color3.fromRGB(255, 60, 0)
            label.TextSize = 16
            label.Font = Enum.Font.SourceSansBold
            label.TextStrokeTransparency = 0 
            label.Parent = billboard
        end
    end
end

local function CreateEarGameESP(model)
    if not model:FindFirstChild("EarGame_Highlight_ESP") then
        local hl = Instance.new("Highlight")
        hl.Name = "EarGame_Highlight_ESP"
        hl.FillColor = Color3.fromRGB(255, 0, 100)
        hl.FillTransparency = 0.4                     
        hl.OutlineColor = Color3.fromRGB(255, 255, 255) 
        hl.OutlineTransparency = 0                    
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop 
        hl.Parent = model
    end
    if model and not model:FindFirstChild("EarGame_Text_ESP") then
        local targetPart = model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("Head") or model:FindFirstChildOfClass("BasePart")
        if targetPart then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "EarGame_Text_ESP"
            billboard.Size = UDim2.new(0, 180, 0, 50)
            billboard.AlwaysOnTop = true
            billboard.ExtentsOffset = Vector3.new(0, 3.5, 0)
            billboard.Adornee = targetPart
            billboard.Parent = model
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = model.Name 
            label.TextColor3 = Color3.fromRGB(255, 0, 100)
            label.TextSize = 16
            label.Font = Enum.Font.SourceSansBold
            label.TextStrokeTransparency = 0 
            label.Parent = billboard
        end
    end
end

local function CreateScrapESP(part)
    if not part:FindFirstChild("Scrap_Highlight_ESP") then
        local hl = Instance.new("Highlight")
        hl.Name = "Scrap_Highlight_ESP"
        hl.FillColor = Color3.fromRGB(0, 255, 100) 
        hl.FillTransparency = 0.5                     
        hl.OutlineColor = Color3.fromRGB(255, 255, 255) 
        hl.OutlineTransparency = 0                    
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop 
        hl.Parent = part
    end
    if not part:FindFirstChild("Scrap_Text_ESP") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "Scrap_Text_ESP"
        billboard.Size = UDim2.new(0, 150, 0, 40)
        billboard.AlwaysOnTop = true
        billboard.ExtentsOffset = Vector3.new(0, 2, 0)
        billboard.Adornee = part
        billboard.Parent = part
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = part.Name 
        label.TextColor3 = Color3.fromRGB(0, 255, 100)
        label.TextSize = 14
        label.Font = Enum.Font.SourceSansBold
        label.TextStrokeTransparency = 0 
        label.Parent = billboard
    end
end

local function CreateRecyclerESP(obj)
    if not obj:FindFirstChild("Recycler_Highlight_ESP") then
        local hl = Instance.new("Highlight")
        hl.Name = "Recycler_Highlight_ESP"
        hl.FillColor = Color3.fromRGB(170, 85, 255) 
        hl.FillTransparency = 0.4                     
        hl.OutlineColor = Color3.fromRGB(255, 255, 255) 
        hl.OutlineTransparency = 0                    
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop 
        hl.Parent = obj
    end
    if not obj:FindFirstChild("Recycler_Text_ESP") then
        local targetPart = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
        if targetPart then
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "Recycler_Text_ESP"
            billboard.Size = UDim2.new(0, 160, 0, 40)
            billboard.AlwaysOnTop = true
            billboard.ExtentsOffset = Vector3.new(0, 4, 0)
            billboard.Adornee = targetPart
            billboard.Parent = obj
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = "废品回收机" 
            label.TextColor3 = Color3.fromRGB(170, 85, 255)
            label.TextSize = 15
            label.Font = Enum.Font.SourceSansBold
            label.TextStrokeTransparency = 0 
            label.Parent = billboard
        end
    end
end

local function CreateCardESP(part)
    if not part:FindFirstChild("Card_Highlight_ESP") then
        local hl = Instance.new("Highlight")
        hl.Name = "Card_Highlight_ESP"
        hl.FillColor = Color3.fromRGB(0, 200, 255) 
        hl.FillTransparency = 0.4                     
        hl.OutlineColor = Color3.fromRGB(255, 255, 255) 
        hl.OutlineTransparency = 0                    
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop 
        hl.Parent = part
    end
    if not part:FindFirstChild("Card_Text_ESP") then
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "Card_Text_ESP"
        billboard.Size = UDim2.new(0, 150, 0, 40)
        billboard.AlwaysOnTop = true
        billboard.ExtentsOffset = Vector3.new(0, 2, 0)
        billboard.Adornee = part
        billboard.Parent = part
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "Card" 
        label.TextColor3 = Color3.fromRGB(0, 200, 255)
        label.TextSize = 15
        label.Font = Enum.Font.SourceSansBold
        label.TextStrokeTransparency = 0 
        label.Parent = billboard
    end
end

local function InteractWithObject(obj)
    local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        fireproximityprompt(prompt)
    else
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait()
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
end

local function IsValidGroundItem(obj)
    local allPlayers = Players:GetPlayers()
    for i = 1, #allPlayers do
        local p = allPlayers[i]
        if p.Character and obj:IsDescendantOf(p.Character) then return false end
        local bp = p:FindFirstChild("Backpack")
        if bp and obj:IsDescendantOf(bp) then return false end
    end
    if obj:IsA("BasePart") then
        if obj.Transparency > 0.5 then return false end
        if obj.Position.Y < -50 then return false end
    else
        local cp = obj:GetPivot().Position
        if cp.Y < -50 then return false end
    end
    return true
end

local function PlayerHasLootToSell()
    local char = LPlr.Character
    local bp = LPlr:FindFirstChild("Backpack")
    
    local validScrapNames = {}
    local scrapsFolder = workspace:FindFirstChild("Scraps")
    if scrapsFolder then
        for _, v in pairs(scrapsFolder:GetChildren()) do
            if v:IsA("BasePart") or v:IsA("Model") then
                validScrapNames[v.Name] = true
            end
        end
    end
    
    if bp then
        for _, tool in pairs(bp:GetChildren()) do
            if tool:IsA("Tool") and validScrapNames[tool.Name] then
                return true
            end
        end
    end
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and validScrapNames[tool.Name] then
                return true
            end
        end
    end
    return false
end

local CachedItems = { Scraps = {}, Recycler = nil }
local function UpdateMapCache()
    table.clear(CachedItems.Scraps)
    CachedItems.Recycler = nil
    
    local scrapsFolder = workspace:FindFirstChild("Scraps")
    if scrapsFolder then
        local children = scrapsFolder:GetChildren()
        for i = 1, #children do
            local v = children[i]
            if v:IsA("BasePart") or v:IsA("Model") then
                table.insert(CachedItems.Scraps, v)
            end
        end
    end
    
    local recycler = workspace:FindFirstChild("ScrapRecycler", true)
    if recycler and (recycler:IsA("BasePart") or recycler:IsA("Model")) then
        CachedItems.Recycler = recycler
    end
end

task.spawn(function()
    while true do
        if Config.AutoGold then
            UpdateMapCache()
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while true do
        RS.Heartbeat:Wait()
        if Config.AutoGold and LPlr.Character and LPlr.Character:FindFirstChild("HumanoidRootPart") and LPlr.Character:FindFirstChildOfClass("Humanoid") and LPlr.Character.Humanoid.Health > 0 then
            local hrp = LPlr.Character.HumanoidRootPart
            
            if PlayerHasLootToSell() then
                local recycler = CachedItems.Recycler or workspace:FindFirstChild("ScrapRecycler", true)
                if recycler then
                    local recyclerPos = recycler:IsA("BasePart") and recycler.CFrame or recycler:GetPivot()
                    local sellTimer = tick()
                    while PlayerHasLootToSell() and LPlr.Character and LPlr.Character.Humanoid.Health > 0 and (tick() - sellTimer < 1.5) do
                        if not Config.AutoGold then break end
                        hrp.CFrame = recyclerPos
                        InteractWithObject(recycler)
                        task.wait(0.05) 
                    end
                end
            else
                if not Config.AutoGold then continue end
                local targetItem = nil
                local itemArray = CachedItems.Scraps
                if itemArray then
                    for i = #itemArray, 1, -1 do 
                        local v = itemArray[i]
                        if v and v.Parent and IsValidGroundItem(v) then
                            targetItem = v
                            break
                        end
                    end
                end
                
                if targetItem and Config.AutoGold then
                    local itemPos = targetItem:IsA("BasePart") and targetItem.CFrame or targetItem:GetPivot()
                    if itemPos then
                        hrp.CFrame = itemPos                
                        InteractWithObject(targetItem)                       
                        local fastCheck = tick()
                        while tick() - fastCheck < 0.35 do
                            if not Config.AutoGold then break end
                            if PlayerHasLootToSell() then break end
                            RS.Heartbeat:Wait()
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()  
    while task.wait(0.5) do 
        if Config.SCPHighlight then 
            local children = workspace:GetChildren()
            for i = 1, #children do
                local v = children[i]
                if v.Name == "SCP-3199" and not v:FindFirstChild("SCP3199_ESP") then 
                    local h = Instance.new("Highlight", v) h.Name = "SCP3199_ESP" h.FillColor = Color3.new(1,0,0) 
                    local b = Instance.new("BillboardGui", v) b.Name = "SCP3199_ESP" b.Size = UDim2.new(0,150,0,50) b.Adornee = v.PrimaryPart or v:FindFirstChild("Head") b.AlwaysOnTop = true b.ExtentsOffset = Vector3.new(0,3,0) 
                    local l = Instance.new("TextLabel", b) l.Size = UDim2.new(1,0,1,0) l.BackgroundTransparency = 1 l.Text = "SCP-3199" l.TextColor3 = Color3.new(1,0,0) l.TextSize = 14 
                end  
            end
        end 
        if Config.MonkeyESP then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and TargetMonkeys[v.Name] then
                    CreateOutlineESP(v)
                end
            end
        end 
        if Config.EarGameESP then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and TargetEarMonkeys[v.Name] then
                    CreateEarGameESP(v)
                end
            end
        end
        if Config.ScrapESP then
            local scrapsFolder = workspace:FindFirstChild("Scraps")
            if scrapsFolder then
                for _, v in pairs(scrapsFolder:GetChildren()) do
                    if v:IsA("BasePart") or v:IsA("Model") then
                        CreateScrapESP(v)
                    end
                end
            end
        end
        if Config.RecyclerESP then
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "ScrapRecycler" and (v:IsA("BasePart") or v:IsA("Model")) then
                    CreateRecyclerESP(v)
                end
            end
        end
        if Config.CardESP then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("MeshPart") and v.Name == "Card" then
                    if IsValidGroundItem(v) then
                        CreateCardESP(v)
                    else
                        if v:FindFirstChild("Card_Highlight_ESP") then v.Card_Highlight_ESP:Destroy() end
                        if v:FindFirstChild("Card_Text_ESP") then v.Card_Text_ESP:Destroy() end
                    end
                end
            end
        end
    end 
end)

RS.RenderStepped:Connect(function() if Config.SpeedEn and LPlr.Character and LPlr.Character:FindFirstChild("Humanoid") then LPlr.Character.Humanoid.WalkSpeed = Config.Speed end if Config.NightVis then Light.Brightness, Light.Ambient, Light.ClockTime = 2, Color3.new(1,1,1), 12 end if Config.FOVEn then Cam.FieldOfView = Config.FOV end if Config.ThirdPerson then LPlr.CameraMode = Enum.CameraMode.Classic end if Config.InfStamina then pcall(function() local s = LPlr.PlayerGui.Stamina.Handler.Stamina if s.Value < 100 then s.Value = 100 end end) end end)
RS.Stepped:Connect(function() if Config.Noclip and LPlr.Character then for _,v in pairs(LPlr.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end end end)
UIS.JumpRequest:Connect(function() if Config.InfJump and LPlr.Character then local h = LPlr.Character:FindFirstChildOfClass("Humanoid") if h then h:ChangeState("Jumping") end end end)
OrionLib:Init()