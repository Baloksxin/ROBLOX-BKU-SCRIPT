local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/BK-PE-SCRIPT/refs/heads/main/UI.txt"))()

local Window = OrionLib:MakeWindow({
    Name = "BKU HUB BY BALOKSXIN", 
    HidePremium = true, 
    SaveConfig = false,
    IntroText = "正在加载BKU HUB"
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local InfiniteJumpEnabled = false
local NoclipEnabled = false
local NightVisionEnabled = false
local SpeedEnabled = false 
local TargetSpeed = 16    
local ServerJobId = game.JobId ~= "" and game.JobId or "单人/私服环境"
local GamePlaceId = game.PlaceId

local OriginalBrightness = Lighting.Brightness
local OriginalAmbient = Lighting.Ambient
local OriginalClockTime = Lighting.ClockTime

local InfoTab = Window:MakeTab({
    Name = "信息",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})

InfoTab:AddSection({ Name = "信息" })
InfoTab:AddLabel("使用者: " .. LocalPlayer.DisplayName)
InfoTab:AddLabel("执行器: " .. ((identifyexecutor and identifyexecutor()) or "未知"))
InfoTab:AddLabel("游戏 ID (PlaceId): " .. tostring(GamePlaceId))
InfoTab:AddLabel("服务器 ID (JobId): " .. ServerJobId)

InfoTab:AddButton({
	Name = "点击复制服务器 ID",
	Callback = function()
		setclipboard(ServerJobId)
		OrionLib:MakeNotification({
			Name = "系统提示",
			Content = "服务器 ID 已复制到剪贴板",
			Time = 2
		})
	end    
})

local MainTab = Window:MakeTab({
    Name = "主要",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})

MainTab:AddSection({ Name = "🐷要" })
MainTab:AddTextbox({
    Name = "设置目标速度数值",
    Default = "16",
    TextDisappear = false,
    Callback = function(Value)
        local num = tonumber(Value)
        if num then TargetSpeed = num end
    end      
})

MainTab:AddToggle({
    Name = "开启速度修改",
    Default = false,
    Callback = function(Value)
        SpeedEnabled = Value
        if not Value and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
})

MainTab:AddToggle({ Name = "无限跳跃", Default = false, Callback = function(V) InfiniteJumpEnabled = V end })
MainTab:AddToggle({ Name = "穿墙模式 (Noclip)", Default = false, Callback = function(V) NoclipEnabled = V end })
MainTab:AddToggle({ 
    Name = "夜视模式 (全局高亮)", 
    Default = false, 
    Callback = function(Value) 
        NightVisionEnabled = Value 
        if not Value then
            Lighting.Brightness = OriginalBrightness
            Lighting.Ambient = OriginalAmbient
            Lighting.ClockTime = OriginalClockTime
        end
    end 
})

MainTab:AddSection({ Name = "工具" })

MainTab:AddButton({
	Name = "Infinite Yield",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
	end    
})

MainTab:AddButton({
	Name = "飞行 GUI",
	Callback = function()
		loadstring(game:HttpGet("https://github.com/MiniCapy/scripts/raw/refs/heads/main/fly%20GUI"))()
	end    
})

MainTab:AddButton({
	Name = "R15动作脚本",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Gazer-Ha/Free-emote/refs/heads/main/Delta%20mad%20stuffs"))()
	end    
})

MainTab:AddButton({
	Name = "变回旧版Gui☠☠☠",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/jannnerb/core-gui-fixer/refs/heads/main/CoreGUIFixer.luau"))()
	end    
})

local DoorsTab = Window:MakeTab({
    Name = "DOORS",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})
DoorsTab:AddSection({ Name = "DOORS脚本" })
DoorsTab:AddButton({
	Name = "Velocity X",
	Callback = function()
		loadstring(game:HttpGet("https://velocityloader.vercel.app/"))()
	end    
})
DoorsTab:AddButton({
	Name = "OP实体生成器",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/althan99/doors-entity-spawner/main/Script"))()
	end    
})

local ForsakenTab = Window:MakeTab({
    Name = "Forsaken",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})
ForsakenTab:AddSection({ Name = "Forsaken 专用脚本" })
ForsakenTab:AddButton({
	Name = "Byby Hub",
	Callback = function()
		loadstring(game:HttpGet('https://raw.githubusercontent.com/Edulucas2013/Byby-hub/refs/heads/main/Forsaken%20byby%20hub'))()
	end    
})

local NdsTab = Window:MakeTab({
    Name = "自然灾害幸存",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})
NdsTab:AddSection({ Name = "自然灾害脚本" })
NdsTab:AddButton({
    Name = "NDS HUB",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/KaterHub-Inc/NaturalDisasterSurvival/refs/heads/main/main.lua"))()
    end
})
NdsTab:AddButton({
    Name = "Super Ring Parts V4",
    Callback = function()
        loadstring(game:HttpGet("https://rscripts.net/raw/super-ring-parts-v4-by-lukas_1741980981842_td0ummjymf.txt",true))()
    end
})

local BFTab = Window:MakeTab({
    Name = "Blox Fruits",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})
BFTab:AddSection({ Name = "Blox Fruits 脚本" })
BFTab:AddButton({
    Name = "4479Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/4479cantcode/4479Hub/refs/heads/main/Script.lua"))()
    end
})

local TsunamiTab = Window:MakeTab({
    Name = "逃离海啸，获得脑腐",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})
TsunamiTab:AddSection({ Name = "逃离海啸获得脑腐脚本" })
TsunamiTab:AddButton({
    Name = "1",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptify12/EscapeTsunami/main/KeySystem.lua", true))()
    end
})

local ElevatorTab = Window:MakeTab({
    Name = "疯狂电梯",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})
ElevatorTab:AddSection({ Name = "疯狂电梯脚本" })
ElevatorTab:AddButton({
    Name = "免费工具",
    Callback = function()
        loadstring(game:HttpGet(('https://pastebin.com/raw/vE8WMLit'),true))()
    end
})

local FishTab = Window:MakeTab({
    Name = "Fish It",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})
FishTab:AddSection({ Name = "Fish It 脚本" })
FishTab:AddButton({
    Name = "1",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/dilleron964/Fish-It/main/Fish-It.lua'))()
    end
})

local GAndBTab = Window:MakeTab({
    Name = "内脏与黑火药",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})
GAndBTab:AddSection({ Name = "Guts & Blackpowder 脚本" })
GAndBTab:AddButton({
    Name = "Katchi Hub",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/XaviscoZ/roblox/refs/heads/main/g%26b.lua"))()
    end    
})

local Forest99Tab = Window:MakeTab({
    Name = "森林中的99夜",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})
Forest99Tab:AddSection({ Name = "森林中的99夜 脚本" })
Forest99Tab:AddButton({
    Name = "UNPERFORMED HUB",
    Callback = function()
        loadstring(game:HttpGet("https://api.junkie-development.de/api/v1/luascripts/public/6ed3b0b29cae165a5df389c3650171583312f6baeaf622f2330521e9c340436c/download"))()
    end    
})

local BreakIn2Tab = Window:MakeTab({
    Name = "Break In 2",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})
BreakIn2Tab:AddSection({ Name = "Break In 1/2 脚本" })
BreakIn2Tab:AddButton({
    Name = "break in 1/2可以用",
    Callback = function()
        getgenv().ignoreGameCheck = false
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Iptxt/ActualHub/refs/heads/main/Loader"));
    end    
})

local FNAFTab = Window:MakeTab({
    Name = "FNAF:永恒之夜",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})
FNAFTab:AddSection({ Name = "FNAF 永恒之夜脚本" })
FNAFTab:AddButton({
    Name = "1",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Snipez-Dev/Rbx-Scripts/refs/heads/main/Eternal%20Nights"))()
    end
})

local GardenTab = Window:MakeTab({
    Name = "种植花园",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})
GardenTab:AddSection({ Name = "种植花园脚本" })
GardenTab:AddButton({
    Name = "Zap Hub",
    Callback = function()
        loadstring(game:HttpGet('https://zaphub.xyz/Exec'))()
    end
})

local LexingtonTab = Window:MakeTab({
    Name = "莱辛顿和康科德",
    Icon = "rbxassetid://77348087165494",
    PremiumOnly = false
})
LexingtonTab:AddSection({ Name = "莱辛顿和康科德脚本" })
LexingtonTab:AddButton({
    Name = "1",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Lexington-and-Concord-LC-75016"))()
    end
})

RunService.RenderStepped:Connect(function()
    if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = TargetSpeed
    end
    if NightVisionEnabled then
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.ClockTime = 12
    end
end)

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

OrionLib:Init()
