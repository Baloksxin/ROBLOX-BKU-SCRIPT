local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/UI.txt"))()

local Window = OrionLib:MakeWindow({
    Name = "服务器选择",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "ServerSelect",
    IntroEnabled = true,
    IntroText = "服务器选择",
    IntroIcon = "rbxassetid://8834748103",
    Icon = "rbxassetid://8834748103",
})

local MainTab = Window:MakeTab({
    Name = "服务器选择",
    Icon = "server",
})

local function ExecuteScript(url)
    pcall(function()
        local result = game:HttpGet(url)
        local func = loadstring(result)
        if func then
            func()
        end
    end)
end

MainTab:AddSection({ Name = "更新日志" })
MainTab:AddLabel("🥳欢迎回来🥳")
MainTab:AddLabel("添加了btm部分功能")
MainTab:AddLabel("最后更新时间:2026/10/22")

MainTab:AddSection({ Name = "可选服务器" })
MainTab:AddButton({
    Name = "通用",
    Callback = function()
        ExecuteScript("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/%E9%80%9A%E7%94%A8.LUA")
    end,
    Icon = "rbxassetid://3944703587"
})

MainTab:AddButton({
    Name = "Ear Game",
    Callback = function()
        ExecuteScript("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/EAR%20GAME.LUA")
    end,
    Icon = "rbxassetid://3944703587"
})

MainTab:AddButton({
    Name = "致命猴子",
    Callback = function()
        ExecuteScript("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/LETHALAPE.LUA")
    end,
    Icon = "rbxassetid://3944703587"
})

MainTab:AddButton({
    Name = "Scary Baboon",
    Callback = function()
        ExecuteScript("https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/SCARYBABOON.LUA")
    end,
    Icon = "rbxassetid://3944703587"
})
OrionLib:Init()