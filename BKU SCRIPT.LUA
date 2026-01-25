local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/BK-PE-SCRIPT/refs/heads/main/UI.txt"))()

local Window = OrionLib:MakeWindow({
    Name = "BKU SCRIPT", 
    HidePremium = true, 
    SaveConfig = true,
    ConfigFolder = "BKU_Config",
    IntroText = "BKU SCRIPT INITIALIZING..."
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
    Icon = "rbxassetid://4483345998",
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
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddSection({ Name = "速度控制" })

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

MainTab:AddSection({ Name = "常规增强" })

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

MainTab:AddSection({ Name = "辅助工具" })

MainTab:AddButton({
	Name = "开启飞行 GUI",
	Callback = function()
		loadstring(game:HttpGet("https://github.com/MiniCapy/scripts/raw/refs/heads/main/fly%20GUI"))()
	end    
})

local DoorsTab = Window:MakeTab({
    Name = "DOORS",
    Icon = "rbxassetid://4483345998",
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
    Icon = "rbxassetid://4483345998",
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
    Icon = "rbxassetid://4483345998",
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
