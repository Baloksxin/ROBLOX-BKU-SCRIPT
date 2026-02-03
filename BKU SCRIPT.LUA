local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/BK-PE-SCRIPT/refs/heads/main/UI.txt"))()
local LPlr = game:GetService("Players").LocalPlayer
local RS, UIS, Light = game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("Lighting")
local Cam = workspace.CurrentCamera

local Config = { Speed = 16, FOV = 70, SpeedEn = false, FOVEn = false, InfJump = false, Noclip = false, NightVis = false }
local Orig = { FOV = Cam.FieldOfView, Bright = Light.Brightness, Ambient = Light.Ambient, Clock = Light.ClockTime }

local Window = OrionLib:MakeWindow({Name = "BKU HUB BY BALOKSXIN", HidePremium = true, SaveConfig = false, IntroText = "BKU HUB"})

OrionLib:MakeNotification({Name = "BKU HUB", Content = "BKU HUB已加载完毕!🤯🤯🤯", Time = 3})

local t = Window:MakeTab({Name = "信息", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "信息"})
t:AddLabel("使用者: " .. LPlr.DisplayName)
t:AddLabel("执行器: " .. ((identifyexecutor and identifyexecutor()) or "未知"))
t:AddLabel("游戏 ID (PlaceId): " .. tostring(game.PlaceId))
t:AddLabel("服务器 ID (JobId): " .. (game.JobId ~= "" and game.JobId or "单人/私服环境"))
t:AddButton({Name = "点击复制服务器 ID", Callback = function() setclipboard(game.JobId) end})
t:AddButton({Name = "复制作者KS ID", Callback = function() setclipboard("Baloksxin") end})

local t = Window:MakeTab({Name = "通用", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "角色属性修改"})
t:AddTextbox({Name = "修改速度值", Default = "16", Callback = function(v) Config.Speed = tonumber(v) or 16 end})
t:AddToggle({Name = "开启速度修改", Callback = function(v) Config.SpeedEn = v if not v and LPlr.Character:FindFirstChild("Humanoid") then LPlr.Character.Humanoid.WalkSpeed = 16 end end})
t:AddTextbox({Name = "修改FOV值", Default = "70", Callback = function(v) Config.FOV = tonumber(v) or 70 end})
t:AddToggle({Name = "开启 FOV 修改", Callback = function(v) Config.FOVEn = v if not v then Cam.FieldOfView = Orig.FOV end end})
t:AddToggle({Name = "无限跳跃", Callback = function(v) Config.InfJump = v end})
t:AddToggle({Name = "穿墙模式 (Noclip)", Callback = function(v) Config.Noclip = v end})
t:AddToggle({Name = "夜视模式 (全局高亮)", Callback = function(v) Config.NightVis = v if not v then Light.Brightness, Light.Ambient, Light.ClockTime = Orig.Bright, Orig.Ambient, Orig.Clock end end})
t:AddSection({Name = "工具"})
t:AddButton({Name = "Infinite Yield", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end})
t:AddButton({Name = "飞行 GUI", Callback = function() loadstring(game:HttpGet("https://github.com/MiniCapy/scripts/raw/refs/heads/main/fly%20GUI"))() end})
t:AddButton({Name = "R15动作脚本", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Gazer-Ha/Free-emote/refs/heads/main/Delta%20mad%20stuffs"))() end})

local t = Window:MakeTab({Name = "DOORS", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "DOORS脚本"})
t:AddButton({Name = "Velocity X", Callback = function() loadstring(game:HttpGet("https://velocityloader.vercel.app/"))() end})
t:AddButton({Name = "OP实体生成器", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/althan99/doors-entity-spawner/main/Script"))() end})

local t = Window:MakeTab({Name = "Forsaken", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "Forsaken 专用脚本"})
t:AddButton({Name = "Byby Hub", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/Edulucas2013/Byby-hub/refs/heads/main/Forsaken%20byby%20hub'))() end})

local t = Window:MakeTab({Name = "自然灾害幸存", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "自然灾害脚本"})
t:AddButton({Name = "NDS HUB", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/KaterHub-Inc/NaturalDisasterSurvival/refs/heads/main/main.lua"))() end})
t:AddButton({Name = "Super Ring Parts V4", Callback = function() loadstring(game:HttpGet("https://rscripts.net/raw/super-ring-parts-v4-by-lukas_1741980981842_td0ummjymf.txt",true))() end})

local t = Window:MakeTab({Name = "Blox Fruits", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "Blox Fruits 脚本"})
t:AddButton({Name = "4479Hub", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/4479cantcode/4479Hub/refs/heads/main/Script.lua"))() end})

local t = Window:MakeTab({Name = "Rooms&Doors", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "Rooms&Doors 脚本"})
t:AddButton({Name = "Xera Hub", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/NobodyOrIdk/XeraHub/main/main.lua"))() end})

local t = Window:MakeTab({Name = "逃离海啸，获得脑腐", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "逃离海啸获得脑腐脚本"})
t:AddButton({Name = "1", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/scriptify12/EscapeTsunami/main/KeySystem.lua", true))() end})

local t = Window:MakeTab({Name = "偷走脑腐", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "偷走脑腐脚本"})
t:AddButton({Name = "1", Callback = function() loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/fcc63f5f04efa9a6a85d6f16a179b870.lua"))() end})

local t = Window:MakeTab({Name = "疯狂电梯", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "疯狂电梯脚本"})
t:AddButton({Name = "免费工具", Callback = function() loadstring(game:HttpGet(('https://pastebin.com/raw/vE8WMLit'),true))() end})

local t = Window:MakeTab({Name = "Fish It", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "Fish It 脚本"})
t:AddButton({Name = "1", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/dilleron964/Fish-It/main/Fish-It.lua'))() end})

local t = Window:MakeTab({Name = "内脏与黑火药", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "Guts & Blackpowder 脚本"})
t:AddButton({Name = "Katchi Hub", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/XaviscoZ/roblox/refs/heads/main/g%26b.lua"))() end})

local t = Window:MakeTab({Name = "森林中的99夜", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "森林中的99夜 脚本"})
t:AddButton({Name = "UNPERFORMED HUB", Callback = function() loadstring(game:HttpGet("https://api.junkie-development.de/api/v1/luascripts/public/6ed3b0b29cae165a5df389c3650171583312f6baeaf622f2330521e9c340436c/download"))() end})

local t = Window:MakeTab({Name = "FNAF:永恒之夜", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "FNAF 永恒之夜脚本"})
t:AddButton({Name = "1", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Snipez-Dev/Rbx-Scripts/refs/heads/main/Eternal%20Nights"))() end})

local t = Window:MakeTab({Name = "种植花园", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "种植花园脚本"})
t:AddButton({Name = "Zap Hub", Callback = function() loadstring(game:HttpGet('https://zaphub.xyz/Exec'))() end})

local t = Window:MakeTab({Name = "莱辛顿和康科德", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "莱辛顿和康科德脚本"})
t:AddButton({Name = "1", Callback = function() loadstring(game:HttpGet("https://rawscripts.net/raw/Lexington-and-Concord-LC-75016"))() end})

local t = Window:MakeTab({Name = "黑客GUI", Icon = "rbxassetid://77348087165494"})
t:AddLabel("想啥呢，肯定是客户端啊")
t:AddButton({Name = "c00lgui", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/Scripts/c00lgui.LUA"))() end})
t:AddButton({Name = "1x1x1x1gui", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/Scripts/1x1x1x1gui%203.3.LUA"))() end})
t:AddButton({Name = "k00pgui", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/Scripts/k00pgui%20v12.LUA"))() end})

local t = Window:MakeTab({Name = "BloxStrike", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "BloxStrike 脚本"})
t:AddButton({Name = "wyvern gui v2", Callback = function() loadstring(game:HttpGet("https://gist.githubusercontent.com/wydirdscripts/f6daf1950dd645377bb8a86e941baf9f/raw/c0b8895d18d12ceb8c1e5ae3d30798c5e10d972b/gistfile1.txt"))() end})

local t = Window:MakeTab({Name = "Solo Hunters", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "Solo Hunters 脚本"})
t:AddButton({Name = "1", Callback = function() loadstring(game:HttpGet('https://gist.githubusercontent.com/weeew07/d477f12afffdec7131886d9bdb06dbe7/raw/1a13b69b74915e3effa36ed447f6863cebd743a5/Solo%20Hunters'))() end})

local t = Window:MakeTab({Name = "ROB IT", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "ROB IT 脚本"})
t:AddButton({Name = "ROB IT HUB", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/agentstojak/ROB-IT/refs/heads/main/ROB%20IT"))() end})

local t = Window:MakeTab({Name = "死亡之死", Icon = "rbxassetid://77348087165494"})
t:AddSection({Name = "死亡之死 脚本"})
t:AddButton({Name = "RedScripter102 HUB", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/RedScripter102/Script/refs/heads/main/Die%20of%20death%20updated"))() end})

RS.RenderStepped:Connect(function()
    if Config.SpeedEn and LPlr.Character and LPlr.Character:FindFirstChild("Humanoid") then LPlr.Character.Humanoid.WalkSpeed = Config.Speed end
    if Config.NightVis then Light.Brightness, Light.Ambient, Light.ClockTime = 2, Color3.new(1,1,1), 12 end
    if Config.FOVEn then Cam.FieldOfView = Config.FOV end
end)

RS.Stepped:Connect(function()
    if Config.Noclip and LPlr.Character then
        for _, v in pairs(LPlr.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

UIS.JumpRequest:Connect(function()
    if Config.InfJump and LPlr.Character then LPlr.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping") end
end)

OrionLib:Init()
